import json
import urllib
import kinesis
import base64
import ast
import time
import thingsboard

def FindRecords(streamName):

  keyIt = kinesis.getShardIterator(streamName,'shardId-000000000000')
  dic = json.loads(keyIt)
  records_SI = kinesis.getRecords(dic['ShardIterator'])
  rDecode = records_SI.decode("UTF-8")
  rDecJson = json.loads(rDecode)
  nextIterator = rDecJson['NextShardIterator']
  

  while( rDecJson['NextShardIterator'] != None ):
    if(len(rDecJson['Records']) > 0 ):
      break
    
    records = kinesis.getRecords(nextIterator)
    rDecode = records.decode("UTF-8")
    rDecJson = json.loads(rDecode)

    nextIterator = rDecJson['NextShardIterator']
    
    time.sleep(0.1)

  records = rDecJson['Records']
  return records

def lambda_handler(event, context):
    
    print("---------Start------------")
    
    streamName = 'inmet-Analytics-Stream'
    records = FindRecords(streamName)
    
    
    cities = []
    for i in records:
      cities.append(i['Data'])

    for i in cities:
      base64_bytes = i.encode('utf-8')
      message_bytes = base64.b64decode(base64_bytes)
      message = message_bytes.decode('utf-8')
      message = json.loads(message)
      print(message)

      thingsboard.putRecords({ message["DC_NOME"]:[ message["TEM_INS"], message["UMD_INS"], message["HI"], message["TEM_MIN"], message["TEM_MAX"], message["RAD_GLO"], message["VEN_DIR"], message["DT_MEDICAO"], message["HR_MEDICAO"]] })

    # TODO implement
    return {
        # 'statusCode': 200,
        # 'body': json.dumps(message)
    }

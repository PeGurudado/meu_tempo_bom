import json
import urllib
import kinesis
import base64
import ast
import time

def FindRecords(streamName):

  keyIt = kinesis.getShardIterator(streamName,'shardId-000000000000')
  dic = json.loads(keyIt)
  records_SI = kinesis.getRecords(dic['ShardIterator'])
  rDecode = records_SI.decode("UTF-8")
  rDecJson = json.loads(rDecode)
  nextIterator = rDecJson['NextShardIterator']

  while( rDecJson['NextShardIterator'] != None ):
    
    if(len(rDecJson['Records']) > 0):
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


    
    base64_message = records[len(records)-1]['Data']
    
  
    base64_bytes = base64_message.encode('utf-8')
    message_bytes = base64.b64decode(base64_bytes)
    message = message_bytes.decode('utf-8')
    
    
    lis = []
    lis.append(message)
    
    kinesis.putRecords('UpLink-Thingsboard', 'ThingsboardTable' , lis)
    
    
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps(message)
    }

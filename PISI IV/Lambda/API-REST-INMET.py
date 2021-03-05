import json
import urllib
from botocore.vendored import requests
import urllib.request
import kinesis
from datetime import datetime

def recordStream(data):
    data = list(map(lambda x: json.dumps(x), data))
    window_size = 400
    i = 0
    while (i*window_size <= len(data)):
        print(kinesis.putRecords('inmet-Stream', 'InmetTable',data[i*window_size:i*window_size+window_size]))
        i+=1
    

def lambda_handler(event, context):
    d= datetime.today().strftime('%Y-%m-%d')
    h= datetime.today().strftime('%H')

    
    res = urllib.request.urlopen(urllib.request.Request(
        url="https://apitempo.inmet.gov.br/estacao/dados/%s/%s00" %(d,h),
        headers={'Accept': 'application/json'},
        method='GET'),
        timeout=5)
        
    
    data = json.loads(res.read())
    
    try:
        if event and 'queryStringParameters' in event and 'kinesis' in event['queryStringParameters']:
            recordStream(data)
            return {
                'statusCode': 200,
                'body': json.dumps(['ok'])
            }
    except Exception:
        pass
    return {
        'statusCode': 200,
        'body': json.dumps(data)
    }
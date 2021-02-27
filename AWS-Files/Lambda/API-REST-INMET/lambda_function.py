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
    
    
def heatIndex(T, RH):
    
    T= (T * 9/5) + 32;
    
    HI= 1.1 * T - 10.3 + 0.047 * RH
    
    HIf = 0
    
    if HI < 80:
        HIcheck = True
        HIf = HI
    else:
        HI = (-42.379 + 
        2.04901523 * T + 
        10.14333127 * RH - 
        0.22475541 * T * RH - 
        6.83783 * 10**-3 * T**2 - 
        5.481717 * 10**-2 * RH**2 +
        1.22874 * 10**-3 * T**2 * RH + 
        8.5282 * 10**-4 * T * RH**2 -
        1.99 * 10**-6 * T**2 * RH**2)
        if T <= 80 and T <=112 and RH <= 13:
            HIcheck= True
            HIf = HI - (3.25 - 0.25 * RH) * ((17 - abs(T-95))/17)*0.5
        elif T <= 80 and T <= 87 and RH > 85:
            HIcheck= True
            HIf = HI + 0.02 * (RH -85) * (87-T)
        else:
            HIcheck= False

    HIf = (HIf -32) * 5/9
    
    if(HIcheck == False):
        HIf = None

        
    return HIf

def lambda_handler(event, context):
    # TODO implement
    d= datetime.today().strftime('%Y-%m-%d')
    h= datetime.today().strftime('%H')

    
    res = urllib.request.urlopen(urllib.request.Request(
        url="https://apitempo.inmet.gov.br/estacao/dados/%s/%s00" %(d,h),
        headers={'Accept': 'application/json'},
        method='GET'),
        timeout=5)
        
    
    data = json.loads(res.read())
    
    print(heatIndex(29, 48))
    
    i = 0
    while(i < len(data) ): #Goes through each map on i
        
        tem = data[i]['TEM_INS']
        
        if(tem == None):
            i += 1
            continue
        else:
            tem = float(tem)
        
        umd = data[i]['UMD_INS']
        
        if(umd == None):
            i += 1
            continue
        else:
            umd = float(umd)
        
        
        heatIn = heatIndex(tem, umd)
        data[i]['HEAT_INDEX'] = str(heatIn)
        
        i += 1
        
    
    try:
    # returm
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

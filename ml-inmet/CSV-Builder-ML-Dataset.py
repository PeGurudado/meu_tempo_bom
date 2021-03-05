import os.path
import json
import urllib
import urllib.request
import socket
from datetime import datetime, timedelta

save_path = 'P:/Downloads/meu_tempo_bom/ml-inmet'

name_of_file = "inmetdataset"

completeName = os.path.join(save_path, name_of_file+".csv") 

file= open (completeName, 'w')

key= []
s = '2019/05/01'
date = datetime.strptime(s, "%Y/%m/%d")

modified_date = date + timedelta(days=0)
# print(modified_date)
x= datetime.strftime(modified_date, "%Y-%m-%d")

modified_hour = date + timedelta(hours=0)

h= datetime.strftime(modified_hour, "%H")
print(h)

while True:
    if x == '2021-03-02':
        break
    else:
        
        try:
            res = urllib.request.urlopen(urllib.request.Request(

                    url=("https://apitempo.inmet.gov.br/estacao/dados/%s/%s00" %(x,h)),
                    headers={'Accept': 'application/json'},
                    method='GET'),
                    timeout=10)
            data = json.loads(res.read())
        except :
            print('Socket.timeout Error') 
            oldH= datetime.strftime(modified_hour, "%H") 

        
            modified_hour = modified_hour + timedelta(hours=1)
            h= datetime.strftime(modified_hour, "%H")        
    

            if  h == '00' and oldH != h:
                print("Rodou dia")
                modified_date = modified_date + timedelta(days=1)
                x= datetime.strftime(modified_date, "%Y-%m-%d")
            continue   
        
        oldH= datetime.strftime(modified_hour, "%H") 

        
        modified_hour = modified_hour + timedelta(hours=1)
        h= datetime.strftime(modified_hour, "%H")        
 

        if  h == '00' and oldH != h:
            print("Rodou dia")
            modified_date = modified_date + timedelta(days=1)
            x= datetime.strftime(modified_date, "%Y-%m-%d")

            
        if len(key) == 0:

            for i in range (len(data)):
                for j in data[i]:
                    key.append(j)
                    file.write(j+ ',')

                file.write('\n')
                break

        for i in range (len(data)):
            for j in key:
                if data[i][j] == None:
                    data[i][j]= ''
                file.write(data[i][j]+ ',')

            file.write('\n')    
            # break        
file.close()

print('fim')
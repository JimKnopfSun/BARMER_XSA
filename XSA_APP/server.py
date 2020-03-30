from rpy2 import robjects
from git_clone import git_clone
from hdfs import InsecureClient
import shutil

# Next Round
print("Hello again")
print("Hallo Stefan")

# Check if there is data for a prediction
client_hdfs = InsecureClient('http://awscdh6-ma.sap.local:9870', user='dr.who')
hdfs_content = client_hdfs.list('/tmp/tbr/BARMER/XSA')
print(hdfs_content)
print()

if len(hdfs_content) > 0 and hdfs_content[0] == 'iris.csv':

    print('Starte Prediction')
   
    #Herkunft des R-Scripts
    source_path = 'https://github.com/JimKnopfSun/BARMER_XSA.git'
    
    #Ziel des R-Scripts auf XSA
    target_path = '/usr/sap/HN2/home/testdir/'
    
    #Leere alte Script-Downloads im XSA
    shutil.rmtree(path=target_path + "/BARMER_XSA", ignore_errors=True, onerror=None)
    
    #Lade R-Script nach XSA
    git_clone(source_path, target_path)
    
    #Führe R-Script aus
    r = robjects.r
    _ = r.source(target_path + "/BARMER_XSA/sample.R")
    
    # Remove Data from HDFS
    client_hdfs.delete("/tmp/tbr/BARMER/XSA/iris.csv")
    

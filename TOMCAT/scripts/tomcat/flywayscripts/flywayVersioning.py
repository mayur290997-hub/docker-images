from __future__ import print_function
#from builtins import str
import shutil,sys,os,fileinput
src = sys.argv[1]
product=sys.argv[2]
version=sys.argv[3]
print(src)
inFile = open(src+"/revision.log")
print(inFile)
if not os.path.exists(src+"/flyway/ddl"):
  os.makedirs(src+"/flyway/ddl")
if not os.path.exists(src+"/flyway/dml"):
  os.makedirs(src+"/flyway/dml")
if not os.path.exists(src+"/flyway/dashboard"):
  os.makedirs(src+"/flyway/dashboard")
dest = src+"/flyway"

def updateFile(dir, searchExp, replaceExp):
    for fileName in os.listdir(dir):
        print("Iterating Directory" + dir)
        if fileName.endswith('.sql'):
            print("Checking file " + fileName)
            for line in fileinput.input(dir+"/"+fileName, inplace=1):
                if searchExp in line:
                    line = line.replace(searchExp, replaceExp)
                sys.stdout.write(line)


results_arr = []
current_arr = []
for line in inFile:
    if line.startswith('r'):
        results_arr.append(current_arr)
        current_arr = []
        current_arr += [line.split()]
    elif '.sql' in line:
        current_arr += [line.strip().split()]
    else:
        pass
results_arr.append(current_arr)
results_arr.pop(0)
dicts={}

for rev_list in results_arr:
    flag=1
    count=0
    for item in rev_list:
        if 'r' in str(item) and flag == 1:
            rev=item[0]
            author=item[2]
            revision=rev[1:]
            flag=2
        if '.sql' in str(item) and item[1].rsplit("/",4)[1] != 'entity_scripts':
            if item[1] in dicts:
                locRev = dicts[item[1]].split('_')[0]
                if revision > locRev:
                    dicts[item[1]] = (revision + "_" + str(count) + "__" + author + ":" + item[0])
                else:
                    pass
            else:
                dicts[item[1]] = (revision + "_" + str(count) + "__" + author + ":" + item[0])
            count += 1
for key in dicts:
     try:
                   target=key.rsplit("/",2)[1]
                   fileName=key.rsplit("/",1)[1]
                   opr = dicts[key].rsplit(":", 1)[1]
                   revisionNo = dicts[key].split(":", 1)[0]
                   if opr == 'D':
                       print("File being skipped as it has been deleted : " + key)
                       pass
                   else:
                       print("File being moved and rename : " + key)
                   shutil.copy2(src+"/obdx/"+"/"+target+"/"+fileName,dest+"/"+target+"/"+"V"+product+"_"+version+"_"+revisionNo+"_"+fileName)

     except:
                    print("file not found" + key)
print("Replacing the placeholders")
updateFile(src+"/flyway/ddl","%ENTITY_ID%","OBDX_BU")
updateFile(src+"/flyway/dml","%ENTITY_ID%","OBDX_BU")
updateFile(src+"/flyway/dashboard","%ENTITY_ID%","OBDX_BU")

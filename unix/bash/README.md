# Commands Glosary

list information about all running processes.
```bash
ps -efc | sort -k 1 -r
```

List processes gathering most of the CPU load
```bash
ps -ceo pcpu,pid,user,args | sort -k 1
```

list processes with net access
```bash
lsof -Pni
```

list all connections with status ESTABLISHED, TIME_WAIT or LISTEN
```bash
netstat -atln
```

show the allocated swap disk or disks
```bash
swapon -s 
```

List in descendant order the files consuming space in Gigabytes
```bash
sudo du -ch -d2 . | sort -r | grep 'G'
```

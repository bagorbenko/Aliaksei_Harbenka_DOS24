#!/bin/bash

# Указание лог-файла
LOGFILE="server.log"

# Cтатус 200
echo "Users with status 200:"
grep 'status=200' $LOGFILE | awk -F 'ip=' '{print $2}' | awk -F ' status' '{print $1}' | sort | uniq

# Cтатус 403
echo "Users with error 403:"
grep 'status=403' $LOGFILE | awk -F 'user=' '{print $2}' | awk -F ' ip' '{print $1}' | sort | uniq

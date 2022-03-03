#!/bin/bash
IP=`kubectl get svc | grep influx | awk '{print $3}'`;
for i in `seq 1 10000`; do curl -s -o /dev/null http://$IP:8086; done  

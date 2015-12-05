#!/bin/bash

## Simple script which kills a specific process when VPN is down
## 1. the VPN interface is TUN
## 2. external IP should start with 9 or 193


GUARDED_PROCESS=/usr/bin/ANY   #replace with an actual process 
GUARDED_CMD=ANY                #replace with an actual command
TUN_STATE=0
while :
do
  PROCESS=$(ps aux | grep $GUARDED_PROCESS | grep -v grep | wc -l)
  ## For VPN the TUN interface
  TUN=$(ifconfig | grep tun0 | wc -l)
  if [ $TUN == "1" ] && [ $TUN_STATE == "0" ]
  then
    sleep 1
    EXT_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
  fi
  TUN_STATE=$TUN
  
  if [ $PROCESS == "1" ]
  then  
      if [ $TUN == "0" ]
      then
	killall $GUARDED_CMD;
	notify-send VPN "VPN TUN lost. process killed!";
      elif [[ $EXT_IP != 9* ]] && [[ $EXT_IP != 193* ]]
      then
	killall $GUARDED_CMD;
	notify-send VPN "process killed with IP: $EXT_IP!";
      fi
  fi
  
  sleep 1;
done
#!/bin/sh
YELLOW="\033[01;93m"
WHITE="\033[01;97m"
CLOSE="\033[m"
nohup warp-svc &
sleep 2
warp-cli registration new
warp-cli connect
sleep 6
IP=$(curl https://ifconfig.me)
clear
echo -e $YELLOW"IP:$WHITE$IP$CLOSE"

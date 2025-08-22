#!/bin/bash
proxy_ipv4(){
  nohup warp-svc &
  sleep 2
  warp-cli registration new
  warp-cli mode proxy
  warp-cli proxy port $PORT
  warp-cli connect
  tail -f /dev/null
}

proxy_ipv6(){
  nohup warp-svc &
  sleep 4
  warp-cli registration new
  warp-cli connect
  cat tinyproxy.conf | sed "s/Port 8888/Port $PORT/g" > /etc/tinyproxy/tinyproxy.conf
  tinyproxy
  tail -f /dev/null
}

connect(){
  nohup warp-svc &
  sleep 2
  warp-cli registration new
  warp-cli connect
}

if [[ $MODE == "ipv4" ]];then
  proxy_ipv4
elif [[ $MODE == "ipv6" ]];then
  proxy_ipv6
elif [[ $MODE == "connect" ]];then
  connect
elif [[ $MODE == "none" ]];then
  bash
else
  echo -e "\033[01;91mINVALID ARGUMENT\033[m"
fi

#!/bin/bash
warp_proxy(){
  nohup warp-svc &
  sleep 2
  warp-cli registration new
  warp-cli mode proxy
  warp-cli proxy port $2
  warp-cli connect
  tail -f /dev/null
}

warp_connect(){
  nohup warp-svc &
  sleep 2
  warp-cli registration new
  warp-cli connect
}

docker_start(){
  for (( i=1; i<=$2; i++ ));do
    PORT=$((40000 + i));
    NAME="proxy$i";
    docker rm proxy$i &> /dev/null
    docker run -d -e PROXY_PORT=$PORT --network host --name $NAME warp-proxy &> /dev/null
    echo -e "PROXY => socks5://localhost:$PORT"
    sleep 1
  done
}

test_ip(){
  for (( i=1; i<=$2; i++ ));do
    PORT=$((40000 + i))
    PROXY="socks5://localhost:$PORT"
    IP=$(curl --proxy $PROXY https://ifconfig.me)
    echo -e "PORT-IP\n$PORT - $IP"
  done  
}

if [[ $1 == "--port" ]];then
  warp_proxy $@
elif [[ $1 == "--docker" ]];then
  docker_start $@
elif [[ $1 == "--test" ]];then
  test_ip $@
elif [[ $1 == "--connect" ]];then
  warp_connect
elif [[ $1 == "--open" ]];then
  docker run --privileged -it -e OPTION=NONE --rm warp-proxy
elif [[ $1 == "NONE" ]];then
  bash
else
  echo -e "\033[01;91mINVALID ARGUMENT\033[m"
fi

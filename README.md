# cloudflare-warp-docker
This repository contains the configuration to run cloudflare-warp with docker and even turn it into a proxy accessible on the host machine.

## Build
```bash
docker build -t warp-proxy .
```

## Usage
#### ipv4
```bash
docker run -d -e MODE=ipv4 -e PORT=9001 --network host --name ipv4 warp-proxy
```
#### ipv6
> [!NOTE]
> To use IPv6 you must create a docker network and specify it when starting the container.
##### Creating network IPV6
```bash
docker network create --ipv6  --subnet "2001:db8:1::/64" docker-ipv6
```
##### Using for starting container
```bash
docker run -d -e MODE=ipv6 -e PORT=9001 --privileged --network docker-ipv6 --name ipv6 warp-proxy
```

## TEST IP
#### ipv4
```bash
curl -x socks5://localhost:9001
```
#### ipv6
> [!NOTE]
> You should inspect the docker network you created to get the corresponding ip of the ipv6 container you created.
##### inspecting ipv6 docker network
```bash
docker inspect network docker-ipv6
```
<p>You should look for something that contains the name of the container you created and then get the ipv4 of it</p>

##### EXAMPLE

```json
"Containers": {
  "xxxxxxxxxxxxxxxxxxxxxxxxxx": {
  "Name": "ipv6", // name of your container
  "EndpointID": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "MacAddress": "xxxxxxxxxxxxxxx",
  "IPv4Address": "172.18.0.2/16", // get this ip for using proxy
  "IPv6Address": "2001:db8:1::2/64"
}
```
##### RUN
```bash
curl -x http://172.18.0.2:9001 ifconfig.me
```

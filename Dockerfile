FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    curl ca-certificates wget gpg lsb-release nano tinyproxy

RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list \
    && apt-get update && apt-get install cloudflare-warp -y

WORKDIR /root
COPY warp.sh /root/
COPY tinyproxy.conf /root/
RUN mkdir -p /root/.local/share/warp/
RUN echo "yes" > /root/.local/share/warp/accepted-tos.txt

ENV MODE=ipv4
ENV PORT=3128

ENTRYPOINT ["warp.sh"]

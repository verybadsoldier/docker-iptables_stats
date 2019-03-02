FROM python:3.6
#FROM python:3.6-alpine

LABEL maintainer="verybadsoldier"
LABEL version="0.9.4"
LABEL description="Gather statistics from iptables and ipset and publish via MQTT"
LABEL vcs-url="https://github.com/verybadsoldier/docker-iptables_stats"


#RUN apk add build-base && \
#    apk add iptables && \
#    pip install iptables_stats && \
#    apk del build-base && \
#    rm -rf /var/cache/apk/*

RUN apt-get update -y && apt-get install -y gcc && \
    apt-get install -y python3 && apt-get install -y python3-pip && \
    apt-get install -y iptables && apt-get install -y ipset && \
    pip3 install iptables_stats && \
    apt-get remove --purge -y gcc && \
    apt-get autoremove -y && \ 
    rm -rf /var/lib/apt/lists/*

#COPY run_airsensor.sh /airsensor/run_airsensor.sh

CMD iptables_stats

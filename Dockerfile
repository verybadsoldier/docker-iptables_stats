FROM python:3.6-alpine

LABEL maintainer="verybadsoldier"
LABEL version="0.9.11"
LABEL description="Gather statistics from iptables and ipset and publish via MQTT"
LABEL vcs-url="https://github.com/verybadsoldier/docker-iptables_stats"


RUN apk add build-base && \
    apk add libc6-compat && \
    apk add iptables && \
    apk add ipset && \
    pip install iptables_stats==0.9.11 && \
    apk del build-base && \
    rm -rf /var/cache/apk/*

# all the following is needed cause of problems with ldconfig in alpine
# refer to: https://github.com/docker-library/python/issues/111
# python-iptables heavily relies on find_library()
Run ln -s /usr/lib/libip4tc.so.0 /usr/lib/libip4tc.so && \
    ln -s /usr/lib/libip6tc.so.0 /usr/lib/libip6tc.so

# replace original ldconfig with a fake ldconfig with prints a faked cache
# this is called by python's find_library()
COPY ldconfig /sbin/ldconfig

# some vars to also support loading correct dynamic libraries
ENV XTABLES_LIBDIR=/usr/lib/xtables
ENV PYTHON_IPTABLES_XTABLES_VERSION=12
ENV IPTABLES_LIBDIR=/usr/lib

CMD iptables_stats

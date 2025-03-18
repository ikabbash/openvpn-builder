FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y stunnel && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 1194

CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt update && \
    apt dist-upgrade -y && \
    apt install curl -y && \
        curl https://downloads.python.org/pypy/pypy3.10-v7.3.17-linux64.tar.bz2 -o /tmp/pypy3.tar.bz2 && tar xf /tmp/pypy3.tar.bz2 && \
            for exe in pypy pypy3 python python3; do ln -s /pypy3.10-v7.3.17-linux64/bin/$exe /usr/bin/$exe; done && \
            for exe in pypy pypy3 python python3; do ln -s /pypy3.10-v7.3.17-linux64/bin/$exe /usr/local/bin/$exe; done
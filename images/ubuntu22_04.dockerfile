FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive; apt update && apt dist-upgrade -y

RUN export DEBIAN_FRONTEND=noninteractive; apt install software-properties-common -y

RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt update -y

RUN export DEBIAN_FRONTEND=noninteractive; apt install python3.12 -y
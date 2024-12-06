FROM amazonlinux:2022

RUN yum update -y

RUN yum install -y sudo
RUN yum install -y shadow-utils
RUN yum install -y openssh-server

RUN yum install -y python3.10
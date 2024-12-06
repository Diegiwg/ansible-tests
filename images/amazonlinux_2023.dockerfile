FROM amazonlinux:2023

RUN yum update -y

RUN yum install -y sudo
RUN yum install -y shadow-utils
RUN yum install -y openssh-server
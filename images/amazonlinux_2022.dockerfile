FROM amazonlinux:2022

RUN yum update -y && \
        yum install -y sudo shadow-utils openssh-server python3.10
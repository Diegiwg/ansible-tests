FROM amazonlinux:2023

RUN yum update -y && \
        yum install -y sudo shadow-utils openssh-server python3.12 && \
            update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
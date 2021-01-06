# pull base image
FROM alpine:3.12

# Labels.
LABEL maintainer="alechivo847@gmail.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="AleMartinez-Devops/ansible" \
    org.label-schema.description="Ansible inside Docker" \
    org.label-schema.url="https://github.com/AleMartinez-Devops/docker-ansible" \
    org.label-schema.vcs-url="https://github.com/AleMartinez-Devops/docker-ansible" \
    org.label-schema.vendor="AMSystems" \
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa amsystems/ansible:2.8-alpine-3.11"

RUN apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base && \
    pip3 install --upgrade pip cffi wheel && \
    pip3 install ansible==2.10.3 && \
    pip3 install mitogen ansible-lint jmespath && \
    pip3 install --upgrade pywinrm && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]

FROM hub.maestro.io:5000/crisidev/debian
MAINTAINER Matteo Bigoi bigo@crisidev.org

RUN apt-get update
RUN apt-get install -y wget python python-pip python-dev libssl-dev libffi-dev bash curl

RUN mkdir /app
WORKDIR /app

RUN wget https://github.com/jwilder/docker-gen/releases/download/0.4.0/docker-gen-linux-amd64-0.4.0.tar.gz
RUN tar xvzf docker-gen-linux-amd64-0.4.0.tar.gz -C /usr/local/bin
RUN wget https://github.com/coreos/etcd/releases/download/v2.0.13/etcd-v2.0.13-linux-amd64.tar.gz
RUN tar xvzf etcd-v2.0.13-linux-amd64.tar.gz
RUN mv etcd-v2.0.13-linux-amd64/etcdctl /usr/local/bin

RUN pip install python-etcd
RUN pip install haproxy_log_analysis

ADD spartito.tmpl spartito.tmpl

ENV DOCKER_HOST unix:///var/run/docker.sock

CMD docker-gen -notify "/bin/bash /tmp/spartito.sh" -interval 10 spartito.tmpl /tmp/spartito.sh

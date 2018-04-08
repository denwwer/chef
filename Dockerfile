FROM ubuntu:16.04

RUN apt-get update && apt-get install -y build-essential curl git libfreetype6-dev libpng12-dev libzmq3-dev pkg-config python-dev python-numpy python-pip software-properties-common swig zip
RUN apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./ /app

CMD [ "sh", "chef.sh" ]

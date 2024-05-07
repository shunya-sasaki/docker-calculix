FROM ubuntu:22.04

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y sudo wget curl git
RUN apt-get install -y neovim
RUN apt-get install -y python3 python3-pip && \
    apt-get install -y build-essential gcc g++ gfortran make

RUN adduser ubuntu
COPY ./scripts/setup-calculix.sh /opt/setup-calculix.sh
RUN bash /opt/setup-calculix.sh 
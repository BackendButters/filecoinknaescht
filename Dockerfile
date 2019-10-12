FROM ubuntu:18.04

# Install.
RUN \
  apt-get update && \
  apt-get install software-properties-common && \
  add-apt-repository ppa:longsleep/golang-backports && \
  apt-get update && \
  apt-get install -y jq golang-1.12-go && \
  apt-get -y upgrade && \
  mkdir -p ~/code/go/src

# Set environment variables.
ENV HOME /root
ENV GOPATH $HOME/code/go
ENV PATH $PATH:$GOPATH/bin
ENV PATH $PATH:/usr/lib/go-1.12/bin

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]

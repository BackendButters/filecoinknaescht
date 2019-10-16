FROM ubuntu:18.04

# Install.
RUN \
  apt-get update && \
  apt-get install software-properties-common curl apt-utils git --no-install-recommends -y && \
  add-apt-repository ppa:longsleep/golang-backports && \
  apt-get update && \
  apt-get install --no-install-recommends -y jq golang-1.12-go pkg-config build-essential && \
  apt-get -y upgrade && \
  mkdir -p ~/code/go/src

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y

# Set environment variables.
ENV HOME /root
ENV GOPATH $HOME/code/go
ENV PATH $PATH:$GOPATH/bin
ENV PATH $PATH:/usr/lib/go-1.12/bin
ENV FILECOIN_USE_PRECOMPILED_RUST_PROOFS=true

RUN mkdir -p ${GOPATH}/src/github.com/filecoin-project && \
	git clone https://github.com/filecoin-project/go-filecoin.git ${GOPATH}/src/github.com/filecoin-project/go-filecoin && \
	cd $GOPATH/src/github.com/filecoin-project/go-filecoin && \
	git fetch origin && \
	git checkout tags/0.5.7 && \
	git submodule update --init --recursive && \
	go run ./build deps && \
	go run ./build build && \
	cp go-filecoin $GOPATH/bin

RUN $GOPATH/src/github.com/filecoin-project/go-filecoin/go-filecoin init --devnet-user --genesisfile=https://genesis.user.kittyhawk.wtf/genesis.car

WORKDIR $GOPATH/src/github.com/filecoin-project/go-filecoin

CMD ["go-filecoin daemon"]

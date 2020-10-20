FROM ubuntu:18.04
MAINTAINER napat

# Update the OS and install any OS packages needed.
RUN apt-get update -y

RUN apt-get install -y git build-essential libtool autotools-dev automake pkg-config autoconf
RUN apt-get install -y libssl-dev libevent-dev bsdmainutils libboost-all-dev
RUN apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler #opt: only needed if you want bitcoin-qt
RUN apt-get install -y libzmq3-dev clang-tools-10 # provides ZMQ API 4.x
RUN ls /usr/bin/
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 100
RUN apt-get install -y software-properties-common                               #opt: only needed if your wallet uses the old format
RUN add-apt-repository ppa:bitcoin-unlimited/bu-ppa                          #     this is not needed if your wallet will use the new
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev python3-git curl
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo --version
RUN rustc --version

WORKDIR /home/safeuser

COPY . /home/safeuser/bu/
WORKDIR /home/safeuser/bu
RUN ls

RUN ./autogen.sh
RUN ./configure
RUN make
RUN make electrscash

# RUN sudo make install

FROM debian:latest

ENV TZ="UTC" \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color

RUN apt update -qq \
    && apt-get install -y -qq lsb-release gnupg git wget build-essential cmake gcc make apt-utils zip unzip tzdata libtool automake m4 re2c curl supervisor libssl-dev zlib1g-dev libcurl4-gnutls-dev libprotobuf-dev \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove

WORKDIR /srv

RUN wget https://archives.boost.io/release/1.85.0/source/boost_1_85_0.tar.gz && \
    tar -xf boost_1_85_0.tar.gz && \
    cd boost_1_85_0 && \
    sh bootstrap.sh && \
    ./b2 install release variant=release debug-symbols=on optimization=speed \
                                  --with-json \
                                  --with-thread \
                                  --with-headers \
                                  --with-coroutine \
                                  --with-iostreams \
                                  --with-system \
                                  --with-regex \
                                  --with-system \
                                  --with-serialization \
                                  --with-program_options \
                                  --with-exception \
                                  --with-contract \
                                  --with-container \
                                  --with-context \
                                  --with-chrono \
                                  --with-locale \
                                  --with-thread \
                                  --with-test \
                                  --with-timer \
                                  --with-random \
                                  --with-charconv \
                                  --with-fiber \
                                  --with-atomic \
                                  --with-filesystem \
                                  --with-date_time \
                                  --with-url && \
    cd .. && \
    rm boost_1_85_0 -rf && \
    rm boost_1_85_0.tar.gz

WORKDIR /srv

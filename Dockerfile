FROM debian:latest

ENV TZ="UTC" \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color

WORKDIR /srv

RUN apt update -qq \
    && apt-get install -y -qq lsb-release gnupg git wget build-essential cmake gcc make apt-utils zip unzip tzdata libtool automake m4 re2c curl supervisor libssl-dev zlib1g-dev libcurl4-gnutls-dev libprotobuf-dev \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove \
    && wget https://archives.boost.io/release/1.86.0/source/boost_1_86_0.tar.gz  \
    && tar -xf boost_1_86_0.tar.gz  \
    && cd boost_1_86_0  \
    && sh bootstrap.sh  \
    && ./b2 install release variant=release debug-symbols=on optimization=speed \
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
                                  --with-url  \
    && cd ..  \
    && rm boost_1_86_0 -rf  \
    && rm boost_1_86_0.tar.gz \
    && git clone https://github.com/trusch/libbcrypt \
    && cd libbcrypt \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && ldconfig \
    && cd .. \
    && cd .. \
    && rm libbcrypt -rf \
    && wget https://github.com/getsentry/sentry-native/releases/download/0.7.9/sentry-native.zip \
    && unzip sentry-native.zip -d sentry \
    && rm sentry-native.zip \
    && cd sentry \
    && cmake -B build -D SENTRY_BACKEND=crashpad -D CMAKE_BUILD_TYPE=RelWithDebInfo \
    && cmake --build build --parallel \
    && cmake --install build \
    && cd .. \
    && rm sentry -rf \
    && git clone https://github.com/karastojko/mailio.git \
    && cd mailio \
    && cmake . \
    && make install \
    && cd .. \
    && rm mailio -rf \
    && git clone https://github.com/nlohmann/json.git \
    && cd json \
    && cmake . \
    && make \
    && make install \
    && cd .. \
    && rm json -rf \
    && git clone https://github.com/pantor/inja.git \
    && cd inja \
    && cmake . -DBUILD_TESTING=OFF -DINJA_BUILD_TESTS=OFF -DBUILD_BENCHMARK=OFF -DCOVERALLS=OFF \
    && make install \
    && cd .. \
    && rm inja -rf

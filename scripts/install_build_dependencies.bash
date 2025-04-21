#!/bin/bash
set -e
set -o pipefail

apt update -qq

apt-get install -y -qq lsb-release \
                       gnupg \
                       git \
                       wget \
                       build-essential \
                       cmake \
                       gcc \
                       make \
                       apt-utils \
                       zip \
                       unzip \
                       tzdata \
                       libtool \
                       automake \
                       m4 \
                       re2c \
                       curl \
                       supervisor \
                       libssl-dev \
                       zlib1g-dev \
                       libcurl4-gnutls-dev \
                       libprotobuf-dev \
                       python3 \
                       iputils-ping \
                       netcat-traditional \
                       default-mysql-client \
                       lcov \
                       doxygen \
                       graphviz \
                       rsync \
                       gcovr \
                       musl \
                       musl-dev \
                       musl-tools

ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
apt-get clean
apt-get autoclean
apt-get autoremove

git clone https://github.com/trusch/libbcrypt bcrypt
cd bcrypt
mkdir build
cd build
cmake ..
make -j4
make install
ldconfig
cd ../..
rm bcrypt -Rf

git clone https://github.com/nlohmann/json.git json
cd json
git checkout tags/v3.11.3
mkdir build
cd build
cmake .. -DJSON_BuildTests=OFF
make -j4
make install
ldconfig
cd ../..
rm json -Rf

git clone https://github.com/pantor/inja inja
cd inja
git checkout tags/v3.4.0
mkdir build
cd build
cmake .. -DBUILD_TESTING=OFF -DINJA_EXPORT=OFF -DINJA_BUILD_TESTS=OFF -DBUILD_BENCHMARK=OFF
make -j4
make install
ldconfig
cd ../..
rm inja -Rf


git clone https://github.com/jeremydumais/CPP-SMTPClient-library.git smtpclient
cd smtpclient
cmake .
make -j4
make install
ldconfig
cd ..
rm smtpclient -Rf

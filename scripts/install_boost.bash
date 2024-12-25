#!/bin/bash
set -e
set -o pipefail

BOOST_VERSION_DASH=$(echo $BOOST_VERSION | sed 's/\./_/g')

if [ "$BOOST_VARIANT" == "debug" ]; then
  DEBUG="on"
else
  DEBUG="off"
fi

wget https://boostorg.jfrog.io/artifactory/main/release/$BOOST_VERSION/source/boost_$BOOST_VERSION_DASH.tar.gz

tar -xf boost_$BOOST_VERSION_DASH.tar.gz

cd boost_$BOOST_VERSION_DASH
sh bootstrap.sh

./b2 install $BOOST_VARIANT variant=$BOOST_VARIANT debug-symbols=$DEBUG \
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
                                  --with-url

cd ..
rm boost_$BOOST_VERSION_DASH -rf
rm boost_$BOOST_VERSION_DASH.tar.gz
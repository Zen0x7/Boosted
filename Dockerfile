FROM debian:latest

ARG BOOST_VERSION="1.87.0"
ARG BOOST_VARIANT="release"

ENV TZ="UTC" \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color \
    BOOST_ROOT="/srv/boost"

WORKDIR /srv

COPY scripts/install_build_dependencies.bash install_build_dependencies.bash
COPY scripts/install_boost.bash install_boost.bash

RUN bash install_build_dependencies.bash \
    && bash install_boost.bash

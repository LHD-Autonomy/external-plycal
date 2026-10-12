FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libpcl-dev \
    libceres-dev \
    libeigen3-dev \
    libvtk6-dev \
    libvtk6-qt-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
FROM ubuntu:xenial
MAINTAINER Matti Eskelinen "matti.j.eskelinen@gmail.com"

RUN apt-get update
RUN apt-get install -y libopencv-dev yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils pkg-config curl build-essential checkinstall cmake haskell-platform git
RUN apt-get autoclean && apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /source

VOLUME ["/source"]
WORKDIR /source
CMD ["bash"]

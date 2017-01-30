FROM ubuntu:xenial
MAINTAINER Matti Eskelinen "matti.j.eskelinen@gmail.com"
LABEL version="0.0.2"

RUN apt-get update && apt-get install -y \
  pkg-config \
  build-essential \
  cmake \
  execstack \
  yasm \
  git \
  python-dev \
  python-numpy \
  libpython* \
  haskell-platform \
  openjdk-8-jre \
  openjdk-8-jdk \
  ant \
  libjffi-java \
  libjffi-jni \
  libjpeg-dev \
  libjasper-dev \
  libopenexr-dev \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  libavresample-dev \
  libv4l-dev \
  libtbb-dev \
  libqt4-dev \
  libgtk2.0-dev \
  libmp3lame-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  libtheora-dev \
  libvorbis-dev \
  libxvidcore-dev \
  x264 \
  v4l-utils \
  libatlas* \
  liblapack* \
  libblas* \
  libopenblas* \
  libeigen* \
  libgsl* \
  gsl-bin \
  libwrap0-dev \
  && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /tmp/
RUN git clone https://github.com/Itseez/opencv.git
WORKDIR /tmp/opencv/
RUN git checkout 2.4.13.2
RUN mkdir build

# configure and build opencv
WORKDIR /tmp/opencv/build
RUN cmake \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_DOCS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DBUILD_TESTS=OFF \
  -DWITH_TBB=ON \
  -DWITH_OPENMP=ON \
  -DWITH_IPP=ON \
  -DWITH_CSTRIPES=ON \
  -DWITH_CUDA=OFF \
  -DWITH_OPENCL=OFF \
  -DWITH_1394=OFF \
  -DWITH_FFMPEG=ON \
  -DWITH_OPENEXR=ON ..

RUN make && make install

# configure java libraries
RUN mkdir /usr/lib/jni \
  && mv /usr/local/share/OpenCV/java/libopencv_java2413.so /usr/lib/jni/
RUN execstack -c /usr/lib/jni/libopencv_java2413.so
RUN ln -s /usr/local/share/OpenCV/java/opencv-2413.jar /usr/share/java/opencv.jar

# need to build twice to get both static and shared libraries
RUN rm -rf *
RUN cmake \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_DOCS=OFF \
  -DBUILD_PERF_TESTS=OFF \
  -DBUILD_TESTS=OFF \
  -DWITH_TBB=ON \
  -DWITH_OPENMP=ON \
  -DWITH_IPP=ON \
  -DWITH_CSTRIPES=ON \
  -DWITH_CUDA=OFF \
  -DWITH_OPENCL=OFF \
  -DWITH_1394=OFF \
  -DWITH_FFMPEG=ON \
  -DWITH_OPENEXR=ON ..
RUN make && make install

# configure lib paths
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
RUN ldconfig

# build CV library for haskell
WORKDIR /tmp
RUN git clone https://github.com/aleator/CV.git
WORKDIR /tmp/CV/
RUN cabal update && cabal install --global cabal-install c2hs
# something goes wrong with man install and causes problems later, remove
RUN rm /usr/local/man/man1/cabal.1
RUN cabal install --global

RUN apt-get autoclean && apt-get clean
RUN rm -rf /tmp/* /var/tmp/*

RUN mkdir /source
VOLUME ["/source"]
WORKDIR /source

CMD ["bash"]

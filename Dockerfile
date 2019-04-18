FROM ubuntu:18.04

# Install gstreamer and opencv dependencies
RUN \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-doc \
    gstreamer1.0-tools \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev && \
  \
  apt-get install -y \
    wget \
    unzip \
    build-essential \
    cmake \
    git \
    pkg-config \
    libgtk-3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libx265-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    openexr \
    libatlas-base-dev \
    libtbb2 \
    libtbb-dev \
    libdc1394-22-dev \
    python3-dev \
    python3-pip \
    python3-numpy

# Download OpenCV and build from source
RUN \
  cd ~ && \
  wget -O ~/opencv.zip https://github.com/opencv/opencv/archive/4.1.0.zip && \
  unzip ~/opencv.zip && \
  mv ~/opencv-4.1.0/ ~/opencv/ && \
  rm -rf ~/opencv.zip && \
  wget -O ~/opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.0.zip && \
  unzip ~/opencv_contrib.zip && \
  mv ~/opencv_contrib-4.1.0/ ~/opencv_contrib/ && \
  rm -rf ~/opencv_contrib.zip && \
  \
  cd ~/opencv && \
  mkdir build && \
  cd build && \
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D WITH_GSTREAMER=ON \
    -D WITH_GSTREAMER_0_10=OFF \
    -D BUILD_EXAMPLES=ON .. && \
  \
  cd ~/opencv/build && \
  make -j $(nproc) && \
  make install && \
  ldconfig

WORKDIR /development

COPY main.py /development

CMD ["sh", "-c", "python3 -u main.py"]

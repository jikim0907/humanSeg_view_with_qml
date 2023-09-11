#!/bin/bash

#qtcreator install env set auto
sudo apt-get install g++ -y &&
sudo apt-get install build-essential -y &&
sudo apt install libxcb-xinerama0-dev -y &&

#gcc
sudo apt-get update -y && 
sudo apt-get upgrade -y && 
sudo apt-get dist-upgrade -y && 
sudo apt-get install software-properties-common -y && 
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y && 
sudo apt-get update -y &&
sudo apt-get install gcc-9 g++-9 -y && 
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && 
sudo update-alternatives --config gcc &&

#MPEG install
sudo apt install libdvdnav4 libdvdread7 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly -y &&
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y  libdvd-pkg ubuntu-restricted-extras &&
sudo apt-get install vlc -y &&

#git
sudo apt install git -y &&

#python 3
sudo apt install -y zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev &&
sudo apt install python -y &&
sudo apt-get install -y python2.7-dev python3.8-dev python-numpy python3-numpy &&
sudo apt-get install -y python-numpy python3-numpy  &&

#cmake
sudo apt install -y cmake &&

#ffmpeg
mkdir -p dependencies/ffmpeg_sources
mkdir -p dependencies/ffmpeg_build
mkdir -p dependencies/bin
cd ~/dependencies/ffmpeg_sources
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 &&
tar xjvf ffmpeg-snapshot.tar.bz2 &&

sudo apt-get install ffmpeg -y &&
sudo apt install libunistring-dev libaom-dev -y &&
sudo apt-get install nasm -y &&

sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  libx264-dev &&

cd ~/dependencies/ffmpeg_sources/ffmpeg 

git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
PATH="$HOME/dependencies/bin:$PATH" PKG_CONFIG_PATH="$HOME/dependencies/ffmpeg_build/lib/pkgconfig"
./configure  --prefix="$HOME/dependencies/ffmpeg_build"   --pkg-config-flags="--static"   --extra-cflags="-I$HOME/dependencies/ffmpeg_build/include"   --extra-ldflags="-L$HOME/dependencies/ffmpeg_build/lib"   --extra-libs=-lpthread   --extra-libs=-lm   --bindir="$HOME/dependencies/bin"   --enable-gpl     --enable-libfreetype --enable-libx264 --enable-nonfree &&
PATH="$HOME/dependencies/bin:$PATH" make -j$(nproc)
make install &&

#H.264 decoder
sudo apt-get install -y gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-libav &&

#openCV 4.4.0
cd ~
mkdir -v -p dependencies/opencv
cd ~/dependencies/opencv
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.4.0.zip &&
unzip opencv.zip &&
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.4.0.zip &&
unzip opencv_contrib.zip &&
mkdir opencv-4.4.0/build
cd opencv-4.4.0/build 
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
-D INSTALL_PYTHON_EXAMPLES=OFF  -D INSTALL_C_EXAMPLES=OFF -D WITH_FFMPEG=1 \
-D BUILD_LIST=core,imgproc,imgcodecs,highgui,video,videoio .. &&
make -j$(nproc) &&
sudo make install &&


#python과 opencv묶기
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" -y &&
sudo apt-get update -y &&
sudo apt-get install -y libv4l-dev v4l-utils  &&
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev &&
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng-dev libjpeg8-dev &&
sudo apt-get install -y libgtk-3-dev &&
sudo apt-get install -y libatlas-base-dev gfortran &&
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev &&
sudo apt-get install -y libeigen3-dev libqt5opengl5-dev libqt5svg5-dev libgl1-mesa-dev libfftw3-dev &&

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=OFF -D WITH_IPP=OFF -D WITH_1394=OFF -D BUILD_WITH_DEBUG_INFO=OFF -D BUILD_DOCS=OFF -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=OFF -D BUILD_PACKAGE=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D WITH_QT=OFF -D WITH_GTK=ON -D WITH_OPENGL=ON -D BUILD_opencv_python3=ON -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.4.0/modules -D WITH_V4L=ON  -D WITH_FFMPEG=ON -D WITH_XINE=ON -D OPENCV_ENABLE_NONFREE=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D OPENCV_SKIP_PYTHON_LOADER=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D PYTHON3_INCLUDE_DIR=/usr/include/python3.8 -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ -D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages -D PYTHON3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.8.so .. &&
make -j$(nproc) &&
sudo make install &&

#tensorflow
sudo apt install -y curl &&
cd ~/dependencies 
git clone --branch r2.2 --single-branch  https://github.com/tensorflow/tensorflow.git &&
cd tensorflow

./tensorflow/lite/tools/make/download_dependencies.sh &&
./tensorflow/lite/tools/make/build_lib.sh &&

sudo apt-get install -y v4l2loopback-dkms && 
sudo ldconfig&&

#remove zip, tar...
sudo rm ~/dependencies/ffmpeg_sources/ffmpeg-snapshot.tar.bz2 ~/dependencies/opencv/opencv_contrib.zip  ~/dependencies/opencv/opencv.zip


FROM ubuntu:latest

# vars
ENV JULIA_VERSION=1.6.3
ENV JULIUS_VERSION=4.3.1
ENV TZ=Asia/Jakarta

# image setup
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtimeapt-get update && apt-get install \
  make \
  tar \
  libc6-dev-i386 \
  libx11-dev \
  curl \
  gcc \
  build-essential \ 
  zlib1g-dev \
  libsdl2-dev \
  libasound2-dev \
  python3 \
  alsa-base \
  alsa-utils \
  pulseaudio \
  -y && echo $TZ > /etc/timezone
RUN 

# setup dirs
RUN mkdir -p /opt/voxforce/bin/htk && \
  mkdir -p /opt/voxforce/bin/julius

# setup workdir
WORKDIR /root

# install htk
COPY htk.tar.gz /root/htk.tar.gz
COPY htk_setup.sh /root/htk_setup.sh

RUN ./htk_setup.sh && mv htk/bin.cpu /opt/voxforce/bin/htk/bin

# install Julia
RUN curl -s https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-$JULIA_VERSION-linux-x86_64.tar.gz | tar -xvzf -
RUN mv julia-$JULIA_VERSION/ /opt/julia && ln -s /opt/julia/bin/julia /usr/local/bin/julia

# install Julius
RUN curl -sL http://voxforge.org/home/dev/acousticmodels/linux/create/htkjulius/tutorial/download/julius-standard-alsa-$JULIUS_VERSION.tar.gz | tar -xvzf -
RUN mv julius-$JULIUS_VERSION /opt/julius && ln -s /opt/julius/bin/julius /usr/local/bin/julius

# setup paths
ENV PATH="${PATH}:/opt/voxforce/bin/htk/bin:/opt/voxforce/bin/julius/bin"

CMD ["bash"]


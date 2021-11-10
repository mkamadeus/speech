FROM ubuntu:latest

# vars
ENV JULIA_VERSION 1.6.3
ENV JULIUS_VERSION 4.3.1

# image setup
RUN apt-get update && apt-get install \
  make \
  tar \
  libc6-dev-i386 \
  libx11-dev \
  curl \
  gcc \
  build-essential \
  -y

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
RUN curl -s http://jaist.dl.sourceforge.jp/julius/60273/julius-$JULIUS_VERSION.tar.gz | tar -xvzf - && cd julius-$JULIUS_VERSION && ./configure && make && make install
RUN mkdir -p /opt/julius && curl -s http://jaist.dl.sourceforge.jp/julius/60416/dictation-kit-v$JULIUS_VERSION-linux.tgz | tar -C /opt/julius -xvzf -

# setup paths
ENV PATH="${PATH}:/opt/voxforce/bin/htk/bin:/opt/voxforce/bin/julius/bin"

CMD ["bash"]


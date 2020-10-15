FROM ubuntu:bionic

LABEL maintainer="calvintam236"
LABEL description="ethminer in Docker. Supports GPU mining."

WORKDIR /tmp/

ADD \
https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin \
.

ADD \
https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub \
.

RUN \
mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
&& apt-get update \
&& apt-get -y --no-install-recommends install gnupg2 software-properties-common \
&& apt-key add 7fa2af80.pub \
&& add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /" \
&& apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install cuda-runtime-10-2 \
&& rm -rf /var/lib/apt/lists/* \

# Git repo set up
RUN git clone https://github.com/ethereum-mining/ethminer; \
    cd ethminer; \
    git checkout tags/v0.18.0

# Build
RUN cd ethminer; \
    mkdir build; \
    cd build; \
    cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF -DETHSTRATUM=ON; \
    cmake --build .; \
    make install;

ENTRYPOINT ["/usr/local/ethminer/ethminer"]
CMD ["bash", "-c", "-P" , "stratums://0xBAC4787497Ac1fcf37510EB2362F91FDc87f3519.aws@us1.ethermine.org:4444"]

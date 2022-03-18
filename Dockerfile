FROM ubuntu:xenial

ARG bcftoolsVer="1.15"

LABEL base.image="ubuntu:xenial"
LABEL dockerfile.version="1"
LABEL software1="bcftools"
LABEL description1="Variant calling and manipulating files in the Variant Call Format (VCF) and its binary counterpart BCF"
LABEL website1="https://github.com/samtools/bcftools"
LABEL license1="https://github.com/samtools/bcftools/blob/develop/LICENSE"


ARG bedtoolsVer="2.30.0"


LABEL software2="bcftools"
LABEL description2="Variant calling and manipulating files in the Variant Call Format (VCF) and its binary counterpart BCF"
LABEL website2="https://github.com/samtools/bcftools"
LABEL license2="https://github.com/samtools/bcftools/blob/develop/LICENSE"


# install dependencies, cleanup apt garbage
RUN apt-get update && apt-get install --no-install-recommends -y \
 wget \
 ca-certificates \
 perl \
 bzip2 \
 autoconf \
 automake \
 make \
 gcc \
 zlib1g-dev \
 libbz2-dev \
 liblzma-dev \
 libcurl4-gnutls-dev \
 libssl-dev \
 libperl-dev \
 libgsl0-dev && \
 rm -rf /var/lib/apt/lists/* && apt-get autoclean



# get bcftools and make /data
RUN wget --no-check-certificate https://github.com/samtools/bcftools/releases/download/${bcftoolsVer}/bcftools-${bcftoolsVer}.tar.bz2 && \
 tar -vxjf bcftools-${bcftoolsVer}.tar.bz2 && \
 rm bcftools-${bcftoolsVer}.tar.bz2 && \
 cd bcftools-${bcftoolsVer} && \
 make && \
 make install 


RUN cd /usr/local/bin && \
 wget --no-check-certificate https://github.com/arq5x/bedtools2/releases/download/v${bedtoolsVer}/bedtools.static.binary && \
 mv bedtools.static.binary bedtools && \
 chmod +x bedtools 
 
 
RUN mkdir /data

# set $PATH (honestly unnecessary here, lol) and locale settings for singularity compatibility
ENV PATH="$PATH" \
 LC_ALL=C

# set working directory
WORKDIR /data
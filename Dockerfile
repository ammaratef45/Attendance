FROM adamantium/flutter

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && \
    apt-get install -qy curl ca-certificates gnupg2 build-essential --no-install-recommends && apt-get clean

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y build-essential && \
    apt-get install -y zlib1g && \
    apt-get install zlib1g-dev

RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.3.3"
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && gem install pdd"

RUN apt-get install -y python-pip && \
    pip install firebase-admin

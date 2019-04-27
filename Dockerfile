FROM adamantium/flutter

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y build-essential && \
    apt-get install -y zlib1g && \
    apt-get install zlib1g-dev

RUN apt-get install -y gnupg2 && \
    mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.co && \
    gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby && \
    sudo -s source /usr/local/rvm/scripts/rvm && \
    gem install pdd

RUN apt-get install -y python-pip && \
    pip install firebase-admin

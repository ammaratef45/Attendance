FROM adamantium/flutter

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y build-essential && \
    apt-get install -y zlib1g && \
    apt-get install zlib1g-dev && \
    wget https://www.python.org/ftp/python/3.6.7/Python-3.6.7.tgz && \
    tar xvzf Python-3.6.7.tgz && \
    cd Python-3.6.7 && \
    ./configure && make && \
    make install

RUN wget https://www.python.org/ftp/python/2.7/Python-2.7.tgz && \
    tar xvzf Python-2.7.tgz && \
    cd Python-2.7 && \
    ./configure && make && \
    make install

RUN apt-get install -y python-pip && \
    pip install firebase-admin

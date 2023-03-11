FROM debian:11.6
USER root

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y curl ca-certificates openssl net-tools \
        git gnupg wget locales nano vim mc zip unzip jq \
        procps software-properties-common screen \
        build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev \
        libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev

RUN mkdir /var/compile \
    && cd /var/compile \
    && wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz \
    && tar -xvf Python-3.10.0.tgz \
    && cd Python-3.10.0 \
    && ./configure --enable-optimizations \
    && make PROFILE_TASK="-m test.regrtest --pgo -j $(nproc)" -j $(nproc) \
    && make altinstall \
    && /usr/local/bin/python3.10 -m venv /var/venv \
    && source /var/venv/bin/activate \
    && pip install --no-input torch==1.13.1 \
    && pip install --no-input fairscale==0.4.13 \
    && pip install --no-input fire==0.5.0 \
    && pip install --no-input sentencepiece==0.1.97

#################################################################
# Configure
#################################################################
VOLUME ["/var/llama-cpu", "/mnt/models"]
WORKDIR /var/llama-cpu

ENTRYPOINT ["tail", "-f", "/dev/null"]

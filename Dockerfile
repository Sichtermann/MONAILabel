FROM ubuntu:20.04

RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
    python3.8 python3-pip python3-setuptools python3-dev \
    g++ gcc \
    python-is-python3 \
    git

RUN rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && apt-get clean

RUN python3 -m pip install --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir monailabel numpy

WORKDIR /usr

RUN git clone https://github.com/Project-MONAI/MONAILabel
RUN mv MONAILabel monailabel

RUN monailabel apps --download --name deepedit --output /usr/monailabel/apps
RUN monailabel datasets --download --name Task09_Spleen --output /usr/monailabel/datasets

ENTRYPOINT monailabel start_server --app /usr/monailabel/apps/deepedit --studies /usr/monailabel/datasets/Task09_Spleen/imagesTr
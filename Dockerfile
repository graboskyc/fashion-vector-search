FROM ubuntu:23.04
ENV CONTAINER_SHELL=bash
ENV CONTAINER=

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# basic app installs
# two steps because i kept getting cache errors without it
RUN apt-get clean && \
    apt-get update
RUN apt-get install -y \
        python3.11 \
        wget

# links
RUN ln -s /usr/bin/python3.11 /usr/bin/python3 -f
RUN ln -s /usr/bin/python3.11 /usr/bin/python -f

# break venv req
RUN rm /usr/lib/python3.11/EXTERNALLY-MANAGED

# install pip
RUN wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

# copy over webapp
RUN mkdir /opt/fashion
COPY ./encoder /opt/fashion/encoder
COPY ./webapp /opt/fashion/webapp
COPY ./requirements.txt /opt/fashion/requirements.txt
COPY ./preloadpackages.py /opt/fashion/preloadpackages.py

# install pip required packages
RUN python3 -m pip install -r /opt/fashion/requirements.txt

RUN cd /opt/fashion/webapp
WORKDIR /opt/fashion/webapp
RUN python3 /opt/fashion/preloadpackages.py
ENTRYPOINT ["python3", "/opt/fashion/webapp/flask_server.py"]
#CMD ["/bin/bash"]

EXPOSE 5010
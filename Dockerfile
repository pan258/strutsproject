FROM python:2.7.18-buster

RUN python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools
RUN pip install urllib3 ipaddress requests docopt

RUN apt-get update && \
    apt-get install -y nmap screen dnsutils curl wget jq && \
    apt-get clean

RUN mkdir /struts2
RUN curl -o /struts2/strutsrce.py https://dl.packetstormsecurity.net/1703-exploits/struntsrce.py.txt

# sleep so that container stays up for the demo
CMD [ "sleep",  "86400"]

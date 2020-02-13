ARG tomcat_version=7

FROM tomcat:${tomcat_version}

ARG struts2_version=2.3.12
ARG owner_email=me@me.com

LABEL maintainer="Me <me@me.com>"
LABEL Project=Sapporo

RUN apt-get update
RUN apt-get -y install curl git nmap dnsutils 
RUN set -ex \
	&& rm -rf /usr/local/tomcat/webapps/* \
	&& chmod a+x /usr/local/tomcat/bin/*.sh
RUN curl -o /usr/local/tomcat/webapps/ROOT.war -k https://repo1.maven.org/maven2/org/apache/struts/struts2-showcase/${struts2_version}/struts2-showcase-${struts2_version}.war
EXPOSE 8080

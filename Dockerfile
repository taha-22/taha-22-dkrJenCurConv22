FROM tomcat:8.0-alpine

LABEL maintainer="taha-22"

ARG JMETER_VERSION="5.1.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN	${JMETER_HOME}/bin
ENV JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre


# Install JDK8 &JMETER
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Configure tomcat and Deploy REST web service
ADD ./tomcat-users.xml /usr/local/tomcat/conf/
ADD ./dist/dkrJenCurConv.war /usr/local/tomcat/webapps/

# Configure jmeter testing
RUN mkdir -p /usr/local/jmetertests
ADD ./jmeterCurConvRS.jmx /usr/local/jmetertests/jmeterCurConvRS.jmx


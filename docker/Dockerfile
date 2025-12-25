FROM alpine:3.19 AS downloader

RUN apk add --no-cache curl

WORKDIR /downloads

# Jenkins WAR
RUN curl -fsSL https://updates.jenkins.io/download/war/2.440.1/jenkins.war -o jenkins.war

# Jolokia WAR
RUN curl -fsSL https://repo1.maven.org/maven2/org/jolokia/jolokia-war/1.7.2/jolokia-war-1.7.2.war -o jolokia.war

# Prometheus Java Agent
RUN curl -fsSL https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.20.0/jmx_prometheus_javaagent-0.20.0.jar -o prometheus-agent.jar

FROM tomcat:9.0-jdk17

LABEL maintainer="email@gmail.com"
LABEL description="Container Tomcat 9 com Jenkins e Prometheus Agent"


RUN rm -rf /usr/local/tomcat/webapps/*

RUN cp -r /usr/local/tomcat/webapps.dist/ROOT /usr/local/tomcat/webapps/ROOT
RUN cp -r /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/manager


COPY conf/tomcat-users.xml /usr/local/tomcat/conf/
COPY conf/context.xml /usr/local/tomcat/webapps/manager/META-INF/

COPY conf/prometheus-config.yaml /usr/local/tomcat/conf/prometheus-config.yaml
COPY --from=downloader /downloads/prometheus-agent.jar /usr/local/tomcat/prometheus-agent.jar

COPY --from=downloader /downloads/jenkins.war /usr/local/tomcat/webapps/jenkins.war
COPY --from=downloader /downloads/jolokia.war /usr/local/tomcat/webapps/jolokia.war

EXPOSE 8080 8081
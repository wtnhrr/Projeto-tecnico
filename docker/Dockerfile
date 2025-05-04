# Etapa 1: Baixar artefatos
FROM alpine:3.19 AS downloader

RUN apk add --no-cache curl

WORKDIR /downloads

# Jenkins WAR
RUN curl -fsSL https://updates.jenkins.io/download/war/2.491/jenkins.war -o jenkins.war

# Jolokia WAR
RUN curl -fsSL https://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-agent-war/2.2.9/jolokia-agent-war-2.2.9.war -o jolokia.war

# Etapa 2
FROM tomcat:11.0.6-jdk17

LABEL maintainer="email@gmail.com"
LABEL description="Container Tomcat com Jenkins e Jolokia"

# Limpeza de aplicações padrão
RUN rm -rf /usr/local/tomcat/webapps/*

# aplicações básicas
COPY --from=tomcat:11.0.6-jdk17 /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/manager
COPY --from=tomcat:11.0.6-jdk17 /usr/local/tomcat/webapps.dist/ROOT /usr/local/tomcat/webapps/ROOT

# Configurações personalizadas
COPY conf/tomcat-users.xml /usr/local/tomcat/conf/
COPY conf/context.xml /usr/local/tomcat/webapps/manager/META-INF/

# Copia os WARs baixados
COPY --from=downloader /downloads/jenkins.war /usr/local/tomcat/webapps/jenkins.war
COPY --from=downloader /downloads/jolokia.war /usr/local/tomcat/webapps/jolokia.war

EXPOSE 8080
FROM tomcat:11.0.6-jdk17

LABEL maintainer="email@gmail.com"
LABEL description="Container tomcat com jenkins e jolokia"

RUN rm -rf /usr/local/tomcat/webapps/*

RUN cp -r /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/ && \
    cp -r /usr/local/tomcat/webapps.dist/ROOT /usr/local/tomcat/webapps/

COPY conf/tomcat-users.xml /usr/local/tomcat/conf/
COPY conf/context.xml /usr/local/tomcat/webapps/manager/META-INF/

RUN wget -q https://updates.jenkins.io/download/war/2.491/jenkins.war -O /usr/local/tomcat/webapps/jenkins.war

RUN wget -q https://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-agent-war/2.2.9/jolokia-agent-war-2.2.9.war -O /usr/local/tomcat/webapps/jolokia.war

EXPOSE 8080
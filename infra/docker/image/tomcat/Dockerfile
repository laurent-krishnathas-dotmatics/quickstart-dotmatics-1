FROM centos:7.6.1810
RUN  yum update -y && \
     yum install java-1.8.0-openjdk  unzip vim glibc.i686 -y


ENV CATALINA_HOME /usr/local/tomcat

ARG TOMCAT_TAR_FILE

COPY $TOMCAT_TAR_FILE /tmp/apache-tomcat.tar.gz

RUN tar -zxf /tmp/apache-tomcat.tar.gz -C /usr/local && \
    rm /tmp/apache-tomcat.tar.gz && \
    mv /usr/local/apache-tomcat-* $CATALINA_HOME  && \
    chmod +x $CATALINA_HOME/bin/* && \
    chmod 0644 $CATALINA_HOME/conf/* && \
    rm -rf $CATALINA_HOME/webapps/ROOT  \
           $CATALINA_HOME/webapps/docs  \
           $CATALINA_HOME/webapps/examples  \
           $CATALINA_HOME/webapps/host-manager \
           $CATALINA_HOME/webapps/manager

RUN groupadd tomcat &&\
    useradd  -u 1000 -ms /bin/false -g tomcat tomcat &&\
    chown -R tomcat:tomcat $CATALINA_HOME  && \
    chmod -R 755 $CATALINA_HOME/webapps/


WORKDIR /usr/local/tomcat
#USER tomcat
EXPOSE 8080

COPY docker/image/tomcat/goss /goss

RUN  chmod +x /goss/install && \
     /goss/install && \
     goss -g /goss/goss-buildtime.yaml validate

HEALTHCHECK --interval=30s --timeout=30s --retries=5 CMD goss -g /goss/healthcheck.yaml validate


CMD ["/usr/local/tomcat/bin/catalina.sh" , "run"]
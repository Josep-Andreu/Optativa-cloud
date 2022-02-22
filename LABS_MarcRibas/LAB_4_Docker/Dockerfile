FROM ubi7/ubi:7.7
LABEL MAINTAINER="Marc Ribas <mribasg@edu.tecnocampus.cat>"
LABEL DESCRIPTION="jboss docker by MarcRibas"
                                                                                                                                             
ENV JBOSS_HOME=/opt/jboss                                                            
ENV JAVA_OPT="$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0"

USER root

COPY ../jboss-eap-7.2.0.zip /opt
                                           
RUN yum install -y -q unzip openssh-clients zip net-tools &&\              
    yum install -y -q java &&\
    yum -y clean all &&\			     
    useradd jboss -d /home/jboss -G wheel &&\               
    usermod -aG wheel jboss &&\                      
    unzip /opt/jboss-eap-7.2.0.zip -d /opt &&\                             
    mv /opt/jboss-eap-7.2 ${JBOSS_HOME} &&\                             
    ${JBOSS_HOME}/bin/add-user.sh admin admin123 -s &&\   
    echo ${JAVA_OPT}>> ${JBOSS_HOME}/bin/standalone.conf

EXPOSE 8080 9090 9990

RUN chown -R jboss:0 ${JBOSS_HOME}

USER ${JBOSS_USER}
CMD ["/opt/jboss/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
WORKDIR /home/jboss


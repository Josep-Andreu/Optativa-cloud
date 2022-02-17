FROM ubi7/ubi:7.7
LABEL MAINTAINER="Marc Ribas <mribasg@edu.tecnocampus.cat>"
LABEL DESCRIPTION="jboss docker by MarcRibas"
ENV JBOSS_USER="jboss"                                                                          \
    ADMIN_USER="admin"                                                                          \
    ADMIN_PASSWORD="admin123"                                                                   
ENV JBOSS_HOME="/opt/${JBOSS_USER}"                                                             \
    JAVA_OPT="$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0"
ENV JBOSS_USER_HOME="/home/${JBOSS_USER_HOME}"
USER root

COPY ../jboss-eap-7.2.0.zip /opt

RUN yum update --security -y -q                                         
RUN    yum install -y -q  wget                                            
RUN    yum install -y -q unzip openssh-clients zip net-tools              
RUN    yum install -y -q java                                            
RUN    yum -y clean all 			
RUN    echo "${JBOSS_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers        
RUN    useradd ${JBOSS_USER} -d ${JBOSS_USER_HOME} -G wheel                
RUN    usermod -aG wheel ${JBOSS_USER}                                     
RUN    unzip /opt/jboss-eap-7.2.0.zip -d /opt                              
RUN    mv /opt/jboss-eap-7.2 ${JBOSS_HOME}                                 
RUN    ${JBOSS_HOME}/bin/add-user.sh ${ADMIN_USER} ${ADMIN_PASSWORD} -s    
RUN    echo ${JAVA_OPT}>> ${JBOSS_HOME}/bin/standalone.conf

EXPOSE 8080 9090 9990

RUN chown -R jboss:0 ${JBOSS_HOME}

USER ${JBOSS_USER}
CMD ["${JBOSS_HOME}/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
WORKDIR ${JBOSS_USER_HOME}


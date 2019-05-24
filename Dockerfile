FROM ubuntu:18.04

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME /opt/hadoop

RUN apt-get update
RUN apt-get install -y --reinstall build-essential
RUN apt-get install -y ssh
RUN apt-get install -y rsync
RUN apt-get install -y vim
RUN apt-get install -y net-tools
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y python2.7-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libkrb5-dev
RUN apt-get install -y libffi-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libldap2-dev
RUN apt-get install -y python-lxml
RUN apt-get install -y libxslt1-dev
RUN apt-get install -y libgmp3-dev
RUN apt-get install -y libsasl2-dev
RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y libmysqlclient-dev

RUN \
    if [ ! -e /usr/bin/python ]; then ln -s /usr/bin/python2.7 /usr/bin/python; fi

RUN \
   wget http://apache.crihan.fr/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz && \
    tar -xzf hadoop-3.1.2.tar.gz && \
    mv hadoop-3.1.2 $HADOOP_HOME && \
    for user in hadoop hdfs yarn mapred; do \
         useradd -U -M -d /opt/hadoop/ --shell /bin/bash ${user}; \
    done && \
    for user in root hdfs yarn mapred; do \
         usermod -G hadoop ${user}; \
    done && \
    echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "export HDFS_DATANODE_SECURE_USER=hdfs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc

####################################################################################

RUN \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

ADD *xml $HADOOP_HOME/etc/hadoop/

ADD ssh_config /root/.ssh/config

ADD start-all.sh start-all.sh

EXPOSE 8042 8088 8888 9000 9864 9870 9866 19888

CMD bash start-all.sh
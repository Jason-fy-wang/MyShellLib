FROM docker.io/jasonfywang/coder:zulujdk17

COPY apache-zookeeper-3.8.4-bin.tar.gz  /opt

RUN cd /opt/ && tar -zxf apache-zookeeper-3.8.4-bin.tar.gz && rm -f apache-zookeeper-3.8.4-bin.tar.gz && mv apache-zookeeper-3.8.4-bin zookeeper

COPY logback.xml zoo.cfg /opt/zookeeper/conf/
COPY --chmod=777 start.sh /opt/zookeeper/bin/

ENTRYPOINT [ "/opt/zookeeper/bin/start.sh"]

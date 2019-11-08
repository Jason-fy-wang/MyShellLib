#!/bin/bash
docker run -it -d \
# 指定启动名字
--name fcaps_am_controller \
# 挂载目录
-v /opt/ericsson/nfvo/fcaps/config/am_controller:/opt/ericsson/nfvo/fcaps/am_controller/config \
-v /opt/ericsson/nfvo/fcaps/runtime_log/am_controller:/opt/ericsson/nfvo/fcaps/am_controller/logs \
# 设置网络模式
--network host \
114798ce6b7e  \
# 运行启动命令
/bin/bash -c "sh /opt/ericsson/nfvo/fcaps/am_controller/bin/start.sh start;/bin/bash"

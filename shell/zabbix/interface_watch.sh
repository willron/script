#!/bin/bash
#ping站点并上报平均ping响应时间(浮点)与丢包率(整数)到zabbix
#target_host变量[]中为ping的目标站点。=后是zabbix的key名。需要在zabbix新建采集器(Zabbix trapper)
#by: willron

declare -A target_host
target_host=([www.jd.com]=14line [www.163.com]=61line [www.taobao.com]=eth03 [www.baidu.com]=eth01 [www.qq.com]=eth02)

for i in ${!target_host[*]}
do
    (
    ping -W 2 -c 5 ${i}|awk -v keyname=${target_host[$i]} -F '[/ ]' '/packet loss/{sub("%","",$6);print "-k "keyname".packetloss -o "$6};/min.avg/{print "-k "keyname".ping -o "$8}'|while read line;do zabbix_sender -c /etc/zabbix/zabbix_agent.conf $line;done
    )&
done
wait

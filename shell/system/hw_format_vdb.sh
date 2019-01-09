#!/bin/bash
#华为云服务器格式化vdb数据盘并挂载/data
#也可用于其他云服务器
#/data下会创建logs和www目录

echo 
echo "This Script Will Format /dev/vdb And Mount To /data, Are You Sure ..."
read -p "(Please input 'Y/N' ! Default N) : " OPTION
echo

if [[ "$OPTION" == "" || "$OPTION" == "N" ]];then
    echo "Bye"
    exit 2
fi

if [ "$OPTION" == "Y" ];then
    parted /dev/vdb --script -- mklabel msdos
    parted /dev/vdb --script -- mkpart primary 0 -1
    mkfs.ext4 /dev/vdb1
    mkdir /data
    mount /dev/vdb1 /data
    mkdir -p /data/www /data/logs/{php,nginx}
    chown www.www -R /data/{logs,www}
    echo '/dev/vdb1  /data ext4    defaults    0  0' >> /etc/fstab
    sed -i '3,$s/^/#/' $0
fi

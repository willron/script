import pymysql
from sshtunnel import SSHTunnelForwarder

SSH_IP = 'SSH服务器IP'
SSH_PORT = 22
SSH_USERNAME = 'root'
SSH_PASSWD = '123456'
PROXY_TARGET_IP = '转发到IP'
PROXY_TARGET_PORT = 3306

with SSHTunnelForwarder((SSH_IP, SSH_PORT), ssh_password=SSH_PASSWD, ssh_username=SSH_USERNAME, remote_bind_address=(PROXY_TARGET_IP, PROXY_TARGET_PORT)) as proxy:
    conn = pymysql.connect(user='mysql_user', host='127.0.0.1', port=proxy.local_bind_port, passwd='mysql_passwd', db='lf_and_acc', charset='utf8')

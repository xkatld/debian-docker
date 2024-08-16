#!/bin/bash

# 安装脚本 - 在Debian Docker容器中设置supervisord

# 更新包列表并安装supervisord
apt-get update
apt-get install -y supervisor

# 创建supervisord配置目录（如果不存在）
mkdir -p /etc/supervisor/conf.d

# 创建supervisord主配置文件
cat > /etc/supervisor/supervisord.conf <<EOL
[unix_http_server]
file=/var/run/supervisor.sock
chmod=0700

[supervisord]
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid
childlogdir=/var/log/supervisor

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

[include]
files = /etc/supervisor/conf.d/*.conf
EOL

# 创建服务配置文件
cat > /etc/supervisor/conf.d/services.conf <<EOL
[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
autostart=true
autorestart=true

[program:ssh]
command=/usr/sbin/sshd -D
autostart=true
autorestart=true

[program:ttyd]
command=/usr/bin/ttyd --port 7681 --credential user:password login -f user
autostart=true
autorestart=true
EOL

# 创建一个简单的管理脚本
cat > /usr/local/bin/manage-services <<EOL
#!/bin/bash

case \$1 in
    start)
        supervisord
        ;;
    stop)
        supervisorctl stop all
        killall supervisord
        ;;
    restart)
        supervisorctl stop all
        killall supervisord
        supervisord
        ;;
    status)
        supervisorctl status
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status}"
        exit 1
        ;;
esac
EOL

# 使管理脚本可执行
chmod +x /usr/local/bin/manage-services

# 启动supervisord
supervisord

echo "安装完成。使用 'manage-services {start|stop|restart|status}' 来管理服务。"

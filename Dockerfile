FROM debian:12

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    openssh-server \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装webssh
RUN pip3 install webssh

# 设置SSH
RUN mkdir /var/run/sshd
RUN echo 'root:yourpassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH登录修复
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# 暴露WebSSH端口（默认8888）
EXPOSE 8888

# 创建启动脚本
RUN echo '#!/bin/bash\n/usr/sbin/sshd\nwssh --port=8888 --address=0.0.0.0' > /start.sh && chmod +x /start.sh

# 运行启动脚本
CMD ["/start.sh"]

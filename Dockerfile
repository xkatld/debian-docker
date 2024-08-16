FROM debian:latest

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置SSH
RUN mkdir /var/run/sshd
RUN echo 'root:yourpassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH登录修复
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# 暴露SSH端口
EXPOSE 22

# 运行SSH服务
CMD ["/usr/sbin/sshd", "-D"]

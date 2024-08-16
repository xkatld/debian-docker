FROM debian:12

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 ttyd
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 -O /usr/bin/ttyd \
    && chmod +x /usr/bin/ttyd

# 创建非 root 用户
RUN useradd -m -s /bin/bash user && \
    echo "user:password" | chpasswd && \
    adduser user sudo

# 允许 sudo 不需要密码
RUN echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user

# 暴露 ttyd 端口
EXPOSE 7681

# 启动 ttyd
CMD ["ttyd", "--port", "7681", "--credential", "user:password", "login", "-f", "user"]

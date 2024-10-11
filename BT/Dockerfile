FROM fsynet/bt

# 安装必要的软件包
RUN yum update && yum install -y \
    curl \
    wget \
    sudo \
    && yum clean

# 暴露 ttyd 端口
EXPOSE 8000

# 重启 bt
CMD ["bt", "1"] 

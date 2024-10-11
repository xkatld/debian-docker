FROM xkatld/bt-centos9-image:light

# 暴露 ttyd 端口
EXPOSE 5230

# 启动 bt 服务并保持容器运行
CMD ["sh", "-c", "bt 3 && tail -f /dev/null"]

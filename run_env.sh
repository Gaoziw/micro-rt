#！/bin/bash
# 启动编译环境的容器
# 将 /path/to/your/code 替换为您本地代码的实际路径
# 如果使用了 Dockerfile.update 文件构建了新的镜像
# 请将 localhost/sel4-build-env:updated 替换为您构建的镜像名称

podman run -it --rm --userns=keep-id \
  -v $PWD:/workspace \
  localhost/sel4-build-env:updated \
  /bin/bash
#！/bin/bash
# 启动编译环境的容器
# 使用 Dockerfile.update 文件构建新的镜像后
# 请将 localhost/sel4-build-env:updated 替换为您构建的镜像名称

podman run -it --rm --userns=keep-id \
  -v $PWD:/workspace \
  localhost/sel4-build-env:updated \
  /bin/bash
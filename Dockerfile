# 使用一个较新版本的 Ubuntu LTS 作为基础镜像
FROM ubuntu:22.04

# 为了避免在安装过程中被询问时区等问题，设置非交互式前端
ENV DEBIAN_FRONTEND=noninteractive

# 1. 更新系统并安装基础构建工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    # 2. 安装 seL4 构建系统依赖
    cmake \
    ccache \
    ninja-build \
    cmake-curses-gui \
    libxml2-utils \
    ncurses-dev \
    curl \
    git \
    doxygen \
    device-tree-compiler \
    xxd \
    u-boot-tools \
    cpio \
    # 3. 安装 Python 相关依赖
    python3-dev \
    python3-pip \
    python-is-python3 \
    python3-yaml \
    python3-jinja2 \
    python3-lxml \
    python3-six \
    python3-setuptools \
    protobuf-compiler \
    python3-protobuf \
    # 4. 安装模拟器 QEMU
    qemu-system-arm \
    qemu-system-x86 \
    qemu-system-misc \
    qemu-utils \
    # 5. 安装 ARM 交叉编译器
    gcc-arm-linux-gnueabi \
    g++-arm-linux-gnueabi \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    # 6. 安装 RISC-V 工具链编译依赖（选择一种方法后，可以注释掉另一方）
    autoconf \
    automake \
    autotools-dev \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev \
    # 清理缓存以减小镜像体积
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

    # 安装 Python 包
RUN pip install pyfdt \
    && pip install jsonschema \
    && pip install ply \
    && pip install libarchive-c \
    && pip install pyelftools
    && pip3 install --user setuptools sel4-deps

###############################################
# 方法A：安装预编译的 RISC-V GNU 工具链 (推荐)
# 从 SiFive 或 Bootlin 下载预编译的工具链，速度更快
###############################################
# 设置安装目录
ENV RISCV=/opt/riscv
ENV PATH=$PATH:$RISCV/bin

# 下载并解压预编译的工具链 (例如，来自 Bootlin)
# 请根据需要选择最新的稳定版本链接：
# https://toolchains.bootlin.com/releases_riscv64.html
# https://github.com/sifive/freedom-tools/releases

# RUN mkdir -p $RISCV && \
#     curl -OL https://toolchains.bootlin.com/downloads/releases/toolchains/riscv64/tarballs/riscv64--glibc--bleeding-edge-2022.08-1.tar.bz2 && \
#     tar -xf riscv64--glibc--bleeding-edge-2022.08-1.tar.bz2 -C $RISCV --strip-components=1 && \
#     rm riscv64--glibc--bleeding-edge-2022.08-1.tar.bz2

###############################################
# 方法B：从源码编译 RISC-V GNU 工具链 (备用)
# 注释掉上面的“方法A”，取消注释下面的“方法B”即可切换
# 注意：这是一个极其耗时的过程，会使镜像构建时间大幅增加
###############################################
RUN mkdir -p $RISCV && \
   git clone https://github.com/riscv/riscv-gnu-toolchain.git /tmp/riscv-gnu-toolchain && \
   cd /tmp/riscv-gnu-toolchain && \
   git submodule update --init --recursive && \
   ./configure --prefix=$RISCV --enable-multilib && \
   make linux -j$(nproc) && \
   cd / && \
   rm -rf /tmp/riscv-gnu-toolchain

# 7. (可选) 创建一个非 root 用户用于编译，更安全
RUN useradd -m -s /bin/bash builder
USER builder
WORKDIR /home/builder

# 设置工作目录为 /workspace，我们稍后会在这里挂载我们的代码
VOLUME /workspace
WORKDIR /workspace

# 验证工具链是否安装成功
RUN aarch64-linux-gnu-gcc --version && riscv64-unknown-linux-gnu-gcc --version

# 默认命令，可以设置为一个 shell
CMD ["/bin/bash"]

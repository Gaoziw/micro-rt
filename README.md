## 项目介绍：
            micro-rt 是一个基于sel4内核，并继承了 refos kataos 等项目的优点的微型实时内核
        项目的宗旨是在满足最小运行时环境下进行全面的形式化验证，以最小的代码，适配更多的硬件


# 拉取项目并运行一个简单测试用例
## 项目中包含自动化脚本，先创建一个文件夹
    ```bash
    mkdir micro-rt
    cd micro-rt
    ```

## 安装工具
    ```bash
    sudo apt install podman
    ```

## micro-rt 使用podman对所有管理编译环境，在虚拟环境中实现代码拉取，构建，测试
    ```bash
    docker build -t sel4-build-env .
    # 如果网络不好也可以拉取已经构建完成的images

    ```

## 运行虚拟环境
    ```bash
    ./run_env.sh
    ```

## 拉取 sel4 kernel 源码
    ```bash
    ./PullCode.sh
    ```

# 手动构建kernel，运行测试集
    ```bash
    # create build directory
    mkdir build
    cd build

    # configure build
    ../init-build.sh -DSIMULATION=TRUE -DAARCH32=TRUE -DPLATFORM=sabre

    # build
    ninja

    # run
    ./simulate
    ```

# 代码提交
    ```bash
    # 1. 查看当前修改状态
    git status

    # 2. 添加所有修改的文件到暂存区
    git add .

    # 或者添加特定文件
    git add Dockerfile README.md

    # 3. 提交更改
    git commit -m "描述您所做的修改，例如：修复重复的包安装项"

    # 4. 推送到远程仓库
    git push
    ```
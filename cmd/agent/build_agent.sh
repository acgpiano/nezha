#!/bin/bash

# 编译 nezha agent 脚本
# 支持 Linux 和 Darwin 的 amd64 和 arm64 架构

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 输出目录
OUTPUT_DIR="agent"
VERSION=${VERSION:-"dev"}

echo -e "${GREEN}开始编译 Nezha Agent...${NC}"
echo -e "${YELLOW}版本: ${VERSION}${NC}"

# 创建输出目录
mkdir -p ${OUTPUT_DIR}

# 编译函数
build() {
    local os=$1
    local arch=$2
    local output_name="nezha-agent_${os}_${arch}"

    echo -e "${YELLOW}正在编译 ${os}/${arch}...${NC}"

    CGO_ENABLED=0 GOOS=${os} GOARCH=${arch} go build \
        -trimpath \
        -ldflags "-s -w -X main.version=${VERSION}" \
        -o ${OUTPUT_DIR}/${output_name} \
        .

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ ${os}/${arch} 编译成功: ${OUTPUT_DIR}/${output_name}${NC}"
        # 显示文件大小
        ls -lh ${OUTPUT_DIR}/${output_name} | awk '{print "  大小: " $5}'
    else
        echo -e "${RED}✗ ${os}/${arch} 编译失败${NC}"
        exit 1
    fi
}

# 编译各个平台
build "linux" "amd64"
build "linux" "arm64"
build "darwin" "amd64"
build "darwin" "arm64"

echo ""
echo -e "${GREEN}所有编译完成!${NC}"
echo -e "${YELLOW}输出目录: ${OUTPUT_DIR}/${NC}"
echo ""
ls -lh ${OUTPUT_DIR}/

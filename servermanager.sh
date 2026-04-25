#!/bin/bash

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33"
BLUE="\033[0;34m"
NC="\033[0m"

# Variables
_SERVER_VERSION="6.6"
_SERVER_DOWNLOAD_PATH="7892/979"
_SERVER_FILES="ServerFiles-${_SERVER_VERSION}.zip"
_ARCHLIGHT_URL="https://files.hypertention.cn/v1/objects/fd0abb528e951b96cfa836d16f44ed170b198800"
_ARCHLIGHT_JAR="archlight-1.0.2-SNAPSHOT-668f9f3.jar"

echo -e "${BLUE}> [DEBUG] ATM10 - Server version: ${_SERVER_VERSION} (Archlight)${NC}"

if [[ ! -d "/data" ]]; then
    echo -e "${RED}> [ERROR] No mountpoint found, data loss possible - Continue without persistent data!${NC}"
    mkdir /data
fi

cd /data

if [[ "$EULA" == "true" ]]; then
    echo "eula=true" > /data/eula.txt
else
    echo -e "${RED}> [ERROR] You must accept the eula to install the server!${NC}"
    exit 0
fi

if [[ ! -f "$_SERVER_FILES" ]]; then
    rm -rf config \
        defaultconfigs \
        kubejs \
        mods \
        packmenu \
        libraries \
        neoforge*
    curl -Lo "$_SERVER_FILES" "https://mediafilez.forgecdn.net/files/$_SERVER_DOWNLOAD_PATH/$_SERVER_FILES" || exit 1
    bsdtar -xf $_SERVER_FILES
    ATM10_INSTALL_ONLY=true /bin/bash startserver.sh
fi

if [[ ! -f "$_ARCHLIGHT_JAR" ]]; then
    echo -e "${BLUE}> [DEBUG] Downloading Archlight ${_ARCHLIGHT_JAR}...${NC}"
    curl -Lo "$_ARCHLIGHT_JAR" "$_ARCHLIGHT_URL" || exit 1
fi

source /includes/config.sh

# Build JVM args: use JVM_ARGS env var if set, otherwise use Aikar flags with configurable heap
if [[ -z "$JVM_ARGS" ]]; then
    _MIN_RAM=${MIN_RAM:-4G}
    _MAX_RAM=${MAX_RAM:-8G}
    JVM_ARGS="-Xms${_MIN_RAM} -Xmx${_MAX_RAM} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
-XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
-XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
-XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
-XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
-XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
-XX:MaxTenuringThreshold=1"
fi

echo -e "${BLUE}> [DEBUG] Starting Archlight with JVM args: ${JVM_ARGS}${NC}"

java $JVM_ARGS -jar "$_ARCHLIGHT_JAR" nogui

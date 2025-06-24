# shellcheck shell=ash
# service.sh for OpenList Magisk Module

MODDIR="${0%/*}"
DATA_DIR="/data/adb/openlist/"
OPENLIST_BINARY="$MODDIR/system/bin/openlist"
MODULE_PROP_FILE="$MODDIR/module.prop"
LOG_FILE="$MODDIR/service.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_lan_ip() {
    # 尝试获取 Wi-Fi IP
    local ip_address
    ip_address=$(ip addr show wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)

    # 如果 Wi-Fi 没有 IP，则尝试获取移动网络 IP
    if [ -z "$ip_address" ]; then
        local wifi_state
        wifi_state=$(dumpsys wifi | grep "Wi-Fi is" | awk '{print $3}' | tr -d '.')
        if [ "$wifi_state" != "enabled" ]; then
            log "警告: Wi-Fi 未启用或未连接，请检查 Wi-Fi 设置。"
        else
            log "警告: Wi-Fi 已启用但未能获取到 IP 地址。"
        fi
        ip_address=$(ip addr show rmnet0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
    fi

    # 如果以上都未能获取到 IP，则使用默认占位符
    [ -z "$ip_address" ] && ip_address="无法获取IP"
    log "获取 IP: ip_address=$ip_address"
    echo "$ip_address"
}

update_module_prop_running() {
    CURRENT_IP=$(get_lan_ip)
    log "更新 module.prop 运行状态，CURRENT_IP=$CURRENT_IP"

    # 获取 openlist 的 PID
    pid=$(pgrep -f "$OPENLIST_BINARY server --data" 2>/dev/null | head -n 1)
    if [ -z "$pid" ]; then
        log "错误: 未找到运行中的 openlist"
        NEW_DESC="description=【未运行】无法找到 openlist 进程，请检查日志 $LOG_FILE"
    else
        log "找到 Openlist PID: $pid"

        # 尝试使用 ss 获取端口
        port=$(ss -tulnp 2>/dev/null | grep "$pid" | awk '{print $5}' | cut -d':' -f2 | sort -u | head -n 1)
        if [ -z "$port" ] && command -v netstat >/dev/null; then
            port=$(netstat -tulnp 2>/dev/null | grep "$pid" | awk '{print $4}' | cut -d':' -f2 | sort -u | head -n 1)
        fi

        # 检查初始密码文件
        PASSWORD_TEXT=""
        if [ -f "${DATA_DIR}/初始密码.txt" ]; then
            PASSWORD_TEXT=" | 初始密码：$(cat "${DATA_DIR}/初始密码.txt")"
        fi

        if [ -n "$port" ]; then
            log "找到 Openlist 端口: $port"
            NEW_DESC="description=【运行中】当前地址：http://${CURRENT_IP}:${port} | 数据目录：${DATA_DIR} | 点击▲操作关闭程序${PASSWORD_TEXT}"
        else
            log "警告: 未找到 openlist 的端口 (PID: $pid)"
            NEW_DESC="description=【运行中】无法检测 openlist 端口，请检查日志 $LOG_FILE | 数据目录：${DATA_DIR} | 点击▲操作关闭程序${PASSWORD_TEXT}"
        fi
    fi

    # 确保 module.prop 存在且可写
    if [ ! -f "$MODULE_PROP_FILE" ]; then
        log "错误: $MODULE_PROP_FILE 不存在"
        return 1
    fi
    if [ ! -w "$MODULE_PROP_FILE" ]; then
        log "警告: $MODULE_PROP_FILE 不可写，尝试修复权限"
        chmod 644 "$MODULE_PROP_FILE" 2>/dev/null || log "错误: 无法设置 $MODULE_PROP_FILE 的权限"
    fi

    # 记录更新前的 module.prop 内容
    log "更新前的 module.prop 内容: $(cat "$MODULE_PROP_FILE" 2>/dev/null || echo '无法读取 module.prop')"

    # 更新 description 字段
    grep -v '^description=' "$MODULE_PROP_FILE" > "${MODULE_PROP_FILE}.tmp" 2>/dev/null
    echo "$NEW_DESC" >> "${MODULE_PROP_FILE}.tmp"
    if mv "${MODULE_PROP_FILE}.tmp" "$MODULE_PROP_FILE" 2>/dev/null; then
        log "成功更新 module.prop"
    else
        log "错误: 更新 module.prop 失败"
    fi

    # 清理备份文件
    rm -f "${MODULE_PROP_FILE}.bak" "${MODULE_PROP_FILE}.tmp.*" 2>/dev/null

    # 检查 module.prop 是否包含非键值对行
    if grep -vE '^[a-zA-Z_]+=' "$MODULE_PROP_FILE" >/dev/null; then
        log "警告: module.prop 包含无效行，正在清理"
        grep -E '^[a-zA-Z_]+=' "$MODULE_PROP_FILE" > "${MODULE_PROP_FILE}.clean" 2>/dev/null
        mv "${MODULE_PROP_FILE}.clean" "$MODULE_PROP_FILE" 2>/dev/null
        log "清理后的 module.prop 内容: $(cat "$MODULE_PROP_FILE" 2>/dev/null || echo '无法读取 module.prop')"
    fi
}

log "启动 service.sh 于 $(date '+%Y-%m-%d %H:%M:%S')"

# 检查 ip 命令是否存在
if ! command -v ip >/dev/null; then
    log "错误: 未找到 ip 命令"
    exit 1
fi

# 检查 openlist 二进制文件
if [ "$OPENLIST_BINARY" = "TO_BE_REPLACED" ]; then
    log "错误: OPENLIST_BINARY 未在安装时配置"
    exit 1
fi
if [ ! -f "$OPENLIST_BINARY" ]; then
    log "错误: $OPENLIST_BINARY 不存在"
    exit 1
fi
if [ ! -x "$OPENLIST_BINARY" ]; then
    log "警告: $OPENLIST_BINARY 不可执行，尝试修复"
    chmod 755 "$OPENLIST_BINARY" 2>/dev/null || {
        log "错误: 无法设置 $OPENLIST_BINARY 的执行权限"
        exit 1
    }
fi

# 检查 DATA_DIR 是否配置
if [ "$DATA_DIR" = "TO_BE_REPLACED" ]; then
    log "错误: DATA_DIR 未在安装时配置"
    exit 1
fi

# 检查并创建数据目录
mkdir -p "$DATA_DIR" 2>/dev/null
if [ $? -ne 0 ]; then  # 如果返回值不为0（失败）
    log "错误: 无法创建数据目录 $DATA_DIR"
    exit 1
fi
if [ ! -w "$DATA_DIR" ]; then
    log "警告: 数据目录 $DATA_DIR 不可写，尝试修复权限"
    chmod 777 "$DATA_DIR" 2>/dev/null || {
        log "错误: 无法设置 $DATA_DIR 的写权限"
        exit 1
    }
fi
log "已创建或验证数据目录：$DATA_DIR"

# 等待系统启动完成
ELAPSED=0
MAX_WAIT=60
while [ $ELAPSED -lt $MAX_WAIT ]; do
    if [ "$(getprop sys.boot_completed)" = "1" ]; then
        log "Android 系统启动完成"
        break
    fi
    log "等待 Android 系统启动... ($ELAPSED/$MAX_WAIT 秒)"
    sleep 1
    ELAPSED=$((ELAPSED + 1))
done

if [ $ELAPSED -ge $MAX_WAIT ]; then
    log "警告: 系统启动超时，继续尝试启动 openlist"
fi

# 启动 openlist 服务
log "启动 OpenList: $OPENLIST_BINARY server --data $DATA_DIR"
$OPENLIST_BINARY server --data "$DATA_DIR" &
OPENLIST_PID=$!

# 检查 openlist 是否启动成功
if ps -p $OPENLIST_PID >/dev/null || pgrep -f "$OPENLIST_BINARY server --data" >/dev/null; then
    log "OpenList 服务启动成功 (PID: $OPENLIST_PID)"
    update_module_prop_running
else
    log "错误: 无法启动 OpenList 服务"
    # 尝试手动运行以捕获错误
    OUTPUT=$($OPENLIST_BINARY server --data "$DATA_DIR" 2>&1)
    log "手动运行输出: $OUTPUT"
    exit 1
fi
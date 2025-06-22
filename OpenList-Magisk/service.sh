#!/system/bin/sh
# service.sh for OpenList Magisk Module

MODDIR=${0%/*}
DATA_DIR="$MODDIR/data"
OPENLIST_BINARY="/system/bin/openlist"
MODULE_PROP="$MODDIR/module.prop"
PASSWORD_FILE="$MODDIR/随机密码.txt"
LOG_FILE="$MODDIR/service.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_lan_ip() {
    LAN_IP=$(ip addr show wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
    [ -z "$LAN_IP" ] && LAN_IP=$(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}')
    [ -z "$LAN_IP" ] && LAN_IP="192.168.x.x"
    log "get_lan_ip: LAN_IP=$LAN_IP"
    echo "$LAN_IP"
}

generate_random_password() {
    log "Attempting to generate random password"
    OUTPUT=$($OPENLIST_BINARY admin random --data "$DATA_DIR" 2>&1 | \
             grep -E "username|password" | \
             awk '/username/ {print "账号：" $NF} /password/ {print "密码：" $NF}')
    if [ -n "$OUTPUT" ]; then
        echo "$OUTPUT" > "$PASSWORD_FILE"
        chmod 600 "$PASSWORD_FILE" 2>/dev/null || log "Warning: Failed to set permissions on $PASSWORD_FILE"
        log "Password file created at $PASSWORD_FILE with content: $OUTPUT"
        echo "$OUTPUT"
    else
        log "Error: Failed to generate or capture username and password"
        return 1
    fi
}

get_account_password() {
    if [ -f "$PASSWORD_FILE" ]; then
        # 提取账号和密码
        account=$(grep "账号" "$PASSWORD_FILE" | sed 's/账号：//')
        password=$(grep "密码" "$PASSWORD_FILE" | sed 's/密码：//')
        # 去除多余空格或换行
        account=$(echo "$account" | tr -d '[:space:]\n')
        password=$(echo "$password" | tr -d '[:space:]\n')
        if [ -n "$account" ] && [ -n "$password" ]; then
            log "Extracted account: $account, password: $password"
            echo "$account|$password"
        else
            log "Warning: Failed to extract account or password from $PASSWORD_FILE"
            echo "未知|未知"
        fi
    else
        log "Warning: $PASSWORD_FILE does not exist"
        echo "未知|未知"
    fi
}

update_module_prop_running() {
    LAN_IP=$(get_lan_ip)
    log "Updating module.prop for running state, LAN_IP=$LAN_IP"

    # 获取 openlist 的 PID
    pid=$(pgrep -f openlist 2>/dev/null)
    if [ -z "$pid" ]; then
        log "Error: No running openlist process found"
        NEW_DESC="description=【未运行】无法找到 openlist 进程，请检查日志 $LOG_FILE"
    else
        log "Found openlist PID: $pid"

        # 尝试使用 ss 获取端口
        port=$(ss -tulnp 2>/dev/null | grep "$pid" | awk '{print $5}' | cut -d':' -f2 | sort -u | head -n 1)
        if [ -z "$port" ] && command -v netstat >/dev/null 2>&1; then
            port=$(netstat -tulnp 2>/dev/null | grep "$pid" | awk '{print $4}' | cut -d':' -f2 | sort -u | head -n 1)
        fi

        # 获取账号和密码
        account_password=$(get_account_password)
        account=$(echo "$account_password" | cut -d'|' -f1)
        password=$(echo "$account_password" | cut -d'|' -f2)

        if [ -n "$port" ]; then
            log "Found openlist port: $port"
            NEW_DESC="description=【运行中】局域网地址：http://${LAN_IP}:${port} | 首次启动会生成随机密码：${account} | ${password} | 请勿删除模块目录中的“随机密码.txt”，否则重启手机后会把你在后台管理界面设置的自定义密码给顶掉！"
        else
            log "Warning: No port found for openlist (PID: $pid)"
            NEW_DESC="description=【运行中】无法检测 openlist 端口，请检查日志 $LOG_FILE | 首次启动会生成随机密码：${account} | ${password} | 请勿删除模块目录中的“随机密码.txt”，否则重启手机后会把你在后台管理界面设置的自定义密码给顶掉！"
        fi
    fi

    # 确保 module.prop 存在且可写
    if [ ! -f "$MODULE_PROP" ]; then
        log "Error: $MODULE_PROP does not exist"
        return 1
    fi
    if [ ! -w "$MODULE_PROP" ]; then
        log "Warning: $MODULE_PROP is not writable, attempting to fix permissions"
        chmod 644 "$MODULE_PROP" 2>/dev/null || log "Error: Failed to set permissions on $MODULE_PROP"
    fi

    # 记录更新前的 module.prop 内容
    log "module.prop content before update: $(cat "$MODULE_PROP" 2>/dev/null || echo 'Unable to read module.prop')"

    # 更新 description 字段
    echo "$(grep -v '^description=' "$MODULE_PROP" 2>/dev/null)" > "${MODULE_PROP}.tmp"
    echo "$NEW_DESC" >> "${MODULE_PROP}.tmp"
    mv "${MODULE_PROP}.tmp" "$MODULE_PROP" 2>/dev/null
    if [ $? -eq 0 ]; then
        log "Updated module.prop successfully"
    else
        log "Error: Failed to update module.prop"
    fi

    # 清理备份文件
    rm -f "${MODULE_PROP}.bak" "${MODULE_PROP}.tmp.*" 2>/dev/null

    # 检查 module.prop 是否包含非键值对行
    if grep -vE '^[a-zA-Z_]+=' "$MODULE_PROP" >/dev/null 2>&1; then
        log "Warning: module.prop contains invalid lines, cleaning up"
        grep -E '^[a-zA-Z_]+=' "$MODULE_PROP" > "${MODULE_PROP}.clean" 2>/dev/null
        mv "${MODULE_PROP}.clean" "$MODULE_PROP" 2>/dev/null
        log "Cleaned module.prop content: $(cat "$MODULE_PROP" 2>/dev/null || echo 'Unable to read module.prop')"
    fi
}

log "Starting service.sh at $(date '+%Y-%m-%d %H:%M:%S')"

# 检查 ip 命令是否存在
if ! command -v ip >/dev/null 2>&1; then
    log "Error: ip command not found"
    exit 1
fi

# 检查 openlist 二进制文件
if [ ! -f "$OPENLIST_BINARY" ]; then
    log "Error: $OPENLIST_BINARY does not exist"
    exit 1
fi
if [ ! -x "$OPENLIST_BINARY" ]; then
    log "Warning: $OPENLIST_BINARY is not executable, attempting to fix"
    chmod +x "$OPENLIST_BINARY" 2>/dev/null || {
        log "Error: Failed to set executable permissions on $OPENLIST_BINARY"
        exit 1
    }
fi

# 检查并创建数据目录
mkdir -p "$DATA_DIR" 2>/dev/null
if [ $? -ne 0 ]; then
    log "Error: Failed to create data directory $DATA_DIR"
    exit 1
fi
log "Created or verified data directory: $DATA_DIR"

# 等待系统启动完成
ELAPSED=0
MAX_WAIT=60
WAIT_INTERVAL=5
while [ $ELAPSED -lt $MAX_WAIT ]; do
    if [ "$(getprop sys.boot_completed)" = "1" ]; then
        log "Android system boot completed"
        break
    fi
    log "Waiting for Android system boot... ($ELAPSED/$MAX_WAIT seconds)"
    sleep $WAIT_INTERVAL
    ELAPSED=$((ELAPSED + WAIT_INTERVAL))
done

if [ $ELAPSED -ge $MAX_WAIT ]; then
    log "Warning: System boot timeout, attempting to start OpenList service"
fi

# 启动 openlist 服务
log "Starting OpenList: $OPENLIST_BINARY server --data $DATA_DIR"
$OPENLIST_BINARY server --data "$DATA_DIR" &
OPENLIST_PID=$!

# 检查 openlist 是否启动成功
if ps -p $OPENLIST_PID >/dev/null 2>&1 || pgrep -f openlist >/dev/null 2>&1; then
    log "OpenList service started successfully (PID: $OPENLIST_PID)"
    if [ ! -f "$PASSWORD_FILE" ]; then
        generate_random_password || log "Password generation failed, continuing"
    else
        log "Detected $PASSWORD_FILE, skipping password generation"
    fi
    update_module_prop_running
else
    log "Error: Failed to start OpenList service"
    # 尝试手动运行以捕获错误
    OUTPUT=$($OPENLIST_BINARY server --data "$DATA_DIR" 2>&1)
    log "Manual run output: $OUTPUT"
    exit 1
fi

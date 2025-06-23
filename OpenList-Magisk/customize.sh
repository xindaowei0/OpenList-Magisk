#!/system/bin/sh

ui_print "正在安装 OpenList Magisk 模块..."

# 检测设备架构
ARCH=$(getprop ro.product.cpu.abi)
ui_print "检测到架构: $ARCH"

# 定义模块路径和二进制文件名
MODPATH=$MODPATH
BINARY_NAME="openlist"

# 按键检测函数
check_button() {
    if [ -x "/system/bin/getevent" ]; then
        /system/bin/getevent -lc 1 2>/dev/null | while read line; do
            if echo "$line" | grep -q "KEY_VOLUMEUP.*DOWN"; then
                echo "up"
                break
            elif echo "$line" | grep -q "KEY_VOLUMEDOWN.*DOWN"; then
                echo "down"
                break
            fi
        done
    elif [ -f "$MODPATH/keycheck" ]; then
        "$MODPATH/keycheck"
        case $? in
            42) echo "up" ;;
            41) echo "down" ;;
        esac
    fi
}

# 显示菜单选项
show_binary_menu() {
    local current=$1
    ui_print " "
    ui_print "📂 选择安装位置"
    ui_print "1、data/adb/openlist"
    ui_print "2、模块目录/bin"
    ui_print "3、system/bin"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "音量+ 确认  |  音量- 切换"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "👉 当前选择：选项 $current"
}

show_data_menu() {
    local current=$1
    ui_print " "
    ui_print "📁 选择数据目录"
    ui_print "1、data/adb/openlist"
    ui_print "2、Android/openlist"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "音量+ 确认  |  音量- 切换"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "👉 当前选择：选项 $current"
}

show_password_menu() {
    local current=$1
    ui_print " "
    ui_print "🔐 初始密码设置"
    ui_print "询问是否修改初始密码为admin？"
    ui_print "（后续请到管理面板自行修改）"
    ui_print "1、不修改"
    ui_print "2、修改"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "音量+ 确认  |  音量- 切换"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "👉 当前选择：选项 $current"
}

# 选择函数
make_selection() {
    local menu_type="$1"
    local max_options="$2"
    local current=1
    
    # 显示初始菜单
    case "$menu_type" in
        "binary")
            show_binary_menu "$current"
            ;;
        "data")
            show_data_menu "$current"
            ;;
        "password")
            show_password_menu "$current"
            ;;
    esac
    
    while true; do
        key=$(check_button)
        case "$key" in
            "up")
                ui_print "✅ 已确认选项 $current"
                return $current
                ;;
            "down")
                current=$((current + 1))
                [ $current -gt $max_options ] && current=1
                ui_print "👉 当前选择：选项 $current"
                ;;
        esac
        sleep 0.3
    done
}

# 安装流程开始
ui_print "⚙️ 开始配置..."

# 选择二进制安装路径
make_selection "binary" "3"
INSTALL_OPTION=$?

# 定义安装路径和service.sh中的路径
case $INSTALL_OPTION in
    1) 
        BINARY_PATH="/data/adb/openlist/bin/"
        BINARY_SERVICE_PATH="/data/adb/openlist/bin/openlist"  # 绝对路径
        ;;
    2) 
        BINARY_PATH="$MODPATH/bin/"
        BINARY_SERVICE_PATH="\${MODDIR}/bin/openlist"  # 使用 MODDIR 变量
        ;;
    3) 
        BINARY_PATH="$MODPATH/system/bin/"
        BINARY_SERVICE_PATH="\${MODDIR}/system/bin/openlist"  # 使用 MODDIR 变量
        ;;
esac

# 创建安装目录
mkdir -p "$BINARY_PATH"

# 安装二进制文件
if echo "$ARCH" | grep -q "arm64"; then
    ui_print "📦 安装 ARM64 版本..."
    if [ -f "$MODPATH/openlist-arm64" ]; then
        mv "$MODPATH/openlist-arm64" "$BINARY_PATH/$BINARY_NAME"
        rm -f "$MODPATH/openlist-arm"
    else
        ui_print "❌ 错误：未找到 ARM64 版本文件"
        exit 1
    fi
else
    ui_print "📦 安装 ARM 版本..."
    if [ -f "$MODPATH/openlist-arm" ]; then
        mv "$MODPATH/openlist-arm" "$BINARY_PATH/$BINARY_NAME"
        rm -f "$MODPATH/openlist-arm64"
    else
        ui_print "❌ 错误：未找到 ARM 版本文件"
        exit 1
    fi
fi

chmod 755 "$BINARY_PATH/$BINARY_NAME"

[ "$BINARY_PATH" = "$MODPATH/system/bin/" ] && chcon u:object_r:system_file:s0 "$BINARY_PATH/$BINARY_NAME"

# 选择数据目录
make_selection "data" "2"
DATA_DIR_OPTION=$?

case $DATA_DIR_OPTION in
    1) DATA_DIR="/data/adb/openlist/" ;;
    2) DATA_DIR="/storage/emulated/0/Android/openlist/" ;;
esac

# 数据迁移提示
ui_print " "
ui_print "📢 数据目录设置"
ui_print "━━━━━━━━━━━━━━━━━━━━━━"
ui_print "✓ 已选择: $DATA_DIR"
ui_print "⚠️ 注意事项："
ui_print "1. 新数据目录将在重启后生效"
ui_print "2. 请手动将现有数据迁移到新目录"
ui_print "3. 迁移后更新 config.json 中的路径"
ui_print "━━━━━━━━━━━━━━━━━━━━━━"

# 更新 service.sh
if [ -f "$MODPATH/service.sh" ]; then
    chmod 644 "$MODPATH/service.sh"
    
    # 仅替换占位符，保留其他所有内容
    sed -i "s|^DATA_DIR=.*|DATA_DIR=\"$DATA_DIR\"|" "$MODPATH/service.sh"
    sed -i "s|^OPENLIST_BINARY=.*|OPENLIST_BINARY=\"$BINARY_SERVICE_PATH\"|" "$MODPATH/service.sh"
    
    # 验证更新是否成功
    if grep -q "^OPENLIST_BINARY=\"$BINARY_SERVICE_PATH\"" "$MODPATH/service.sh" && \
       grep -q "^DATA_DIR=\"$DATA_DIR\"" "$MODPATH/service.sh"; then
        ui_print "✅ 配置更新成功"
    else
        ui_print "❌ 配置更新失败"
        exit 1
    fi
    
    chmod 755 "$MODPATH/service.sh"
else
    ui_print "❌ 错误：未找到 service.sh"
    exit 1
fi

# 完成安装
ui_print " "
ui_print "✨ 安装完成"
ui_print "━━━━━━━━━━━━━━━━━━━━━━"
ui_print "📍 二进制: $BINARY_PATH$BINARY_NAME"
ui_print "📁 数据目录: $DATA_DIR"

# 选择是否修改密码
make_selection "password" "2"
PASSWORD_OPTION=$?

if [ "$PASSWORD_OPTION" = "2" ]; then
    ui_print " "
    ui_print "🔄 正在修改初始密码..."
    
    # 使用绝对路径执行命令
    COMMAND_SUCCESS=0
    case $INSTALL_OPTION in
        1) 
            # 二进制文件在 /data/adb/openlist/bin/
            /data/adb/openlist/bin/openlist admin set admin --data "$DATA_DIR"
            COMMAND_SUCCESS=$?
            ;;
        2) 
            # 二进制文件在模块目录/bin/
            "$MODPATH/bin/openlist" admin set admin --data "$DATA_DIR"
            COMMAND_SUCCESS=$?
            ;;
        3) 
            # 二进制文件在 system/bin/
            "$MODPATH/system/bin/openlist" admin set admin --data "$DATA_DIR"
            COMMAND_SUCCESS=$?
            ;;
    esac
    
    if [ $COMMAND_SUCCESS -eq 0 ]; then
        ui_print "✅ 密码已修改为：admin"
        
        # 确保数据目录存在
        mkdir -p "$DATA_DIR"
        
        # 写入密码到初始密码.txt
        echo "admin" > "$DATA_DIR/初始密码.txt"
        if [ $? -eq 0 ]; then
            # 设置文件权限确保可读
            chmod 644 "$DATA_DIR/初始密码.txt"
            ui_print "✅ 已将密码保存到：$DATA_DIR/初始密码.txt"
        else
            ui_print "❌ 密码文件写入失败"
        fi
    else
        ui_print "❌ 密码修改失败"
    fi
else
    ui_print "✓ 跳过密码修改"
fi

ui_print " "
ui_print "👋 安装完成，请重启设备"
ui_print "━━━━━━━━━━━━━━━━━━━━━━"
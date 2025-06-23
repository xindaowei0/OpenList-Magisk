#!/system/bin/sh

# 定义模块路径
MODULE_DIR="/data/adb/modules/openlist-magisk"
# 定义进程名称
PROCESS_NAME="openlist"
# 定义数据目录
DATA_DIR="/storage/emulated/0/Android/openlist"

# 函数：提示用户确认
confirm_action() {
    local action_desc="$1"
    local confirm_count=0
    while [ $confirm_count -lt 2 ]; do
        echo "$action_desc"
        echo "请输入 'yes' 确认，或其他任意键取消："
        read -r user_input
        if [ "$user_input" = "yes" ]; then
            confirm_count=$((confirm_count + 1))
            if [ $confirm_count -lt 2 ]; then
                echo "请再次确认。"
            fi
        else
            echo "操作已取消。"
            return 1
        fi
    done
    return 0
}

echo "正在准备卸载 openlist-magisk 模块..."

# 杀死相关进程
echo "查找并杀死 $PROCESS_NAME 相关进程..."
pids=$(pidof $PROCESS_NAME)
if [ -n "$pids" ]; then
    for pid in $pids; do
        echo "杀死进程 PID: $pid"
        kill -9 $pid
    done
    # 等待片刻确保进程已终止
    sleep 1
    # 再次检查是否还有残留进程
    if pidof $PROCESS_NAME >/dev/null; then
        echo "警告：部分 $PROCESS_NAME 进程可能未成功终止，请手动检查。"
    else
        echo "所有 $PROCESS_NAME 进程已终止。"
    fi
else
    echo "未找到 $PROCESS_NAME 相关进程，跳过终止步骤。"
fi

# 删除数据目录
if [ -d "$DATA_DIR" ]; then
    echo "准备删除数据目录 $DATA_DIR ..."
    if confirm_action "确认删除数据目录 $DATA_DIR 吗？此操作不可恢复！"; then
        rm -rf "$DATA_DIR"
        # 检查是否删除成功
        if [ ! -d "$DATA_DIR" ]; then
            echo "数据目录 $DATA_DIR 已成功删除。"
        else
            echo "错误：无法删除数据目录 $DATA_DIR，请检查权限或手动删除。"
            exit 1
        fi
    else
        echo "跳过数据目录删除。"
    fi
else
    echo "数据目录 $DATA_DIR 不存在，跳过删除步骤。"
fi

# 删除模块目录
if [ -d "$MODULE_DIR" ]; then
    echo "准备删除模块目录 $MODULE_DIR ..."
    if confirm_action "确认删除模块目录 $MODULE_DIR 吗？此操作不可恢复！"; then
        rm -rf "$MODULE_DIR"
        # 检查是否删除成功
        if [ ! -d "$MODULE_DIR" ]; then
            echo "模块已成功卸载！请重启设备以应用更改。"
        else
            echo "错误：无法删除模块目录，请检查权限或手动删除 $MODULE_DIR"
            exit 1
        fi
    else
        echo "跳过模块目录删除。"
    fi
else
    echo "错误：模块目录 $MODULE_DIR 不存在，无需卸载。"
fi
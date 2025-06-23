#!/system/bin/sh
ui_print "正在安装 OpenList Magisk 模块..."
ARCH=$(getprop ro.product.cpu.abi)
ui_print "检测到架构: $ARCH"

# 定义安装目录
INSTALL_DIR=$MODPATH/system/bin

# 定义用户可访问的 OpenList 数据目录
OPENLIST_USER_DATA_DIR="/storage/emulated/0/Android/openlist"
SOURCE_DATA_DIR="/data/adb/modules/openlist-magisk/data"

# --- 处理 data 目录 ---
# 检测是否存在现有的 data 目录
if [ -d "$SOURCE_DATA_DIR" ]; then
  ui_print "检测到现有的 data 目录，正在移动其所有内容到 $OPENLIST_USER_DATA_DIR..."
  # 创建用户可访问的 OpenList 数据目录（如果不存在）
  mkdir -p "$OPENLIST_USER_DATA_DIR"

  # 移动 data 目录内的所有文件和子目录到目标目录
  find "$SOURCE_DATA_DIR" -mindepth 1 -maxdepth 1 -exec mv {} "$OPENLIST_USER_DATA_DIR/" \; 2>/dev/null
  
else
  ui_print "未检测到 data 目录，继续安装..."
fi

# --- 根据架构安装对应的二进制文件 ---
if echo "$ARCH" | grep -q "arm64"; then
  ui_print "安装 64 位 OpenList 二进制..."
  mv "$MODPATH/system/bin/openlist-arm64" "$MODPATH/system/bin/openlist"
  rm -f "$MODPATH/system/bin/openlist-arm" # 使用 -f 避免文件不存在时报错
else
  ui_print "安装 32 位 OpenList 二进制..."
  mv "$MODPATH/system/bin/openlist-arm" "$MODPATH/system/bin/openlist"
  rm -f "$MODPATH/system/bin/openlist-arm64" # 使用 -f 避免文件不存在时报错
fi

chmod 755 "$MODPATH/system/bin/openlist"
ui_print "OpenList 已安装到 /system/bin/openlist"
ui_print "数据文件已移动到指定位置。"
ui_print "安装完成。"

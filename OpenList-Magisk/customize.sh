#!/system/bin/sh
ui_print "正在安装 OpenList Magisk 模块..."
ARCH=$(getprop ro.product.cpu.abi)
ui_print "检测到架构: $ARCH"

if echo "$ARCH" | grep -q "arm64"; then
  ui_print "安装 64 位 OpenList 二进制..."
  mv $MODPATH/system/bin/openlist-arm64 $MODPATH/system/bin/openlist
  rm $MODPATH/system/bin/openlist-arm
else
  ui_print "安装 32 位 OpenList 二进制..."
  mv $MODPATH/system/bin/openlist-arm $MODPATH/system/bin/openlist
  rm $MODPATH/system/bin/openlist-arm64
fi

chmod 755 $MODPATH/system/bin/openlist
ui_print "OpenList 已安装到 /system/bin/openlist"

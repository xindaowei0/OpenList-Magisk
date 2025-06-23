# Changelog

#### 1、修复了升级覆盖安装时丢数据问题(magisk的锅)
#### 2、删除迁移代码，增加了代码复杂性，导致启动问题。
#### 3、安装时支持音量键选择自定义二进制安装路径，分别为adb/openlist、安装目录/bin、system/bin。
#### 4、安装时音量键可选生成初始密码，magisk主页可以查看初始密码admin
#### 5、安装时音量键可以自定义数据目录，分别为adb/openlist和Android/openlist
#### 6、修复一些玄学问题，删除一些垃圾代码。
#### 7、支持magisk主页查看局域网、端口、密码等。
#### 8、如果你不想在magisk主页显示初始密码，可以到数据目录把“初始密码.txt”给删除掉，它就不再显示密码。
#### 9、是否支持TWRE刷入？我哪知道，我又没测试。光是测试当前这个模块我就重启了无数遍手机。你们自己测试。
#### 下个版本模块更新预告，可能会考虑增加frpc和aria2、caddy、ddnsgo等。
####有问题你们提ISS，有空我就会看。

- v4.0.2: Synced with OpenList official release v4.0.2
## What's Changed\r\n* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295\r\n* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294\r\n* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296\r\n* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279\r\n* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302\r\n* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297\r\n\r\n## New Contributors\r\n* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294\r\n* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279\r\n* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297\r\n\r\n**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

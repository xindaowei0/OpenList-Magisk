# Changelog

#### 下一个版本的openlist模块由机器人自动构建，模块有功能性或修复bug的我会在此说明。摆烂中....(下一次你还是看到此信息，说明我在摆烂)

#### 在此感谢[![TianwanTW's GitHub](https://img.shields.io/badge/GitHub-TianwanTW-blue?logo=github)](https://github.com/TianwanTW)大佬提交的PR，使用基于magisk提供的busybox的语法重写了customize.sh刷机脚本，解决了部分安卓用户死在刷机脚本无法执行这一步。

@TianwanTW https://github.com/TianwanTW


#### 截止2025-6/25 3:09
#### 更新日志：优化 service.sh，实现局域网IP和动态端口异步并行获取，增加失败重试(每间隔1秒请求一次直到成功为止，最多30次/秒中止逻辑死循环)，缩短启动时间，修复潜在的网络延迟和端口绑定超时问题，增强日志记录和错误处理。




#### 截止2025/6/24 21:54
#### 更新了自述文档，根据busybox语法重构customize.sh刷机脚本解决部分用户无法刷入模块的问题。(之前的customize.sh刷机脚本使用的是纯bash语法，有人可以有人不行)
#### ~~目前已知问题，获取WLAN时会显示报错，临时解决办法。点击magisk面板里面的“操作”，一开一关它又行了。。。不知道啥问题，有空再查。~~(已修复)


##### 历史更新👇🏻

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
#### 有问题你们提ISS，有空我就会看。


- v4.0.2: Synced with OpenList official release v4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.2: Synced with OpenList official release vv4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.2: Synced with OpenList official release vv4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.2: Synced with OpenList official release vv4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.2: Synced with OpenList official release vv4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.2: Synced with OpenList official release vv4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.2: Synced with OpenList official release vv4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.2: Synced with OpenList official release vv4.0.2
## What's Changed
* add dropbox api by @PIKACHUIM in https://github.com/OpenListTeam/OpenList/pull/295
* 删除曲奇云盘驱动 by @eiauo in https://github.com/OpenListTeam/OpenList/pull/294
* fixed(drive):Delete old Dropbox renewapi by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/296
* docs(README_cn): format document links as list to sync with other languages. by @Timer-u in https://github.com/OpenListTeam/OpenList/pull/279
* fix(ci):fixed changelog ci by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/302
* fix(setting): update PDF and EPUB viewer URLs by @xixu-me in https://github.com/OpenListTeam/OpenList/pull/297

## New Contributors
* @eiauo made their first contribution in https://github.com/OpenListTeam/OpenList/pull/294
* @Timer-u made their first contribution in https://github.com/OpenListTeam/OpenList/pull/279
* @xixu-me made their first contribution in https://github.com/OpenListTeam/OpenList/pull/297

**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.1...v4.0.2

vv4.0.3: Synced with OpenList official release vv4.0.3
## Main changes\r\n- Supported Quark Cloud Disk Open\r\n- Supports file cross network disk movement function (experimental)\r\n- Fixed some driver's and page's issues\r\n\r\n## What's Changed\r\n* fix(cloudreve_v4): change upS3 callback method from POST to GET by @xrgzs in https://github.com/OpenListTeam/OpenList/pull/323\r\n* fix(fs):Repair file loss caused by special reasons when moving files by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/321\r\n* fix(cloudreve_v4): update rename api path to  by @xrgzs in https://github.com/OpenListTeam/OpenList/pull/331\r\n* fix(cloudreve_v4): reference error in the refreshToken method by @xrgzs in https://github.com/OpenListTeam/OpenList/pull/328\r\n* fix(ci):fixed webversion by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/332\r\n* fix(ci):Fixed webversion by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/333\r\n* chore(issue): Update issue templates with improved descriptions and links by @jyxjjj in https://github.com/OpenListTeam/OpenList/pull/337\r\n* feat(quark_open): add quark open driver support by @dgscyg in https://github.com/OpenListTeam/OpenList/pull/324\r\n* chore(google_photo): update titles in getFakeRoot by @LittleJake in https://github.com/OpenListTeam/OpenList/pull/343\r\n* feature:add crypt cmd by @jenken827 in https://github.com/OpenListTeam/OpenList/pull/342\r\n* feat(thunder&thunder_browser): fix deviceId generation & support offline download and update login interface by @dgscyg in https://github.com/OpenListTeam/OpenList/pull/290\r\n* fix(123&123open): repair etag format by @dgscyg in https://github.com/OpenListTeam/OpenList/pull/349\r\n* refactor(fs):Refactor the move function and fix known issues by @Suyunmeng in https://github.com/OpenListTeam/OpenList/pull/353\r\n\r\n## New Contributors\r\n* @dgscyg made their first contribution in https://github.com/OpenListTeam/OpenList/pull/324\r\n* @LittleJake made their first contribution in https://github.com/OpenListTeam/OpenList/pull/343\r\n* @jenken827 made their first contribution in https://github.com/OpenListTeam/OpenList/pull/342\r\n\r\n## Important Notice\r\nIn the current version, we have added the function of moving files between cloud drives, which is an experimental feature. \r\nIt may fail to move or even result in file loss due to network or deployment environment influences. Please use it with caution.\r\n在当前版本我们增加了网盘间移动文件的功能，此为实验性功能。\r\n可能因为网络或者部署环境的影响导致移动失败，甚至出现文件丢失的情况，请谨慎使用。\r\n\r\n**Full Changelog**: https://github.com/OpenListTeam/OpenList/compare/v4.0.2...v4.0.3


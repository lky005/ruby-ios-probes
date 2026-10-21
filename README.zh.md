# ruby-ios-probes

`ruby` / MT6877 上 XNU + iOS bring-up 的只读探针仓库。

仓库刻意保持很小，**不包含 Apple 固件、IPSW/DMG、iOS root 镜像、dyld cache、
设备 dump、序列号或个人路径**，只放探针脚本、workflow 和脱敏后的 run card。

## 检查什么

| 探针 | 回答什么问题 |
|---|---|
| `probes/host/check-env.sh` | 磁盘、内存、FUSE、loop、apfs-fuse、hfsprogs、python、adb/fastboot、clang/lld |
| `probes/host/check-loop.sh` | 这台机器能不能创建并 loop 挂载一个小的 HFS+ 镜像（合成数据，不碰 Apple 内容） |
| `probes/device/probe-twrp.sh` | TWRP 版本、slot、分区大小、ICL 块状态、SWEETLOG ring（只读） |
| `.github/workflows/host-check.yml` | 在 GitHub-hosted Ubuntu runner 上跑 host 探针，输出文本报告 |

## 快速开始

主机：

```sh
sh probes/host/check-env.sh
sudo sh probes/host/check-loop.sh
```

设备（TWRP，只读）：

```sh
sh probes/device/probe-twrp.sh
```

CI：Actions -> host-check -> Run workflow，报告是一个文本 artifact。

## 边界

- 默认只读。设备探针不写块设备、不刷机。
- 仓库不存 Apple 材料。IPSW/DMG 由使用者自备，并遵守 Apple 条款。
- 不要把带个人路径、序列号或设备标识的生成报告提交进来；模板见 `runs/TEMPLATE.md`。
- TWRP 是第三方前置，仓库不包含。

## 相关项目

`ruby-ios-bringup` 保存构建配方、success bundle 哈希和复现文档；本仓库只放探针和 run card。

## 许可

探针代码 MIT；Apple 材料和第三方工具保持各自条款。见 `LICENSE`、`LEGAL.md`、`SECURITY.md`。

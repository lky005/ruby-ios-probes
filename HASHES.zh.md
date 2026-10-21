# hash 稳定性

这个仓库里有两类 hash，不能当成同一种东西。

## 固定 / 启动前（身份）

启动前对比这些：

- patchset `de1824c2...`；主项目的启动参数；
- ICL 块 `ae317804...` / `4a489542...`；
- 命名的 root 快照：A `e698339d...`、B `985c30...`、C `34c2882d...`、
  A' `55e2ab2c...`；
- 命名的工件：参考 0084 `94c639d1...`；2026-10-22 CI kernel `8a80855d...`、
  payload `2749bf1c...`、image `87dd4910...`。

这些是对应文件的身份。B/C 的完整镜像不保留；A' 是一次首启快照。新的首启
会得到新状态（A''）。CI kernel 构建不是位级一致；patchset hash 是复现门禁；
每次 run 记录实际 artifact hash。

## 易变 / 启动后（不要求相同）

- 任何启动后的 live root（A' -> A''）、UUID/时间戳、日志/缓存；
- SWEETLOG ring 及其解码文本；
- UI 像素、时序、崩溃的时序/次数。

同样的 B+NOP 再首启一次，不会得到字节一致的 A'。后续启动后的 live root 也
不是 A'。这些 hash 是观察值，不是契约。

## 规则

先对启动前身份，再看行为：锁屏、autoswipe、桌面、ring 标记（autoswipe
attempts、崩溃集合）。启动后的 hash 只作为证据记录。

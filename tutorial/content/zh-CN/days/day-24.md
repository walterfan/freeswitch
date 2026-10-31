# 第 24 天：Custom event、有界计数与并发

## 今日成果

- 发布带 Menu、Choice、Timestamp、Unique-ID 的 custom event。
- 用锁保证多个 channel 同时选择时不丢失或重复计数。

## 核心原理

custom event 只携带 tutorial 观察所需的字段；Menu/Choice 来自静态配置，Unique-ID 只作为服务端关联来源。全局 counter 与配置数组由 mutex 保护，API 在锁内复制后在锁外格式化，避免长时间占用模块锁。

## 源码导航

- [mod_tutorial.c](../../../../tutorial/module/mod_tutorial/mod_tutorial.c)
- [metrics.cpp](../../../../tutorial/site/src/metrics.cpp)
- [unit_tests.cpp](../../../../tutorial/site/test/unit_tests.cpp)
- [本课实验目录](../../../labs/day-24/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 订阅 `CUSTOM tutorial::ivr_choice` 并检查四项必要 header。
2. 用并发 unit test 让多个 worker 记录同一 branch，比较 invocation 与 choice count。
3. 向 service 发送一个未经信任的 custom event，确认 Metrics 把未知 menu/choice 归入 other。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

解释为什么 event timestamp 与 server 接收时间可能不同，以及二者都不能用作 UUID 或密码替代。

## 验收

**验收方式：自动：logic 并发测试、event contract 和 Metrics allowlist；多通道 live 验证为半自动。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 计数少于呼叫数 → 检查 lock 范围和重复事件处理。
- event 变成无限 label → 只接受配置 menu/choice。
- 共享 event 带 caller data → 删除不必要 header 并重新运行 redaction 检查。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 自定义事件 | custom event | 由模块发布的受限事件类型 |
| 互斥锁 | mutex | 保护共享状态的同步原语 |
| 基数 | cardinality | label 可能取值的数量 |

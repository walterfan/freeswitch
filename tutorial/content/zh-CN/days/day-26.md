# 第 26 天：status、HEARTBEAT、Channel events 与 CDR

## 今日成果

- 区分实时 gauge、累计 counter、duration 和 CDR。
- 用 HEARTBEAT 与 channel events 建立 Metrics 语义。

## 核心原理

status 给出可达性和容量摘要，HEARTBEAT 提供周期性的 session/freshness 观察，CHANNEL_CREATE/DESTROY 描述 live 生命周期，CDR 则在呼叫完成后提供记录。不同来源可能乱序或重复，Metrics 必须按相关标识和 finalization 状态只结算一次。

## 源码导航

- [metrics.cpp](../../../../tutorial/site/src/metrics.cpp)
- [switch_core_state_machine.c](../../../../src/switch_core_state_machine.c)
- [mod_event_socket.c](../../../../src/mod/event_handlers/mod_event_socket/mod_event_socket.c)
- [本课实验目录](../../../labs/day-26/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 执行 `status` 并记录 UP、session 和 capacity 的安全摘要。
2. 订阅 heartbeat、create、answer、hangup、destroy，观察当前 session 与 completed calls。
3. 对一通呼叫比较 CDR duration 与事件时序，不将 UUID 作为 label。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

给出一个 status 当前值、heartbeat freshness、call counter、duration 的四格解释，说明它们各自何时更新。

## 验收

**验收方式：自动：parser、correlation 和 Prometheus families 有单元测试；真实 CDR 需要 lab。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 缺少 HEARTBEAT header → 输出 unknown/NaN 或 degraded，不能填零假装健康。
- 重复 hangup → 检查 correlation finalization。
- CDR 到达早于 destroy → 允许后续事件补充但不重复计数。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 心跳 | HEARTBEAT | 周期性报告服务活性的事件 |
| 度量仪表 | gauge | 表示当前值的 Metrics 类型 |
| 通话详单 | CDR | 呼叫完成后的记录数据 |

# 第 27 天：ESL Collector、有界快照与重复事件

## 今日成果

- 理解 event reader、Metrics registry 和 immutable snapshot。
- 演练重连、乱序、重复事件和 overflow。

## 核心原理

collector 把原始 ESL event 转成内部结构，再交给 Metrics 和 EventHub。内部 snapshot 是 mutex 保护下的不可变副本；event ring、client queue 和 call correlation 都有独立上限。重复 event 不能增加完成呼叫，慢浏览器也不能反向阻塞 reader。

## 源码导航

- [esl_observer.cpp](../../../../tutorial/site/src/esl_observer.cpp)
- [metrics.cpp](../../../../tutorial/site/src/metrics.cpp)
- [unit_tests.cpp](../../../../tutorial/site/test/unit_tests.cpp)
- [本课实验目录](../../../labs/day-27/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 检查 event client 的 connecting/authenticating/subscribed/degraded 状态。
2. 按 create→answer→hangup→destroy、重复 hangup、缺少 destroy 和乱序顺序喂给 unit tests。
3. 让 bounded ring 和 per-client queue 溢出，观察 drop counter 与新 snapshot。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

计算给定 retention 上限下的最大内存项，说明为什么 correlation 与 recent event 需要两个不同的生命周期。

## 验收

**验收方式：自动：已有 ESL observer/Metrics tests 覆盖；实际断线与浏览器慢订阅为半自动。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 重复 call total → 检查 correlation 的 finalized 标记。
- snapshot 出现半值 → 只从锁内 copy 返回，不暴露内部可变容器。
- drop 后客户端卡住 → 发送 drop notification 和 fresh snapshot。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 收集器 | collector | 从运行时信号聚合观察值的组件 |
| 有界保留 | bounded retention | 对历史数据设置硬上限 |
| 乱序 | out of order | 事件到达顺序不同于呼叫发生顺序 |

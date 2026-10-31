# 第 19 天：ESL 认证、命令与事件

## 今日成果

- 区分 ESL command/reply 与 event subscription。
- 在不暴露密码的前提下关联一通呼叫的生命周期。

## 核心原理

ESL 命令连接适合有限的同步只读 API，事件连接则由专用 reader 持续消费。认证失败应该进入 degraded，并且 password 永远不能进入浏览器响应或日志。事件中的 Unique-ID 只用于服务端关联，面向浏览器时需要安全的相关标识。

## 源码导航

- [esl.c](../../../../libs/esl/src/esl.c)
- [esl_client.cpp](../../../../tutorial/site/src/esl_client.cpp)
- [esl_observer.cpp](../../../../tutorial/site/src/esl_observer.cpp)
- [本课实验目录](../../../labs/day-19/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 确认 ESL 只绑定实验边界，并从环境变量注入密码。
2. 用 `status`、`sofia status` 等 allowlist 命令验证 reply；不要把命令输入框暴露给页面。
3. 订阅 HEARTBEAT、CHANNEL 和 tutorial custom event，关联 create/answer/hangup。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

设计一个认证失败演练，列出用户能看到的三个安全字段和明确不能看到的三个敏感字段。

## 验收

**验收方式：半自动：连接状态、订阅和 redaction 可测试；真实呼叫关联要在隔离 ESL 环境验证。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- auth rejected → 只显示 authentication degraded，检查环境变量和 ACL。
- reply 被 event 打断 → 使用独立 command/event socket。
- 事件带完整 UUID → 在 normalize 层替换为相关标识后再发送。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 事件套接字层 | ESL | FreeSWITCH 的命令与事件 TCP 接口 |
| 订阅 | subscription | 请求接收一组事件的连接状态 |
| 回复 | reply | 对 ESL 命令返回的同步结果 |

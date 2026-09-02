# 第 29 天：事件面板、Metrics 面板与故障演练

## 今日成果

- 在课程阅读不中断的情况下查看事件和 Metrics。
- 完成 FreeSWITCH down、ESL auth、stale heartbeat、overflow 四项演练。

## 核心原理

前端是 server snapshot 的呈现者，不是 Metrics source of truth。事件面板显示有限的 timestamp/type/correlation/summary，溢出显示 drop evidence；health 面板把 service、FreeSWITCH、ESL、SIP profile、heartbeat 和 Metrics freshness 分开。

## 源码导航

- [live_evidence.mjs](../../../../tutorial/site/web/live_evidence.mjs)
- [http_server.cpp](../../../../tutorial/site/src/http_server.cpp)
- [health.cpp](../../../../tutorial/site/src/health.cpp)
- [本课实验目录](../../../labs/day-29/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 打开课程页并保持 lesson reader，在另一终端触发呼叫/IVR；确认事件和 Metrics 面板有界更新。
2. 分别注入四类故障，记录 status、detail、remediation 和页面是否仍能阅读。
3. 恢复依赖，确认新 snapshot 覆盖旧 stale 状态并且没有 credential 泄漏。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

设计一张故障演练记录卡，分开填写自动状态、事件证据、人工听感和恢复动作。

## 验收

**验收方式：自动加半自动：面板渲染、drop 和健康序列有测试；真实故障恢复需隔离 lab。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 课程内容打不开 → 检查静态 route 与 ESL 解耦。
- 页面显示密码/Authorization → 立即停止分享，修正 server normalize/public response。
- overflow 不明显 → 检查 drop count 是否和 fresh snapshot 一起发送。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 单一事实源 | source of truth | 决定 Metrics 实际值的服务端状态 |
| 面板 | panel | 展示一组相关运行时证据的 UI 区域 |
| 故障演练 | failure drill | 人为触发故障并验证恢复流程 |

# 第 30 天：浏览器到 IVR/SIP 的 Metrics Capstone

## 今日成果

- 串起浏览器注册、SIP 呼叫、WebRTC 音频、DTMF IVR、模块事件和 Prometheus。
- 完成可复现、可清理的最终验收记录。

## 核心原理

capstone 把不同层的证据放在同一条呼叫链：浏览器通过 WSS 注册，FreeSWITCH 处理 WebRTC 与 SIP/RTP，tutorial IVR 收集 DTMF，mod_tutorial 发布 custom event，ESL collector 更新 snapshot，网站和 Prometheus 只读取安全结果。自动 signaling 不等于人工音频通过。

## 源码导航

- [browser-to-sip-acceptance.md](../../../../tutorial/tests/browser-to-sip-acceptance.md)
- [module_integration.sh](../../../../tutorial/tests/module_integration.sh)
- [metrics.cpp](../../../../tutorial/site/src/metrics.cpp)
- [本课实验目录](../../../labs/day-30/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 按 deploy README 启动隔离 FreeSWITCH、模块、教程 XML 和 teaching service。
2. 浏览器注册 1000，呼叫 SIP 1001 完成人工双向音频；再呼叫 9000，走 main 1→submenu 1。
3. 收集 registered/ringing/established/terminated、DTMF、custom event、module API、health 和 `/metrics` 证据。
4. 按 acceptance checklist 分别记录自动信令、人工听感、失败演练和 cleanup。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

为下一位开发者写一份不含密码、完整 UUID、地址和原始 SDP 的复现报告，并列出每条证据的产生组件。

## 验收

**验收方式：半自动加人工：所有自动端点和状态必须通过测试；注册、双向听感、IVR 选择和清理必须在隔离 lab 真实执行。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 任何阶段失败 → 按 stage-specific diagnostics 停在最早失败层。
- Metrics 与页面不一致 → 以服务端 snapshot 为准，检查 event drop/stale。
- 清理不完整 → 先 hangup/unload，再 down tutorial project，确认 FreeSWITCH baseline 仍可独立运行。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 验收标准 | acceptance criteria | 判断 capstone 是否完成的可复现条件 |
| 证据链 | evidence chain | 把组件输出按时间和来源关联的记录 |
| 收尾清理 | cleanup | 实验结束后移除教程资源并恢复边界 |

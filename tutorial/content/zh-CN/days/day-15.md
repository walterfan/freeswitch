# 第 15 天：WebRTC 故障挑战

## 今日成果

- 把 WSS、注册、ICE、codec 和无声现象映射到不同阶段。
- 完成故障注入、证据记录和恢复清理。

## 核心原理

有效排障不是把所有错误都显示成“呼叫失败”，而是根据最早可观察的失败阶段选择动作。secure context/certificate/WSS 属于连接前，Digest 属于注册，SDP/ICE/DTLS/codec 属于媒体建立，no-audio 则可能发生在建立之后。诊断文字必须是安全摘要。

## 源码导航

- [diagnostics.mjs](../../../../tutorial/site/web/diagnostics.mjs)
- [web_tests.mjs](../../../../tutorial/site/test/web_tests.mjs)
- [10-runbook.md](../../../../man/10-runbook.md)
- [本课实验目录](../../../labs/day-15/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 依次运行九个诊断 fixture，确认每个阶段都有不同 remediation。
2. 在隔离环境只注入一个失败条件，保存阶段、状态和恢复动作。
3. 恢复后清除临时证书/抓包/日志，重新完成一通正常呼叫。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

给定“注册成功、established、远端无声”的报告，按证据顺序提出三个最小检查，而不是立即重启服务。

## 验收

**验收方式：自动：诊断 fixture 和敏感错误隐藏可测试；实际故障演练与音频仍须人工记录。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 重复出现 certificate/DTLS 误分类 → 检查诊断模式边界和完整错误阶段。
- 错误信息含密码 → 页面只显示通用失败，服务端日志走 redaction。
- 恢复后仍 degraded → 检查 heartbeat/SIP profile 是否已经新鲜。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 故障阶段 | failure stage | 诊断输出中最早可行动的协议层 |
| 恢复动作 | remediation | 把系统带回可验证状态的安全步骤 |
| 无声 | no audio | 信令建立后没有可听媒体的结果 |

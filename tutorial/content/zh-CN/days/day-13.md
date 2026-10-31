# 第 13 天：WebRTC SDP、ICE、DTLS-SRTP 与 Opus

## 今日成果

- 说明浏览器媒体协商的四层证据。
- 从脱敏 offer/answer 和候选摘要定位媒体失败阶段。

## 核心原理

WebRTC 音频不仅是 SIP 注册：SDP 选择媒体参数，ICE 选择可达候选，DTLS-SRTP 建立加密媒体，Opus 等 codec 承载音频。FreeSWITCH 的 Sofia WebRTC 端点把这些过程与 SIP dialog 连接起来。任何抓包分享都必须去掉 SDP 中的地址、候选和 UUID 等不必要数据。

## 源码导航

- [diagnostics.mjs](../../../../tutorial/site/web/diagnostics.mjs)
- [sofia_glue.c](../../../../src/mod/endpoints/mod_sofia/sofia_glue.c)
- [switch_rtp.c](../../../../src/switch_rtp.c)
- [本课实验目录](../../../labs/day-13/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 建立一通浏览器到 SIP 的实验呼叫，记录 SDP 是否有 audio、ICE 是否有可用 candidate、DTLS 是否完成、最终 codec。
2. 用诊断 fixture 分别模拟 SDP、ICE、DTLS-SRTP 和 codec 失败。
3. 恢复正常路径后做一次人工双向听感，不把自动 signaling 结果当作声音证明。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

制作四层故障卡片，每张只允许一个恢复动作，并指出证据来自浏览器、FreeSWITCH 还是人工听感。

## 验收

**验收方式：自动加人工：fixture 和状态映射自动验证；真实候选连通与音频听感需要实验执行。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 没有 audio m-line → 检查 media constraints 与 SDP answer。
- ICE failed → 比较候选连通性和 NAT，不先修改 codec。
- DTLS 成功但无声 → 检查 RTP track、输出设备和 codec。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 交互式连接建立 | ICE | 选择浏览器与对端可达候选的过程 |
| 数据报传输层安全 | DTLS | 协商安全媒体密钥的协议 |
| 安全实时传输 | SRTP | 加密 RTP 音频的传输方式 |

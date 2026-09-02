# 第 9 天：SDP、RTP、DTMF 与编解码

## 今日成果

- 从 SDP offer/answer 找到音频方向、payload 和媒体端口。
- 解释 RFC 2833/telephone-event 与编解码交集。

## 核心原理

SDP 负责协商媒体能力，RTP 承载连续音频，DTMF 可以使用 telephone-event 负载而不是把按键混入语音。双方 codec 没有交集时，信令可能成功但媒体无法建立；因此必须把 signaling、SDP、RTP 和听感分层验证。报告只保留 payload、codec 和阶段信息。

## 源码导航

- [switch_rtp.c](../../../../src/switch_rtp.c)
- [sofia_glue.c](../../../../src/mod/endpoints/mod_sofia/sofia_glue.c)
- [06-workflows.md](../../../../man/06-workflows.md)
- [本课实验目录](../../../labs/day-09/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 发起一通内部呼叫，保存脱敏的 offer/answer 摘要：音频方向、Opus/PCMU 等 codec 和 telephone-event。
2. 按一个数字进入测试 IVR，核对事件/应用侧是否收到 DTMF。
3. 比较 codec 交集存在与不存在的结果，关闭抓包或 debug。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

解释为什么“200 OK”不能单独证明有声音，并列出 SDP、ICE/RTP、应用 DTMF 三类证据。

## 验收

**验收方式：半自动：协商摘要和按键结果可检查；人耳确认仍为人工项目。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 无共同 codec → 对照 offer/answer 的 payload，不改动无关 profile。
- DTMF 未到达 → 区分 RTP telephone-event、SIP INFO 和应用读取方式。
- 端口可见但无音频 → 进入 NAT、ICE 或 DTLS-SRTP 诊断，而非继续重拨。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 会话描述 | SDP | 描述媒体能力与协商结果的文本 |
| RTP | RTP | 承载实时音频采样的传输协议 |
| 电话事件 | telephone-event | RTP 中表示 DTMF 的负载类型 |

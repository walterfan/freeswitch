# 第 14 天：浏览器到 SIP 桥接与转码

## 今日成果

- 完成浏览器分机到 SIP 分机的桥接验证。
- 识别直通 codec 与 FreeSWITCH 转码的证据。

## 核心原理

浏览器侧使用 WebRTC/DTLS-SRTP，传统 SIP 客户端可能使用 RTP 与另一组 codec。FreeSWITCH 在桥接两条腿时可以直通共同 codec，也可以在没有交集时转码；这会改变 CPU 与音频质量，但不改变教学服务只做观察的边界。

## 源码导航

- [switch_ivr_bridge.c](../../../../src/switch_ivr_bridge.c)
- [sofia_glue.c](../../../../src/mod/endpoints/mod_sofia/sofia_glue.c)
- [sip_adapter.mjs](../../../../tutorial/site/web/sip_adapter.mjs)
- [本课实验目录](../../../labs/day-14/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 注册浏览器与 1000，再用软电话注册 1001；建立并挂断一通测试呼叫。
2. 保存两条 media leg 的 codec、answer-state 和 bridge 事件摘要。
3. 在允许的实验配置中移除一个 codec，观察转码或失败，并恢复原配置。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

用表格（不含地址和 UUID）比较浏览器 leg、SIP leg 和 bridge 结果，写出一条自动证据与一条人工证据。

## 验收

**验收方式：人工：浏览器与软电话的双向音频必须实际听测；信令、事件和 codec 摘要可自动辅助。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 一侧无声 → 先判断是哪条 leg 的 RTP/输出问题。
- 呼叫建立但 codec 不同 → 查 answer 的 codec，确认是否发生转码。
- bridge 事件缺失 → 检查 ESL 订阅和服务健康，不把网页重载当修复。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 媒体腿 | media leg | 一条呼叫方向上的媒体协商与传输 |
| 转码 | transcoding | 在不同 codec 之间转换音频 |
| 直通 | passthrough | 不转换编码而转发兼容媒体 |

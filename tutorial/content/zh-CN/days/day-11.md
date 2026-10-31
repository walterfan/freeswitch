# 第 11 天：浏览器安全上下文、麦克风与设备

## 今日成果

- 解释 secure context、权限状态和音频设备枚举。
- 让浏览器区分授权、拒绝和没有输入设备三种结果。

## 核心原理

浏览器只有在可信 HTTPS 或 localhost 例外下才能调用麦克风；设备标签通常也要在授权后才完整。输入设备约束影响本地 WebRTC track，输出设备则通过 audio sink 影响播放。页面状态和 SIP 密码只保存在当前内存，不写入 localStorage、URL 或课程进度。

## 源码导航

- [preflight.mjs](../../../../tutorial/site/web/preflight.mjs)
- [media_devices.mjs](../../../../tutorial/site/web/media_devices.mjs)
- [mod_sofia.c](../../../../src/mod/endpoints/mod_sofia/mod_sofia.c)
- [本课实验目录](../../../labs/day-11/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 用 localhost HTTPS 打开课程页，检查 secure context 与 microphone preflight。
2. 分别执行允许、拒绝权限和拔掉输入设备的测试，记录三个不同状态。
3. 选择输入/输出设备后重载页面，确认进度可以恢复但密码不会恢复。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

为一个新同学写 preflight 检查顺序，并解释为什么必须先解决 secure context 再讨论 WSS。

## 验收

**验收方式：自动加人工：状态映射可由浏览器测试验证，真实麦克风和扬声器可用性由人工确认。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 浏览器提示不安全 → 使用可信 localhost 证书，不关闭证书检查。
- 权限已允许但没有输入 → 检查设备枚举和系统隐私设置。
- 输出设备选择无效 → 检查 setSinkId 支持与浏览器输出设备策略。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 安全上下文 | secure context | 浏览器允许敏感 API 的可信页面环境 |
| 媒体设备 | media device | 麦克风或扬声器等音频输入输出设备 |
| 权限拒绝 | permission denied | 用户或系统阻止媒体 API 的结果 |

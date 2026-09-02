# 第 12 天：Sofia WS/WSS 与可信证书

## 今日成果

- 定位 Sofia WS/WSS 监听与浏览器注册入口。
- 完成 localhost 与远程地址证书 SAN/信任检查。

## 核心原理

浏览器 SIP transport 使用 WebSocket；WSS 额外要求证书链被浏览器信任且名称匹配访问地址。证书信任和 SAN 匹配是两个独立条件，任何一个失败都会在注册前阻断。ESL 密码属于服务端配置，不能出现在 public-config 或页面日志。

## 源码导航

- [internal.xml](../../../../conf/vanilla/sip_profiles/internal.xml)
- [README.md](../../../../tutorial/deploy/README.md)
- [mod_sofia.c](../../../../src/mod/endpoints/mod_sofia/mod_sofia.c)
- [本课实验目录](../../../labs/day-12/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 从 internal profile 找到 WS/WSS 端口和 TLS 文件位置。
2. 为 localhost 生成教程 CA/证书，验证 `openssl s_client` 的链与 SAN，再打开网页。
3. 远程场景使用包含真实主机名或 IP 的证书，不能用 localhost 证书替代。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

列出“证书文件存在、链可信、SAN 匹配、WSS 可连接、SIP 可注册”五个阶段，并说明每阶段的安全证据。

## 验收

**验收方式：半自动：证书检查和诊断可自动；浏览器信任导入和注册需要当前实验环境确认。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- unknown CA → 只导入教程 CA 到实验浏览器，不导入私钥。
- 名称不匹配 → 重新签发含实际 SAN 的证书。
- WSS 连接拒绝 → 先查监听/profile 状态，再查 SIP Digest。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| WebSocket 安全传输 | WSS | TLS 保护的浏览器 WebSocket |
| 主题备用名称 | SAN | 证书声明的可用主机名或 IP |
| 信任链 | trust chain | 浏览器验证证书颁发关系的链路 |

# 第 5 天：用户注册、首通与 UUID

## 今日成果

- 完成 1000/1001 的隔离实验注册。
- 从 REGISTER、INVITE 到 BYE 关联同一通话 UUID。

## 核心原理

用户注册是身份与联系地址建立过程，首通则会经过 Sofia、session、dialplan 和 bridge。UUID 是 FreeSWITCH 为每条 channel 分配的关联键；它可以帮助你把 fs_cli、事件和日志对齐，但不能直接公开到 Metrics 标签或共享日志中。

## 源码导航

- [1000.xml](../../../../conf/vanilla/directory/default/1000.xml)
- [sofia.c](../../../../src/mod/endpoints/mod_sofia/sofia.c)
- [switch_core_session.c](../../../../src/switch_core_session.c)
- [本课实验目录](../../../labs/day-05/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 确认实验账号只在隔离环境使用，并检查 internal profile 与 directory。
2. 用两个 SIP 客户端注册 1000 和 1001，拨打 1001；分别记录注册结果、通话状态和人工双向听感。
3. 用 `show channels` 或指定的只读 API 保存短 UUID 证据，挂断后确认 channel 被清理。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

如果注册成功但首通失败，画出“注册地址 → INVITE 目标 → default context → Local_Extension → bridge”五步链路，并说明每步的观察证据。

## 验收

**验收方式：半自动：两个注册状态和 UUID 生命周期可自动或命令验证；双向音频必须单独记录人工结果。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 注册失败 → 先检查 realm、用户名和 profile 端口，不分享 Digest 内容。
- 能听到单向声音 → 将信令成功与 RTP/设备问题分开，检查第 10 天的媒体证据。
- 挂断后仍有 channel → 检查 bridge 和 hangup cause，再确认不是查询延迟。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 注册 | registration | SIP 用户建立联系地址的过程 |
| 通话 UUID | call UUID | 关联一条 channel 生命周期的标识 |
| 双向音频 | bidirectional audio | 双方都能听到并说话的人工媒体结果 |

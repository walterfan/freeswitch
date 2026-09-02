# 第 10 天：NAT、地址宣告与单向音频

## 今日成果

- 区分 SIP 可达性、RTP 可达性和浏览器设备问题。
- 完成一次有边界的单向音频故障演练并恢复配置。

## 核心原理

NAT 故障常表现为信令建立但 RTP 回程地址不可达。FreeSWITCH 的 profile、external_rtp_ip、local_network_acl 和 ICE candidate 共同影响地址选择；容器 host-network 与桥接网络的行为也不同。排障应先保存最小证据，再关闭抓包和临时日志，不能靠公开地址或完整号码做标签。

## 源码导航

- [internal.xml](../../../../conf/vanilla/sip_profiles/internal.xml)
- [switch_rtp.c](../../../../src/switch_rtp.c)
- [10-runbook.md](../../../../man/10-runbook.md)
- [本课实验目录](../../../labs/day-10/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 记录实验拓扑、监听端口和实际媒体候选，不把远端地址直接放到公共日志。
2. 制造一个可回滚的 advertised-address 错误，观察诊断页面将问题归入媒体层。
3. 恢复配置后重新验证双向音频，并确认临时 tracing 已关闭。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

写出单向音频的决策树：信令、SDP、ICE/RTP、浏览器输出设备，每步只选择一个下一证据。

## 验收

**验收方式：人工：需要真实媒体听感；自动部分只验证诊断阶段、清理动作和敏感字段防泄漏。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 只看到 SIP 成功 → 继续检查 RTP/ICE candidate。
- 容器地址与宿主地址不一致 → 使用实验 baseline 的宣告地址，避免修改 vanilla 示例。
- 排障结束仍有大量日志 → 恢复日志级别并删除共享的抓包文件。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 网络地址转换 | NAT | 改变地址/端口映射的网络边界 |
| 宣告地址 | advertised address | 告诉对端用于回连的地址 |
| 单向音频 | one-way audio | 只有一方能听到媒体的现象 |

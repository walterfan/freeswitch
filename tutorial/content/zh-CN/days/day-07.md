# 第 7 天：Digest 注册与 directory lookup

## 今日成果

- 解释 401 challenge、响应计算和 directory 用户查找。
- 从源码与只读命令定位注册失败发生在哪一层。

## 核心原理

Sofia profile 先决定监听与认证策略，directory 再提供 domain、用户和认证参数。Digest 的 Authorization 只在客户端到服务端的认证交换中短暂存在；教学服务和共享证据都不需要它。成功注册并不意味着 INVITE 一定能通过 context 和 dialplan。

## 源码导航

- [internal.xml](../../../../conf/vanilla/sip_profiles/internal.xml)
- [sofia.c](../../../../src/mod/endpoints/mod_sofia/sofia.c)
- [switch_xml.c](../../../../src/switch_xml.c)
- [本课实验目录](../../../labs/day-07/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 查看 internal profile 的 auth-calls、apply-inbound-acl 和 directory include。
2. 用 `user_exists`、`user_data` 等只读命令验证 1000/1001 的 domain 与 user_context。
3. 用错误密码做一次失败注册，记录状态阶段和 remediation，不记录密码、nonce 或 Authorization。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

给出成功与失败各一份“profile → directory → Digest → registration”证据图，要求每一项都能由安全字段复现。

## 验收

**验收方式：自动/半自动：目录查找和 profile 可由检查验证；认证抓包只保留脱敏结果。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 未知用户 → 比较实际 realm/domain 与 directory 文件名。
- 密码错误 → 看到 401/403 只说明认证阶段失败，不能把响应头复制出来。
- 注册成功但无来电 → 继续检查 contact、context 和 dialplan，而不是重复改密码。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 摘要认证 | Digest authentication | 不直接发送明文密码的 SIP 认证交换 |
| 域 | domain | directory 与 SIP 地址使用的命名范围 |
| 联系地址 | Contact | UA 可被呼叫到的 SIP 联系信息 |

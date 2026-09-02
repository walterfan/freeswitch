# 第 17 天：DTMF 收集与错误分支

## 今日成果

- 设置最大长度、超时、终止符和重试策略。
- 验证有效、超时、非法输入都能安全结束。

## 核心原理

DTMF 收集的输入边界应在 dialplan 和应用两侧同时存在。read 等应用负责收集，channel variable 保存结果，后续 condition 决定路由；超时不能被当成有效数字，非法输入也不能拼进任意 application 命令。RFC 2833 的传输成功与 IVR 分支成功需要分别观察。

## 源码导航

- [features.xml](../../../../conf/vanilla/dialplan/features.xml)
- [tutorial-ivr.xml](../../../../tutorial/module/mod_tutorial/tutorial-ivr.xml)
- [sip_adapter.mjs](../../../../tutorial/site/web/sip_adapter.mjs)
- [本课实验目录](../../../labs/day-17/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 用 tutorial IVR 收集单字符主菜单输入，测试 1、未知数字、超时和 # 终止。
2. 记录 `tutorial_main_digit` 等安全变量和最终 branch，不记录号码或完整 SDP。
3. 对照浏览器 `sendDtmf` 的输入校验，验证命令形状字符串被拒绝。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

增加一个“重复输入”和“超时后重试”场景，说明每次 retry 的上限以及最终安全退出。

## 验收

**验收方式：半自动：按键和变量可通过事件/检查验证；用户是否听到正确提示仍需人工。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 总是 timeout → 查音频媒体与 DTMF payload，而不是只查 dialplan regex。
- 未知数字进入主菜单 → 检查默认/invalid 分支和应用变量清理。
- 输入含分号被执行 → 这是安全缺陷，应立即停用并检查边界校验。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 双音多频 | DTMF | 电话键盘数字与符号信号 |
| 超时 | timeout | 规定时间内没有获得完整输入 |
| 终止符 | terminator | 表示输入结束的按键 |

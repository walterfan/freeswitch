# 第 23 天：tutorial_ivr_metric Application 与 channel variables

## 今日成果

- 调用教学 application 记录有效 menu/choice。
- 验证无效输入的变量和计数安全性。

## 核心原理

dialplan application 接收的数据必须先经过菜单和单字符 DTMF allowlist。成功时设置 `tutorial_ivr_menu`、`tutorial_ivr_choice`、`tutorial_ivr_recorded=true`；失败时清理旧选择并设置 error，不能执行输入中携带的命令。

## 源码导航

- [mod_tutorial.c](../../../../tutorial/module/mod_tutorial/mod_tutorial.c)
- [switch_channel.c](../../../../src/switch_channel.c)
- [tutorial-ivr.xml](../../../../tutorial/module/mod_tutorial/tutorial-ivr.xml)
- [本课实验目录](../../../labs/day-23/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 在 live channel 上执行 `tutorial_ivr_metric main 1`，读取三个 result variables。
2. 执行 unknown menu、12、空输入和额外 token，确认 choice counter 不变。
3. 将应用放进独立 IVR XML，验证 channel hangup 前后变量证据符合预期。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

提出一个旧 channel variable 可能误导下一菜单的场景，并用清理变量和 error 状态修正。

## 验收

**验收方式：半自动：变量和计数可由 harness/ESL 验证；live channel 仍需要隔离 lab。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- recorded 仍为 true → 每次调用前先设 false 并清除旧 menu/choice。
- 未知 menu 被统计到新 label → 检查配置 allowlist，不动态创建 key。
- 额外参数被接受 → 检查 token 数量必须严格为两个。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 拨号计划应用 | dialplan application | 由 channel 执行的 FreeSWITCH 应用 |
| 变量清理 | variable cleanup | 在新一次处理前移除旧状态 |
| 有效输入 | valid input | 通过格式和配置 allowlist 的输入 |

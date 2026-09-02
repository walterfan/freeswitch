# 第 18 天：多级 XML IVR 与 channel variables

## 今日成果

- 理解多级 condition、菜单变量和安全退出路径。
- 让主菜单和二级菜单都产生可观察但有界的结果。

## 核心原理

多级 IVR 可以由 XML nested condition 或 IVR menu 实现；每级都应定义有效输入、重试和退出。channel variable 是单通呼叫上下文，适合传递当前选择，但不应承载密码或未经验证的命令。教程模块只接受 allowlist 中的 menu/choice。

## 源码导航

- [tutorial-ivr.xml](../../../../tutorial/module/mod_tutorial/tutorial-ivr.xml)
- [switch_xml.c](../../../../src/switch_xml.c)
- [switch_core_state_machine.c](../../../../src/switch_core_state_machine.c)
- [本课实验目录](../../../labs/day-18/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 将 `tutorial-ivr.xml` 挂载到独立 dialplan context，执行 `reloadxml`。
2. 拨打 9000，测试主菜单 1→二级 1/2，以及主菜单 2/3；确认每条路径安全 hangup。
3. 查看 `tutorial_ivr_menu`、`tutorial_ivr_choice` 和 custom event 的摘要。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

画出 timeout、invalid、主菜单 1、二级 1/2、主菜单 2/3 五条路径，并标注每条是否调用教学应用。

## 验收

**验收方式：半自动：XML reload、分支和事件可检查；提示音与双向媒体仍需人工确认。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- reloadxml 失败 → 先校验教程文件 XML，不编辑运行中的 compiled fsxml。
- 二级菜单读到旧变量 → 每次进入菜单前清理变量并限定输入。
- 非法菜单名进入应用 → 检查模块 allowlist 和应用拒绝变量。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 多级 IVR | multi-level IVR | 由多个菜单层级组成的语音交互路由 |
| 嵌套条件 | nested condition | 在上一级匹配后继续判断的 XML 条件 |
| 安全退出 | safe exit | 超时/非法输入后的可预测结束路径 |

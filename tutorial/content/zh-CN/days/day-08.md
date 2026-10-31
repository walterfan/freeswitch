# 第 8 天：INVITE 路由、context 与 bridge

## 今日成果

- 追踪认证后的 INVITE 如何进入 context、dialplan 和 bridge。
- 解释 originate 与 bridge 的 source-level 入口。

## 核心原理

认证后的 channel 通常带有 directory 提供的 user_context；dialplan XML 根据 context、extension 和 condition 生成 application 序列。`bridge` 会为目标用户建立 B-leg，失败时可能按 `continue_on_fail` 继续。路由证据要使用目标扩展、context、应用名等低敏字段，不需要 caller number 或完整 UUID。

## 源码导航

- [default.xml](../../../../conf/vanilla/dialplan/default.xml)
- [switch_core_state_machine.c](../../../../src/switch_core_state_machine.c)
- [switch_ivr_originate.c](../../../../src/switch_ivr_originate.c)
- [本课实验目录](../../../labs/day-08/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 用 `xml_locate` 定位 default context 的 `Local_Extension`，只保存 extension 名称。
2. 拨打 1001，观察 CHANNEL_EXECUTE 中的 bridge，并对照 `switch_ivr_originate` 的调用路径。
3. 用不存在的扩展验证 `NO_ROUTE_DESTINATION`，记录 fail 而非执行任意 API。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

把一次 INVITE 从 Request-URI 到 B-leg 的数据流画成五个节点，并指出 channel variable `${destination_number}` 与预处理变量 `$${domain}` 的时机。

## 验收

**验收方式：半自动：路由命中和失败 cause 可自动检查；是否完成媒体桥接仍需要测试呼叫。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 没有匹配 extension → 比较 context、destination_number 和 regex。
- 桥接失败进入错误分支 → 记录 originate 失败和 hangup cause，检查演示用户是否在线。
- 把 `global_getvar` 当成 channel 变量 → 分别用 `$${}` 和 `${}` 的语义重新核对。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 路由 | routing | 从请求目标到 dialplan 应用的选择 |
| A-leg/B-leg | A-leg/B-leg | 主叫 channel 与被桥接目标 channel |
| 桥接 | bridge | 把两条媒体/信令腿连接起来 |

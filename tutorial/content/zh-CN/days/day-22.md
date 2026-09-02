# 第 22 天：tutorial_metrics API 与一致快照

## 今日成果

- 调用 text/json 两种 API 输出。
- 证明 API 读取不会修改计数器且输出字段稳定。

## 核心原理

API 是只读观察接口，输出包含 version、uptime、invocations、invalid 和每个配置选择。应用线程更新计数器时使用 mutex，API 先复制完整 snapshot，再格式化；因此不会把半更新的 choice 数字发送给 ESL 或网页。

## 源码导航

- [mod_tutorial_logic.c](../../../../tutorial/module/mod_tutorial/mod_tutorial_logic.c)
- [mod_tutorial.c](../../../../tutorial/module/mod_tutorial/mod_tutorial.c)
- [switch_apr.h](../../../../src/include/switch_apr.h)
- [本课实验目录](../../../labs/day-22/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 加载模块后执行 `tutorial_metrics` 和 `tutorial_metrics json`。
2. 调用几次 valid/invalid 应用，再比较 text 与 JSON 中的计数。
3. 执行不支持的选项，确认只返回 usage，不增加 invocation 或 choice。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

写一个只解析 JSON 的小检查器，验证它拒绝未知结构或缺失 version，并说明为什么不能执行 API 返回的内容。

## 验收

**验收方式：自动：module logic tests 覆盖格式化、只读快照和 usage；ESL API 调用需隔离实例。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 输出截断 → 检查有界选择数和格式化 buffer。
- JSON 解析失败 → 检查格式化转义与 version。
- usage 调用改变计数 → 检查参数解析必须发生在锁外且不能调用 record。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 快照 | snapshot | 同一时刻复制出的完整可读状态 |
| 只读 API | read-only API | 不改变模块状态的查询接口 |
| 调用总数 | invocation total | 应用被调用的累计次数 |

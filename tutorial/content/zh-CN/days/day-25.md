# 第 25 天：模块测试、失败路径与源码调试

## 今日成果

- 运行 module unit/contract/integration 测试目标。
- 区分静态 harness 证据、live lab 证据和人工音频证据。

## 核心原理

可靠的模块测试分三层：无 FreeSWITCH 的解析/格式化逻辑、源代码与 XML contract harness、需要运行实例的 load/IVR/ESL integration。失败路径测试必须验证模块未停止 FreeSWITCH，日志只输出安全原因，cleanup 只移除教程资源。

## 源码导航

- [test_mod_tutorial.c](../../../../tutorial/module/mod_tutorial/test/test_mod_tutorial.c)
- [module_integration.sh](../../../../tutorial/tests/module_integration.sh)
- [SubmittingPatches](../../../../docs/SubmittingPatches)
- [本课实验目录](../../../labs/day-25/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 运行 `ctest --test-dir tutorial/module/mod_tutorial/build --output-on-failure`。
2. 在有隔离 FreeSWITCH 时设置 `TUTORIAL_INTEGRATION=1`，运行 gated integration test。
3. 对 invalid config、missing config 和 unload 做一次演练；保存结果并删除临时 module/event 数据。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

为一个失败的 integration test 写出最小复现信息：阶段、命令、非敏感输出、恢复动作，不包含 ESL 密码。

## 验收

**验收方式：自动加半自动：无 trunk 的 tests 必须通过；integration 明确标识需要运行实例。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- CTest 显示 skipped → 只有设置 integration 环境后才执行 live 测试。
- load 失败 → 先查看配置路径和依赖，再确认 FreeSWITCH 仍然 UP。
- 调试日志过量 → 降回原级别并清理捕获文件。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 测试 harness | test harness | 围绕被测行为提供固定输入与断言的程序 |
| 失败路径 | failure path | 错误或依赖缺失时的执行分支 |
| 源码调试 | source debugging | 结合源码位置与运行证据定位问题 |

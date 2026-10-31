# 第 21 天：FreeSWITCH 模块生命周期与独立构建

## 今日成果

- 理解 module interface、pool、load/shutdown 顺序。
- 用安装的 `freeswitch.pc` 独立构建 `mod_tutorial`。

## 核心原理

模块在自己的 memory pool 中创建接口，load 时先解析配置和初始化同步，再 reserve event subclass，最后注册 API/application。shutdown 按相反方向释放事件类和 mutex；它不需要改 `build/modules.conf.in`，也不能把教程文件放进 `conf/vanilla`。

## 源码导航

- [standalone_module](../../../../build/standalone_module/)
- [CMakeLists.txt](../../../../tutorial/module/mod_tutorial/CMakeLists.txt)
- [switch_loadable_module.c](../../../../src/switch_loadable_module.c)
- [本课实验目录](../../../labs/day-21/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 查找安装前缀中的 `freeswitch.pc`，配置 standalone CMake。
2. 构建并运行 module unit/contract tests；检查输出同时有 `mod_tutorial.so` 和测试二进制。
3. 在隔离 FreeSWITCH 中显式 load/unload 模块，确认 FreeSWITCH 进程仍在运行。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

列出 load 失败发生在配置、mutex、event subclass 三个阶段时应释放的资源，并说明 pool 的所有权。

## 验收

**验收方式：自动加半自动：独立构建与单元测试自动；运行中 load/unload 需要隔离实例。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 找不到 header/library → 检查 `FREESWITCH_PC_FILE`，不要加入主工程 modules.conf。
- 配置错误导致模块未加载 → 阅读安全错误并修复教程 XML。
- unload 后接口仍在 → 检查 event subclass/interface 生命周期和活动呼叫。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 模块接口 | module interface | FreeSWITCH 发现模块导出能力的接口 |
| 内存池 | memory pool | 模块分配并随生命周期管理的内存域 |
| 加载/卸载 | load/unload | 注册或移除模块能力的生命周期操作 |

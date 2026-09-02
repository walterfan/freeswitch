# 第 20 天：C++ ESL 客户端与浏览器事件轨迹

## 今日成果

- 运行最小 C++ ESL client 并处理断线重连。
- 从事件连接把一通浏览器呼叫显示成有界轨迹。

## 核心原理

事件 reader 必须拥有接收循环，不能让多个线程同时读同一个 ESL handle。重连使用有限指数退避，成功后恢复订阅并重置退避；lesson delivery 不依赖 ESL。事件进入网站前先规范化、脱敏并进入有界 ring。

## 源码导航

- [esl_client.cpp](../../../../tutorial/site/src/esl_client.cpp)
- [esl_observer.cpp](../../../../tutorial/site/src/esl_observer.cpp)
- [unit_tests.cpp](../../../../tutorial/site/test/unit_tests.cpp)
- [本课实验目录](../../../labs/day-20/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 构建并启用 `TUTORIAL_ENABLE_ESL`，配置测试 ESL 密码。
2. 让 FreeSWITCH/ESL 短暂不可达，观察 disconnected/degraded/backoff，再恢复连接。
3. 拨打 9000，检查 create、custom choice、hangup 的时间顺序和 bounded UI rows。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

给重连过程增加一个慢浏览器订阅者，说明为什么慢客户端不能阻塞 ESL reader。

## 验收

**验收方式：自动：状态机、退避和队列测试；端到端呼叫事件需隔离 lab。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 重连后无事件 → 检查是否重新发送 subscribe。
- SSE 客户端拖慢服务 → 检查每客户端 queue/drop，不增加全局无限缓存。
- 断线期间页面白屏 → 内容路由必须与 ESL readiness 解耦。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 退避 | backoff | 失败重试之间逐步增加的等待时间 |
| 事件 reader | event reader | 拥有持续接收循环的线程/任务 |
| 轨迹 | trace | 按时间排列的有限运行时证据 |

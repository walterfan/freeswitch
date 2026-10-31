# 第 6 天：SIP 消息、事务、对话与拆线

## 今日成果

- 区分 REGISTER、INVITE、响应、ACK、BYE/CANCEL 的职责。
- 用一个受控抓包或日志片段标注事务与对话边界。

## 核心原理

事务负责一组请求与响应的可靠交互，对话则描述建立后的长期关系。INVITE 可能先收到 100、401/407 或 180，再以 200/ACK 建立媒体；未接通时 CANCEL，已接通后通常由 BYE 结束。课程证据只保存方法、状态码、阶段和脱敏时间，不能把 Authorization 或完整地址复制到报告。

## 源码导航

- [06-workflows.md](../../../../man/06-workflows.md)
- [sofia.c](../../../../src/mod/endpoints/mod_sofia/sofia.c)
- [mod_sofia.c](../../../../src/mod/endpoints/mod_sofia/mod_sofia.c)
- [本课实验目录](../../../labs/day-06/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 在本地实验网只抓取一通测试呼叫，开始前记录过滤条件，结束后关闭 tracing。
2. 从 REGISTER 到 BYE/CANCEL 按时间排序，给每个响应标注所属事务。
3. 对照事件流中的 CHANNEL_CREATE、ANSWER、HANGUP，说明 SIP 与 core 事件不是同一个层次。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

比较正常接通和无人接听两条时序，指出哪一条使用 CANCEL，哪一条使用 BYE，并说明不能用日志行数推断事务数量。

## 验收

**验收方式：半自动：时序结构和状态码可检查；抓包内容的脱敏与解读由学习者确认。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 401 后没有第二个带凭证请求 → 检查客户端是否支持 Digest，绝不把 nonce 写进 issue。
- 180 后没有 200 → 先判定对端未接听，不要误判为 RTP 故障。
- BYE 后页面仍显示 established → 以 CHANNEL_HANGUP/HANGUP_COMPLETE 为清理信号。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 事务 | transaction | 一个请求及其响应的交互范围 |
| 对话 | dialog | 建立后由 Call-ID、tags 等关联的会话关系 |
| 拆线 | teardown | 取消或结束 SIP 对话与媒体的过程 |

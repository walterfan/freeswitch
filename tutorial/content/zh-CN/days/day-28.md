# 第 28 天：Prometheus、健康与陈旧性

## 今日成果

- 读取 HELP/TYPE/sample 三部分 Prometheus 文本。
- 区分 outage zero、unknown 和 stale session。

## 核心原理

Prometheus exposition 必须使用固定 metric family 和有限 label。FreeSWITCH/ESL outage 时 availability 为 0，heartbeat age 继续增长；最后一次 session 值不能伪装成当前值，应通过 stale/known 语义表达。IVR labels 只来自配置 allowlist，未知值折叠到 other。

## 源码导航

- [metrics.cpp](../../../../tutorial/site/src/metrics.cpp)
- [prometheus.yml](../../../../tutorial/deploy/prometheus.yml)
- [http_smoke.py](../../../../tutorial/site/test/http_smoke.py)
- [本课实验目录](../../../labs/day-28/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 请求 `/metrics`，检查所有要求的 HELP/TYPE 和 numeric samples。
2. 停止或断开 FreeSWITCH/ESL，观察 up=0、heartbeat age 和 stale 结果。
3. 提交未知 hangup cause、menu、choice，确认不会创建新 label。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

解释为什么 sessions_current=0 与 sessions_current=NaN 表示不同事实，并指出 dashboard 应如何显示。

## 验收

**验收方式：自动：Prometheus 文本、有限 labels 和 outage unit tests；真实 outage drill 为半自动。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- parser 把 malformed heartbeat 当零 → 保持 unknown/degraded。
- label 出现 UUID/IP → 立刻停用 scrape 并检查 normalize。
- age 停在旧值 → 检查 clock/last heartbeat，而不是刷新浏览器。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 暴露格式 | exposition | 服务向 Prometheus 提供的文本协议 |
| 陈旧 | stale | 数据不再代表当前依赖状态 |
| 标签基数 | label cardinality | 指标标签取值数量的上限 |

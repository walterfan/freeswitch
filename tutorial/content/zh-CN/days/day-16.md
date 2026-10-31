# 第 16 天：Playback、Record 与 Phrase

## 今日成果

- 区分 playback 文件、phrase 宏和 recording 输出。
- 用安全检查确认实验音频依赖是否可用。

## 核心原理

播放是读取音频资源，record 是把媒体写到实验输出，phrase 可以把语言宏映射到多个提示。缺少声音包应是 unavailable，而不是假装播放成功；文件检查也不能替代人耳验收。教程使用独立 sound_root 和 tone_stream 示例，不从产品 vanilla 复制私有资产。

## 源码导航

- [main.cpp](../../../../tutorial/site/src/main.cpp)
- [README.md](../../../../tutorial/labs/day-16/README.md)
- [mod_dptools.c](../../../../src/mod/applications/mod_dptools/mod_dptools.c)
- [本课实验目录](../../../labs/day-16/)

## 引导实验

前置条件：使用隔离的 Ubuntu/Debian Docker lab；涉及 SIP、WSS、ESL、RTP、麦克风或音频文件时，不使用生产凭据和生产网络。

1. 查看 `tutorial/labs/day-16/sounds/` 的三项资源约定。
2. 运行 `ivr-sounds` 检查，观察缺失文件时的 unavailable 和安装提示。
3. 在隔离环境放入实验室批准的 wav 文件，执行 playback/phrase/record，再单独记录听感和生成文件清理。

清理：只删除本课生成的临时文件、呼叫和教程容器；分享输出前移除凭证、Authorization、地址、号码、原始 SDP 和完整 UUID。

## 独立挑战

说明为什么“文件存在”只能证明依赖就绪，不能证明采样率、播放设备和人耳听感都正确。

## 验收

**验收方式：半自动加人工：资源检查自动，实际播放、录音内容和清理由人工确认。**

- **pass**：完成本课成果，并保留不含敏感字段的命令、事件或页面证据。
- **fail**：依赖可达但结果与预期不符；沿源码导航和故障排查定位，不扩大权限或执行任意命令。
- **unavailable**：FreeSWITCH、ESL、浏览器设备或实验素材不可用；记录缺失依赖和 remediation，不能把未执行的音频观察标为通过。

## 故障排查

- 检查 unavailable → 按 remediation 安装实验音频到 sound_root，不修改 vanilla。
- 文件存在但播放失败 → 检查格式、采样率和 channel codec。
- 录音文件泄漏 → 使用隔离临时目录并在实验结束删除。

## 中英术语表

| 中文 | English | 本课含义 |
|---|---|---|
| 播放 | playback | 从音频资源向 channel 输出媒体 |
| 短语宏 | phrase macro | 按语言/场景组织提示文本或音频的宏 |
| 录音 | recording | 把 channel 音频保存为实验文件 |

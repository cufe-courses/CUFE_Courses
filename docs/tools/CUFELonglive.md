# CUFE 校园网自动登录

> 🔗 **GitHub 仓库**: [https://github.com/luzhiyu-econ/CUFELonglive](https://github.com/luzhiyu-econ/CUFELonglive)

一个针对中央财经大学校园网 Dr.COM ePortal 认证超时问题的确定性解决方案。

## 动机

手动重新认证校园网接入的机会成本不可忽视。对于远程服务器管理而言，认证失败构成单点故障，可能导致灾难性后果（即需要物理介入）。本工具通过自动化监控与重认证机制，最小化此类外部性。

## 技术规格

- **认证协议**：Dr.COM ePortal Web Portal（基于 HTTP GET）
- **支持平台**：macOS (launchd)、Linux (systemd)
- **依赖**：Python ≥3.7，`requests`
- **资源开销**：极低（后台守护进程，约 15 秒轮询间隔）

## 部署

### 前置条件

```bash
pip3 install -r requirements.txt
```

### 配置

```bash
cp config.example.py config.py
```

编辑 `config.py`，填入你的凭据：

```python
USERNAME = "你的学号"
PASSWORD = "你的密码"
DRCOM_HOST = "10.13.13.2"  # 根据实际情况调整
DRCOM_PORT = 801
```

亦可通过环境变量 `CAMPUS_USERNAME` 和 `CAMPUS_PASSWORD` 配置。

### 安装

**自动安装（推荐）**：

```bash
chmod +x install.sh
./install.sh
```

脚本将自动处理依赖验证、配置引导及系统服务注册。

**手动安装**：

```bash
python3 autologin.py login    # 单次登录
python3 autologin.py status   # 网络诊断
python3 autologin.py monitor  # 持久守护模式
```

## 架构

```
┌─────────────────────────────────────────────────────────┐
│                      监控循环                            │
│  ┌──────────┐    ┌──────────┐    ┌──────────────────┐  │
│  │  外网    │───▶│  离线？  │───▶│  Portal 可达？   │  │
│  │  检测    │ 否 │          │ 是 │                  │  │
│  └──────────┘    └──────────┘    └────────┬─────────┘  │
│       │                                    │            │
│       ▼                                    ▼            │
│  ┌──────────┐                      ┌──────────────┐    │
│  │   心跳   │                      │   重新登录   │    │
│  │ (5 分钟) │                      │ (指数退避)   │    │
│  └──────────┘                      └──────────────┘    │
└─────────────────────────────────────────────────────────┘
```

**连通性验证**：测试多个端点（小米、Google、Apple、Microsoft、百度）。任一成功即判定网络可用，确保对单一端点故障的鲁棒性。

**重试策略**：指数退避，上限 60 秒。连续失败 10 次后进入冷却期。

**心跳机制**：定期发送重认证请求（默认 300 秒），防止会话过期。Dr.COM 允许幂等登录操作。

## 服务管理

### macOS

```bash
launchctl list | grep campus                                    # 状态
launchctl unload ~/Library/LaunchAgents/com.campus.autologin.plist  # 停止
launchctl load ~/Library/LaunchAgents/com.campus.autologin.plist    # 启动
tail -f ~/Library/Logs/campus_autologin.log                     # 日志
```

### Linux

```bash
systemctl --user status campus-autologin   # 状态
systemctl --user stop campus-autologin     # 停止
systemctl --user start campus-autologin    # 启动
journalctl --user -u campus-autologin -f   # 日志
```

## 文件结构

```
.
├── autologin.py         # 核心实现
├── config.example.py    # 配置模板
├── config.py            # 本地配置（已纳入 .gitignore）
├── requirements.txt     # Python 依赖
├── install.sh           # 跨平台安装脚本
├── uninstall.sh         # 卸载脚本
└── README.md            # 文档
```

## 安全注意事项

- `config.py` 已通过 `.gitignore` 排除在版本控制之外
- 凭据亦可通过环境变量提供
- 建议执行：`chmod 600 config.py`

## 局限性

- 假定为基于 HTTP 的 Dr.COM ePortal；HTTPS 变体可能需要修改
- 不支持带验证码的认证门户
- IPv6 认证未经测试

## 许可证

MIT

---

_"优化的第一法则：不要优化。第二法则（仅限专家）：现在还不要优化。第三法则：把繁琐的部分自动化。"_


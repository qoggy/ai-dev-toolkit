# GitHub CLI (gh) 安装指南

GitHub CLI 是 GitHub 官方命令行工具，支持在终端操作 Issues、PR、Releases 等。

## 安装

### macOS

```bash
brew install gh
```

### Windows（winget）

```powershell
winget install --id GitHub.cli
```

## 登录认证

```bash
gh auth login
```

按提示选择：

- 账户类型：`GitHub.com`
- 协议：`HTTPS`（推荐）或 `SSH`
- 认证方式：`Login with a web browser`（最简单）

验证登录状态：

```bash
gh auth status
```

## 参考

- 官方文档：https://cli.github.com/manual/
- GitHub 仓库：https://github.com/cli/cli
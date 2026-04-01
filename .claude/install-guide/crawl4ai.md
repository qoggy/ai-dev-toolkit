# crawl4ai

网页抓取并转为 Markdown 的 CLI 工具，基于 Playwright，专为 LLM 设计。

## 安装

```bash
# 安装为全局工具
uv tool install crawl4ai

# 将 ~/.local/bin 加入 PATH（只需一次）
uv tool update-shell

# 安装 Playwright 浏览器（只需一次）
crawl4ai-setup

# 验证
crawl4ai-doctor
```

## 常用命令

```bash
crwl <url> -o md        # 完整 Markdown
crwl <url> -o md-fit    # 降噪 Markdown（过滤导航/广告，更适合 LLM 阅读）
crwl <url> -o md -O out.md  # 输出到文件
```

## 升级

```bash
uv tool upgrade crawl4ai
```
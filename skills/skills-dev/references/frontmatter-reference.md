# Frontmatter 可选字段参考

`name`、`description` 是所有工具通用的必填字段（写法见 SKILL.md）。本文件列出其余可选字段，按适用工具分组，仅在有明确需求时添加。跨工具复用同一份 skill 时，不识别的字段通常被忽略，但不要依赖这一点。

## Claude Code 专有 frontmatter

以下字段仅 Claude Code 识别，Codex 等其他工具会忽略。

### argument-hint

自动补全时显示的参数提示。

```yaml
argument-hint: "<描述你想要的 skill>"   # 或 [filename] [format]
```

### disable-model-invocation

```yaml
disable-model-invocation: true
```

禁止模型自动触发此 skill，且 description 不注入 context，只能用 `/name` 手动调用。Codex 对应 `agents/openai.yaml` 的 `allow_implicit_invocation: false`。

### user-invocable

```yaml
user-invocable: false
```

从 `/` 菜单隐藏。适合模型自动加载、用户不直接调用的背景知识类 skill。

### allowed-tools

此 skill 激活时模型无需额外确认即可使用的工具，空格分隔或 YAML 列表。

```yaml
allowed-tools: Read Grep Bash
```

### context / agent

```yaml
context: fork          # 在 subagent 的分叉 context 中运行，适合需独立执行的任务
agent: general-purpose # 配合 context: fork，指定 subagent 类型
```

### model

指定此 skill 激活时使用的模型，覆盖会话默认值。适用于对模型能力有特殊要求的任务。

```yaml
model: claude-opus-4-6
```

### effort

控制此 skill 激活时的推理深度（分配给 CoT 的 thinking tokens），覆盖会话默认值。高 effort 在复杂步骤上投入更多推理，低 effort 跳过思考直接回答、更快更省。

```yaml
effort: high
```

| 级别 | 适用场景 |
| --- | --- |
| `low` | 短小、延迟敏感、无需推理 |
| `medium` | 成本敏感、可接受少量推理损失 |
| `high` | 需要推理的任务的最低建议值 |
| `xhigh` | 多数编码和 agentic 任务的最佳选择 |
| `max` | 仅当前会话生效，不跨会话持久化 |

可用级别取决于模型：Opus 4.7 支持全部五档；Opus 4.6 / Sonnet 4.6 无 `xhigh`。

### hooks

为此 skill 的生命周期配置 hooks，语法同 settings.json，但仅作用于该 skill 执行期间。详见 [Claude Code hooks 文档](https://code.claude.com/docs/en/hooks)。

```yaml
hooks:
  - event: PostToolUse
    command: echo "tool used"
```

### paths

Glob 列表，限定仅在处理匹配文件时自动加载此 skill；不影响 `/name` 手动调用。接受逗号分隔字符串或 YAML 列表。

```yaml
paths: "src/**/*.ts,tests/**/*.ts"
```

### shell

指定 skill 内联 shell 命令（`` `!command` `` 和 ` ```! ` 块）使用的 shell。可选 `bash`（默认）、`powershell`（需环境变量 `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`，仅 Windows）。

```yaml
shell: powershell
```

## 开放标准字段（agentskills.io）

供工具链读取的元数据，模型本身不使用。

```yaml
metadata:              # 任意键值对，供打包脚本、注册表、第三方工具读取
  version: "1.0"
  author: "team-name"
  tags: ["devops", "automation"]
license: Apache-2.0     # 协议名，或捆绑 license 文件路径
compatibility: Requires Python 3.10+. Needs network access.  # 环境需求，≤500 字符
```

## 已废弃：when_to_use

曾用于补充触发条件、拼接在 `description` 后展示。当前 agentskills.io 规范与 Claude Code 文档均已移除，相关内容直接写入 `description`。

## Codex：agents/openai.yaml

Codex 不用 frontmatter 配置行为（frontmatter 仍只需 `name` + `description`），而在 skill 目录下放 `agents/openai.yaml`：

```
skill-name/
├── SKILL.md
├── scripts/  references/  assets/   # 可选；openai.yaml 引用的图标放 assets/
└── agents/openai.yaml               # 可选：外观、调用策略、依赖
```

三块均可选：

```yaml
interface:                       # 仅影响 ChatGPT 桌面端展示，不影响 CLI 行为
  display_name: "对用户显示的名字"
  short_description: "对用户显示的简介"
  icon_small: "./assets/small-logo.svg"    # 路径相对 skill 目录
  icon_large: "./assets/large-logo.png"
  brand_color: "#3B82F6"
  default_prompt: "调用该 skill 时包裹的默认提示"

policy:
  allow_implicit_invocation: false   # 默认 true；false=禁止自动触发，$skill 手动调用仍有效（等价 Claude 的 disable-model-invocation）

dependencies:
  tools:                             # 声明依赖的 MCP server
    - type: "mcp"
      value: "openaiDeveloperDocs"
      description: "OpenAI Docs MCP server"
      transport: "streamable_http"
      url: "https://developers.openai.com/mcp"
```

要同时兼容两方，两处都写：frontmatter 放 `disable-model-invocation: true`（Claude），`agents/openai.yaml` 放 `allow_implicit_invocation: false`（Codex）。

**禁用 skill 而不删文件**：编辑 `~/.codex/config.toml` 后重启 Codex。`~/.codex/` 仅用于放此配置，不是推荐的 skill 存放位置；skill 优先放 `~/.agents/skills` 或仓库内 `.agents/skills`，Codex 扫描时会跟随 symlink。

```toml
[[skills.config]]
path = "/path/to/skill/SKILL.md"
enabled = false
```

来源：[Codex / ChatGPT 官方 Build skills 文档](https://learn.chatgpt.com/docs/build-skills)。

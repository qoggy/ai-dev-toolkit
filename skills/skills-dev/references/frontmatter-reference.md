# 高级 Frontmatter 字段

以下字段较少使用，仅在有明确需求时添加。

---

## 来自 agentskills.io 开放标准的字段

### `metadata`

任意键值对，供工具链（打包脚本、注册表、第三方工具）读取。Claude 本身不使用这些值。

```yaml
metadata:
  version: "1.0"
  author: "team-name"
  tags: ["devops", "automation"]
```

### `license`

声明此 skill 的许可协议，可以是协议名称或捆绑 license 文件的路径。

```yaml
license: Apache-2.0
# 或
license: Proprietary. See LICENSE.txt
```

### `compatibility`

描述此 skill 的环境需求，最多 500 字符。用于说明适用的 AI 产品、需要的系统包、网络访问要求等。

```yaml
compatibility: Requires Python 3.10+. Designed for Claude Code. Needs network access for API calls.
```

---

## 已废弃字段

### `when_to_use`（已废弃）

曾用于补充触发条件，拼接在 `description` 后面展示。当前的 agentskills.io 规范和 Claude Code 中文文档均已移除此字段，应将相关内容直接写入 `description`。

---

## `model`

指定此 skill 激活时使用的模型，覆盖会话默认值。

```yaml
model: claude-opus-4-6
```

适用场景：skill 任务对模型能力有特殊要求（如需要扩展思考的复杂推理任务）。

## `effort`

控制此 skill 激活时模型的**推理深度**（自适应思考），覆盖会话默认值。

本质上是控制模型 CoT 思考的投入程度：高 effort 让模型在复杂步骤上分配更多 thinking tokens 进行推理，低 effort 则跳过思考直接回答，速度更快、成本更低。

```yaml
effort: high
```

| 级别 | 适用场景 |
| --- | --- |
| `low` | 短小、延迟敏感、不需要推理的任务 |
| `medium` | 对成本敏感、可接受少量推理损失的任务 |
| `high` | 需要推理的任务的最低建议值 |
| `xhigh` | 大多数编码和 agentic 任务的最佳选择（仅 Opus 4.7 支持） |
| `max` | 当前会话生效，不跨会话持久化 |

具体可用级别取决于所用模型：Opus 4.7 支持全部五档，Opus 4.6 / Sonnet 4.6 支持 `low`/`medium`/`high`/`max`（无 `xhigh`）。

## `hooks`

为此 skill 的生命周期配置 hooks，语法与 settings.json 中的 hooks 相同，但仅作用于该 skill 的执行过程。

```yaml
hooks:
  - event: PostToolUse
    command: echo "tool used"
```

详见 [Claude Code hooks 文档](https://code.claude.com/docs/en/hooks)。

## `paths`

Glob 模式列表，限定 Claude 在哪些文件路径下自动加载此 skill。接受逗号分隔的字符串或 YAML 列表。

```yaml
paths: "src/**/*.ts,tests/**/*.ts"
```

或：

```yaml
paths:
  - src/**/*.ts
  - tests/**/*.ts
```

设置后，Claude 只在处理匹配文件时自动加载该 skill。不影响通过 `/name` 手动调用。

## `shell`

指定 skill 中内联 shell 命令（`` `!command` `` 和 ` ```! ` 块）使用的 shell。

```yaml
shell: powershell
```

可选值：`bash`（默认）、`powershell`。`powershell` 需要启用环境变量 `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`，仅 Windows 有效。
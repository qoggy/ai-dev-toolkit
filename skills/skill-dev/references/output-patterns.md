# 输出模式

当 skill 需要生成一致、高质量的输出时，使用以下模式。

## 模板模式

为输出格式提供模板。根据需求选择适当的严格程度。

**严格要求（如 API 响应或数据格式）：**

```markdown
## 报告结构

始终使用以下精确的模板结构：

# [分析标题]

## 执行摘要
[关键发现的一段式概述]

## 关键发现
- 发现 1 及支撑数据
- 发现 2 及支撑数据
- 发现 3 及支撑数据

## 建议
1. 具体的可操作建议
2. 具体的可操作建议
```

**灵活指导（当需要适应性时）：**

```markdown
## 报告结构

以下是合理的默认格式，但请自行判断：

# [分析标题]

## 执行摘要
[概述]

## 关键发现
[根据发现的内容调整章节]

## 建议
[针对具体情境量身定制]

根据具体分析类型按需调整章节。
```

## 示例模式

对于输出质量依赖于示例的 skill，提供输入/输出对：

```markdown
## Commit message 格式

按照以下示例生成 commit message：

**示例 1：**
输入：添加了基于 JWT token 的用户认证
输出：
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**示例 2：**
输入：修复了报告中日期显示不正确的 bug
输出：
```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```

遵循此风格：类型（范围）：简短描述，然后是详细说明。
```

示例能比单纯的文字描述更清晰地帮助 Claude 理解期望的风格和详细程度。

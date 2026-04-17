---
name: skill-dev
description: 创建有效 skill 的指导手册。当用户想要创建新 skill（或更新现有 skill）以通过专业知识、工作流程或工具集成来扩展 Claude 能力时，应使用本 skill。
argument-hint: <描述你想要的 skill>
disable-model-invocation: true
---

# skill-dev

本 skill 提供创建有效 skill 的指导。

## 关于 Skill

Skill 是模块化、自包含的软件包，通过提供专业知识、工作流程和工具，来扩展 Claude 的能力。可以将其理解为特定领域或任务的"上手指南"——它们将通用型 Claude 转变为配备程序性知识的专业化 agent，而这类知识是任何模型都无法完全掌握的。

## 核心原则

### 简洁为王

context window 是公共资源。Skill 与 Claude 所需的一切共享 context window：系统提示、对话历史、其他 skill 的元数据，以及实际的用户请求。

**默认假设：Claude 本身已经非常聪明。** 只添加 Claude 还没有的上下文。质疑每一条信息："Claude 真的需要这段解释吗？"以及"这个段落值得消耗这些 token 吗？"

优先用简洁的示例代替冗长的解释。

### 设定适当的自由度

将具体程度与任务的脆弱性和可变性相匹配：

**高自由度（基于文本的说明）**：当多种方案均可行、决策依赖上下文，或需要启发式方法时使用。

**中等自由度（伪代码或带参数的脚本）**：当存在推荐模式、部分变化可接受，或配置会影响行为时使用。

**低自由度（特定脚本，参数极少）**：当操作脆弱且容易出错、一致性至关重要，或必须遵循特定顺序时使用。

### Skill 的结构

每个 skill 由一个必需的 SKILL.md 文件和可选的打包资源组成：

```
skill-name/
├── SKILL.md（必需）
│   ├── YAML frontmatter 元数据（必需）
│   └── Markdown 说明（必需）
└── 打包资源（可选）
    ├── scripts/          - 可执行代码（Python/Bash 等）
    ├── references/       - 按需加载到 context 中的文档
    └── assets/           - 输出中使用的文件（模板、图标、字体等）
```

#### SKILL.md（必需）

每个 SKILL.md 包含：

- **Frontmatter**（YAML）：包含 `name` 和 `description` 字段。这是 Claude 判断何时触发该 skill 的唯一依据，因此清晰、全面地描述 skill 的功能及使用时机至关重要。
- **Body**（Markdown）：使用 skill 的说明和指导。只有在 skill 触发后才会加载。

##### Frontmatter

编写包含 `name` 和 `description` 的 YAML frontmatter：

- `name`：skill 名称（小写字母、数字、连字符，最多 64 字符）
- `description`：这是 skill 的主要触发机制，帮助 Claude 理解何时使用该 skill。
    - **使用第三人称**描述 skill 的功能和触发场景（description 会注入到 system prompt，视角混乱会导致发现问题）。避免使用"I can..."或"You can use this to..."。
    - 同时包含 skill 的功能说明和具体的触发条件/使用场景。
    - 所有"何时使用"的信息都放在这里——不要放在 body 中。body 只有在触发后才会加载，因此 body 中的"何时使用本 Skill"章节对 Claude 没有帮助。
    - `description` 与 `when_to_use` 合计在 skill 列表中截断为 1,536 字符，关键用例应前置。
    - `docx` skill 的示例 description："支持修订追踪、注释、格式保留和文本提取的全面文档创建、编辑和分析工具。处理专业 Word 文档（.docx 文件）时使用：(1) 创建新文档，(2) 修改或编辑内容，(3) 使用修订追踪，(4) 添加注释，或任何其他文档任务"

可选 frontmatter 字段：

- `argument-hint`：自动补全时显示的参数提示，如 `<issue-number>` 或 `[filename] [format]`
- `disable-model-invocation: true`：禁止 Claude 自动触发此 skill，适合只想用 `/name` 手动调用的工作流
- `user-invocable: false`：从 `/` 菜单中隐藏，适合背景知识类 skill（Claude 自动加载，用户不直接调用）
- `context: fork`：在 subagent 的分叉 context 中运行，适合需要独立执行的任务
- `agent`：配合 `context: fork` 指定使用的 subagent 类型
- `allowed-tools`：此 skill 激活时 Claude 无需额外确认即可使用的工具，空格分隔或 YAML 列表
- `when_to_use`：补充触发条件，如触发短语、示例请求。内容追加在 skill 列表中的 `description` 之后，共享 1,536 字符上限。


#### 打包资源（可选）

##### Scripts（`scripts/`）

可执行代码（Python/Bash 等），用于需要确定性可靠性或反复重写的任务。

- **何时包含**：当相同代码被反复重写，或需要确定性可靠性时
- **示例**：`scripts/rotate_pdf.py` 用于 PDF 旋转任务
- **优点**：token 高效、结果确定，可在不加载到 context 的情况下执行
- **注意**：脚本仍可能需要被 Claude 读取，以进行修补或环境特定的调整

##### References（`references/`）

文档和参考资料，按需加载到 context 中，为 Claude 的处理和思考提供参考。

- **何时包含**：用于 Claude 在工作时应参考的文档
- **示例**：`references/finance.md` 用于财务 schema，`references/mnda.md` 用于公司 NDA 模板，`references/policies.md` 用于公司政策，`references/api_docs.md` 用于 API 规范
- **使用场景**：数据库 schema、API 文档、领域知识、公司政策、详细的工作流程指南
- **优点**：保持 SKILL.md 精简，只在 Claude 判断需要时才加载
- **最佳实践**：如果文件较大（>10k 词），在 SKILL.md 中包含 grep 搜索模式
- **避免重复**：信息应存放在 SKILL.md 或 references 文件中，不要两者都有。对于详细信息，优先使用 references 文件，除非该信息是 skill 的核心内容——这样既能保持 SKILL.md 精简，又能让信息可被发现，而不会占用 context window。SKILL.md 只保留基本的程序性说明和工作流程指导；将详细的参考资料、schema 和示例移至 references 文件。

##### Assets（`assets/`）

不打算加载到 context 中，而是在 Claude 生成的输出中使用的文件。

- **何时包含**：当 skill 需要将在最终输出中使用的文件时
- **示例**：`assets/logo.png` 用于品牌资产，`assets/slides.pptx` 用于 PowerPoint 模板，`assets/frontend-template/` 用于 HTML/React 样板代码，`assets/font.ttf` 用于字体
- **使用场景**：模板、图片、图标、样板代码、字体、会被复制或修改的示例文档
- **优点**：将输出资源与文档分离，使 Claude 无需将文件加载到 context 即可使用

#### Skill 中不应包含什么

Skill 应只包含直接支持其功能的必要文件。不要创建额外的文档或辅助文件，包括：

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- 等等

Skill 只应包含 AI agent 完成任务所需的信息，不应包含有关创建过程、设置和测试流程、面向用户的文档等辅助性上下文。创建额外的文档文件只会增加混乱。

### 渐进式披露设计原则

Skill 使用三级加载系统来有效管理 context：

1. **元数据（name + description）** - 始终在 context 中（约 100 词）
2. **SKILL.md body** - 当 skill 触发时（<5k 词）
3. **打包资源** - 由 Claude 按需加载（无限制，因为脚本可以在不读取到 context window 的情况下执行）

#### 渐进式披露模式

将 SKILL.md body 保持在基本内容以内、500 行以下，以最小化 context 膨胀。在接近这个限制时，将内容拆分到单独的文件中。将内容拆分到其他文件时，务必在 SKILL.md 中引用它们，并清楚描述何时读取它们，以确保 skill 的读者知道它们的存在和使用时机。

**核心原则：** 当一个 skill 支持多种变体、框架或选项时，SKILL.md 中只保留核心工作流程和选择指南，将变体特定的细节（模式、示例、配置）移到单独的 reference 文件中。

**模式 1：带引用的高层次指南**

```markdown
# PDF 处理

## 快速开始

使用 pdfplumber 提取文本：
[代码示例]

## 高级功能

- **表单填写**：完整指南见 [FORMS.md](FORMS.md)
- **API 参考**：所有方法见 [REFERENCE.md](REFERENCE.md)
- **示例**：常见模式见 [EXAMPLES.md](EXAMPLES.md)
```

只有在需要时，Claude 才会加载 FORMS.md、REFERENCE.md 或 EXAMPLES.md。

**模式 2：按领域组织**

对于涉及多个领域的 skill，按领域组织内容，避免加载无关的 context：

```
bigquery-skill/
├── SKILL.md（概述和导航）
└── reference/
    ├── finance.md（收入、账单指标）
    ├── sales.md（商机、销售管道）
    ├── product.md（API 使用量、功能）
    └── marketing.md（营销活动、归因）
```

当用户询问销售指标时，Claude 只读取 sales.md。

类似地，对于支持多个框架或变体的 skill，按变体组织：

```
cloud-deploy/
├── SKILL.md（工作流程 + 云服务商选择）
└── references/
    ├── aws.md（AWS 部署模式）
    ├── gcp.md（GCP 部署模式）
    └── azure.md（Azure 部署模式）
```

当用户选择 AWS 时，Claude 只读取 aws.md。

**模式 3：条件性细节**

显示基础内容，链接到进阶内容：

```markdown
# DOCX 处理

## 创建文档

使用 docx-js 创建新文档。参见 [DOCX-JS.md](DOCX-JS.md)。

## 编辑文档

对于简单编辑，直接修改 XML。

**对于修订追踪**：参见 [REDLINING.md](REDLINING.md)
**对于 OOXML 细节**：参见 [OOXML.md](OOXML.md)
```

只有当用户需要这些功能时，Claude 才会读取 REDLINING.md 或 OOXML.md。

**重要指南：**

- **避免深层嵌套引用** - 保持引用为从 SKILL.md 的一层深度。所有 reference 文件都应直接从 SKILL.md 链接。
- **为较长的 reference 文件设置结构** - 对于超过 100 行的文件，在顶部包含目录，以便 Claude 在预览时能看到完整范围。
- **始终使用正斜杠路径** - 文件路径一律用 `scripts/helper.py`，不要用 `scripts\helper.py`（反斜杠在 Unix 系统上会报错）。

## 创建新 Skill

从头创建时，先参见 [references/create-new.md](references/create-new.md) 完成步骤 1-3（理解、规划、初始化），然后回到下方「编辑指南」。

## 更新现有 Skill

1. 读取 SKILL.md 和关联的**全部**打包资源，全面理解当前结构和用途
2. 确认要改动的位置：description / body / scripts / references / assets
3. 编辑对应文件（参见下方「编辑指南」）
4. 如果改动了脚本，实际运行验证无 bug

## 编辑指南

编辑（新生成的或现有的）skill 时，请记住 skill 是为另一个 Claude 实例创建的。包含对 Claude 有益且非显而易见的信息。考虑哪些程序性知识、领域特定细节或可复用资产能帮助另一个 Claude 实例更有效地执行这些任务。

### 学习经过验证的设计模式

根据 skill 的需求参考以下最佳实践指南：

- **多步骤流程**：参见 [references/workflows.md](references/workflows.md)，了解顺序工作流程和条件逻辑
- **特定输出格式或质量标准**：参见 [references/output-patterns.md](references/output-patterns.md)，了解模板和示例模式

### 从可复用的 Skill 内容开始

开始实现时，从上述已识别的可复用资源开始：`scripts/`、`references/` 和 `assets/` 文件。注意此步骤可能需要用户输入。例如，在实现 `brand-guidelines` skill 时，用户可能需要提供要存储在 `assets/` 中的品牌资产或模板，或要存储在 `references/` 中的文档。

添加的脚本必须通过实际运行来测试，以确保没有 bug 且输出符合预期。任何不需要的示例文件和目录应删除。

#### 更新 SKILL.md

**MUST：** 始终使用祈使/不定式形式。

## 打包 Skill

skill 开发完成后，可以将其打包成可分发的 .skill 文件以供用户分享。打包过程会自动先验证 skill，以确保满足所有要求：

```bash
scripts/package_skill.py <path/to/skill-folder> ./dist
```

## refs

官方 skill 规范与最佳实践文档，供深入了解时参阅。

- https://code.claude.com/docs/zh-CN/skills
- https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- https://agentskills.io/skill-creation/best-practices

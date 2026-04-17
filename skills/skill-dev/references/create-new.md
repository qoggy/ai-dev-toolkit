# 创建新 Skill

完成以下步骤后，回到 SKILL.md 的「编辑指南」继续第 4、5 步。

## 第 1 步：通过具体示例理解 Skill

只有在 skill 的使用模式已经清晰理解时才跳过此步骤。

要创建有效的 skill，需要清楚地理解 skill 将被如何使用的具体示例。这种理解可以来自用户直接提供的示例，或通过生成示例再经用户反馈验证。

例如，在构建 image-editor skill 时，相关问题包括：

- "image-editor skill 应支持哪些功能？编辑、旋转，还是其他？"
- "你能举一些这个 skill 会被如何使用的例子吗？"
- "用户会说什么来触发这个 skill？"

避免在一条消息中提问太多问题。从最重要的问题开始，根据需要跟进。

## 第 2 步：规划可复用的 Skill 内容

分析每个具体示例，识别哪些脚本、references 和 assets 会有帮助：

**scripts/**：可执行代码，用于需要确定性可靠性或反复重写的任务。
- 示例：`scripts/rotate_pdf.py` 用于 PDF 旋转任务
- 何时包含：当相同代码被反复重写，或需要确定性可靠性时

**references/**：文档和参考资料，按需加载到 context 中。
- 示例：`references/schema.md` 用于数据库 schema，`references/api_docs.md` 用于 API 规范
- 何时包含：数据库 schema、API 文档、领域知识、公司政策、详细工作流程指南
- 最佳实践：如果文件较大（>10k 词），在 SKILL.md 中包含 grep 搜索模式

**assets/**：不加载到 context，而是在输出中使用的文件。
- 示例：`assets/logo.png` 品牌资产，`assets/slides.pptx` 模板，`assets/hello-world/` 样板代码
- 何时包含：模板、图片、图标、样板代码、字体

创建要包含的可复用资源列表，作为下一步的基础。

## 第 3 步：初始化 Skill

从头创建新 skill 时，始终运行 `init_skill.py`：

```bash
scripts/init_skill.py <skill-name> --path <output-directory>
```

必须通过 `--path` 显式指定创建目录，例如 `--path ~/.claude/skills`。

该脚本会创建 skill 目录、生成带 TODO 占位符的 SKILL.md 模板，以及示例 `scripts/`、`references/`、`assets/` 目录。

初始化后，删除不需要的示例文件和目录，再继续编辑 SKILL.md。
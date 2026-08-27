# 示例写法

示例是 skill 里 token 效率最高的部分。
示例能承载规则清单装不下的东西。规则是把真实场景抽象成几条互相独立的断言，抽象过程中丢掉的正是各种因素怎么交织在一起、判断的先后顺序、边界处的取舍。
示例往往直接取自真实场景，把这些因素原封不动地保留着，表达力因此更丰富。尤其对付 Bad Case：写十条 MUST NOT 也未必堵住一个具体的坏写法，而给出这个坏写法本身，一眼就能对上。

## 格式 A：轨迹 + commentary

一段完整的对话/操作轨迹，末尾用 `<commentary>` 点明这次判断的关键。适合动作复杂、光靠文字描述说不清参数该怎么填的场景。

```markdown
<example>
user: "Can you get a second opinion on whether this migration is safe?"
assistant: <thinking>I'll ask the code-reviewer agent — it won't see my analysis, so it can give an independent read.</thinking>
Task({
  description: "Independent migration review",
  subagent_type: "code-reviewer",
  prompt: "Review migration 0042_user_schema.sql for safety. Context: we're adding a NOT NULL column to a 50M-row table. Existing rows get a backfill default. I want a second opinion on whether the backfill approach is safe under concurrent writes — I've checked locking behavior but want independent verification. Report: is this safe, and if not, what specifically breaks?"
})
<commentary>
The agent starts with no context from this conversation, so the prompt briefs it: what to assess, the relevant background, and what form the answer should take.
</commentary>
</example>
```

要点：

- `<thinking>` 是这个格式的价值所在：它示范的是决策过程——为什么选这条路、当时在权衡什么
- `<thinking>` 用第一人称写当时的内心判断，属于示例内容本身；`<commentary>` 站在示例之外，一到两句点明这个示例要示范的原则，是给读者的元说明
- 两者分工不同，禁止内容重叠：thinking 里的推理不要在 commentary 里再铺一遍。commentary 写长了就说明它在抢 thinking 的活，把推理挪回 thinking，commentary 只留结论

## 格式 B：正反例集合 + reasoning

分「该用」「不该用」两组，每组若干 `<example>`，每例末尾 `<reasoning>` 用编号列出判断依据。适合触发条件模糊、单个示例画不出边界的场景（典型：什么时候该调用某个工具）。原文每组给了 4 例，下面各取 1 例示范格式：

```markdown
## Examples of When to Use the Todo List

<example>
User: I want to add a dark mode toggle to the application settings. Make sure you run the tests and build when you're done!
Assistant: *Creates todo list with the following items:*
1. Creating dark mode toggle component in Settings page
2. Adding dark mode state management (context/store)
3. Implementing CSS-in-JS styles for dark theme
4. Updating existing components to support theme switching
5. Running tests and build process, addressing any failures or errors that occur
*Begins working on the first task*

<reasoning>
The assistant used the todo list because:
1. Adding dark mode is a multi-step feature requiring UI, state management, and styling changes
2. The user explicitly requested tests and build be run afterward
3. The assistant inferred that tests and build need to pass by adding "Ensure tests and build succeed" as the final task
</reasoning>
</example>

## Examples of When NOT to Use the Todo List

<example>
User: What does the git status command do?
Assistant: The git status command shows the current state of your working directory and staging area. It displays which changes have been staged, which haven't, and which files aren't being tracked by Git. This is a fundamental command for understanding the current state of your repository before making commits.

<reasoning>
The assistant did not use the todo list because this is an informational request with no actual coding task to complete. The user is simply asking for an explanation, not for the assistant to perform multiple steps or tasks.
</reasoning>
</example>
```

要点：

- 两组都要有，只给正例等于没划边界
- `<reasoning>` 编号列出的是**判断依据**（触发了哪条规则），不是操作步骤复述
- 一组 2-4 例，每例覆盖不同的判断维度（步骤数量、用户显式要求、任务性质……）；雷同示例只是浪费 token

## 格式 C：Good/Bad 并列对比

同一场景的错写法与对写法紧挨着放，用代码注释直接标注结论和原因。适合差异在细节里、抽象描述抓不住的写法问题。

```markdown
// Anti-pattern — lazy delegation (bad whether continuing or spawning)
Task({ prompt: "Based on your findings, fix the auth bug", ... })
Task({ prompt: "The worker found an issue in the auth module. Please fix it.", ... })

// Good — synthesized spec (works with either continue or spawn)
Task({ prompt: "Fix the null pointer in src/auth/validate.ts:42. The user field on Session (src/auth/types.ts:15) is undefined when sessions expire but the token remains cached. Add a null check before user.id access — if null, return 401 with 'Session expired'. Commit and report the hash.", ... })
```

要点：

- 注释里必须写清**为什么错**，只标 `// Bad` 传达不了任何信息
- 正反例针对同一场景，只有一处不同，否则读者无法定位差异
- 也可以退化成两个简短清单（「好的写法」若干条 +「不好的写法」若干条并附一句原因），适合罗列多个平行的写法问题

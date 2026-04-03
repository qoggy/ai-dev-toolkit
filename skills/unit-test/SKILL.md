---
name: unit-test
description: 编写单元测试
argument-hint: <测试目标>
---

## User Input

```text
$ARGUMENTS
```

你**必须**在处理之前先查看用户输入（如果非空）。

## Core Task

你任务是编写单元测试，

1. **理解测试目标**
    - 如果用户没有提供测试目标，则询问用户
    - 明确用户想要验证什么场景

2. **收集信息**
    - 阅读相关代码，理解目标代码的运行机制

3. **阅读一个适配的单测规范**
    - [java-unit-test](./java-unit-test-guide.md):
      编写Java单元测试。适用于测试无外部依赖的类（工具类、算法、纯业务逻辑）。不涉及容器和Mock。
    - [spring-container-test](./spring-container-test-guide.md):
      编写Spring容器集成测试。适用于需要Spring容器和真实Bean的集成测试。测试Bean注册、依赖注入、AOP等Spring特性。
    - [python-unit-test](./python-unit-test-guide.md):
      编写Python单元测试

4. **编写单测**
    - 严格遵循规范进行编码
    - 添加必要的中文注释
    - 如果用户频繁拒绝代码，则必须停止编写代码并回到步骤一，简要阐述实现方案并寻求用户同意

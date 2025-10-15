---
description: Changelog创建和更新指南。当新增/编辑Changelog时使用。
---

## 核心要求

- 基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 标准
- 新版本在前，旧版本在后（倒序排列）
- 按类型分组：Added/Changed/Deprecated/Removed/Fixed/Security
- 面向用户描述，避免技术实现细节
- 使用语义化版本规范（MAJOR.MINOR.PATCH）

## 标准格式模板

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 新功能描述

### Changed
- 变更描述

### Deprecated
- 即将弃用的功能

### Removed
- 已移除的功能

### Fixed
- Bug 修复描述

### Security
- 安全性改进

## [1.0.0] - 2024-01-15

### Added
- 初始版本发布
- 核心功能实现

### Fixed
- 修复了登录问题

## [0.1.0] - 2024-01-01

### Added
- 项目初始化
- 基础框架搭建

[unreleased]: https://github.com/username/project/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/username/project/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/username/project/releases/tag/v0.1.0
```

## 变动类型分类

- **Added**：新功能、新 API、新配置选项
- **Changed**：现有功能修改、API 行为变更、性能改进
- **Deprecated**：即将移除的功能，不建议继续使用
- **Removed**：已删除的功能、不再支持的 API
- **Fixed**：Bug 修复、错误处理改进
- **Security**：安全漏洞修复、安全性增强

## 版本号和日期格式

### 版本号格式
- 使用语义化版本规范：`MAJOR.MINOR.PATCH`
- 格式：`[版本号] - 日期`
- 示例：`[1.2.3] - 2024-01-15`

### 日期格式
- **必须使用**：`YYYY-MM-DD` 格式
- 符合 ISO 8601 标准
- 示例：`2024-01-15`

## Unreleased 区块使用

### 目的
- 记录即将发布的更新内容
- 便于版本发布时直接移动内容

### 使用方法
1. 在开发过程中，将变更记录在 `[Unreleased]` 区块
2. 发布新版本时，将 `[Unreleased]` 内容移动到新版本区块
3. 清空 `[Unreleased]` 区块，准备下次开发

## 常见错误和避免方法

### ❌ 错误做法：包含过多技术细节
```markdown
## [1.0.2] - 2025-10-07

### Fixed
- Fix Spring AOP proxy timing issue in extension framework
  - Move extension registration from `postProcessAfterInstantiation` to `postProcessAfterInitialization` to ensure Spring AOP proxies are registered
  - Move `@ExtensionInject` processing to `postProcessBeforeInitialization` to avoid proxy field injection issues
  - Use `AopUtils.getTargetClass()` to properly handle proxied beans during registration
  - Add comprehensive tests to verify Spring AOP proxy integration

### Added
- Add test dependencies for Spring AOP proxy testing (spring-tx, spring-jdbc, h2)
```

### ✅ 正确做法：面向用户的描述
```markdown
## [1.0.2] - 2025-10-07

### Fixed
- Fix Spring AOP integration issues that caused AOP features to be bypassed
    - Fixed issue where `@Transactional`, `@Cacheable`, `@PreAuthorize` and other AOP annotations were not working when called through extension framework
    - Fixed `@ExtensionInject` injection failure in Spring AOP proxied beans (e.g., beans with `@Transactional` methods)
```

## 文件命名规范

### 推荐文件名
- `CHANGELOG.md`

### 文件位置
- 项目根目录
- 与 `README.md` 同级

## 撤回版本处理

对于因重大 bug 或安全问题而撤回的版本：

```markdown
## [0.0.5] - 2014-12-13 [YANKED]

### Fixed
- 修复了严重的安全漏洞

**注意：此版本因安全问题已被撤回，请勿使用。**
```

## 创建 Changelog 的工作流程

1. **分析变更内容**：识别变更类型和用户影响
2. **分类整理**：按 Added/Changed/Deprecated/Removed/Fixed/Security 分类
3. **版本号确定**：重大变更→MAJOR，新功能→MINOR，Bug修复→PATCH
4. **格式检查**：日期格式（YYYY-MM-DD）、Markdown 格式、链接正确性

## 质量检查清单

创建或更新 changelog 时，请检查：

- [ ] 使用了正确的日期格式（YYYY-MM-DD）
- [ ] 变更按类型正确分类
- [ ] 版本号遵循语义化版本规范
- [ ] 描述面向用户，而非技术实现细节
- [ ] 包含了所有重要变更
- [ ] 新版本在旧版本之前
- [ ] 链接格式正确
- [ ] 语言清晰、简洁
- [ ] 没有包含 git commit 信息
- [ ] Unreleased 区块存在且格式正确

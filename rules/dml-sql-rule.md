---
description: 数据库DML规范。当编写DML SQL时使用。
---

请严格遵循以下规则和模板编写 SQL 语句

## 详细规则

### 表级规范

- 必须指定 utf8mb4 编码、表描述和字段描述
- 表命名：使用小写字符和单数形式，示例：`customer_order_relation`
- 禁止定义数据库外键、触发器
- 禁止修改和删除现有表的"表名"、"字段名"，避免导致系统不兼容

### 字段规范

- 必须包含字段：`id`、`gmt_create`、`gmt_modified`
- 创建人字段命名为 `creator`
- 修改人字段命名为 `modifier`
- 布尔型字段命名：`is_xxx` 格式，数据类型为 `unsigned tinyint`，`1` 表示真，`0` 表示假
- 枚举型字段：使用有意义的字符串值，避免使用数字编码（如 `0`,`1`,`2`），我们不缺这一点存储空间

### 索引规范

- 唯一索引命名：`uk_字段名`
- 普通索引命名：`idx_字段名`

## SQL 模板
```sql
CREATE TABLE `xxxx` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
    `gmt_create` datetime NOT NULL COMMENT '创建时间',
    `gmt_modified` datetime NOT NULL COMMENT '修改时间',
    ...其他字段
    PRIMARY KEY (`id`),
    ...其他索引
) DEFAULT CHARACTER SET=utf8mb4 COMMENT='xxxx';
```

## 示例

### 创建表

```sql
CREATE TABLE `team` (
	`id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
	`gmt_create` datetime NOT NULL COMMENT '创建时间',
	`gmt_modified` datetime NOT NULL COMMENT '修改时间',
	`creator` varchar(64) NOT NULL COMMENT '创建人',
	`modifier` varchar(64) NOT NULL COMMENT '修改人',
	`uuid` varchar(64) NOT NULL COMMENT 'uuid',
	`name` varchar(128) NOT NULL COMMENT '团队名称',
	`description` varchar(512) NULL COMMENT '团队描述',
	`members` json NOT NULL COMMENT '团队成员',
	PRIMARY KEY (`id`),
	UNIQUE KEY `uk_uuid` (`uuid`)
) DEFAULT CHARACTER SET=utf8mb4 COMMENT='团队';
```

### 修改表

```sql
ALTER TABLE `mcp_resource`
	MODIFY COLUMN `category` varchar(128) NULL COMMENT '类型',
	ADD COLUMN `override_uuid` varchar(64) NULL COMMENT '覆盖的uuid';
```
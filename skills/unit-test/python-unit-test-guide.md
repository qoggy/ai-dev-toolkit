## 目录结构

通常，测试文件放在项目根目录的 `test/` 下，与 `src/` 平级。

## 环境与依赖

测试使用 **pytest** 框架。

主要测试依赖：

| 包 | 用途 |
|---|---|
| `pytest` | 测试运行器 |
| `pytest-asyncio` | 异步测试支持（`asyncio_mode = "auto"`） |
| `pytest-mock` | Mock 支持（`mocker` fixture） |
| `pytest-xdist` | 并行运行（`-n auto`） |
| `pytest-cov` | 覆盖率报告 |

## 命名规范

### 测试文件

- 格式：`test_[被测模块名].py`
- 示例：`src/my-utils/errors.py` → `test/test_errors.py`

### 测试函数

| 场景 | 格式 | 示例 |
|---|---|---|
| 基础测试 | `test_[函数名]` | `test_get_root_causes` |
| 特定场景 | `test_[函数名]_[场景]` | `test_get_root_causes_with_exception_group` |
| 预期结果 | `test_[函数名]_[预期结果]` | `test_get_root_causes_returns_leaf` |

命名使用全小写 + 下划线，清晰描述测试意图。

### 测试类（可选）

当一个被测类的方法较多时，可用测试类分组：

- 格式：`Test[被测类名]`
- 示例：`class TestExceptionUtils:`

```python
class TestExceptionUtils:
    def test_get_root_causes(self) -> None:
        ...

    def test_get_root_causes_with_chained_exception(self) -> None:
        ...
```

## 类型标注

测试函数返回值统一标注为 `-> None`，参数使用具体类型：

```python
def test_parse_returns_object() -> None:
    ...

def test_with_fixture(tmp_path: Path) -> None:
    ...
```

## 导入规范

```python
import pytest

# 被测模块使用绝对导入
from my_utils.errors import ExceptionUtils
```

## 测试覆盖场景

每个功能应覆盖以下场景：

**正常情况**

- 典型输入的正常执行路径
- 多种有效输入组合

**边界情况**

- 空值：空字符串 `""`、空列表 `[]`、空字典 `{}`
- `None` 值：`None` 参数、`None` 字段
- 边界值：最大值、最小值、零值
- 特殊字符：空格、符号、Unicode

**异常情况**

- 无效输入
- 非法参数
- 预期异常抛出

**复杂场景**

- 嵌套结构
- 循环引用
- 并发情况（如适用）

## 测试结构

### 基础测试

```python
def test_get_root_cause_message() -> None:
    exc = ValueError("something went wrong")
    result = ExceptionUtils.get_root_cause_message(exc)
    print(f"result: {result}")
    assert result == "something went wrong"
```

### 调试输出

使用 `print()` 输出中间结果便于调试（pytest 默认捕获，失败时自动展示）：

```python
def test_get_root_causes_with_chained() -> None:
    inner = ValueError("inner error")
    outer = RuntimeError("outer")
    outer.__cause__ = inner

    result = ExceptionUtils.get_root_causes(outer)
    print(f"root causes: {result}")
    assert len(result) == 1
    assert result[0] is inner
```

### 异常断言

使用 `pytest.raises` 断言预期异常：

```python
def test_parse_invalid_json() -> None:
    with pytest.raises(ValueError) as exc_info:
        parse_json("not-json")
    print(f"exception: {exc_info.value}")  # 调试输出，确认异常内容符合预期
```

### 辅助方法

提取重复的构建逻辑为私有辅助函数：

```python
def _build_exception_group() -> ExceptionGroup:
    return ExceptionGroup("group", [ValueError("a"), KeyError("b")])


def test_get_root_causes_from_group() -> None:
    eg = _build_exception_group()
    result = ExceptionUtils.get_root_causes(eg)
    assert len(result) == 2
```

### 内部数据类

使用内部 dataclass 或普通类作为测试数据载体：

```python
from dataclasses import dataclass

def test_parse_to_dataclass() -> None:
    @dataclass
    class UserInfo:
        name: str
        age: int

    result = parse(json_str, UserInfo)
    assert result.name == "Alice"
    assert result.age == 30
```

## 异步测试

项目已配置 `asyncio_mode = "auto"`，直接使用 `async def` 即可，无需额外装饰器：

```python
async def test_async_http_get() -> None:
    result = await fetch("https://example.com")
    print(f"status: {result.status_code}")
    assert result.status_code == 200
```

---
description: Java单元测试指南。适用于测试无外部依赖的类（工具类、算法、纯业务逻辑）。不涉及容器和Mock。
---

## 命名规范

### 测试类

- 类名：`[被测试的类名]Test`
- 修饰符：包私有（不加 `public`）
- JavaDoc：简洁，不超过一行

### 测试方法

- 方法名模式：
    - `test[方法名]`：基础测试
    - `test[方法名]_[场景]`：特定场景测试，如 `testAdd_multipleFields`
    - `test[方法名]_[预期结果]`：预期结果测试，如 `testParse_invalidJson`
- 修饰符：包私有（不加 `public`）
- JavaDoc：可选，简洁，不超过一行

```java
/**
 * Unit tests for ToStringHelper
 */
class ToStringHelperTest {
    @Test
    void testToStringHelper_withObject() {
        // test code
    }

    @Test
    void testAdd_nullValue() {
        // test code
    }
}
```

## 依赖导入

使用 JUnit 5 (org.junit.jupiter):

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
```

## 测试覆盖场景

每个功能应覆盖以下场景：

### 正常情况

- 典型输入的正常执行路径
- 多种有效输入组合

### 边界情况

- 空值：空字符串、空集合、空数组
- null 值：null 参数、null 字段
- 边界值：最大值、最小值、零值
- 特殊字符：空格、符号、Unicode

### 异常情况

- 无效输入
- 非法参数
- 预期异常抛出

### 复杂场景

- 嵌套结构
- 循环引用
- 并发情况（如适用）

## 测试结构

### 测试数据类

使用 static 内部类作为测试数据：

```java
class JsonUtilsTest {
    @Test
    void testParse() {
        TestBean bean = JsonUtils.parse(json, TestBean.class);
        assertEquals("expected", bean.getName());
    }

    // 注意：如果对一些动态代理场景进行测试，可能需要把修饰符改为public
    private static class TestBean {
        private String name;
        private Integer age;
        // getter, setter ...
    }
}
```

### 辅助方法

提取重复的测试数据构建逻辑：

```java
private TreeNode buildSampleTree() {
    TreeNode root = new TreeNode("A", null);
    TreeNode nodeB = new TreeNode("B", "A");
    root.setChildren(Collections.singletonList(nodeB));
    return root;
}
```

### 调试输出

使用 `System.out.println()` 输出中间结果便于调试：

```java
@Test
void testCall() {
    String result = method.call(param);
    System.out.println("result: " + result);
    assertEquals(expected, result);
}
```

### 测试异常情况

使用`assertThrows`异常断言：

```java
@Test
void testCall_invalidParam() {
    IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
        method.call(invalidParam);
    });
    exception.printStackTrace();    // 调试输出，用于检查抛出的异常是否符合预期
}
```

## 工作流程

1. 读取被测试的类文件，熟悉被测试类的职责和功能
2. 识别测试文件存放位置
3. 编写单测代码
4. 检查单测能否通过编译
5. 预测运行结果并告诉我

**重要**：你不要运行单元测试，我会替你运行。取而代之的，你需要预测运行结果并告诉我。
---
description: 编写Spring容器集成测试。适用于需要Spring容器和真实Bean的集成测试。测试Bean注册、依赖注入、AOP等Spring特性。
---

## User Input

```text
$ARGUMENTS
```

你**必须**在处理之前先查看用户输入（如果非空）。

## Core Task

请严格遵循以下规则和模板编写 Spring 容器集成测试

## Execution Steps

1. 读取被测试的类文件，熟悉被测试类的职责和功能
2. 识别测试文件存放位置
3. 编写单测代码
4. 检查单测能否通过编译
5. 预测运行结果并告诉我

**重要**：你不要运行单元测试，我会替你运行。取而代之的，你需要预测运行结果并告诉我。

## Important Instructions

### 命名规范

#### 测试类

- 类名：`[被测试的类名]Test`
- 修饰符：包私有（不加 `public`）
- JavaDoc：简洁，不超过一行

#### 测试方法

- 方法名模式：
    - `test[方法名]`：基础测试
    - `test[方法名]_[场景]`：特定场景测试
    - `test[方法名]_[预期结果]`：预期结果测试
- 修饰符：包私有（不加 `public`）

```java
/**
 * Spring Boot自动配置测试
 */
class MyAutoConfigurationTest {
    @Test
    void testAutoConfiguration_shouldCreateBeans() {
        // test code
    }
}
```

### 依赖导入

```java
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import org.springframework.boot.autoconfigure.AutoConfigurations;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
```

### ApplicationContextRunner

用于测试 Spring Boot 自动配置和容器行为的轻量级测试工具。

#### 基础用法

```java
class MyAutoConfigurationTest {
    private final ApplicationContextRunner contextRunner = new ApplicationContextRunner()
            .withConfiguration(AutoConfigurations.of(MyAutoConfiguration.class));

    @Test
    void testAutoConfiguration_shouldCreateBeans() {
        contextRunner.run(context -> {
            assertTrue(context.containsBean("myContext"));
            assertNotNull(context.getBean(MyContext.class));
        });
    }
}
```

#### 添加用户配置

```java
@Test
void testExtensionRegistration_shouldRegisterAutomatically() {
    contextRunner
            .withUserConfiguration(TestConfiguration.class)
            .run(context -> {
                ExtensionContext extensionContext = context.getBean(ExtensionContext.class);
                TestExtensionPoint extension = extensionContext.find(TestExtensionPoint.class);
                assertNotNull(extension);
            });
}
```

### 测试配置类

使用 static 内部类作为测试配置：

```java
@Configuration
static class TestConfiguration {
    @Bean
    public TestService testService() {
        return new TestService();
    }

    @Bean
    public TestExtensionImpl testExtensionImpl() {
        return new TestExtensionImpl();
    }
}
```

### 常见测试场景

#### Bean 注册和依赖注入

```java
@Test
void testBeanRegistration_shouldRegisterBean() {
    contextRunner
            .withUserConfiguration(TestConfiguration.class)
            .run(context -> {
                assertTrue(context.containsBean("testService"));
                TestService service = context.getBean(TestService.class);
                assertNotNull(service);
                assertNotNull(service.getDependency());
                assertEquals("expected", service.callDependency());
            });
}
```

#### AOP 代理测试

```java
@Test
void testAopProxy_shouldCreateProxy() {
    contextRunner
            .withUserConfiguration(ProxyTestConfiguration.class)
            .run(context -> {
                ProxiedService service = context.getBean(ProxiedService.class);
                assertTrue(AopUtils.isAopProxy(service));
                String result = service.methodWithAnnotation();
                assertEquals("expected result", result);
            });
}
```

#### 事务管理测试

```java
@Configuration
@EnableTransactionManagement
static class TransactionTestConfiguration {
    @Bean
    public DataSource dataSource() {
        return new EmbeddedDatabaseBuilder()
                .setType(EmbeddedDatabaseType.H2)
                .build();
    }

    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean
    public TransactionalService transactionalService() {
        return new TransactionalService();
    }
}
```

### 测试技巧

#### 验证 Bean 类型

```java
TestService service = context.getBean(TestService.class);
assertTrue(service instanceof ExpectedType);
assertSame(bean1, bean2); // 验证是同一个实例
```

#### 调试输出

```java
@Test
void testFeature() {
    contextRunner.run(context -> {
        TestService service = context.getBean(TestService.class);
        String result = service.doSomething();
        System.out.println("result: " + result);
        assertEquals("expected", result);
    });
}
```

#### 异常场景测试

```java
@Test
void testInvalidConfiguration_shouldFail() {
    contextRunner
            .withUserConfiguration(InvalidConfiguration.class)
            .run(context -> {
                assertThrows(RuntimeException.class, context::isRunning);
            });
}
```
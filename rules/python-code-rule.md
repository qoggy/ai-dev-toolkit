# 开发规范

MUST:

- 私有方法最多只写一行注释
- 必须编写方法/函数的出入参类型，哪怕是`Any`,`dict`
- 使用 Python 3.10+ 最新标准语法来写类型标注，例如：`Optional[T] -> T | None`, `List[T] -> list[T]`, `Dict[T] -> dict[T]`
- 异常处理：
    - 当使用 except 捕获异常时，不允许静默处理：必须记录日志或重新抛出异常（raise），至少满足其一。
- 打印日志的时候，如果遇到异常，那么必须打印堆栈（`exc_info`）
- 相对导入 vs 绝对导入：
    - 包内部代码之间：使用相对导入（. 或 ..）
    - 公共 API 层面：使用绝对导入

SHOULD:

- 公开方法写在类的上面，私有方法写在类/代码文件的最下面
- 如果方法出入参很简单、逻辑也很简单，那就只写一行注释
- 为了达到代码自解释的目标，任何自定义编程元素在命名时，使用尽量完整的单词组合来表达其意。
    - 订单退款记录，正例：`OrderRefundRecord`，反例：`RefundRecord`
    - 库存盘点任务，正例：`inventory_check_task`，反例：`check_task`
- 不要过度设计 `YAGNI — “You Ain’t Gonna Need It.”`
- `try-except`块控制的范围越精准越好而不要过度包裹

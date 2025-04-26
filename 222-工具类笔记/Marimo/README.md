# Marimo 深度解析：反应式 Python 笔记本指南

## 引言

Marimo 代表了 Python 笔记本环境的一次革新，它被设计为一个反应式的、可交互的、可复现的 Python 程序开发工具，旨在克服传统笔记本（如 Jupyter）固有的诸多局限性 1。其核心特性包括：

- **反应性 (reactivity)**，即单元格的执行由数据依赖关系自动驱动；
- **交互性 (interactivity)**，通过 UI 元素与 Python 代码无缝绑定；
- **可复现性 (reproducibility)**，消除隐藏状态并保证确定性执行；
- **可执行性 (executability)**，每个笔记本本身就是纯 Python 文件，可作为脚本运行；
- 以及**可部署性 (deployability)**，能够轻松部署为交互式 Web 应用 1。

Marimo 的设计哲学是为 Python 社区提供一个更优越的编程环境，以促进科学研究、代码实验、成果交流和计算科学教学 1。它的灵感来源于 Pluto.jl、ObservableHQ 等项目，并顺应了向反应式数据流编程范式发展的趋势 1。

本报告将深入探讨 Marimo 的各个方面，从其核心的反应性机制出发，详细介绍用户输入、信息展示、执行流控制、SQL 集成、分享发布以及配置自定义等关键功能。旨在为希望使用或评估 Marimo 的开发者和数据科学家提供一份全面、深入的技术指南。

要开始使用 Marimo，可以通过 `pip install marimo` 进行安装，并通过运行 `marimo tutorial intro` 启动入门教程 1。

## 1. 反应性：Marimo 的核心机制

文档链接

Marimo 的核心优势和独特之处在于其反应性执行模型。该模型旨在自动维护代码、输出和程序状态之间的一致性，从而解决传统笔记本中常见的状态管理和可复现性问题。

### (a) 工作原理

Marimo 的反应性并非基于运行时追踪，而是建立在静态代码分析的基础之上。在加载笔记本时，Marimo 会解析每个单元格的代码，识别其中全局变量的定义（赋值、函数定义、类定义、导入等）和引用（读取）。这一过程完全在代码执行之前完成，因此几乎没有运行时开销 12。

基于这些分析结果，Marimo 会构建一个**数据流图 (Directed Acyclic Graph, DAG)**。在这个图中，每个单元格是一个节点。如果单元格 B 引用了单元格 A 定义的任何全局变量，那么图中就存在一条从 A 指向 B 的有向边，表示 B 依赖于 A。这个 DAG 精确地描绘了笔记本中数据依赖关系。

Marimo 的核心运行时规则是：当一个单元格被执行（无论是由于代码被修改还是其绑定的 UI 元素值发生变化），Marimo 会自动沿着 DAG 重新运行所有直接或间接依赖于该单元格所定义变量的下游单元格 5。

例如，如果单元格 A 定义了变量 `x`，单元格 B 使用 `x` 计算 `y`，单元格 C 使用 `y` 生成图表，那么当单元格 A 的代码或其绑定的 UI 元素变化导致 `x` 更新时，Marimo 会自动重新运行单元格 B，接着自动重新运行单元格 C，确保 `y` 的值和最终的图表都反映 `x` 的最新状态。

这种自动化的、基于依赖关系的执行确保了整个笔记本的代码、输出和程序状态始终保持一致性 5。这与传统笔记本（如 Jupyter）形成了鲜明对比。在 Jupyter 中，单元格通常按用户手动执行的顺序运行，并且需要用户自行管理依赖关系和状态 23。用户必须手动重新运行所有受影响的单元格才能确保结果一致，这很容易出错，并常常导致**隐藏状态 (hidden state)** 问题——即输出结果与当前代码不符，或者程序内存中存在由已删除或修改的单元格遗留下来的变量 5。一项研究甚至发现，高达 36% 的 Jupyter 笔记本存在可复现性问题 22。Marimo 通过其反应性模型从根本上解决了这些问题 5。

此外，当在 Marimo 中删除一个单元格时，它所定义的全局变量会自动从程序内存中清除，依赖于这些变量的下游单元格也会被自动重新计算（或标记为过时），从而彻底消除因删除单元格而产生的隐藏状态 5。

### (b) 对使用者的意义与注意事项

理解 Marimo 的反应性模型对有效使用该工具至关重要。以下是一些关键的含义和需要注意的事项：

- **全局变量是核心**: 单元格之间的数据流完全通过全局变量（包括函数、类、导入的模块等）的定义和引用来建立 23。Marimo 要求每个全局变量必须在唯一的一个单元格中定义，以保证数据流的清晰和一致性 23。
- **单元格物理顺序不重要**: 笔记本中单元格的排列顺序对其执行逻辑没有影响；真正重要的是由全局变量依赖关系决定的 DAG 结构 1。这赋予了用户极大的灵活性来组织代码，例如可以将辅助函数或配置代码放在笔记本的末尾，而将重要的输出或交互元素放在开头 1。
- **关键限制：不追踪原地修改 (Mutations)**: 这是 Marimo 反应性模型中最需要注意的一个限制。Marimo 不会追踪对已存在对象进行的原地修改操作 23。这意味着，如果在单元格 B 中修改了由单元格 A 定义的列表（如 `my_list.append(x)`）、字典（如 `my_dict['key'] = value`）或 DataFrame（如 `my_dataframe['new_col'] =...`），依赖于 `my_list`、`my_dict` 或 `my_dataframe` 的下游单元格 C **不会**被自动重新运行 23。
  - 这个设计决策源于在 Python 中可靠地追踪任意对象突变的复杂性和潜在的性能问题，以及可能导致用户难以预测的意外单元格重跑 23。Marimo 选择优先保证基于静态分析的 DAG 的可预测性。
  - 为了维持确定性的执行流程，Marimo 的反应性触发器严格限制在由静态分析识别出的全局变量 **定义** 上，确保 DAG 始终是执行流的唯一依据 23。这迫使用户显式处理那些不是新定义的变量状态变化。
  - **处理原地修改的最佳实践 23**:
    1.  **在定义变量的同一个单元格内进行修改**: 如果必须进行原地修改，应确保修改操作与变量的初始定义在同一个单元格内完成 23。
        ```python
        # Cell 1 (推荐)
        import pandas as pd
        df = pd.DataFrame({"my_column": [5, 1]})
        df["another_column"] = [6, 24] # 在定义 df 的单元格内修改
        ```
        ```python
        # Cell 2 (下游单元格)
        # 这个单元格会正确地在 Cell 1 运行后运行，因为它依赖于 df
        print(df.shape)
        ```
    2.  **避免在下游单元格修改上游定义的变量**：
        ```python
        # Cell 1 (不推荐)
        import pandas as pd
        df = pd.DataFrame({"my_column": [5, 1]})
        ```
        ```python
        # Cell 2 (不推荐)
        # 这个修改不会触发依赖 df 的下游单元格重新运行
        df["another_column"] = [6, 24]
        ```
    3.  **优先创建新变量（函数式风格）**: 最佳实践是避免原地修改，而是创建新的变量来表示修改后的状态 23。这通常更符合数据流的思想，也使代码更易于理解和调试 23。
        ```python
        # Cell 1
        my_list = [5, 1]
        ```
        ```python
        # Cell 2 (推荐)
        new_list = my_list + [6] # 创建新列表，而不是 my_list.append(3)
        ```
        ```python
        # Cell 3 (下游单元格)
        # 这个单元格会在 Cell 2 运行后运行，因为它依赖于 new_list
        print(f"New list length: {len(new_list)}")
        ```
        这种模式与函数式编程中的不可变性概念相呼应。采用这种模式可以减少对可变对象内部隐藏状态变化的依赖，使数据依赖关系更加清晰，从而提高代码的可维护性，尤其是在处理复杂的数据转换时。
- **一致性保证**: 反应性模型的核心目标是确保代码、输出和程序状态三者之间始终保持一致 5。
- **性能考量**: 由于 Marimo 只重新运行必要的下游单元格，其反应性通常是高效的 1。然而，对于具有极其复杂或深度依赖关系的 DAG，反应性更新可能仍会引入一定的计算开销。后续章节将讨论惰性执行和缓存等优化策略。

## 2. 获取用户输入 (User Input)

文档链接

Marimo 提供了丰富的用户界面 (UI) 元素库 (`marimo.ui`，通常导入为 `mo.ui`)，用于从用户那里获取各种类型的输入 12。这些 UI 元素与 Marimo 的反应性系统深度集成，使得用户交互能够直接驱动数据分析和可视化更新 5。

### (a) UI 元素常用配置参数

大多数 `marimo.ui` 元素共享一些通用的配置参数，同时也有各自特定的参数：

- **`label`**: (`类型: str`) 为 UI 元素提供一个描述性标签，支持 Markdown 格式 15。
- **`value`**: (`类型: 取决于元素`) 设置 UI 元素的初始值或默认值。这也是后续在 Python 代码中读取用户输入的主要属性 15。
- **`on_change`**: (`类型: Callable`) 一个可选的回调函数，当元素的值发生改变时被调用。该函数通常接收新值作为参数 15。
- **`debounce`**: (`类型: bool 或 int`) 用于限制前端值更新发送到后端的频率。对于 `mo.ui.text` 或 `mo.ui.number`，可以设置为 `True`（仅在回车或失焦时更新）或一个毫秒数 45。
- **`kind`**: (`类型: Literal`) 用于指定某些元素的变体。例如，`mo.ui.text` 可以有 `'text'`, `'password'`, `'email'`, `'url'` 等类型 27；`mo.ui.file` 可以是 `'button'` 或 `'area'` 26；`mo.ui.button` 可以有 `'neutral'`, `'success'`, `'warn'`, `'danger'` 等样式 26。
- **`placeholder`**: (`类型: str`) 在 `mo.ui.text` 或 `mo.ui.text_area` 为空时显示的提示文本 27。
- **`step`**: (`类型: Numeric`) 用于 `mo.ui.slider` 和 `mo.ui.number`，定义数值的增量 4。
- **`options`**: (`类型: Sequence 或 dict`) 用于 `mo.ui.dropdown`, `mo.ui.radio`, `mo.ui.multiselect`，定义可选的选项。可以是值的列表，也可以是显示名称到实际值的映射字典 15。
- **`multiple`**: (`类型: bool`) 用于 `mo.ui.multiselect` 和 `mo.ui.file`，允许用户选择或上传多个项目 26。
- **`filetypes`**: (`类型: Sequence[str]`) 用于 `mo.ui.file`，限制允许上传的文件类型（如 `[".csv", ".json"]` 或 `"image/*"`）26。
- **`full_width`**: (`类型: bool`) 使元素宽度充满其容器 15。

**示例：**

- **滑块 (Slider)**: `s = mo.ui.slider(start=0, stop=10, step=0.5, value=5, label="选择一个值")` 5。通过 `s.value` 获取当前值 4。`from_series` 方法可以从 Pandas Series 创建滑块 4。
- **下拉菜单 (Dropdown)**: `d = mo.ui.dropdown(options={'选项 A': 'val_a', '选项 B': 'val_b'}, value='val_a', label="选择一项")`。通过 `d.value` 获取选中的值 15。`searchable=True` 可启用搜索 15。`from_series` 方法也可用于从 Series 创建 15。
- **文本输入 (Text)**: `t = mo.ui.text(placeholder="输入姓名...", label="姓名", debounce=True)` 31。通过 `t.value` 获取输入的文本 31。
- **数字输入 (Number)**: `n = mo.ui.number(start=0, stop=100, step=1, label="数量")` 34。通过 `n.value` 获取输入的数字 34。
- **复选框 (Checkbox) / 开关 (Switch)**: `c = mo.ui.checkbox(label="同意条款")` 29 或 `sw = mo.ui.switch(label="启用功能")` 30。通过 `.value` 获取布尔值 (`True`/`False`) 29。
- **单选按钮 (Radio)**: `r = mo.ui.radio(options=['A', 'B', 'C'], value='A', label="选择类别")` 35。通过 `.value` 获取选中的选项值 37。
- **日期选择器 (Date) / 日期时间选择器 (Datetime)**: `dt = mo.ui.date(value="2024-01-01", label="选择日期")` 48。通过 `.value` 获取日期字符串或 `datetime.date`/`datetime.datetime` 对象 48。
- **文件上传 (File)**: `f = mo.ui.file(filetypes=[".csv"], multiple=False, kind='area')` 26。`.value` 返回一个包含 `(name, contents)` 命名元组的列表 26。可以使用 `f.contents(index=0)` 和 `f.name(index=0)` 方便地获取第一个文件的内容和名称 26。最大文件大小限制为 100MB 26。

### (b) `on_change` 回调函数

`on_change` 参数允许指定一个 Python 函数，在 UI 元素的值发生变化时执行 15。这个回调函数通常接收元素的新值作为其参数 15。

**适用场景**:

- **执行副作用**: 当 UI 元素变化时，需要执行一些不直接修改下游单元格输出的操作，例如记录日志、调用外部 API、发送通知等。
- **复杂验证**: 实现一些无法通过 `mo.ui.form` 的 `validate` 参数简单表达的复杂输入验证逻辑。
- **状态同步**: 与 `mo.state` 结合使用，当一个 UI 元素变化时，通过调用 setter 函数来更新共享状态，从而间接影响其他 UI 元素或单元格 14。

**与核心反应性的区别与谨慎使用**:

核心反应性是通过将 UI 元素赋值给全局变量，并在下游单元格中读取其 `.value` 属性来驱动计算的 12。这是 Marimo 推荐的主要交互模式，因为它保持了声明式的数据流，使得依赖关系清晰可见 12。而 `on_change` 回调引入了一种命令式的、事件驱动的逻辑 46。过度使用 `on_change` 来触发下游计算可能会模糊数据流图，使得代码更难理解和维护。因此，建议谨慎使用 `on_change`，优先考虑通过核心反应性机制来响应 UI 变化 14。只有在确实需要执行副作用或无法通过标准反应性实现的复杂逻辑时，才应使用 `on_change` 46。

**示例**:

```python
import marimo as mo

get_state, set_state = mo.state(0)

def handle_slider_change(new_value):
    print(f"滑块值变为: {new_value}") # 副作用：打印日志
    set_state(new_value * 2) # 通过 mo.state 更新共享状态

slider = mo.ui.slider(0, 10, on_change=handle_slider_change)

# 下游单元格可以通过 get_state() 读取被 on_change 修改的状态
# processed_value = get_state()

mo.vstack([slider, mo.md(f"处理后的值: {get_state()}")])
```

### (c) 复合元素深入探讨

复合元素允许将多个 UI 元素组合成一个逻辑单元，这对于动态生成 UI 或构建复杂表单至关重要 13。

- **`mo.ui.array`**: 将一个 UI 元素列表包装成单个 UI 元素 13。其 `.value` 属性是一个列表，包含其内部所有元素的当前值 13。这对于根据其他控件的值动态生成一组 UI 控件非常有用 12。例如，根据一个数字输入 `n` 的值生成 `n` 个滑块 12。需要注意，数组内的元素是原始元素的克隆，修改数组内的元素不会影响原始元素 36。
  ```python
  import marimo as mo
  num_sliders = mo.ui.number(1, 5, value=2, label="滑块数量")
  sliders_array = mo.ui.array([mo.ui.slider(0, 10) for _ in range(num_sliders.value)])
  mo.vstack([num_sliders, sliders_array, mo.md(f"滑块值: {sliders_array.value}")])
  ```
- **`mo.ui.dictionary`**: 类似于 `mo.ui.array`，但使用字符串键来组织 UI 元素 13。其 `.value` 属性是一个字典，将键映射到对应元素的当前值 13。
  ```python
  import marimo as mo
  config_dict = mo.ui.dictionary({
      'learning_rate': mo.ui.slider(0.001, 0.1, step=0.001),
      'optimizer': mo.ui.dropdown(options=['Adam', 'SGD'])
  })
  mo.vstack([config_dict, mo.md(f"配置: {config_dict.value}")])
  ```
- **`mo.ui.batch`**: 允许将 UI 元素嵌入到其他 Marimo 对象（通常是 `mo.md`）的模板字符串中 13。通过 `{key}` 占位符引用 UI 元素，并在 `.batch()` 方法中将键映射到 UI 元素实例 13。其 `.value` 是一个字典，包含所有嵌入元素的键值对 13。`mo.ui.batch` 常用于创建具有自定义布局的表单 13。
  ```python
  import marimo as mo
  user_form_layout = mo.md(
      """
      **用户信息**
      姓名: {name}
      年龄: {age}
      """
  ).batch(
      name=mo.ui.text(),
      age=mo.ui.number(0, 120)
  )
  mo.vstack([user_form_layout, mo.md(f"输入值: {user_form_layout.value}")])
  ```
- **`mo.ui.form`**: 用于包装单个 UI 元素或一个 `mo.ui.batch` 对象，以实现延迟提交 12。被包装元素的值只有在用户点击表单的“提交”按钮后才会被发送到 Python 后端并更新表单的 `.value` 属性 12。这对于需要用户完成一组输入后再触发计算或包含验证逻辑的场景非常有用 12。

  - **验证**: `mo.ui.form` 接受一个 `validate` 参数，该参数是一个函数，接收表单的（潜在）新值，如果值无效则返回错误消息字符串，如果有效则返回 `None` 26。如果验证失败，表单将显示错误消息并且不会提交 55。
  - **提交/清空**: 可以通过 `submit_button_label` 自定义提交按钮文本 26，通过 `clear_on_submit=True` 在提交后自动清空表单内容 26，通过 `show_clear_button=True` 显示一个清空按钮 26。

  ```python
  import marimo as mo

  def validate_email(value):
      if value and '@' not in value.get('email', ''):
          return "请输入有效的电子邮件地址"
      return None

  registration_form = mo.md(
      """
      邮箱: {email}
      密码: {password}
      """
  ).batch(
      email=mo.ui.text(kind='email'),
      password=mo.ui.text(kind='password')
  ).form(
      validate=validate_email,
      clear_on_submit=True,
      show_clear_button=True
  )

  # 只有在表单提交后，registration_form.value 才会更新
  submitted_data = registration_form.value

  mo.vstack([
      registration_form,
      mo.md(f"上次提交的数据: {submitted_data}") if submitted_data else mo.md("尚未提交")
  ])
  ```

### (d) 交互式数据选择

Marimo 允许用户通过交互式表格和图表来选择数据子集，并将选择结果直接作为 DataFrame 返回给 Python 17。

- **`mo.ui.table`**: 除了显示数据，`mo.ui.table` 还支持行选择 21。通过设置 `selection='single'` 或 `selection='multi'` 参数，可以启用单行或多行选择模式 58。当用户在前端表格中选择行时，`table.value` 属性会自动更新为一个新的 DataFrame（类型与输入 DataFrame 一致，Pandas 或 Polars），其中仅包含用户选中的那些行 58。如果未选择任何行，`.value` 将是一个空的 DataFrame 56。

  ```python
  import marimo as mo
  import pandas as pd

  data = pd.DataFrame({'col1': [5, 1, 6, 24], 'col2': ['A', 'B', 'A', 'C']})
  interactive_table = mo.ui.table(data, selection='multi', page_size=5)

  # interactive_table.value 将包含用户选中的行
  selected_data = interactive_table.value

  mo.vstack([
      interactive_table,
      mo.md("**选中的数据:**"),
      selected_data # 直接显示选中的 DataFrame
  ])
  ```

- **`mo.ui.altair_chart` / `mo.ui.plotly`**: 这两个 UI 元素包装了流行的绘图库 Altair 和 Plotly，使其图表具有交互式选择功能 9。用户可以在图表上进行选择操作，例如用鼠标框选（brushing）散点图中的点，或点击图例项 12。Marimo 会自动捕获这些选择 12。与 `mo.ui.table` 类似，`chart.value` 属性会返回一个 Pandas DataFrame，其中包含与当前图表选择相对应的数据点 12。

  ```python
  import marimo as mo
  import altair as alt
  from vega_datasets import data

  cars = data.cars()
  base_chart = alt.Chart(cars).mark_point().encode(
      x='Horsepower',
      y='Miles_per_Gallon',
      color='Origin'
  )

  # 将 Altair 图表包装成可交互的 Marimo UI 元素
  interactive_chart = mo.ui.altair_chart(base_chart)

  # interactive_chart.value 将包含用户在图表中选中的数据点 (作为 Pandas DataFrame)
  selected_points = interactive_chart.value

  mo.vstack([
      interactive_chart,
      mo.md("**选中的点:**"),
      selected_points.head() # 显示选中数据的前几行
  ])
  ```

  可以通过 `chart_selection` 和 `legend_selection` 参数自定义或禁用自动添加的选择行为 12。例如，设置为 `False` 后，可以使用 Altair 原生的 `.add_params()` 方法添加自定义选择器 12。使用 Altair 转换（如过滤、聚合）时，需要安装 `vegafusion` 库 60。`mo.ui.altair_chart` 不支持地理形状图 (geoshapes) 65。

Marimo 将 UI 元素视为其反应系统中的一等公民 12。将 UI 元素分配给全局变量，使其 `.value` 属性成为 DAG 中的一个节点，用户交互会自动触发依赖于该元素的下游单元格的重新执行 12。这种无缝集成是 Marimo 构建交互式工具而无需显式回调（对于核心数据流而言）的关键 5。

复合元素（如 `mo.ui.array`, `mo.ui.dictionary`, `mo.ui.batch`, `mo.ui.form`）提供了必要的抽象层 13。它们允许对动态生成的元素进行分组（array/dictionary）、创建自定义布局（batch）或控制提交时机（form），同时向反应系统呈现一个单一、统一的接口（复合元素本身及其 `.value` 属性）13。这使得管理内部复杂性成为可能，同时从下游单元格的角度保持了反应模型的简单性。

交互式数据选择功能（`mo.ui.table`, `mo.ui.altair_chart`, `mo.ui.plotly`）的 `.value` 属性始终返回 DataFrame，极大地简化了数据探索工作流 58。用户可以直观地选择数据，并立即在 Python 中以标准的、可供分析的格式接收这些数据，而无需编写手动过滤代码。

**表 2.1: Marimo (`mo.ui`) 关键输入元素概览**

| 元素名称 (`mo.ui.*`) | 简要描述             | 关键参数                                        | `.value` 类型            | 常见用例                        |
| :------------------- | :------------------- | :---------------------------------------------- | :----------------------- | :------------------------------ |
| `slider`             | 数值滑块             | `start`, `stop`, `step`, `value`, `orientation` | `Numeric`                | 选择范围内的数值 4              |
| `dropdown`           | 下拉选择菜单         | `options`, `value`, `searchable`                | `Any` (选项值类型)       | 从列表中选择单个选项 15         |
| `multiselect`        | 多选下拉菜单         | `options`, `value`                              | `List[Any]`              | 从列表中选择多个选项 35         |
| `text`               | 单行文本输入         | `value`, `placeholder`, `kind`, `debounce`      | `str`                    | 输入短文本、密码、URL 等 31     |
| `text_area`          | 多行文本输入         | `value`, `placeholder`                          | `str`                    | 输入较长文本 12                 |
| `number`             | 数值输入框           | `start`, `stop`, `step`, `value`, `debounce`    | `Numeric`                | 精确输入数值 34                 |
| `checkbox`           | 复选框               | `value`, `label`                                | `bool`                   | 布尔开关 (是/否) 29             |
| `switch`             | 开关按钮             | `value`, `label`                                | `bool`                   | 布尔开关 (视觉样式不同) 30      |
| `radio`              | 单选按钮组           | `options`, `value`, `label`                     | `Any` (选项值类型)       | 从一组选项中选择一个 35         |
| `date`               | 日期选择器           | `value`, `start`, `stop`                        | `str` 或 `date`          | 选择单个日期 48                 |
| `datetime`           | 日期时间选择器       | `value`, `start`, `stop`                        | `str` 或 `datetime`      | 选择日期和时间 48               |
| `file`               | 文件上传             | `filetypes`, `multiple`, `kind`                 | `List[(name, contents)]` | 上传本地文件 26                 |
| `table`              | 可交互表格           | `data`, `selection` (`'single'`, `'multi'`)     | `DataFrame`              | 显示数据并选择行 21             |
| `altair_chart`       | 可交互 Altair 图表   | `chart`, `chart_selection`, `legend_selection`  | `DataFrame`              | 显示 Altair 图表并选择数据点 7  |
| `plotly`             | 可交互 Plotly 图表   | `figure`                                        | `DataFrame`              | 显示 Plotly 图表并选择数据点 7  |
| `array`              | UI 元素数组          | `elements`                                      | `List[Any]`              | 动态组合多个 UI 元素 13         |
| `dictionary`         | UI 元素字典          | `elements` (dict)                               | `Dict[str, Any]`         | 用键组织多个 UI 元素 13         |
| `batch`              | 模板化 UI 元素批处理 | `template.batch(**elements)`                    | `Dict[str, Any]`         | 在 Markdown 等中嵌入 UI 元素 13 |
| `form`               | 表单（延迟提交）     | `element`, `validate`, `clear_on_submit`        | (内部元素的值类型)       | 控制 UI 元素值的提交时机 13     |
| `button`             | 通用按钮             | `value`, `on_click`, `label`                    | `Any` (可配置)           | 触发回调、管理自身状态 13       |
| `run_button`         | 运行按钮             | `label`                                         | `bool`                   | 显式触发下游单元格执行 13       |

## 3. 向用户展示信息 (Displaying Output)

文档链接 文档链接

Marimo 不仅关注计算和交互，同样提供了丰富的工具来控制和美化信息的展示。单元格的最后一个表达式会被自动渲染为该单元格的输出 13。输出可以是任何 Python 对象。

### (a) `mo.md` 的高级用法

`mo.md()` 是 Marimo 中渲染 Markdown 的核心函数 13。除了基本的 Markdown 语法，它还支持多种高级功能：

- **嵌入 Python 值和 Marimo 元素**: 使用 Python 的 f-string 语法，可以将任何 Python 变量或 Marimo 对象（包括 UI 元素、图表等）直接嵌入到 Markdown 文本中进行渲染 13。
  ```python
  import marimo as mo
  name = mo.ui.text(value="Marimo")
  slider = mo.ui.slider(1, 10)
  mo.md(f"你好, **{name.value}**! 当前值是: {slider}")
  ```
- **嵌入图标 (`mo.icon`)**: 使用 `mo.icon()` 函数可以在 Markdown 或按钮标签中嵌入图标 20。通常使用 `lucide:` 前缀指定 Lucide 图标库中的图标名称 20。可以自定义图标的大小和颜色 20。
  ```python
  import marimo as mo
  mo.md(f"# {mo.icon('lucide:rocket')} 项目启动")
  button_with_icon = mo.ui.button(label=f"保存 {mo.icon('lucide:save', color='blue')}")
  ```
- **嵌入 Mermaid 图 (`mo.mermaid`)**: 可以直接渲染 Mermaid 语法的图表，用于创建流程图、序列图、甘特图等 20。
  ```python
  import marimo as mo
  diagram = """
  graph TD;
      A-->B;
      A-->C;
      B-->D;
      C-->D;
  """
  mo.mermaid(diagram)
  ```
- **Markdown 扩展**: Marimo 支持一些有用的 Markdown 扩展：
  - **Admonitions (告诫框)**: 使用 `/// admonition | 标题` 或 `/// attention | 标题` 语法创建醒目的提示框，用于强调重要信息 5。
    ```python
    import marimo as mo
    mo.md(
        """
        /// attention | 重要提示
        请务必备份您的数据。
        ///
        """
    )
    ```
    _(Markdown 渲染可能需要特定环境支持，这里用代码块示意)_
    ```markdown
    > /// attention | 重要提示
    > 请务必备份您的数据。
    > ///
    ```
  - **Details (可折叠区域)**: 使用 `/// details | 标题` 语法创建可以展开和折叠的内容区域 5。可以通过 `type:` 参数指定样式（如 `info`, `warn`, `danger`）5。
    ````python
    import marimo as mo
    mo.md(
        """
        /// details | 查看代码示例
        type: info
        ```python
        print("Hello, Marimo!")
        ```
        ///
        """
    )
    ````
    _(Markdown 渲染可能需要特定环境支持，这里用代码块示意)_
    ````markdown
    > /// details | 查看代码示例
    > type: info
    >
    > ```python
    > print("Hello, Marimo!")
    > ```
    >
    > ///
    ````

### (b) `mo.ui.table` 显示配置

除了用于交互式选择（见第 2 节），`mo.ui.table` 也提供了控制其显示的参数，特别适用于处理大型数据集：

- **`page_size`**: (`类型: int`) 设置每页显示的行数 56。
- **`pagination`**: (`类型: bool`) 是否启用分页功能。默认为 `True`，当数据行数超过 `page_size` 时显示分页控件 51。

### (c) 布局元素: `mo.hstack` 和 `mo.vstack` 深入讲解

`mo.hstack` 和 `mo.vstack` 是 Marimo 中用于构建灵活布局的基础组件，分别用于水平（行）和垂直（列）排列元素 13。它们通过组合和嵌套，可以创建复杂的网格布局，而无需直接编写 CSS 23。

- **核心参数**:

  - **`items`**: 一个包含要排列的 Marimo 对象的序列（列表或元组）23。
  - **`justify`**: 控制元素在主轴上的分布（`hstack` 的主轴是水平方向，`vstack` 的主轴是垂直方向）。可选值包括 `'start'`, `'center'`, `'end'`, `'space-between'`, `'space-around'` 23。`hstack` 默认为 `'space-between'`，`vstack` 默认为 `'start'` 23。
  - **`align`**: 控制元素在交叉轴上的对齐方式（`hstack` 的交叉轴是垂直方向，`vstack` 的交叉轴是水平方向）。可选值包括 `'start'`, `'end'`, `'center'`, `'stretch'` 23。默认为 `None`（通常表现为 `start`） 23。
  - **`gap`**: (`类型: float`) 控制元素之间的间距，单位是 `rem` (默认为 0.5) 23。
  - **`wrap`**: (`类型: bool`, 仅 `hstack`) 控制当水平空间不足时，元素是否换行。默认为 `False` 23。
  - **`widths` / `heights`**: (`类型: Optional[Literal['equal'] | Sequence[float]]`) 分别用于 `hstack` 和 `vstack`，控制元素的相对尺寸。可以设置为 `'equal'` 使所有元素等宽/等高，或提供一个与 `items` 长度相同的权重列表（如 `[1, 2]` 表示第二个元素是第一个的两倍宽/高）。默认为 `None`，元素尺寸由内容决定 23。

- **复杂嵌套布局示例 (多列响应式仪表板)**:

  ```python
  import marimo as mo
  import altair as alt
  import pandas as pd

  # 假设有 chart1, chart2, chart3, slider, table 等 Marimo 对象
  # (此处省略对象的创建代码)
  chart1 = mo.md("Chart 1 Placeholder")
  chart2 = mo.md("Chart 2 Placeholder")
  chart3 = mo.md("Chart 3 Placeholder")
  slider = mo.ui.slider(label="Example Slider")
  table = mo.ui.table(pd.DataFrame({'A': [1, 2], 'B': [3, 4]}))

  # 左侧边栏 (固定宽度)
  sidebar = mo.vstack([
      mo.md("## 控制面板"),
      slider,
      #... 其他控件
  ], gap=1)

  # 主内容区分成两列
  main_content = mo.hstack([
      # 左列 (占 2 份宽度)
      mo.vstack([
          chart1,
          table
      ], gap=1),
      # 右列 (占 1 份宽度)
      mo.vstack([
          chart2,
          chart3
      ], gap=1)
  ], widths=[2, 1], gap=1.5) # 指定列宽比例和列间距

  # 整体布局：侧边栏 + 主内容区
  dashboard = mo.hstack([
      sidebar,
      main_content
  ], widths=[1, 4], gap=2, align='start') # 侧边栏占 1/5，主内容区占 4/5

  dashboard
  ```

  这个例子展示了如何通过嵌套 `vstack` 和 `hstack`，并结合 `widths` 参数，来创建具有不同列宽和内部垂直布局的复杂仪表板结构 23。Marimo 的布局系统鼓励通过这种组合方式来构建界面，而不是直接操作 CSS 23。

### (d) 其他布局元素

Marimo 还提供了其他多种布局和容器元素 77：

- **`mo.accordion`**: 创建一个或多个可折叠的部分，每个部分有一个标题和一个内容区域 13。
- **`mo.callout`**: 创建一个带有边框和可选图标的突出显示区域，用于引起对特定内容的注意 12。
- **`mo.sidebar`**: 将内容放置在一个可折叠的侧边栏中，通常用于放置导航或控制元素 13。
- **`mo.stat`**: 以标准格式显示一个关键统计数据，包含主数值、标签、说明文字，并可选地指示变化方向（增加/减少）和边框 20。
  ```python
  import marimo as mo
  mo.stat(value="1.2M", label="活跃用户", caption="较上月增长 15%", direction="increase", bordered=True)
  ```
- **`mo.tree`**: 以树状结构展示分层数据 77。
- **`mo.json`**: 格式化并可交互地显示 JSON 数据 77。
- **`mo.image`, `mo.audio`, `mo.video`**: 用于直接在笔记本中显示图像、音频和视频文件 21。

### (e) 状态指示器: `mo.status.progress_bar` 和 `mo.status.spinner`

这些元素用于在耗时操作期间向用户提供视觉反馈 69。

- **`mo.status.progress_bar`**:

  - **迭代模式**: 最常见的用法是直接迭代一个集合，它会自动显示进度条，类似于 `tqdm` 20。
    ```python
    import time
    import marimo as mo
    for i in mo.status.progress_bar(range(10), title="处理中...", show_eta=True):
        time.sleep(0.5)
    ```
  - **上下文管理器模式**: 用于无法直接迭代的情况，需要手动更新进度 83。
    ```python
    import time
    import marimo as mo
    total_steps = 5
    with mo.status.progress_bar(total=total_steps, subtitle="请稍候") as bar:
        for step in range(total_steps):
            # 执行操作...
            time.sleep(1)
            bar.update(subtitle=f"完成第 {step+1} 步") # 可选地更新标题/副标题
    ```
  - **配置**: 可配置 `title`, `subtitle`, 完成时的 `completion_title`, `completion_subtitle`，是否显示速率 (`show_rate`) 和预计剩余时间 (`show_eta`)，以及完成后是否移除 (`remove_on_exit`) 83。注意，为了性能，UI 更新频率限制在约 150ms 一次 65。

- **`mo.status.spinner`**:
  - **上下文管理器模式**: 在 `with` 块执行期间显示一个旋转图标 20。可以在块内使用 `spinner.update()` 更新 `title` 或 `subtitle` 8。
    ```python
    import time
    import marimo as mo
    with mo.status.spinner(title="加载数据...", remove_on_exit=False) as spinner:
        time.sleep(3)
        spinner.update(subtitle="数据加载完成，处理中...")
        time.sleep(2)
    mo.md("处理完毕!")
    ```
  - **条件显示模式**: 可以像普通 Marimo 对象一样根据条件来显示微调器 83。
    ```python
    import marimo as mo
    loading = mo.ui.checkbox(label="加载中")
    mo.vstack([loading, mo.status.spinner(title="处理中...") if loading.value else mo.md("已完成")])
    ```
  - **配置**: 可配置 `title`, `subtitle`, 以及完成后是否移除 (`remove_on_exit`) 83。

### (f) 控制台输出重定向与捕获

默认情况下，`print()` 语句和标准错误输出会显示在单元格下方的独立控制台区域，而不会成为单元格的主要输出 28。Marimo 提供了工具来管理这些流：

- **`mo.redirect_stdout` / `mo.redirect_stderr`**: 这两个上下文管理器可以将相应的标准输出流重定向到单元格的主要输出区域 20。
  ```python
  import sys
  import marimo as mo
  with mo.redirect_stdout():
      print("这条消息将出现在单元格输出中。")
  with mo.redirect_stderr():
      print("这条错误消息也将出现在单元格输出中。", file=sys.stderr)
  ```
- **`mo.capture_stdout` / `mo.capture_stderr`**: 这两个上下文管理器可以将相应的标准输出捕获到一个字符串变量中，而不在任何地方显示它们 20。这对于处理那些将有用信息打印到控制台而不是返回值的库函数很有用 20。
  ```python
  import marimo as mo
  with mo.capture_stdout() as captured:
      print("这段文本被捕获了。")
  captured_output = captured.value
  mo.md(f"捕获到的输出是: `{captured_output}`")
  ```

这种对输出流的明确区分和控制，使得开发者能够清晰地分离最终呈现给用户的结果（单元格主输出）和用于调试或记录过程信息的辅助输出（控制台输出），并能在需要时灵活地重定向或捕获这些信息。

### (g) `mo.output.replace`/`append`/`clear` 的实际用例

这些函数允许在单元格执行期间，以命令式的方式动态地修改当前单元格的输出区域 20。

- **`mo.output.replace(new_output)`**: 用 `new_output` 替换当前单元格的全部输出 20。
- **`mo.output.append(additional_output)`**: 将 `additional_output` 追加到当前单元格输出的末尾 20。
- **`mo.output.clear()`**: 清空当前单元格的输出 20。

**用例**:

- **在循环中逐步更新输出**: 例如，在长时间运行的循环中显示中间结果或状态更新。
  ```python
  import time
  import marimo as mo
  mo.output.replace(mo.md("开始处理..."))
  for i in range(5):
      time.sleep(1)
      mo.output.append(mo.md(f"完成第 {i+1} 步。"))
  mo.output.replace(mo.md("**所有处理已完成！**"))
  ```
- **创建简单动画**: 通过在循环中快速连续地 `replace` 输出（例如，更新一个图表对象）可以创建动画效果。
- **条件性清空**: 在显示新结果之前使用 `mo.output.clear()` 清除旧的输出。

这些动态输出修改功能提供了一种在单个单元格执行的生命周期内与用户交互的方式，补充了 Marimo 基于 DAG 的反应性模型。这对于展示那些不适合分解到多个依赖单元格的、具有内部状态或迭代过程的计算结果特别有用。

Marimo 的布局系统（`hstack`, `vstack` 等）体现了通过组合简单元素来构建复杂 UI 的思想 77。通过嵌套堆栈，用户可以在 Python 中以编程方式创建类似网格的结构，而无需直接操作 CSS，从而降低了布局的门槛 54。

## 4. 控制执行流程 (Execution Flow)

文档链接 文档链接

虽然 Marimo 的核心是自动化的反应性执行，但它也提供了多种工具来让用户更精细地管理和覆盖默认行为。这对于处理计算成本高昂的单元格、实现特定的交互逻辑或优化性能至关重要。

### (a) 管理和覆盖反应性行为

本节重点介绍 Marimo 中用于控制单元格何时以及如何执行的机制，这些机制是对基础反应性模型的补充或调整。

### (b) `mo.ui.button` 与 `mo.ui.run_button` 的对比

Marimo 提供了两种主要的按钮类型，它们的设计意图和对执行流的影响有显著区别：

- **`mo.ui.button`**:
  - **设计意图**: 一个通用的交互式按钮，主要用于管理自身状态或触发副作用 26。
  - **`.value` 行为**: 其 `.value` 属性的行为是可配置的。默认情况下，点击按钮不会改变其值（通常是 `None`）26。但是，可以通过 `on_click` 回调函数来更新 `.value` 13。例如，可以将其配置为一个计数器（每次点击 `value` 加 1）或一个布尔切换器 46。
  - **对反应性的影响**: 点击 `mo.ui.button` 本身**不会**直接触发下游单元格的执行。只有当它的 `.value` 发生变化（通常是通过 `on_click` 回调），并且有下游单元格引用了这个按钮的 `.value` 时，这些下游单元格才会作为标准反应性的一部分被执行 46。
  - **用例**: 实现状态切换（如“播放/暂停”按钮）、计数器、触发不需要重新计算依赖图的任意 Python 逻辑（通过 `on_click` 执行数据库写入、API 调用等副作用）13。
- **`mo.ui.run_button`**:
  - **设计意图**: 专门设计用于**显式触发下游单元格计算**的按钮 26。
  - **`.value` 行为**: 当用户点击 `mo.ui.run_button` 时，其 `.value` 属性会暂时变为 `True` 69。
  - **对反应性的影响**: 这个 `True` 值会**立即触发**所有引用了该按钮变量的下游单元格执行 69。在自动执行模式下，当所有这些下游单元格执行完毕后，Marimo 会自动将按钮的 `.value` 重置回 `False` 69。
  - **用例**: 控制计算密集型单元格的执行，使其仅在用户明确点击按钮时运行；实现“提交”或“运行分析”之类的操作，通常与 `mo.stop` 结合使用 75。

**清晰的用例区分**:

- 如果你需要一个按钮来改变某个状态（比如切换主题、增加计数），并且这个状态变化会通过标准的反应性影响其他单元格，或者你需要按钮点击时执行一些与数据流无关的操作，使用 `mo.ui.button` 并配合 `on_change` 或 `mo.state`。
- 如果你需要一个按钮来明确地“启动”或“允许”一段计算（特别是耗时的计算），并且希望这个启动动作本身触发下游单元格，使用 `mo.ui.run_button` 26。

**表 4.1: `mo.ui.button` vs. `mo.ui.run_button` 对比**

| 特性                  | `mo.ui.button`                                    | `mo.ui.run_button`                               |
| :-------------------- | :------------------------------------------------ | :----------------------------------------------- |
| **主要目的**          | 管理自身状态，触发 `on_click` 回调 (副作用) 26    | 显式触发下游单元格计算 26                        |
| **`.value` 行为**     | 可配置 (默认为 `None`，可通过 `on_click` 修改) 26 | 点击时变为 `True` 69                             |
| **`.value` 自动重置** | 否                                                | 是 (在下游单元格执行完毕后自动重置为 `False`) 69 |
| **触发下游执行**      | 间接 (当下游引用其变化的 `.value` 时) 46          | 直接 (点击按钮本身即触发依赖于它的下游单元格) 69 |
| **典型用例**          | 状态切换、计数器、执行独立副作用 13               | 控制耗时计算、提交操作、与 `mo.stop` 结合使用 75 |

### (c) 惰性执行模式 (Lazy Execution)

对于包含许多计算成本高昂或具有副作用的单元格的笔记本，Marimo 默认的自动反应性执行可能不是最优选择 1。在这种情况下，用户可以将 Marimo 的运行时配置为**惰性执行模式 (Lazy Execution)** 1。

- **配置**: 通常可以通过笔记本的设置菜单或配置文件将执行模式从 `"automatic"` 切换到 `"lazy"`。
- **行为**: 在惰性模式下，当一个单元格被修改或其上游依赖发生变化时，Marimo **不会**自动运行其下游依赖单元格。相反，它会将这些受影响的下游单元格标记为“**过时**” (stale) 1。过时的单元格通常会在编辑器中以某种视觉方式（例如，灰色背景或特殊图标）标示出来。
- **手动执行**: 用户需要手动触发过时单元格的执行。这通常可以通过点击单元格旁边的运行按钮或使用快捷键来完成。运行一个过时的单元格会使其及其所有下游过时单元格执行。
- **优点**: 惰性执行模式在保证程序状态一致性的同时，避免了因意外修改而触发长时间运行的计算，给予用户对何时执行昂贵计算的完全控制权 1。

### (d) `mo.state` 深入探讨：高级状态管理

`mo.state` 提供了一种创建可变反应性状态的机制，用于处理标准反应性模型或 UI 元素内置状态无法满足的复杂场景 14。

- **机制**: `get_state, set_state = mo.state(initial_value)` 返回一对函数：`get_state` 用于读取状态的当前值，`set_state` 用于更新状态的值 14。
- **反应性规则**: 当在一个单元格中调用 `set_state(new_value)` 或 `set_state(lambda current_value:...)` 时，所有通过全局变量引用了 `get_state` 的其他单元格将被自动执行 14。这与 UI 元素的反应性规则非常相似 14。
- **警告**: `mo.state` 被视为高级功能，应谨慎使用 14。它可能引入循环依赖（虽然 Marimo 会尝试检测，但 `mo.state` 可以绕过静态检测）和难以调试的执行路径，因为它引入了命令式的状态更新逻辑 11。**切勿在 `mo.state` 中存储 Marimo UI 元素**，这可能导致难以诊断的错误 11。
- **适用场景与示例**:
  - **维护历史状态**: 记录 UI 元素的所有历史值，而不仅仅是当前值。例如，追踪用户在文本框中输入过的所有内容 46。
    ```python
    import marimo as mo
    history, set_history = mo.state([]) # 初始化为空列表
    text_input = mo.ui.text(on_change=lambda v: set_history(lambda h: h + [v]))
    mo.vstack([text_input, mo.md(f"输入历史: {history()}")])
    ```
  - **同步多个 UI 元素**: 使两个或多个 UI 元素的值保持同步，修改其中任何一个都会更新其他的 11。
    ```python
    import marimo as mo
    # 共享状态
    get_shared_value, set_shared_value = mo.state(50)
    # 滑块，其值来自共享状态，变化时更新共享状态
    slider = mo.ui.slider(0, 100, value=get_shared_value(), on_change=set_shared_value)
    # 数字输入框，同样连接到共享状态
    number = mo.ui.number(0, 100, value=get_shared_value(), on_change=set_shared_value)
    # 显示两个同步的 UI 元素
    mo.hstack([slider, number])
    ```
    在这个例子中 19，`slider` 和 `number` 的 `value` 都通过 `get_shared_value()` 初始化。当用户与 `slider` 交互时，其 `on_change` 回调调用 `set_shared_value`，这会触发读取 `get_shared_value` 的单元格（即包含 `number` 的单元格）重新渲染，反之亦然，从而实现了双向绑定。
  - **实现循环依赖**: 在需要跨单元格创建逻辑循环的情况下（例如，A 依赖 B，B 又依赖 A 的某种状态），`mo.state` 可以作为桥梁 11。但这通常是复杂性的标志，应尽可能避免。
- **`allow_self_loops` 参数**: 默认情况下 (`allow_self_loops=False`)，调用 `set_state` 的单元格即使引用了 `get_state` 也不会被重新运行，以防止意外的无限循环 14。如果确实需要允许调用者单元格被其自身的 `set_state` 调用所触发（例如，在某些复杂的 UI 更新逻辑中），可以将 `allow_self_loops` 设置为 `True` 14。

`mo.state` 和 `on_change` 回调（见第 2 节）是 Marimo 中用于在必要时“跳出”严格的 DAG 反应性模型的受控机制。`mo.state` 允许引入可变状态和潜在的循环，而 `on_change` 则允许执行独立于主数据流的副作用。它们被标记为“高级”并附带警告，正因为它们偏离了核心模型，应在充分理解其含义后审慎使用 14。

### (e) 缓存装饰器: `@mo.cache` 和 `@mo.persistent_cache`

为了优化性能，特别是对于那些接受相同输入时会重复执行的昂贵函数调用，Marimo 提供了缓存装饰器 85：

- **`@mo.cache`**:
  - **功能**: 将函数的返回值缓存在**内存**中 68。当使用相同的参数再次调用该函数时，将直接返回缓存的结果，跳过实际的函数执行 68。
  - **作用域**: 缓存仅在当前的 Marimo 内核会话中有效。重启内核或笔记本将清除缓存。
  - **失效条件**: 当函数的源代码或传递给它的参数发生变化时，缓存将失效，函数会重新执行。
  - **用例**: 加速在单个笔记本会话中可能被多次调用的、无副作用的纯计算函数 68。
- **`@mo.persistent_cache`**:
  - **功能**: 将函数的返回值缓存到**磁盘**上 68。
  - **作用域**: 缓存**跨会话持续存在** 68。即使重启内核或笔记本，只要函数的代码和参数未变，下次调用时仍会从磁盘加载缓存结果 68。
  - **失效条件**: 与 `@mo.cache` 相同（代码或参数变化）。
  - **用例**: 缓存非常耗时的计算结果（如模型训练、大型数据加载和预处理），避免在每次打开笔记本时都重新计算 85。

**示例**:

```python
import marimo as mo
import time

@mo.cache
def expensive_computation(x):
    print(f"正在为 {x} 执行昂贵计算...")
    time.sleep(2)
    return x * x

# 第一次调用会执行并缓存
result1 = expensive_computation(5)
# 第二次调用将直接返回缓存结果，不会打印信息也不会延迟
result2 = expensive_computation(5)

@mo.persistent_cache
def load_large_data(filepath):
    print(f"正在从 {filepath} 加载大型数据...")
    time.sleep(5)
    # 假设这里有实际的数据加载逻辑
    return {"data": "...", "size": 1000000}

# 第一次调用会执行并缓存到磁盘
data1 = load_large_data("my_data.csv")
# 如果重启笔记本后再次运行此单元格，将从磁盘加载，速度很快
data2 = load_large_data("my_data.csv")
```

### (f) 条件性停止执行: `mo.stop`

`mo.stop()` 函数提供了一种在运行时基于特定条件**停止**当前单元格及其所有下游依赖单元格执行的机制 20。

- **用法**: `mo.stop(condition, output=None)`
  - **`condition`**: 一个布尔表达式。如果 `condition` 求值为 `True`，则执行停止 20。
  - **`output`**: (可选) 一个 Marimo 可渲染对象（如 `mo.md("消息")`, `mo.ui.button(...)` 等）。如果提供了 `output`，则在执行停止时，该对象将作为当前单元格的输出显示 20。
- **行为**: 当 `mo.stop(True)` 被调用时，当前单元格中 `mo.stop()` 之后的代码不会执行，并且所有依赖于该单元格的下游单元格也不会被执行（或标记为过时，取决于执行模式）68。
- **用例**:

  - **等待用户输入**: 在处理依赖于表单或 UI 元素输入的单元格时，可以使用 `mo.stop` 来阻止执行，直到用户提供了有效的输入或点击了运行按钮 20。

    ```python
    import marimo as mo
    run_btn = mo.ui.run_button()
    slider = mo.ui.slider(1, 10)
    mo.hstack([slider, run_btn])

    # 只有当运行按钮被点击 (run_btn.value is True) 时才继续执行
    mo.stop(not run_btn.value, mo.md("**点击按钮以计算平方值**"))

    # 下面的代码只有在按钮点击后才会执行
    squared_value = slider.value * slider.value
    mo.md(f"平方值是: {squared_value}")
    ```

    这个例子 展示了 `mo.stop` 与 `mo.ui.run_button` 的典型组合 75。

  - **输入验证**: 在单元格早期进行输入检查，如果条件不满足则停止后续处理。
  - **控制流程**: 根据程序状态决定是否继续执行某个计算分支。

- **异常处理**: `mo.stop` 实际上是通过抛出一个特殊的 `MarimoStopError` 异常来工作的 20。在极少数需要更精细控制的情况下，可以使用 `try...except MarimoStopError` 来捕获这个异常并执行替代逻辑 20。

Marimo 提供了一个分层的执行控制机制。惰性模式是全局开关，`mo.stop` 提供条件性的分支停止，`mo.ui.run_button` 提供用户驱动的分支触发，而缓存则在函数级别进行优化。这种多层次的方法允许用户根据具体需求（从管理复杂性到优化性能）灵活地调整笔记本的执行行为。

## 5. 使用 SQL 查询数据 (SQL Queries)

文档链接

Marimo 内建了对 SQL 的强大支持，允许用户在笔记本中无缝地混合使用 Python 和 SQL 1。用户可以使用 SQL 查询 Python DataFrame（如 Pandas 或 Polars）、CSV 文件、各种关系型数据库（如 SQLite, PostgreSQL, MySQL, Snowflake, BigQuery）甚至 Google Sheets，并将查询结果直接作为 Python DataFrame 返回，用于后续的分析和可视化 1。

要使用 SQL 单元格，通常需要先安装额外的依赖，特别是 `duckdb` 10。推荐使用 `pip install "marimo[sql]"` 或 `conda install -c conda-forge marimo duckdb polars` 来安装 10。

### (a) 连接不同数据库的方法

Marimo 提供了两种主要方式来建立与数据库的连接：

- **通过 UI 添加连接**:
  - 在 Marimo 编辑器的侧边栏（通常是左侧）有一个“**数据源 (Data Sources)**”面板，其中包含一个“**添加数据库连接 (Add Database Connection)**”按钮 87。
  - 点击该按钮会弹出一个界面，引导用户选择数据库类型（目前支持 PostgreSQL, MySQL, SQLite, DuckDB, Snowflake, BigQuery）并输入连接所需的详细信息（主机、端口、用户名、密码、数据库名等） 87。
  - 连接信息可以安全地输入，并且支持使用从 `.env` 文件加载的环境变量来填充字段 87。
  - 成功添加后，这个连接将在数据源面板中可用，并且可以在 SQL 单元格中选择使用 87。
- **在 Python 代码中创建引擎**:

  - 用户可以在 Python 单元格中 使用标准的数据库连接库（如 SQLAlchemy, SQLModel, DuckDB 的 Python API, ClickHouse Connect, 或特定数据库的驱动程序）来创建数据库连接对象或引擎 87。
  - 将创建的连接对象**赋值给一个全局变量** 87。
  - **示例**:

    ```python
    import marimo as mo
    import sqlalchemy
    import duckdb
    # import clickhouse_connect # 如果使用 ClickHouse

    # SQLAlchemy 连接 SQLite (内存数据库)
    sqlite_engine = sqlalchemy.create_engine("sqlite:///:memory:")

    # DuckDB 连接到文件
    duckdb_conn = duckdb.connect("my_database.db")

    # ClickHouse 连接 (示例)
    # ch_client = clickhouse_connect.get_client(host='your_host', user='user', password='pwd')
    ```

  - 通过代码创建的连接引擎也可以在 SQL 单元格的设置中被选择使用 87。

### (b) 在 SQL 单元格设置中选择连接

- **创建 SQL 单元格**: 可以通过右键点击单元格之间的“+”号选择“SQL cell”，或将一个空单元格通过上下文菜单转换为 SQL 类型，或点击笔记本底部的 SQL 按钮来创建 87。
- **选择引擎**: 每个 SQL 单元格都有其设置选项（通常在单元格右上角）。在设置中，可以找到一个下拉菜单，允许用户选择要用于执行该单元格 SQL 查询的数据库连接引擎 87。
- **可用引擎**: 这个下拉菜单会列出所有通过 UI 添加的连接以及所有在 Python 代码中定义为全局变量的有效连接引擎/对象 87。
- **默认引擎**: 如果不进行选择，Marimo 默认使用一个内存中的 DuckDB 连接 87。用户也可以在 Marimo 的全局或项目配置中设置默认的 SQL 引擎。

### (c) SQL 查询结果的不同输出类型配置

SQL 单元格执行后，其结果会被赋值给一个输出变量（默认为 `output_df`，但可以修改为其他非私有名称）87。这个输出变量的类型可以通过 Marimo 的设置（用户配置、项目配置或应用设置）进行配置。可用的输出类型包括 87：

- **`native`**: 返回 DuckDB 的原生惰性关系 (lazy relation)。这是**推荐的选项**，尤其是在处理大型数据集时，因为它允许后续操作继续利用 DuckDB 的惰性求值和优化，性能最佳 87。
- **`lazy-polars`**: 返回一个惰性 Polars DataFrame。适用于希望在 Polars 中进行后续惰性操作的场景 87。
- **`pandas`**: 返回一个即时求值 (eager) 的 Pandas DataFrame。适用于需要立即在 Pandas 中操作结果的场景 87。
- **`polars`**: 返回一个即时求值 (eager) 的 Polars DataFrame。适用于需要立即在 Polars 中操作结果的场景 87。
- **`auto`**: Marimo 会根据已安装的库自动选择。它会优先尝试返回 `polars` DataFrame，如果 Polars 未安装，则返回 `pandas` DataFrame。这是当前的默认设置 87。

**选择建议**: 为了获得最佳性能，特别是在处理大数据时，建议显式地将输出类型配置为 `native`。如果需要在 Python 代码中直接操作查询结果，并且倾向于使用 Polars，则配置为 `polars` 是一个好选择 87。

### (d) 更复杂的参数化查询示例

SQL 单元格的核心优势之一是它们能够与 Marimo 的反应性系统集成，允许在 SQL 查询中动态地嵌入 Python 变量的值，特别是来自 UI 控件的值 1。这是通过在 SQL 代码中使用 f-string 风格的插值 `{python_variable_name}` 来实现的 1。

**示例**: 假设我们有一个包含销售数据的表 `sales`，我们想根据用户选择的产品类别 (来自下拉菜单 `category_dropdown`) 和最低销售额 (来自滑块 `min_sales_slider`) 来查询数据。

```python
# Python Cell 1: 定义 UI 控件
import marimo as mo
categories = ['Electronics', 'Clothing', 'Groceries']
category_dropdown = mo.ui.dropdown(options=categories, value='Electronics', label="产品类别")
min_sales_slider = mo.ui.slider(0, 1000, value=100, label="最低销售额")
mo.vstack([category_dropdown, min_sales_slider])
```

```sql
-- SQL Cell 1: 参数化查询
-- 将查询结果赋值给变量 filtered_sales，以便后续 Python 单元格使用
filtered_sales = SELECT *
                 FROM sales -- 假设 sales 表已通过连接可用或存在于默认 DuckDB 中
                 WHERE category = '{category_dropdown.value}' -- 嵌入下拉菜单的值
                   AND amount > {min_sales_slider.value}; -- 嵌入滑块的值
```

在这个例子中，当用户更改下拉菜单选项或移动滑块时，`category_dropdown.value` 或 `min_sales_slider.value` 会更新。由于 SQL 单元格引用了这些变量，Marimo 的反应性系统会自动重新执行 SQL 查询，使用新的参数值，并更新 `filtered_sales` 变量 9。

**处理列表/元组参数 (用于 IN 子句)**: 如果 Python 变量是一个列表或元组，可以直接在 SQL 的 `IN` 操作符中使用。Marimo (通过 DuckDB) 通常能正确处理这种情况。

```python
# Python Cell 2: 定义 ID 列表
selected_ids = [101, 105, 210]
```

```sql
-- SQL Cell 2: 使用列表进行 IN 查询
results_for_ids = SELECT *
                  FROM products -- 假设 products 表存在
                  WHERE product_id IN ({selected_ids}); -- 直接嵌入列表
```

### (e) 在 Python 单元格中处理 SQL 查询返回的 DataFrame

SQL 单元格的查询结果（存储在其输出变量中，如上例中的 `filtered_sales` 或 `results_for_ids`）可以在任何下游的 Python 单元格中像普通的 Pandas 或 Polars DataFrame 一样被访问和处理 1。

```python
# Python Cell 3: 处理 SQL 查询结果
# 假设 SQL Cell 1 的输出变量是 filtered_sales

# 检查返回的 DataFrame 类型
# (根据 Marimo 配置，filtered_sales 可能是 Pandas, Polars, 或 DuckDB relation)
# 如果是 native DuckDB relation，可以调用 .pl() 或 .df() 转换为 Polars/Pandas
# if hasattr(filtered_sales, 'pl'):
#     filtered_sales_pl = filtered_sales.pl() # 转为 Polars
#     print(f"DataFrame 类型: {type(filtered_sales_pl)}")
# elif hasattr(filtered_sales, 'df'):
#     filtered_sales_pd = filtered_sales.df() # 转为 Pandas
#     print(f"DataFrame 类型: {type(filtered_sales_pd)}")
# else:
#     print(f"DataFrame 类型: {type(filtered_sales)}") # 已经是 Pandas 或 Polars

# 假设已转换为 Pandas DataFrame filtered_sales_pd
import pandas as pd
# (此处假设 filtered_sales 已经是 Pandas DataFrame 或已转换)
# filtered_sales_pd = ... # 确保是 Pandas DataFrame

# if isinstance(filtered_sales_pd, pd.DataFrame) and not filtered_sales_pd.empty:
#     # 如果需要，进行类型转换 (例如，确保日期列是 datetime 类型)
#     # if 'sale_date' in filtered_sales_pd.columns:
#     #     filtered_sales_pd['sale_date'] = pd.to_datetime(filtered_sales_pd['sale_date'])

#     # 进行后续分析或可视化
#     average_amount = filtered_sales_pd['amount'].mean()
#     mo.md(f"所选类别 '{category_dropdown.value}' 中销售额大于 {min_sales_slider.value} 的平均销售额为: {average_amount:.2f}")

#     # 使用结果 DataFrame 创建图表
#     import altair as alt
#     chart = alt.Chart(filtered_sales_pd).mark_bar().encode(
#         x='product_name',
#         y='amount'
#     )
#     chart
# else:
#     mo.md("没有符合条件的数据。")
```

_(注意：上述 Python 代码块需要根据实际的 `filtered_sales` 类型进行调整和错误处理)_

### (f) 数据源面板 (Data Sources panel)

Marimo 编辑器中的数据源面板是一个非常有用的辅助工具 10。当成功连接到数据库后（无论是通过 UI 还是代码），该面板会自动发现并显示数据库的结构信息 87。

- **浏览模式**: 用户可以在面板中层级式地浏览数据库、模式 (schemas)、表 (tables) 和列 (columns) 87。
- **预览数据**: 可以快速预览表中的部分数据，了解其内容 87。
- **自动生成代码片段**: 面板通常提供功能，允许用户点击表名或列名来自动生成相应的 SQL 查询代码片段（例如 `SELECT * FROM table_name LIMIT 10` 或 `SELECT column_name FROM table_name`），并可以方便地插入到当前的 SQL 单元格中 87。

这个面板极大地简化了数据库探索和查询编写的过程，用户无需离开 Marimo 环境即可方便地查找和引用数据库对象 87。

Marimo 将 SQL 单元格视为反应式 DAG 中的节点，这一点至关重要。通过允许在 SQL 查询中插入 Python 变量 `{python_var}`，这些 Python 变量的变化会自动触发 SQL 查询的重新执行 87。这种设计无缝地将数据库交互集成到了反应式流程中。

选择 DuckDB 作为 SQL 单元格的默认引擎是一个重要的设计决策 87。DuckDB 不仅能查询传统数据库和文件，还能直接使用 SQL 查询内存中的 Pandas/Polars DataFrame 87。这使得 SQL 单元格功能开箱即用，用户无需设置外部数据库就能对现有的 Python DataFrame 使用 SQL 进行分析，极大地降低了在笔记本中使用 SQL 的门槛。

## 6. 分享与发布 (Sharing & Publishing)

文档链接 文档链接

Marimo 的设计理念之一就是让笔记本易于分享和部署。由于 Marimo 笔记本本质上是 `.py` 文件，并且具有内置的反应性和 UI 功能，它们可以被用作多种用途：交互式开发环境、可执行脚本，以及可部署的 Web 应用。Marimo 提供了命令行工具和库功能来支持这些不同的分享和发布场景。

### (a) 运行为应用程序: `marimo run`

将 Marimo 笔记本作为交互式 Web 应用程序运行是最常见的分享方式之一 5。使用 Marimo CLI 中的 `run` 命令即可实现 5：

```bash
marimo run your_notebook.py
```

此命令会启动一个 Web 服务器，托管你的笔记本，并以“**应用程序模式**”呈现给用户 68。

- **应用程序模式特点**:
  - **代码默认隐藏**: 用户的焦点集中在输出和交互式 UI 元素上，代码单元格默认不显示 5。这使得最终的应用界面更加简洁，适合分享给非技术用户或用于展示最终结果，同时也可以保护源代码 1。
  - **交互性保留**: 笔记本中定义的所有 Marimo UI 元素（如滑块、下拉菜单、表格选择、图表交互、表单等）在应用模式下 **完全可用且功能正常** 5。用户与这些元素的交互会像在编辑模式下一样触发 Marimo 的反应式更新，从而动态改变应用的输出 5。
  - **布局**: 默认情况下，单元格的输出按垂直顺序连接显示 13。
- **常用命令行选项**:
  - `--include-code`: 在应用程序模式下也显示代码单元格 7。
  - `--headless`: 启动服务器但不自动在浏览器中打开应用程序 24。
  - `--port <number>`: 指定服务器监听的端口号 24。
  - `--host <address>`: 指定服务器绑定的主机地址 (默认为 `127.0.0.1`) 24。
  - `--base-url <path>`: 如果在反向代理后运行，设置应用程序的基础 URL 路径。
  - `--watch`: 监视笔记本文件的变化，并在文件修改时自动重新加载应用程序 96。
- **布局配置**:
  - **垂直布局 (默认)**: 如上所述，简单地垂直堆叠输出 13。
  - **网格布局 (Grid Layout)**: Marimo 提供了一个可视化的拖放式网格编辑器（可在应用预览模式下启用），允许用户自由排列单元格输出 13。布局配置会保存在笔记本目录下的一个 `layouts` 文件夹中；分享笔记本时需要包含此文件夹才能保留自定义布局 60。
  - **幻灯片布局 (Slides Layout)**: 将每个单元格（或按特定分隔符划分的单元格组）渲染为演示文稿的一页幻灯片 5。代码默认隐藏，输出按单元格在笔记本中的物理顺序排列 46。

### (b) 运行为脚本: `python your_notebook.py`

由于 Marimo 笔记本存储为标准的 `.py` 文件，它们可以直接使用 Python 解释器执行 5。

- **执行方式**: 在命令行中运行 `python your_notebook.py [args...]` 5。
- **输出**: 单元格按拓扑顺序（基于 DAG）执行 3。`print()` 语句和标准错误输出会打印到终端 98。UI 元素不会被渲染。
- **命令行参数处理**:

  - **标准库**: 可以像处理任何 Python 脚本一样，使用 `sys.argv` 结合 `argparse` 或 `simple-parsing` 等库来定义和解析命令行参数 5。
  - **`mo.cli_args()`**: Marimo 提供了一个辅助函数 `mo.cli_args()`，它可以将 `--key value` 形式的参数解析为一个字典（例如 `{'key': 'value'}`），并尝试进行基本类型转换（int, float, bool）69。但它不提供参数声明或帮助文本生成功能，因此对于复杂的参数处理，推荐使用 `argparse` 100。
  - **编辑/运行模式下的参数**: 当通过 `marimo edit`, `marimo run` 或 `marimo export` 传递参数时，需要使用 `--` 分隔符将 Marimo 命令选项与传递给脚本的参数分开 98。例如：`marimo run notebook.py -- --user_name Alice --iterations 10` 98。此时，脚本内部的 `sys.argv` 将是 `['notebook.py', '--user_name', 'Alice', '--iterations', '10']` 100。
  - **健壮的代码示例**: 处理脚本参数时，需要考虑在 `marimo edit` 模式下可能没有参数传递的情况 91。使用 `argparse` 的 `parse_args()`（默认使用 `sys.argv[1:]`）或 `parse_known_args()`，并为参数提供默认值或进行检查，可以编写出在两种模式下都能稳健运行的代码 91。

  ```python
  import marimo as mo
  import argparse
  import sys

  # 检查是否在 Marimo 编辑/运行模式下通过 -- 传递了参数
  # 或者是否直接作为脚本运行
  # sys.argv[0] 是脚本名
  # 如果 len(sys.argv) > 1 且 sys.argv[1] 不是 Marimo 内部参数，则认为有脚本参数
  # 一个更简单（但可能不完全通用）的检查是看参数列表是否为空（编辑模式）
  # 或者直接尝试解析，让 argparse 处理

  parser = argparse.ArgumentParser()
  parser.add_argument('--learning_rate', type=float, default=0.01)
  parser.add_argument('--epochs', type=int, default=10)

  # 尝试解析参数，如果失败（例如在 edit 模式下无参数），则使用默认值
  # 注意：直接运行脚本时，sys.argv[1:] 包含参数
  # 通过 marimo edit/run --... 运行时，sys.argv[1:] 也包含参数
  # 在 marimo edit/run 没有 -- 时，sys.argv 只有脚本名，parse_args([]) 会使用默认值
  try:
      # 在 marimo 环境下，sys.argv 可能包含 marimo 自身的参数
      # 如果使用 -- 分隔符，则分隔符后的内容在 sys.argv 中
      # 如果不确定，可以只解析已知参数
      # 明确从 sys.argv[1:] 开始解析，避免解析脚本名
      args, unknown = parser.parse_known_args(sys.argv[1:])
  except SystemExit:
      # argparse 在 --help 时会退出，这里简单处理
      # 如果没有参数，parse_args([]) 会使用默认值
      args = parser.parse_args(sys.argv[1:] if len(sys.argv) > 1 else [])

  learning_rate = args.learning_rate
  epochs = args.epochs

  mo.md(f"""
  学习率: {learning_rate}
  训练轮数: {epochs}
  """)
  ```

### (c) 导出为静态格式: `marimo export`

`marimo export` 命令可以将 Marimo 笔记本转换为多种静态或半静态格式 24。

- **`html`**:
  - **描述**: 导出为包含代码（可选）和所有单元格输出的静态 HTML 文件 96。
  - **包含输出?**: 是 (需要运行笔记本生成) 96。
  - **交互性?**: 否 (UI 元素和图表选择将失去交互性)。
  - **选项**: `--include-code`/`--no-include-code` 67, `--watch` 96, `-o` 96。
  - **优点**: 易于分享的静态报告，保留视觉结果 58。
  - **缺点**: 文件可能较大，失去交互性。需要 Playwright 依赖以确保渲染准确性 96。
- **`html-wasm`**:
  - **描述**: 导出为一个独立的 HTML 文件，该文件使用 WebAssembly (Pyodide) 在浏览器中运行 Marimo 内核和笔记本代码 96。
  - **包含输出?**: 否 (代码在浏览器中重新运行以生成输出)。
  - **交互性?**: 是 (UI 元素和图表选择功能齐全) 67。
  - **选项**: `--include-code`/`--no-include-code` 67, `--watch` 96, `-o` 96, `--mode` (`run`/`edit`) 67, `--show-code` 67。
  - **优点**: 完全自包含，无需服务器即可实现完全交互，便于托管在静态网站（如 GitHub Pages）或直接分享文件 67。
  - **缺点**: 初始加载时间可能较长（需要加载 Pyodide 和 Python 环境），文件体积较大，支持的 Python 包受 Pyodide 限制 67。
- **`ipynb`**:
  - **描述**: 导出为 Jupyter Notebook (`.ipynb`) 文件格式 24。
  - **包含输出?**: 可选 (通过 `--include-outputs` 运行笔记本生成) 24。
  - **交互性?**: 否 (Marimo UI 元素在 Jupyter 中不工作)。
  - **选项**: `--sort` (`topological`/`top-down`) 67, `--watch` 96, `-o` 96, `--include-outputs` 24。
  - **优点**: 与 Jupyter 生态系统兼容，可用于转换格式（如使用 `nbconvert` 转 PDF）或在 Jupyter 环境中查看代码 58。
  - **缺点**: 失去 Marimo 的反应性和交互性 67。
- **`md`**:
  - **描述**: 导出为包含代码单元格的 Markdown 文件 24。
  - **包含输出?**: 否 (当前版本不包含单元格输出) [105, 1]

# R016：列长度与终端预算

状态：完成，单文件、目标构建及全宽度统一集成均通过。主智能体执行。

计划：在有限支持上定义每个x指数的二维列；从下闭性证明该列为自然数初始区间。将每列强制的y,z三角形注入终端次数以前的三维标准集合，证明平方和预算。最后以双射识别总列长度和既有sectionLength。

独占文件：lean/WidthBounds/ColumnBounds.lean。后续与R011通过R012集成。

## 已完成的接口

- `column` / `columnLength`：在既有支持界内用真实标准谓词定义有限列及基数。
- `column_eq_range`：整除下闭推出每列是长度为其基数的初始区间。
- `standard_iff_lt_columnLength`：支持截断使有限列完整描述全部二维单项式。
- `column_endpoint_le`：非空第i列的末端同次lex下移到y轴，给出 `i+n_i<=n_0`。
- `sum_columns_eq_sectionLength`：显式双射 `(i,j) ↦ (i+j,i)`，证明列长之和等于已有总截面长度。
- `terminal_triangle_budget`：把 `(i,j,k)`、`j+k<n_i` 注入次数小于n0的全部三维标准集合。逐列计数和三角和恒等式给出 `sum_i n_i(n_i+1) <= 2*(1+(n0-1)*w)`。

每条结论对任意 `w>=4` 成立；没有使用小宽度有限证书作为证明步骤。`SmallWidth` 的导入仅提供既有 `sectionLength` 定义及通用截断等依赖。

## 编译

`lake env lean WidthBounds/ColumnBounds.lean`：退出码0（第一次完整草稿修复了Sigma投影和自然数减法的显式转换）。没有新增数学假设以消除错误。目标构建日志 `results/lean_columns_build.txt`；最终统一构建日志 `results/lean_all_widths_build.txt`。

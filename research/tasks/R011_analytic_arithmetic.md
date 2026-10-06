# R011：无枚举解析证明的向量算术形式化

状态：完成，主线程已接手并通过统一构建验收，2026-09-23。独占 `lean/WidthBounds/AnalyticArithmetic.lean` 与本报告。

## 接口及计划

最终接口采用 `n : Fin a → Nat`，`2 ≤ a`，并用 `⟨0, by omega⟩ : Fin a` 指定首列。输入为前缀 `choose3 (a+2) ≤ 1+(a-1)*w`、首列正性、原始终端预算 `∑ i, n i*(n i+1) ≤ 2*(1+(n 0-1)*w)` 与 `4 ≤ w`。输出三界合取，其中第一界严格。

先证明前缀推出 `a ≤ w-2`；随后在整数环完成平方并证明 Cauchy 界，允许向量首项为负；最后以严格多项式比较得到 Nat 二项式三界。不把完成平方、Cauchy 或列长平方和的后果当作最终假设。列几何另由主线程负责。

所有证明不使用 `sorry`、`admit`、自定义公理或 `native_decide`。只目标编译本模块，若必要则目标构建缺失的 mathlib 依赖。

## 恢复核验

`.venv\Scripts\python.exe -B scripts/checkpoint.py --check`：`queue_valid=true, errors=[]`。
`--verify-latest`：`archive_valid=true, errors=[]`；当前工作区正常后续变动为 queue 更新与 R016 报告新增，未发现归档损坏。

## 命令与编译证据

以下保留历史编译过程；最终证据为 `results/lean_all_widths_build.txt`，其中本模块及统一AllWidths定理全部通过。

### 编译尝试 1（WIP）

命令（`lean/`）：`lake env lean WidthBounds/AnalyticArithmetic.lean`。
前缀精确乘阶乘、`alpha_le_width_sub_two` 和整数 Cauchy 的部分已被内核接受。完成平方中首项条件式被推断为 Nat，以及误用不存在的 `Int.natCast_sum` / `Int.natCast_ofNat` 导致此轮退出 1。已将条件式明确标为整数，并改用 `Nat.cast_sum` / `Nat.cast_ofNat`。

### 当前进度

最终定理名为 `WidthBounds.analytic_column_binomial_bounds`，精确签名已落盘源码。它输出第一严格界和另两弱界，原始 Nat 前缀与终端预算仍是最终输入。严格比较通过正多项式 `(w-2)^2*(w-1)*(w-3)` 及非负修正项，不进行范围枚举。第二轮单文件编译和主线程最终统一构建均已通过。

## 中断接手

子智能体在报告第二轮单文件编译退出0后遇到额度限制。主线程已从源码及编译产物接手，完成AllWidths集成和统一build。最终公理仅为propext、Classical.choice、Quot.sound；没有仅凭中断前的聊天消息宣布完成。

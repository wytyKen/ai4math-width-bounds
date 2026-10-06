# R022：真实商环维数预算到全宽度组合界

状态：完成并经主智能体统一集成验收；2026-09-23。独占 `lean/WidthBounds/IdealBounds.lean` 与本报告；执行者未修改 R017 或根 import/状态。最终统一日志见 `results/lean_quotient_growth_build.txt`。

目标：对真实单项式理想 I=monomialIdeal S，将 quotientHomogeneous 的 finrank 累计预算通过 R017 代入 all_widths_analytic_bounds；证明真实 xy 单项式商像张成空间的 finrank 等于 sectionLength，而非假设这一等同；最后提供真实维数版本三界。保留与 Betti/半群归约的边界。

计划：利用 standardMonomialBasis 的有限子族；索引 `(range (2*w+1)).sigma (standard2 A)`，由标准次数截断证明它张成无限 xy 单项式商像子空间。其基数与 sectionLength 按定义相等。目标编译通过后由主智能体集成。

## 完成的真实接口

命名空间 `WidthBounds.MonomialInterface`；系数为任意域 K。

- `xyMonomial I i j` 是真实商环中的 `x^i y^j`；`xySubspace I` 定义为所有 `(i,j):ℕ×ℕ` 对应商像的 K 线性张成空间，定义中没有截断或维数假设，对任意真实理想 I 可定义。
- `xyStandardIndices A w` 为 `(range (2*w+1)).sigma (standard2 A)`；`card_xyStandardIndices` 证明其基数等于已有 `sectionLength A w`。
- `boundedXYMonomial_linearIndependent` 将有限索引 `(d,i)` 映到标准指数 `(i,d-i,0)`，利用 `i≤d` 证明单射，再从 R017 的实际商环标准单项式基继承线性独立；没有把待证独立性当假设。
- `finrank_boundedXYMonomialSpan` 因而证明有限族的张成空间维数等于 sectionLength。
- `hilbertBudget_of_finrankBudget` 逐次数用 R017 的 `finrank_quotientHomogeneous` 把真实齐次像的 finrank 预算转换为已有组合 Hilbert 预算。
- `xySubspace_eq_boundedSpan` 证明完整无限 xy 单项式张成空间恰等于上述有限标准族张成空间。每个非标准商像因实际理想成员性等于0；每个标准商像由 `Columns.standard_degree_lt` 落入索引截断；反向包含直接由生成元定义得到。截断依赖显式 lex 条件、w≥4和真实次数维数预算，没有有限余长假设。
- `finrank_xySubspace` 得到真实完整 xy 子空间的 finrank 等于 sectionLength。有限族张成等式还直接展示该子空间有限维；不是对无限空间使用 finrank=0 的退化。
- `monomialIdeal_all_widths_dimension_bounds` 将上述等式与 R007 的初始次数存在及 `all_widths_analytic_bounds` 组合。

## 最终命题

令 `I = monomialIdeal S`，假设：

1. K 是域，S 是指数上集。
2. S 满足当前明确的同次 lex 上闭 `IsLexExponentSet`（变量顺序x>y>z）。
3. I 非零，x的商像非零，即 `standard I 1 0 0`。
4. w≥4；对每个d，实际商环中0至d次齐次多项式像的各次维数之和≤`1+d*w`。

则存在初始a≥2，a次纯x幂非标准而所有更低次数纯x幂标准，且若 `L = Module.finrank K (xySubspace I)`，有

```text
a + 1 + L < (w+1).choose 2
a + 2*L ≤ 2*(w+1).choose 3
L ≤ 3*(w+1).choose 4
```

这里初始次数、商环维数与计数的等同、xy子空间的有限截断，全部由代码证明，不是新增输入假设。第一界严格，所有整数w≥4均适用。

## 编译与审计

目录 `D:\project\ai4math\lean`，固定 Lean/mathlib 4.22.0。

- `lake env lean WidthBounds/IdealBounds.lean`：退出码0。
- 审计入口 `finrank_xySubspace` 与 `monomialIdeal_all_widths_dimension_bounds` 都仅依赖 `[propext, Classical.choice, Quot.sound]`。
- 源码检索无 `sorry`、`admit`、新 `axiom` 声明或 `native_decide`。
- 最终源码 SHA-256：`6d532ead0df25c51f1f97a7cbc4bc5fecb36a053dc2a8eac3126e4c628e07767`。
- `lake build WidthBounds.IdealBounds`：退出码0，`[3075/3075] Built WidthBounds.IdealBounds`，`Build completed successfully.`。

首轮编译的局部错误是 Fintype.card 与 finset.card 未约化、sigma 投影使 omega 目标未约化、以及 Submodule.subset_span 隐式参数无法推断；分别通过显式 `Fintype.card_coe`、带准确类型的中间成员引理和明确子空间目标解决。没有更改数学假设或提高 heartbeat。

## 边界与下一步

实际齐次像仍使用 R017 的定义，尚未装配整个 graded quotient API；xySubspace 是三变量商环中的真实向量子空间，尚未另行构造与二变量环商或 `(I+(z))` 商的环同构。本结论没有将三个显示表达式称为真实 Betti 数：CMS公式、lex/Gröbner Betti 比较、数值半群环/Artinian约化、真实 Hilbert–Samuel 预算的来源，仍是后续代数层。

目标完成后由主智能体添加根 import、统一构建并更新 claims/STATE/queue/检查点。无需改动冻结稿件或重新运行旧有限枚举。

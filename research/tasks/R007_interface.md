# R007：真实单项式理想到 StandardLex 的接口

状态：完成；Lean 文件直接编译及模块 Lake 构建均通过。2026-09-23。

独占文件：`lean/WidthBounds/MonomialInterface.lean` 与本任务文件。没有修改现有模块、根 import 或 lakefile。主线程需要决定是否将新模块加入根 import。

## 已实现的真实增量

系数对象是任意交换半环 `R`（精确单项式成员判据需要 `[Nontrivial R]`），实际多项式环为 `MvPolynomial (Fin 3) R`。`exponent i j k` 用有限支持函数表示三元指数，`monomial3 i j k` 是系数为 1 的真实单项式。

1. `monomial3_mem_of_le`：从真实 `Ideal` 的 `mem_of_dvd` 和 mathlib 的 `monomial_dvd_monomial` 推出单项式成员的坐标向上闭性。该性质不是新的结构假设。
2. `standardLex`：对任意真实多项式理想 `I`，若系数为 1 的单项式成员在同次 lex 上向上闭，则 `standard I := monomial3 ∉ I` 满足已有 `LexCounting.StandardLex`。唯一额外的 lex 假设用 `IsLex I` 明确表达。
3. `monomialIdeal S`：真实理想 `Ideal.span ((fun e => monomial e 1) '' S)`。
4. `mem_monomialIdeal_iff_support`：若 `S` 是指数上集，则任意多项式在该理想中，当且仅当其所有支撑指数都在 `S`。
5. `monomial_mem_monomialIdeal_iff`：在非平凡系数半环中，`monomial e 1 ∈ monomialIdeal S ↔ e ∈ S`。这由 mathlib 的支撑成员判据证明，并没有把对应关系作为假设。
6. `monomialIdeal_isLex`、`monomialIdeal_standardLex` 与 `standard_monomialIdeal_iff`：指数集合的同次 lex 上闭，经成员等价传递到真实理想，再得到已有组合接口及其补集的精确对应。
7. `monomialIdeal_ne_bot_iff`：非平凡系数半环中，生成理想非零当且仅当生成指数集合非空，无需上集假设。
8. `pure_x_mem_of_monomial_mem`、`exists_pure_x_mem`：同次 lex 向上闭使任一理想内单项式迫使同次纯 `x` 幂；因此非空生成集合给出一个禁用纯幂。此步骤不需要有限余长。
9. `exists_initial_degree`：由禁用纯幂存在，以及 0、1 次纯幂标准，使用 `Nat.find` 给出 `a ≥ 2`、`¬ standard I a 0 0` 及所有 `d < a` 的 `standard I d 0 0`。
10. `monomialIdeal_exists_initial_degree`：将上述步骤组装，对非零、指数上闭及同次 lex 上闭的生成理想，假设 `x` 标准，就得到 `a ≥ 2`、现有 `hx` / `hInitial`，以及所有总次数 `< a` 的三变量单项式均标准。

## 主入口

命名空间 `WidthBounds.MonomialInterface`。

```lean
monomialIdeal_standardLex (S : Set (Fin 3 →₀ ℕ))
  (hUp : IsUpperSet S) (hLex : IsLexExponentSet S) :
  LexCounting.StandardLex (standard (monomialIdeal (R := R) S))

monomialIdeal_exists_initial_degree (S : Set (Fin 3 →₀ ℕ))
  (hUp : IsUpperSet S) (hLex : IsLexExponentSet S)
  (hNonzero : monomialIdeal (R := R) S ≠ ⊥)
  (hOne : standard (monomialIdeal (R := R) S) 1 0 0) :
  ∃ a : ℕ, 2 ≤ a ∧ ¬ standard (monomialIdeal (R := R) S) a 0 0 ∧
    (∀ d, d < a → standard (monomialIdeal (R := R) S) d 0 0) ∧
    ∀ i j k, i + j + k < a → standard (monomialIdeal (R := R) S) i j k
```

以上两个入口均需要 `[CommSemiring R] [Nontrivial R]`。`standardLex` 本身只需要交换半环，既不假设理想由单项式生成，也不假设理想齐次。

## 本地 API 地图

- `Mathlib/RingTheory/MvPolynomial/Ideal.lean`：`MvPolynomial.mem_ideal_span_monomial_image`，将单项式生成理想成员精确描述为每个支撑指数支配某个生成指数。
- `Mathlib/Algebra/MvPolynomial/Division.lean`：`MvPolynomial.monomial_dvd_monomial`，连接指数偏序与单项式整除。
- `Mathlib/RingTheory/Ideal/Defs.lean`：`Ideal.mem_of_dvd`。
- `Mathlib/Algebra/MvPolynomial/Basic.lean`：`support_monomial`、`monomial_eq_zero`。
- `Nat.find_spec`、`Nat.find_min`：最小禁用纯幂的存在和最小性。

第一次编译发现 `Mathlib.RingTheory.MvPolynomial.Ideal.olean` 本地尚未构建。已执行 `lake build Mathlib.RingTheory.MvPolynomial.Ideal`，成功补建三个现有依赖模块；没有安装运行时或更改依赖版本。

## 验证记录

在 `D:\project\ai4math\lean`，Lean 4.22.0 / mathlib v4.22.0：

- `lake build Mathlib.RingTheory.MvPolynomial.Ideal`：通过。
- `lake env lean WidthBounds/MonomialInterface.lean`：通过，退出码 0。
- `lake build WidthBounds.MonomialInterface`：通过，退出码 0，`[3054/3054] Built WidthBounds.MonomialInterface`。
- 四个打印公理审计入口：`monomial_mem_monomialIdeal_iff`、`monomialIdeal_standardLex`、`exists_initial_degree`、`monomialIdeal_exists_initial_degree`。输出均仅为 `[propext, Classical.choice, Quot.sound]`，无 `sorryAx`。
- 源码没有 `sorry`、自定义公理或 `native_decide`。

## 准确形式化边界

本轮已把“真实多项式理想的标准单项式符合组合模型”和“非零 lex 单项式理想的初始次数存在”这一有限缺口闭合。不是只把 `StandardLex` 重命名。

仍未形式化：商环单项式基；`hilbert3` 与分次商环向量空间维数的等同；`hilbert2` 与二维截面商环维数的等同；有限余长与理想非零/支撑截断的推导；无一次项与 `hOne` 的代数等价；Macaulay lex 伴随理想的存在；数值半群环、Artinian 约化、Hilbert–Samuel 预算传递、Gröbner/lex Betti 比较和 CMS Betti 公式。因此这不构成从数值半群环到最终宽度 Betti 界的端到端形式化。

`IsLex` / `IsLexExponentSet` 是显式的同次单项式 lex 上闭假设，并没有用 mathlib 的内建单项式序或 Gröbner 初始理想定义证明这一性质。作为当前证明的输入边界，该假设正好可见且方向已核对（变量顺序 `x > y > z`）。

## 下一步建议

主线程验收并将模块纳入根 import 后，可直接把 `monomialIdeal_standardLex` 和 `monomialIdeal_exists_initial_degree` 提供的结果代入已有组合结论。最有价值的后续代数缺口是单项式商环基及有限次数切片维数与 `hilbert3` / `hilbert2` 的精确相等；不建议把尚未证明的这一对应包装成已有结论。

# R027：真实有限余长与纯z幂的接口

状态：已完成。根智能体执行；统一构建通过，R026独立语义审查接受。

## 精确结果

任意域 K、指数上集 S，I=monomialIdeal S 是实际三变量多项式理想。

1. `quotient_finite_iff_standard_finite`：实际商环 `K[x,y,z]/I` 作为 K 模的 `Module.Finite`，当且仅当标准指数集 `Sᶜ` 有限。证明通过 R017 已构造的真实标准单项式基；没有用 `finrank` 数值代替有限维性。
2. `exists_pure_z_mem_of_finite_quotient`：上述真实有限维性推出存在 N，使 `monomial3 0 0 N ∈ I`。此方向不需要 lex 或 HS 预算。
3. `standard_finite_of_pure_z`：如果 S 又满足同次 lex 上闭，纯 z 幂指数成员推出所有标准单项式总次数小于 N，因此标准指数集有限。
4. `quotient_finite_iff_exists_pure_z`：对 lex 指数上集，真实商环有限维当且仅当存在纯 z 幂成员。

N 可以为零（单位理想情形）；后续 R025 的 x 标准假设会排除该情形。没有把一般理想的 Artinian 性和相对于 K 的有限维性混用。本任务使用明确的有限余长含义：商环作为 K 向量空间有限维。

## 文件和验证

- `lean/WidthBounds/FiniteColength.lean`
- 运行目录 `lean/`；命令 `lake env lean WidthBounds/FiniteColength.lean`。
- 单模块 exit code 0；三个输出的主要定理只依赖 `propext`、`Classical.choice`、`Quot.sound`。
- 统一 `lake build` 返回0，日志 `results/lean_generators_build.txt`；源码与日志哈希已登记于 `research/claims.json`。
- 源码SHA-256：`61d1a3ad9387735533610c89156c297ff053e636c66e51f06e4278ad71025cfa`。独立语义审查见R026报告F节。

## 边界与下一步

这只是有限余长假设和 R025 z 阈值构造的桥梁，不是生成数、极小性或 Betti 公式。R025根集成模块已用它给出直接接受真实有限维商环假设的生成集合严格上界。无数学失败路线或数值实验。

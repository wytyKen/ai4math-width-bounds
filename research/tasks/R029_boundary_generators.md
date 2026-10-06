# R029：边界指数候选集合与精确计数

状态：A-D目标文件完成并经根集成验收，2026-09-23。执行者仅编辑本报告与 `lean/WidthBounds/BoundaryGenerators.lean`；根智能体已完成统一构建，R030独立语义审查接受。源码保持冻结。

## 精确目标与接口

泛型系数假设仅 `[CommSemiring R]`。实际理想 `I : Ideal (MvPolynomial (Fin 3) R)`，`hZ : ∃ b, monomial3 0 0 b ∈ I`，自然数 `a` 与函数 `n : ℕ → ℕ`。

- `boundaryExponents I hZ a n`：`exponent a 0 0`、`i<a` 的 `exponent i (n i) 0`、`i<a` 且 `j<n i` 的 `exponent i j (zThreshold I hZ i j)` 三部分的 Finset。
- `mem_boundaryExponents_iff`：上述三类的完整成员刻画。
- `boundaryExponents_monomial_mem`：若 `x^a∈I` 且 `standard I i j 0 ↔ j<n i`，每个候选指数的系数1单项式属于I。
- `exists_boundaryExponent_le`：任何系数1单项式 `monomial e 1∈I` 都存在候选 `b≤e`。此方向不需要 `x^a∈I` 或列刻画，只使用三分法与最小z阈值。
- `boundary_zThreshold_pos`：列内标准xy单项式的z阈值严格正；不与R028的同用途引理同名。
- `card_boundaryExponents`：若列刻画成立，候选集合基数严格等于 `a+1+∑ i∈range a,n i`。不要求a最小、列长严格递减、lex或非平凡系数半环。
- `span_boundaryExponents S hZ a n hx hn`：当 `I=monomialIdeal S` 时，候选系数1单项式的实际 `Ideal.span` 等于I；不要求S向上闭。接口明确采用 `Ideal.span ((fun e => monomial e (1:R)) '' (boundaryExponents I hZ a n : Set _))`，没有定义新指数到多项式Finset映射。

主要证明：两种像分别由x坐标及(x,y)坐标可恢复索引而单射，B与V用z坐标0/正区分，纯x项与其余两部分用x坐标a/<a区分。生成性将原始S中任意指数的单项式按coverage接口取一个边界因子，再用实际理想的 `mem_of_dvd` 提升为span包含。`a=0` 时集合为 `{exponent 0 0 0}`、公式为1；空列自动无垂直候选。

## 编译与局限

最终目标命令（工作目录 `D:\project\ai4math\lean`）：

```text
lake env lean WidthBounds/BoundaryGenerators.lean
```

最终版本退出码0；四个主定理的 `#print axioms` 均只输出：

```text
propext, Classical.choice, Quot.sound
```

最终源码SHA-256：`4D8DF5F5B1ADFE65869A9D997CD370D2936DFFF4C2B54EF4D00A3B8361663570`。

静态搜索 `sorry|admit|axiom|native_decide` 仅命中四行 `#print axioms`。没有sorry/admit/native_decide或自定义公理。此处是目标文件直接编译证据；不是统一 `lake build` 日志。统一构建、源码/日志核验值更新及检查点由根执行。

## 尝试记录与研究边界

第一次A-C编译失败仅因两个Lean实现细节：

1. 用 `rw [← exponent_coordinates e]` 把目标右侧e换成其坐标表达式时，也会重写候选索引中的e；改为先给出完整类型的指数比较，再 `simpa only [exponent_coordinates]`。
2. `omega` 不自动把推导中匿名sigma项的 `.fst` 识别为已解构的i；为局部不等式标注 `i<a` 后即通过。

修复后A-C编译退出0；加入D后最终版本再次编译退出0。没有数学路线失败，没有加强原定研究假设。

不声称候选极小性、任意多项式生成元最少个数、Betti/Tor或完整半群定理；极小性由另一个独立任务处理。

下一步：根使用R028的候选整除极小性与这里的成员、coverage、card、span接口，组合为精确整除极小单项式集合定理，再接已建立的真实维数和有限余长接口。任何从指数Finset转换为多项式Finset后的精确card须另外使用非平凡系数下单项式指数映射单射；不能在平凡半环下直接沿用指数card。

## 根最终验收

根已在GeneratorExact.lean接入R028极小性引理，完成全体极小单项式分类、实际多项式生成集合、精确基数、逐项删除性质及有限余长维数预算下的严格界。统一 `lake build` 退出0，日志 `results/lean_minimal_generators_build.txt`，SHA-256 `588c4d7bce7843f42c919111e755267b2ba4466211bf4c26f5985f4827b77774`。R030独立语义审查接受；本模块交付后源码hash保持不变。本模块自身不依赖极小性，整体已形式化范围详见R028报告B-C节。

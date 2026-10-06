# 证明叙事与精确声明映射

2026-10-04 起草，2026-10-05 复核，R092/R100。本文对应 [PROOF_NARRATIVE](D:/project/ai4math/research/publication/PROOF_NARRATIVE.md) 的 N0–N9；读者可按自然语言结论追到完整假设、当前 Lean 声明和传统来源。它是既有结果的文档映射，**没有新增 Lean 定理、构建、实验或新颖性认证**。源码行号取自本轮实际读取的文件。一级 N0–N9 对应主文章节；表内 N1.1、N1.2 等数字子项是本映射的独立细分，不与主文字母小节逐项等同。本地绝对链接定位当前工作区；未来公开稿须改为固定源码版本的可分发链接并重新核对行号。所有表内 Lean 名称都在 WidthBounds 下；如 Growth.degree_product_bound 的全名为 WidthBounds.Growth.degree_product_bound。

本地科学证据沿用 [R058 验收清单](D:/project/ai4math/results/r058_validation.json) 及 [历史构建日志](D:/project/ai4math/results/lean_higher_tor_build.txt)，固定 Lean/mathlib 4.22.0，mathlib commit 79e94a093aff4a60fb1b1f92d9681e407124c2ca。该记录是含成功缓存回放的统一增量构建，**不是本轮重建或干净重建**。R058 明确记录标准 Tor 范围、真实标量作用和依赖公理 propext、Classical.choice、Quot.sound，不把数学假设藏成自定义公理。较早源码的编译状态沿既有验收链继承，读取源码本身不创造编译证据。

## 合同：以下缩写包含哪些完整条件

令 \(K\) 为任意域，\(A=K[x,y,z]\)，\(\mathfrak m=(x,y,z)\)，变量序 \(x>y>z\)。Lean 的 Ring K 正是 MvPolynomial (Fin 3) K。本文用 \(T(i,j,k)\) 表示标准性，避免与环 \(A\) 重名；组合源码通常把这一谓词命名为 A。

**G（组合合同）**：\(T:\mathbb N^3\to\mathrm{Prop}\) 满足 LexCounting.StandardLex T，即逐坐标向下封闭；固定总次数时，降低首个不同的 x,y 指数仍标准。另给 \(w,a\in\mathbb N\)，\(w\ge4,a\ge2\)，hInitial : ∀ d, d < a → T d 0 0，hx : ¬ T a 0 0，以及

\[
\forall d\in\mathbb N,\qquad \sum_{t=0}^{d}H_t\le1+dw,
\quad H_t=\mathrm{hilbert3}(T,t).
\]

没有预设环、有限余长、Tor 或终端列预算。表中标明“G 的部分条件”的引理，精确弱条件逐项列出。

**Q（实际维数合同）**：{K : Type*} [Field K]；\(S\subseteq(\mathrm{Fin}\,3\to_0\mathbb N)\)；hUp : IsUpperSet S；hLex : IsLexExponentSet S；\(I=\mathrm{monomialIdeal}(S)\ne0\)；hOne : standard I 1 0 0；\(w\ge4\)；对**所有** \(d\in\mathbb N\)，

~~~lean
(∑ t ∈ range (d + 1),
  Module.finrank K (quotientHomogeneous (K := K) S t)) ≤ 1 + d * w
~~~

Q 本身不要求整个 \(A/I\) 有限维；N2/N3 的实际截面上界在这一较弱合同成立。\(Q_t(I)=\mathrm{quotientHomogeneous}(S,t)\) 是次数 t 齐次多项式在实际商中的像，\(\ell=\dim_K\mathrm{xySubspace}(I)\) 是所有 z 指数为零的商单项式所张成的完整子空间维数。

**C（主模型合同）**：Q 中以 [Module.Finite K (A ⧸ I)] 明确要求有限余长；非零性由此推出，不作为额外假设。等价的打包结构为 [LexExtremal.Admissible](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:24)，它本身不含 \(w\ge4\)，使用主结论时另加该范围。x∉I 与 lex 性在传统单项式解释下给出无一次项；本文没有宣称新增 I⊆m² ↔ x∉I 的独立 Lean 声明。Field K 没有特征零、无限域或代数闭限制。这里 w 是预算参数，不要求由半群生成元差实现。

**D（无宽度的具体边界合同）**：任意域 K，实际理想 I : Ideal (Ring K)，hZ : ∃ b, monomial3 0 0 b ∈ I，a : ℕ，n : ℕ → ℕ，hx : monomial3 a 0 0 ∈ I，hLex : IsLex I，hn : ∀ i j, standard I i j 0 ↔ j < n i，hInitial : ∀ d, d < a → standard I d 0 0。构造商分解时还要 hSpan : Ideal.span (exponentMonomials (boundaryExponents I hZ a n)) = I；模 m 微分为零及四个 Tor 维数时再要 hI : I ≤ variableIdeal。D 不要求 w、预算、a≥2 或另一个有限余长实例；C 端点负责构造所需数据，而不是让用户猜它们。

下表的“Lean 已编译”均指上述历史验收范围；“传统”表示自然语言数学证明或已读文献接口，不表示新 Lean 声明。“候选”仅指贡献归属仍待排除，数学证明状态与新颖性状态是两条轴。

## N0：共同对象、真实维数和计数识别

| 子项：自然语言结论 | 精确假设与 Lean 声明 | 来源/范围边界 |
|---|---|---|
| N0.1 标准单项式闭包 | LexCounting.StandardLex，[LexCounting:19](D:/project/ai4math/lean/WidthBounds/LexCounting.lean:19)；MonomialInterface.monomialIdeal_standardLex，[MonomialInterface:139](D:/project/ai4math/lean/WidthBounds/MonomialInterface.lean:139)，输入上集 S、lex 指数集及非平凡交换半环 | 前者仅为两个闭包性质；后者从实际单项式理想导出它们。不能将任意 G 自动说成有限余长三变量理想。 |
| N0.2 标准单项式确为实际商的基 | 任意域、S 上集；MonomialInterface.quotientStandardEquiv 和 standardMonomialBasis，[MonomialBasis:65](D:/project/ai4math/lean/WidthBounds/MonomialBasis.lean:65)、[92](D:/project/ai4math/lean/WidthBounds/MonomialBasis.lean:92) | 基指标为 S 的补集；并非定义 finrank 等于期望计数。一般基不要求指标有限。 |
| N0.3 每次实际维数 \(\dim_K Q_d(I)=H_d\) | 任意域、S 上集、任意 d；MonomialInterface.finrank_quotientHomogeneous，[MonomialBasis:240](D:/project/ai4math/lean/WidthBounds/MonomialBasis.lean:240)；Q_d 定义见 [同文件:136](D:/project/ai4math/lean/WidthBounds/MonomialBasis.lean:136) | 不要求 lex 或整个商有限余长；对应真实齐次像，不是仅定义一个数字 Hilbert 函数。 |
| N0.4 \(\ell=\sum_dh_d=\mathrm{sectionLength}(T,w)\) | 任意域、S 上集且 lex、w≥4、所有次数实际预算；MonomialInterface.finrank_xySubspace，[IdealBounds:125](D:/project/ai4math/lean/WidthBounds/IdealBounds.lean:125)。完整 xySubspace 定义见 [IdealBounds:29](D:/project/ai4math/lean/WidthBounds/IdealBounds.lean:29) | 此识别无需 Q 的非零性或 x 标准性。传统等同于 \(K[x,y]/(I\cap K[x,y])\) 或 \(A/(I+(z))\) 的维数；未新增这些商环间的 Lean 同构。 |
| N0.5 初始次数 a 存在且 a≥2，低于 a 的所有次数全标准 | S 上集且 lex、I 非零、x 标准；MonomialInterface.monomialIdeal_exists_initial_degree，[MonomialInterface:192](D:/project/ai4math/lean/WidthBounds/MonomialInterface.lean:192)。在 C 中 LexExtremal.Admissible.nonzero，[LexGrowthTheta:32](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:32) 给出非零性 | a 是首个禁纯 x 指数，同时是初始总次数。传统比较对象同 [CMS v2 Problem 4.1](https://arxiv.org/html/2307.05770v2#S4) 的三变量无一次项情形，不能称覆盖一般变量数问题。 |

## N1：截面形状、前缀、a 的范围及截断

| 子项：自然语言结论 | 精确假设与 Lean 声明 | 证明层级/边界 |
|---|---|---|
| N1.1 次数 d 的 xy 标准指数恰为 \(0,\ldots,h_d-1\) | 只需 StandardLex T；LexCounting.standard2_eq_range，[LexCounting:88](D:/project/ai4math/lean/WidthBounds/LexCounting.lean:88)，结论 standard2 T d = range (hilbert2 T d) | 组合层；d 无范围限制。 |
| N1.2 \(h_d=d+1,H_d=\binom{d+2}{2}\) 在 d<a；前缀总和为 \(\binom{a+1}{2},\binom{a+2}{3}\) | 只需 StandardLex T、hInitial；LexCounting.hilbert2_eq_of_pure_x、hilbert3_eq_of_pure_x、sum_hilbert2_initial、sum_hilbert3_initial，[Prefix:51](D:/project/ai4math/lean/WidthBounds/Prefix.lean:51)、[64](D:/project/ai4math/lean/WidthBounds/Prefix.lean:64)、[98](D:/project/ai4math/lean/WidthBounds/Prefix.lean:98)、[108](D:/project/ai4math/lean/WidthBounds/Prefix.lean:108) | choose2/choose3 是项目有限算术记号，与 Nat.choose 的等式见 [Prefix:15](D:/project/ai4math/lean/WidthBounds/Prefix.lean:15)。 |
| N1.3 从 a−1 起 h 非增；\(h_d\le a\) 对 d≥a | StandardLex T、hx、a−1≤t≤d；LexCounting.hilbert2_antitone，[LexCounting:140](D:/project/ai4math/lean/WidthBounds/LexCounting.lean:140)，输出 h_d≤h_t；再用 hilbert2_le，[同文件:58](D:/project/ai4math/lean/WidthBounds/LexCounting.lean:58) | 无预算也成立；不是整个 H_d 非增。 |
| N1.4 前缀预算迫使 a≤w−2 | alpha_le_width_sub_two，[AnalyticArithmetic:24](D:/project/ai4math/lean/WidthBounds/AnalyticArithmetic.lean:24)：w≥4,a≥2,\(\binom{a+2}{3}\le1+(a-1)w\)。直接从 G 的 hInitial、hHS 导出版本为 MonomialInterface.initial_degree_le_width_sub_two_of_budget，[GeneratorNumberBounds:39](D:/project/ai4math/lean/WidthBounds/GeneratorNumberBounds.lean:39) | 后一个声明不需要 hx；a≥2 不能省略。 |
| N1.5 h_d=0 对 d≥2w−2 | StandardLex T、w≥4、所有次数 hHS、2w−2≤d；LexCounting.hilbert2_eq_zero_of_cutoff，[Cutoff:57](D:/project/ai4math/lean/WidthBounds/Cutoff.lean:57) | 不需要 a 或纯 x 阈值；源自非零截面强迫 \((d+1)(d+2)\le2\sum_{t\le d}H_t\)，见 [Cutoff:40](D:/project/ai4math/lean/WidthBounds/Cutoff.lean:40)。 |
| N1.6 有限截断没有漏尾 | sectionLength 定义为 \(\sum_{d<2w+1}h_d\)，[SmallWidth:19](D:/project/ai4math/lean/WidthBounds/SmallWidth.lean:19)；sectionLength_eq_sum_of_ge，[同文件:23](D:/project/ai4math/lean/WidthBounds/SmallWidth.lean:23) 在 StandardLex、w≥4、hHS、2w+1≤n 下输出 \(\sum_{d<n}h_d=\mathrm{sectionLength}\) | 源码故意使用比 N1.5 松的截断，不能据定义截断反向假定无限尾为零；零尾已经证明。 |

## N2–N3：点态乘积、谐和和对数上界

记 \(H_n^{\mathrm{harm}}=\sum_{r=1}^{n}1/r\)，避免与三变量逐次计数 H_d 混用。Lean 使用有理数 Growth.harmonicQ n，定义见 [Growth:76](D:/project/ai4math/lean/WidthBounds/Growth.lean:76)。

| 子项：自然语言结论 | 精确假设与 Lean 声明 | 来源/边界 |
|---|---|---|
| N2.1 固定 h 的强迫三变量计数 \(q(d,h)=\sum_{i<h}(d+1-i)\) | LexCounting.sum_sub_le_hilbert3，[LexCounting:177](D:/project/ai4math/lean/WidthBounds/LexCounting.lean:177)：只需 StandardLex，输出 q(d,h_d)≤H_d。cumulative_cost_of_hilbert，[Envelope:78](D:/project/ai4math/lean/WidthBounds/Envelope.lean:78) 用前缀等式、逐次 q 下界和该终点的累计预算得到尾成本 | 这里是下界，三变量可能还有额外标准单项式。 |
| N2.2 \(r h_d<2w\)，其中 r=d−a+1≥1 | G 且 a≤d；Growth.degree_product_bound，[Growth:25](D:/project/ai4math/lean/WidthBounds/Growth.lean:25)，结论原样 (d - a + 1) * hilbert2 T d < 2 * w | 底层 Growth.product_lt_two_width，[Growth:10](D:/project/ai4math/lean/WidthBounds/Growth.lean:10) 只需 0<w、h≤a 及布尔 admissibleHeight ... = true；G 通过 [Envelope:49](D:/project/ai4math/lean/WidthBounds/Envelope.lean:49) 证明该前提。没有依赖有限参数枚举。 |
| N2.3 \(h_{a+r}\le\lfloor(2w-1)/(r+1)\rfloor\)，r∈ℕ | G；Growth.degree_divisor_bound，[Growth:45](D:/project/ai4math/lean/WidthBounds/Growth.lean:45) | 本行 r 是偏移量，和上一行的正长度 r 相差一；避免混用下标。 |
| N2.4 \(\ell\le\binom{a+1}{2}+\sum_{r<2w+1-a}\lfloor(2w-1)/(r+1)\rfloor\) | G；Growth.sectionLength_le_divisor_sum，[Growth:56](D:/project/ai4math/lean/WidthBounds/Growth.lean:56) | 精确自然数除法上界。 |
| N2.5 \(\ell\le3w+(2w-1)H^{\mathrm{harm}}_{2w-1}\) | G；Growth.sectionLength_le_harmonic，[Growth:115](D:/project/ai4math/lean/WidthBounds/Growth.lean:115)。Q 的实际维数版本 Growth.quotient_xy_le_harmonic，[Growth:151](D:/project/ai4math/lean/WidthBounds/Growth.lean:151) | prefix_choose2_le_three_width，[Growth:91](D:/project/ai4math/lean/WidthBounds/Growth.lean:91) 只用 w≥4,a≥2 和前缀预算给 \(\binom{a+1}{2}\le3w\)；2w+1−a≤2w−1 用到 a≥2。M2 候选解析估计；新颖性未定。 |
| N3.1 \(\ell\le3w+(2w-1)(1+\log(2w-1))\) | G：LogGrowth.sectionLength_le_log，[LogGrowth:71](D:/project/ai4math/lean/WidthBounds/LogGrowth.lean:71)；Q：LogGrowth.quotient_xy_le_log，[LogGrowth:94](D:/project/ai4math/lean/WidthBounds/LogGrowth.lean:94) | 只把自然数维数/有理调和数转到实数，不改变 K 的特征。标准调和数接口 harmonicQ_eq_harmonic、harmonicQ_le_one_add_log，[同文件:12](D:/project/ai4math/lean/WidthBounds/LogGrowth.lean:12)、[20](D:/project/ai4math/lean/WidthBounds/LogGrowth.lean:20)，复用 mathlib 已有调和数估计。 |
| N3.2 \(\ell\le10w\log w\) | G：LogGrowth.sectionLength_le_ten_mul_width_log，[LogGrowth:83](D:/project/ai4math/lean/WidthBounds/LogGrowth.lean:83)；Q：LogGrowth.quotient_xy_le_ten_mul_width_log，[LogGrowth:111](D:/project/ai4math/lean/WidthBounds/LogGrowth.lean:111) | 常数 10 对每个 w≥4 成立，比较步骤 log_upper_le_ten_mul_width_log，[同文件:44](D:/project/ai4math/lean/WidthBounds/LogGrowth.lean:44)。不声称常数最优。 |

## N4：终端列预算、带符号 Cauchy 和三项二项式界

置 \(n_i=\#\{j:T(i,j,0)\}\)，0≤i<a。源码构造有限列再证明等于完整列，定义位于 WidthBounds.Columns 命名空间的 **ColumnBounds.lean**。

| 子项：自然语言结论 | 精确假设与 Lean 声明 | 证明层级/边界 |
|---|---|---|
| N4.1 \(T(i,j,0)\leftrightarrow j<n_i\)，\(i+n_i\le n_0\)（n_i>0）；\(\sum_{i<a}n_i=\ell\) | Columns.standard_iff_lt_columnLength、column_endpoint_le，[ColumnBounds:56](D:/project/ai4math/lean/WidthBounds/ColumnBounds.lean:56)、[81](D:/project/ai4math/lean/WidthBounds/ColumnBounds.lean:81)：StandardLex、w≥4、hHS（端点另需 n_i>0）；列和 sum_columns_eq_sectionLength，[同文件:98](D:/project/ai4math/lean/WidthBounds/ColumnBounds.lean:98) 再要 hx | 完整 G 给 i<a⇒n_i>0，见 columnLength_pos，[同文件:73](D:/project/ai4math/lean/WidthBounds/ColumnBounds.lean:73)。 |
| N4.2 \(\sum_{i<a}n_i(n_i+1)\le2(1+(n_0-1)w)\) | Columns.terminal_triangle_budget，[ColumnBounds:137](D:/project/ai4math/lean/WidthBounds/ColumnBounds.lean:137)：StandardLex、w≥4、0<a、hInitial、hHS；不需要 hx | 显式注入 (i,j,k)↦(i+j+k,(i,j))，将 j+k<n_i 的三角形嵌入 n_0−1 以下标准单项式。终端预算是结论，不是 G 的假设。 |
| N4.3 \((2\ell+a-2w)^2\le a[4(w-1)(w-2)+a]\) | column_cauchy_bound，[AnalyticArithmetic:47](D:/project/ai4math/lean/WidthBounds/AnalyticArithmetic.lean:47)：a≥2，任意 n : Fin a → ℕ，1≤n_0，N4.2 的预算。int_sum_sq_le，[同文件:41](D:/project/ai4math/lean/WidthBounds/AnalyticArithmetic.lean:41) 对任意 Fin a → ℤ | 向量 \(v_0=2n_0+1-2w\)，\(v_i=2n_i+1\)（i>0）；v_0 可以为负。绝不能为应用 Cauchy 默加非负性。 |
| N4.4 \(a+1+\ell<\binom{w+1}{2},a+2\ell\le2\binom{w+1}{3},\ell\le3\binom{w+1}{4}\) | G；all_widths_analytic_bounds，[AllWidths:15](D:/project/ai4math/lean/WidthBounds/AllWidths.lean:15)。纯算术入口 analytic_column_binomial_bounds，[AnalyticArithmetic:128](D:/project/ai4math/lean/WidthBounds/AnalyticArithmetic.lean:128)，输入 w≥4,a≥2,n_0≥1、前缀预算和 N4.2 | 第一项严格，后两项显示非严格；不能把“三界”写成三项都以 < 为最终声明。严格多项式比较见 analytic_polynomial_bound，[同文件:83](D:/project/ai4math/lean/WidthBounds/AnalyticArithmetic.lean:83)。 |
| N4.5 第一项的自然数形式 \(a+1+\ell\le\binom{w+1}{2}-1\) | G；all_widths_strict_improvement，[AllWidths:45](D:/project/ai4math/lean/WidthBounds/AllWidths.lean:45) | N4.4 的直接自然数推论。Q 的三表达式端点是 MonomialInterface.monomialIdeal_all_widths_dimension_bounds，[IdealBounds:137](D:/project/ai4math/lean/WidthBounds/IdealBounds.lean:137)；到 N7 才识别为标准 Tor。M1 新颖性仍是候选。 |

## N5：真实下界族、全部次数预算和精确长度

\[
I_s=(x^iy^jz^k:(i+1)(i+j+k+1)>s^2).
\]

下列不同阈值按源码保留：闭包/有限余长对所有 s，预算只需 s≥1，主模型与精确实际长度用 s≥2。

| 子项：自然语言结论 | 精确假设与 Lean 声明 | 范围边界 |
|---|---|---|
| N5.1 指数条件定义实际理想；标准性恰为乘积≤s² | 任意域、任意 s,i,j,k∈ℕ；Lower.lowerExponentSet、lowerIdeal、monomial3_mem_lowerIdeal_iff、standard_lowerIdeal_iff，[LowerConstruction:19](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:19)、[38](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:38)、[41](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:41)、[48](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:48) | 对禁指数证明上集及 lex，而非只规定希望得到的截面数字。 |
| N5.2 lex、有限余长；初始次数等于 s；s≥2 时 x 标准 | Lower.lowerExponentSet_isUpper、lowerExponentSet_isLex、lowerIdeal_quotient_finite、lowerIdeal_initial_degree、x_standard_lowerIdeal，[LowerConstruction:22](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:22)、[27](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:27)、[74](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:74)、[121](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:121)、[127](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:127) | \(z^{s^2}\in I_s\) 与 lex 性给有限补集；所有总次数≥s² 均禁，亦见 [LowerConstruction:134](D:/project/ai4math/lean/WidthBounds/LowerConstruction.lean:134)。 |
| N5.3 \(H_d(I_s)\le s^2\) 对所有 d；H_0=1 及 \(\sum_{t\le d}H_t\le1+ds^2\) | Lower.lower_hilbert3_le 对任意 s,d；lower_hilbert3_zero、lower_hilbert3_budget 需 s≥1，[LowerProfile:30](D:/project/ai4math/lean/WidthBounds/LowerProfile.lean:30)、[58](D:/project/ai4math/lean/WidthBounds/LowerProfile.lean:58)、[73](D:/project/ai4math/lean/WidthBounds/LowerProfile.lean:73)。真实维数接口 Lower.lowerIdeal_finrank_budget，[LowerConstructionBounds:125](D:/project/ai4math/lean/WidthBounds/LowerConstructionBounds.lean:125) | 逐次计数用注入 (i,j)↦i(d+1)+j 到长度 s² 的区间；没有只检查有限前缀。 |
| N5.4 s²≤w 时同一理想满足 w 预算，s≥2 时属于主类 | 任意域，s≥1,s²≤w，任意 d；Lower.lowerIdeal_finrank_budget_of_square_le，[LowerConstructionBounds:135](D:/project/ai4math/lean/WidthBounds/LowerConstructionBounds.lean:135)。完整 C 的结构版 LexExtremal.lower_admissible，[LexGrowthTheta:47](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:47) 需 s≥2 | 平方预算族可以进入更大的任意整数预算，不要求 w=s²。 |
| N5.5 \(h_d=\min(d+1,\lfloor s^2/(d+1)\rfloor)\)；\(n_i=\lfloor s^2/(i+1)\rfloor-i\) | Lower.lower_hilbert2_eq，[LowerProfile:103](D:/project/ai4math/lean/WidthBounds/LowerProfile.lean:103) 对任意 s,d；Lower.lower_columnLength_eq，[LowerConstructionBounds:87](D:/project/ai4math/lean/WidthBounds/LowerConstructionBounds.lean:87) 需 s≥2，i 任意 | Lean 减法是自然数截断减法；i<s 时没有截断损失，i≥s 的列长为零。 |
| N5.6 \(\ell_s=\sum_{i<s}(\lfloor s^2/(i+1)\rfloor-i)\) 是完整实际截面维数 | Lower.lowerSectionLength 定义，[LowerConstructionBounds:56](D:/project/ai4math/lean/WidthBounds/LowerConstructionBounds.lean:56)；Lower.lowerIdeal_xy_finrank，[同文件:155](D:/project/ai4math/lean/WidthBounds/LowerConstructionBounds.lean:155)，任意域、s≥2 | 不只是某个截断的长度。与经典除数求和函数 D(s²) 的恒等式 \(\ell_s=(D(s^2)+s)/2\) 属传统计数解释，未列为本轮新增 Lean 声明。 |
| N5.7 \(s^2H_s^{\mathrm{harm}}\le\ell_s+(s^2+s)/2\) | Lower.lowerSectionLength_harmonic，[LowerConstructionBounds:73](D:/project/ai4math/lean/WidthBounds/LowerConstructionBounds.lean:73) 对任意 s；实际维数版 lowerIdeal_xy_harmonic_lower，[同文件:165](D:/project/ai4math/lean/WidthBounds/LowerConstructionBounds.lean:165) 需 s≥2 | 精确有理数估计；M3 的实际可行族为候选增量，除数计数及其经典渐近不作首创主张。 |

主文式(5.2)的 \(H_d^{(s)}=h_d^{(s)}(d+1)-h_d^{(s)}(h_d^{(s)}-1)/2\) 是这个族完整前置 x 列的直接计数等式；本表对应源码独立端点为精确 h_d、逐次 H_d≤s² 及所有次数预算，不宣称另有一个独立已编译的 H_d 等式。

## N6：非平方宽度下界、最大值达到及标准 Theta

| 子项：自然语言结论 | 精确假设与 Lean 声明 | 范围边界 |
|---|---|---|
| N6.1 \(s=\lfloor\sqrt w\rfloor\ge2,s^2\le w\)；\(\ell_s\ge w\log(w)/16\) | w∈ℕ,w≥64；LogLower.sqrt_admissible、lowerSectionLength_log_lower，[LogLower:21](D:/project/ai4math/lean/WidthBounds/LogLower.lean:21)、[53](D:/project/ai4math/lean/WidthBounds/LogLower.lean:53)；任意域的实际版本 LogLower.lowerIdeal_xy_log_lower，[同文件:87](D:/project/ai4math/lean/WidthBounds/LogLower.lean:87) | Nat.sqrt 是整数平方根；不只对平方 w。前驱估计 \(s^2\log(s+1)\le\ell_s+(s^2+s)/2\) 是 [LogLower:37](D:/project/ai4math/lean/WidthBounds/LogLower.lean:37)。 |
| N6.2 所有实际 C 理想取得的 ell 构成非空有界自然数集；上确界实际达到 | LexExtremal.lengthSet、maxLexLength 定义，[LexGrowthTheta:40](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:40)、[45](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:45)；任意域、w≥4 的 lengthSet_nonempty、lengthSet_bddAbove、maxLexLength_mem、maxLexLength_isGreatest，[同文件:59](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:59)、[62](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:62)、[70](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:70)、[77](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:77) | 取最大值是有界自然数集的标准结论；不是枚举算法，也不提供显式极大理想。下界族未被声称对每个 w 精确极大。 |
| N6.3 \(w\log(w)/16\le M_K(w)\le10w\log(w)\) | 任意域、w≥64；LexExtremal.maxLexLength_log_bounds，[LexGrowthTheta:100](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:100)。单独上界 maxLexLength_le_log 在 w≥4 成立，[同文件:82](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:82) | 相同实际类，同一个预算参数，不是换成任意 Hilbert 数列的放宽极值。 |
| N6.4 标准 Asymptotics.IsTheta Filter.atTop (fun w : ℕ => (maxLexLength K w : ℝ)) (fun w : ℕ => (w : ℝ) * Real.log (w : ℝ)) | 任意域 K；LexExtremal.maxLexLength_isTheta，[LexGrowthTheta:108](D:/project/ai4math/lean/WidthBounds/LexGrowthTheta.lean:108) | 已连接 mathlib 标准渐近对象。端点是截面最大值；没有另建全部 Betti 极值函数的 Theta，也不是半群极值下界。 |

## N7：具体分解到标准 Tor 的实际链

以下结论共同支撑传统已知四秩公式的形式化实现。**纸面可以用 CMS 式(7)解释公式；Lean 走自己的具体 d1、d2、d3 路线，不能因此说 CMS 的纸面每一步已逐字形式化。** F1 的增量候选是具体证明和接口整合，非创造 Tor、有限分解或 lex Betti 公式。

主文 N7a 的完整极小边界也有既有证明入口：在 D 的相应条件下，MonomialInterface.column_strictAnti_of_initial（i<i′<a）、isMinimalExponent_xy_boundary（i<a）、isMinimalExponent_zThreshold（xy 标准位置）分别见 [GeneratorMinimality:71](D:/project/ai4math/lean/WidthBounds/GeneratorMinimality.lean:71)、[85](D:/project/ai4math/lean/WidthBounds/GeneratorMinimality.lean:85)、[124](D:/project/ai4math/lean/WidthBounds/GeneratorMinimality.lean:124)；全部极小指数恰为边界的双向等价是 MonomialInterface.mem_boundaryExponents_iff_isMinimal，[GeneratorExact:124](D:/project/ai4math/lean/WidthBounds/GeneratorExact.lean:124)，需要 D，不需要 hSpan/hI。

| 子项：自然语言结论 | 精确假设与 Lean 声明 | 来源/尚缺桥 |
|---|---|---|
| N7.1 实际 d1 的像为 I；d2 的像为完整 d1 核 | d1 在任意有限指数集 E 与 hSpan 下：MonomialPresentation.range_differential_eq_ideal、presentation_exact，[FiniteMonomialPresentation:82](D:/project/ai4math/lean/WidthBounds/FiniteMonomialPresentation.lean:82)、[136](D:/project/ai4math/lean/WidthBounds/FiniteMonomialPresentation.lean:136)。d2 使用 D（无需 hSpan/hI）：MonomialPresentation.range_secondDifferential，[MonomialFirstSyzygies:186](D:/project/ai4math/lean/WidthBounds/MonomialFirstSyzygies.lean:186)，secondPresentation_exact，[同文件:219](D:/project/ai4math/lean/WidthBounds/MonomialFirstSyzygies.lean:219) | 是所有多项式系数的核/像结论，不限于若干测试关系。边界集合、关系指标定义见 [BoundaryGenerators:15](D:/project/ai4math/lean/WidthBounds/BoundaryGenerators.lean:15)、[BoundarySyzygies:16](D:/project/ai4math/lean/WidthBounds/BoundarySyzygies.lean:16)。 |
| N7.2 d3 列存在，三角支撑、核身份与 m 系数同时成立 | D（无需 hSpan/hI）；MonomialPresentation.exists_lexThirdColumn、lexThirdColumn_spec，[BoundaryThirdDifferential:150](D:/project/ai4math/lean/WidthBounds/BoundaryThirdDifferential.lean:150)、[246](D:/project/ai4math/lean/WidthBounds/BoundaryThirdDifferential.lean:246)；选择定义 lexThirdColumn 见 [同文件:238](D:/project/ai4math/lean/WidthBounds/BoundaryThirdDifferential.lean:238) | 已证存在后使用 Classical.choose。不能称规范可执行矩阵算法；未证明与经典 EK 指定基的矩阵逐项同一。 |
| N7.3 range(d3)=ker(d2) 且 d3 单射 | D（无需 hSpan/hI）；MonomialPresentation.range_lexThirdDifferential、lexThirdDifferential_injective，[BoundaryThirdDifferential:275](D:/project/ai4math/lean/WidthBounds/BoundaryThirdDifferential.lean:275)、[286](D:/project/ai4math/lean/WidthBounds/BoundaryThirdDifferential.lean:286)；范畴 exact 端点 lexThird_exact，[同文件:335](D:/project/ai4math/lean/WidthBounds/BoundaryThirdDifferential.lean:335) | 一般三角归纳入口为 [TriangularSecondSyzygies:228](D:/project/ai4math/lean/WidthBounds/TriangularSecondSyzygies.lean:228)、[262](D:/project/ai4math/lean/WidthBounds/TriangularSecondSyzygies.lean:262)。 |
| N7.4 构造实际商 A/I 的标准投射分解 P；各项 A 有限自由，四秩 \(1,a+1+\sum n_i,a+2\sum n_i,\sum n_i\)，4 次起实际零 | D 加 hSpan；MonomialPresentation.lexQuotientResolution，[LexQuotientResolution:24](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:24)，lexQuotientResolution_free、lexQuotientResolution_finite，[同文件:38](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:38)、[43](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:43)，lexQuotientResolution_rank_zero、lexQuotientResolution_rank_one、lexQuotientResolution_rank_two、lexQuotientResolution_rank_three，[56](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:56)、[62](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:62)、[69](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:69)、[76](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:76)，lexQuotientResolution_zero_tail，[52](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:52) | FiniteThreeResolution.resolution，[FiniteThreeResolution:189](D:/project/ai4math/lean/WidthBounds/FiniteThreeResolution.lean:189)，是**输入给定正合/单射**的打包器；这里由 N7.1–N7.3 供给证明，不能仅引打包器冒充已证明 lex 正合。 |
| N7.5 所有微分模 m 为零；C 自动给所需具体分解及真实 ell 秩 | D+hSpan+hI：MonomialPresentation.lexQuotientResolution_residue_d_zero，[LexQuotientResolution:85](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:85)。C：MonomialPresentation.finiteColength_exists_residue_minimal_resolution，[同文件:98](D:/project/ai4math/lean/WidthBounds/LexQuotientResolution.lean:98) | 这里“最小”是残差微分零；未注册完整 graded shifts、分次 Betti 表或一般 graded 最小性分类。A 有限自由本身不意味着 K 有限。 |
| N7.6 标准 Tor 与残差张量复形同调同构；零微分时同构于第 n 项 | 任意域、实际 I、P : ProjectiveResolution (ModuleCat.of A (A ⧸ I))、任意 n；MonomialInterface.idealQuotientTorIsoHomology，[MinimalResolutionTor:56](D:/project/ai4math/lean/WidthBounds/MinimalResolutionTor.lean:56)。加 hzero : ∀ i j, residueTensorFunctor.map (P.complex.d i j) = 0 后用 idealQuotientTorIsoResidueTensor、idealQuotientTorEquivResidueTensor，[同文件:68](D:/project/ai4math/lean/WidthBounds/MinimalResolutionTor.lean:68)、[80](D:/project/ai4math/lean/WidthBounds/MinimalResolutionTor.lean:80) | 直接复用 mathlib P.isoLeftDerivedObj、HomologyData.ofZeros 和 restrictScalars.mapIso；前两接口不需要自由或有限性。 |
| N7.7 残差张量确为 K 有限，其 K 维数等于原项的 A 自由秩 | 任意域、M : ModuleCat A，[Module.Free A M] [Module.Finite A M]；MonomialInterface.residueTensorFreeCoordinates、residueTensor_free_finite、finrank_residueTensor_free，[ResidueFreeDimension:38](D:/project/ai4math/lean/WidthBounds/ResidueFreeDimension.lean:38)、[51](D:/project/ai4math/lean/WidthBounds/ResidueFreeDimension.lean:51)、[58](D:/project/ai4math/lean/WidthBounds/ResidueFreeDimension.lean:58) | 使用实际 \(A/\mathfrak m\simeq_K K\)，见 variableResidueEquiv，[VariableResidue:54](D:/project/ai4math/lean/WidthBounds/VariableResidue.lean:54)。不是搬运期望维数来定义 K 作用；仍专门化到三变量环。 |
| N7.8 C 中所有次数 Tor 为 K 有限，四维数 \(1,a+1+\ell,a+2\ell,\ell\)，n≥4 为实际 IsZero | MonomialPresentation.finiteColength_higherTor_dimensions，[HigherTorBounds:108](D:/project/ai4math/lean/WidthBounds/HigherTorBounds.lean:108)，准确输出存在 a≥2、a 的首禁性质、∀ j, Module.Finite K (...)、0/1/2/3 维数及 ∀ j, IsZero (IdealQuotientTor I (j + 4))。无预算的边界版本 lexQuotient_tor_dimensions，[同文件:74](D:/project/ai4math/lean/WidthBounds/HigherTorBounds.lean:74) 需 D+hSpan+hI | 高次 IsZero 强于单独 finrank=0；后者在未证有限时不能替代零性。精确公式传统已知：[CMS v2 Lemma 4.2 式(7)](https://arxiv.org/html/2307.05770v2#S4.E7) 计算的是理想 I，转商需 \(b_i(A/I)=\beta_{i-1}(I)\)（i≥1）。 |
| N7.9 标准 Tor 的第一严格、后两非严格二项式界，及所有正次数统一式 | C；MonomialPresentation.finiteColength_higherTor_width_bounds，[HigherTorBounds:137](D:/project/ai4math/lean/WidthBounds/HigherTorBounds.lean:137)，同时返回所有次数 K 有限与高次 IsZero。C 加任意 i≥1：finiteColength_tor_all_positive_bounds，[同文件:170](D:/project/ai4math/lean/WidthBounds/HigherTorBounds.lean:170)，输出 \(b_i\le i\binom{w+1}{i+1}\) | N4+N7.8 的标准 Tor 实例化；尾部不是只编译有限 i 的证书。不能延长为 i≥0 的统一界，因为 b_0=1。 |

**Tor 对象必须原样保留。** MonomialInterface.IdealQuotientTor 的定义 [MinimalResolutionTor:35](D:/project/ai4math/lean/WidthBounds/MinimalResolutionTor.lean:35) 是标准 CategoryTheory.Tor，**第一因子 \(A/\mathfrak m\)，派生第二因子 \(A/I\)**。IdealQuotientTorK [同文件:44](D:/project/ai4math/lean/WidthBounds/MinimalResolutionTor.lean:44) 沿真实 algebraMap K A 限制标量。文献通常写 \(\operatorname{Tor}_i^A(A/I,K)\)，传统上可换因子，但当前代码未新增一般 Tor 因子交换/平衡同构；不能把未证明的代码同构写成 definitional equality。n=1 与旧端点的兼容见 idealQuotientTorK_one，[同文件:51](D:/project/ai4math/lean/WidthBounds/MinimalResolutionTor.lean:51) 及 higherTor_one_dimension_compatibility，[HigherTorBounds:22](D:/project/ai4math/lean/WidthBounds/HigherTorBounds.lean:22)。

固定库与传统来源的逐项分析见 [R098](D:/project/ai4math/research/tasks/R098_formal_contribution_audit.md)。一般 stable/EK 分解、与 EK 具体微分的链同构和通用 Tor 平衡均未在本轮补上；EK 原文未取得，不能给出未经核实的原文微分编号。

## N8：三条谐和 Betti 推论的声明状态

在 C 中记 \(B(w)=(2w-1)H^{\mathrm{harm}}_{2w-1}\)。N1.4、N2.5、N7.8 给出

\[
b_1\le4w-1+B(w),\qquad
b_2\le7w-2+2B(w),\qquad
b_3\le3w+B(w).
\]

| 子项 | 精确源码依据 | 本轮可以声称的层级 |
|---|---|---|
| N8.1 第一条 | C 的 MonomialInterface.finiteColength_torOne_bounds，[TorOneBounds:123](D:/project/ai4math/lean/WidthBounds/TorOneBounds.lean:123)，已经直接输出第一条有理谐和界。组合表达式入口 generator_expression_le_harmonic，[GeneratorNumberBounds:53](D:/project/ai4math/lean/WidthBounds/GeneratorNumberBounds.lean:53) | 既有 Lean 已编译端点；通过 N7 的 n=1 定义兼容可与统一 Tor 记号对应。 |
| N8.2 第二条 | finiteColength_higherTor_dimensions 的 b2 等式 + initial_degree_le_width_sub_two_of_budget + quotient_xy_le_harmonic | 既有 Lean 成分的直接数学复合，**没有声称本轮新增独立的 b2 谐和 Lean 定理**。 |
| N8.3 第三条 | finiteColength_higherTor_dimensions 的 b3=ell + quotient_xy_le_harmonic | 同上，未冒称新独立编译端点。 |
| N8.4 三个固定正次数均为 \(O(w\log w)\) | N3 和上列显式公式的直接推论 | 不是另一个全部 Betti 极值函数的已注册 IsTheta；N6 的标准 IsTheta 端点仅针对实际截面最大值。经 N9 转移的半群 O 界属于传统应用。 |

这些公式不意味着谐和式在每个小 w 都比二项式式更小。M2 比较基线必须包含 [CMS v2 §5 式(19)](https://arxiv.org/html/2307.05770v2#S5.E19) 的 \(O(w^{3/2})\) 路线；不能只与粗二项式界比较后宣称此前完全没有次二次估计。

## N9：四生成元半群的传统转移及 w=3

本节没有对应的端到端 Lean 定理。准确对象为任意域 K、恰有四个最小生成元 \(g_0<g_1<g_2<g_3\) 的数值半群 Γ，\(m=g_0,w=g_3-g_0\ge3\)，\(R=K[[t^\Gamma]],P=K[[X_0,X_1,X_2,X_3]]\)。目标是表示环 P 上 R 的 Betti 数 \(\beta_i^P(R)\)，**不是** \(\operatorname{Tor}_i^R(K,K)\)。

| 子项：传统步骤 | 完整条件、来源与输出 | 尚缺的 Lean 桥 |
|---|---|---|
| N9.1 参数约化保持 Betti | 以 t^m 为 R 上非零因子，相应 X0 在 P 上也正则；得到 Artinian R/(t^m)，长度 m，最小表示无一次项。[CMS v2 §2](https://arxiv.org/html/2307.05770v2#S2) | 半群环、局部表示、正则参数约化及其标准 Tor 比较未接到本项目 Lean。 |
| N9.2 转关联分次、revlex 初始理想、lex 保持 Hilbert 并增大 Betti | 在三变量多项式环依次取 G、J、L；有限长度与一次分量保持；对所有 i≥1，\(\beta_i^P(R)\le b_i(A/L)\)。[CMS 式(1)](https://arxiv.org/html/2307.05770v2#S3.E1) 与 [Theorem 2.1](https://arxiv.org/html/2307.05770v2#S2.Thmthm1)；一般特征用 Pardue 版本 | 关联分次/Gröbner/Bigatti–Hulett–Pardue 比较仍为传统引用；不要求切锥 Cohen–Macaulay，也不声称局部环与切锥 Betti 相等。 |
| N9.3 w≤m−2 分支的所有次数预算 | [CMS Theorem 3.3](https://arxiv.org/html/2307.05770v2#S3.Thmthm3) 给 J 的 HS(d)≤1+dw；同 Hilbert 函数使 L 继承，且 L 有限余长、无一次项 | 不能把该定理的 w≤m−2 条件省略；其预算到实际 Q_d 的本项目接口仅在已经给定 S 后见 N0。 |
| N9.4 w≥m−1 分支 | 同一 lex 商的总长度 m 给 d≥1 时 HS(d)≤m≤w+1≤1+dw，d=0 为1，因此 w≥4 时仍可进入 C 并用谐和界；二项式界亦可直接用 [CMS Corollary 2.4](https://arxiv.org/html/2307.05770v2#S2.Thmthm4) | 长度预算这一步是已有传统对象上的初等推论，未写成新 Lean 半群接口，也不是 Thm3.3 的扩大版本。 |
| N9.5 w≥4 的结论 | N9.1–N9.4 + N7.9 给全部 i≥1 的二项式界（第一项严格）；N8 给 i=1,2,3 的明确谐和式与 O(w log w)；高次由投射维数3消失 | 这些是传统转移后的应用；不能写成原半群链端到端 Lean，也不能从 lex 的下界族反向推出半群下界。 |
| N9.6 w=3 | 四个互异生成元只能是 m,m+1,m+2,m+3；[Herzog–Stamate v3 Proposition 2.7，印刷页9](https://arxiv.org/pdf/1308.4644v3#page=9) 对 r 个等差最小生成元给 \(\beta_i(K[\Gamma])\le i\binom r{i+1}\)（1≤i≤r−1），取 r=4；在齐次极大理想局部化并完备化保持最小分解总秩；i≥4 消失 | 独立传统分支，不能向 C 的 Lean 定理传 w=3。这里不额外宣称第一项严格或同一明确谐和常数；一个有限宽度分支不影响渐近 O 结论。 |

传统接口的首次本地逐项核验见 [algebra_bridge_audit](D:/project/ai4math/research/algebra_bridge_audit.md)。该旧报告末尾关于当时 Lean 覆盖面的描述属于旧时间点；N0–N8 的后续实际 lex/Tor 形式化已经完成，但 N9 所列半群桥仍未完成。CMS v2 的式(7)为理想 Betti，引用到商时必须右移一阶，不能省去该指标转换。

## 贡献标签与未排除项仍有效

[CONTRIBUTION_MAP](D:/project/ai4math/research/publication/CONTRIBUTION_MAP.md) 的 M1/M2/M3/F1 不因本映射而升级为首创认证：N4/N7.9 为全宽度严格界候选；N2/N3/N8 为明确谐和解析控制及直接推论；N5/N6 为真实可行族与匹配阶候选；N7 为传统已知公式的具体形式化实现。传统除数和、自然数有界集取最大、标准 Tor/同调/张量接口均不作新发明。

必须随主文保留 U1–U5：U1 White 2021 博士论文全文未取得；U2 旧算法的精确编码/解析推论未排除；U3 相近极值和下界构造变体未排除；U4 与 EK/cellular/Schreyer 的具体方法同一性未审完；U5 跨库工程覆盖未审完。White 2020 算法结合 \(L+\mathfrak m^{2w+1}\) 截断已有固定 w 优化路径，不能以原总长度无界排除它，亦不能声称首次可计算。相关截断保留总 Betti 而非分次 Betti 表；这条比较观察没有被本轮写成新的 Lean 声明或执行算法。

本映射不授权下一项形式化、作者确认、投稿或外联；R092 完成后交根验收并停止。

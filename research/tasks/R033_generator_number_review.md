# R033：任意多项式最少生成数独立审查

状态：最终接受。纸面证明、冻结源码语义及统一构建证据均已独立核对；本轮最少生成数主定理已 Lean 编译。2026-09-23。A–F保留审查过程，最终证据与结论见G。

本任务只编辑本报告，不改源码、根 import、状态文件、claims、队列或冻结稿件；未派生子智能体。已读 AGENTS、STATE、HANDOFF、queue、R031计划、R028 B–C节，以及相关真实理想接口和 GeneratorExact。独立运行检查点检查：队列有效、旧归档完整；工作区差异为根已登记的新执行/WIP，不是归档损坏。没有浏览互联网或进行新枚举。

## A. 纸面命题与真实多项式支持

令 K 为域，A=K[x,y,z]，S⊆ℕ³ 为指数上集，I 为系数1单项式生成的实际理想 `monomialIdeal S`。令 E 为有限指数集合，每个 e∈E 满足现有定义：x^e∈I，且 f≤e、x^f∈I 蕴含 f=e。下界本身不需要 E 已穷尽所有极小指数；上界达到性则需要另外知道所列单项式生成 I。

定义 K 线性映射 F:A→K^E，F(p)(e)=coeff_e(p)。它在全多项式空间上有定义，但乘法降为常数作用的性质只要求、也只能按本路线对 p∈I 使用。没有把一般 lex 条件当成单项式理想的替代条件。

对 p∈I，现有 `mem_monomialIdeal_iff_support S hUp p` 给出 p 的**每个非零支持指数** f 都属于 S；再由 `monomial_mem_monomialIdeal_iff` 得 x^f∈I。因此当 f≤e 且 e 极小时，有 f=e。这一步从任意实际多项式 p 出发，不能只检查 p 本身为单项式。

对任意 q∈A 与 e∈E，乘积系数展开为

    coeff_e(qp) = Σ_(u+v=e) coeff_u(q) coeff_v(p).

若 coeff_v(p)=0，对应项消失；否则 v 属于 p.support，从 u+v=e 得 v≤e，上段推理给 v=e，再由自然数指数的可消去性给 u=0。所以唯一可能保留的项是 (u,v)=(0,e)，其值正是 constantCoeff(q)·coeff_e(p)。这明确核对了卷积中第二个指数对应 p，第一个对应 q。若实现选用乘法交换后的公式，必须相应交换两个系数的位置，不能对 q 的支持擅自使用 p∈I。

## B. 实际理想上的满射

给任意 v:E→K，取 p=Σ_(e∈E) v(e)x^e。每个 x^e 实际属于 I，所以各标量倍及有限和都属于 I。不同 e 对应不同指数，系数提取给 F(p)(e)=v(e)，因此是

    ∀ v, ∃ p, p∈I ∧ F(p)=v,

而不是仅证明 F 在全多项式空间上满射。该证明不需要 E 的穷尽性，也不需要强加所有极小指数次数相同。乘系数仍是域上的 K 标量乘法。

## C. 任意理想生成系到线性张成系

令 P 为任意有限多项式集合，并假设真实 `Ideal.span (P : Set A)=I`。对每个 g∈P，`Ideal.subset_span` 加上 span 等式给 g∈I。令 W=span_K{F(g):g∈P}。理想 span 归纳中：生成项落入 W；零与加法由 F 的线性性处理；对于任意多项式乘子 q 和已在 I 中的 p，F(qp)=constantCoeff(q)·F(p)，所以仍落在 W。于是 p∈I 蕴含 F(p)∈W。

结合上一节 I 上满射，W=K^E。有限坐标空间维数是 |E|，由有限张成系的维数界得到 |E|≤|F(P)|≤|P|。也可直接将 P 的有限子类型作为张成族索引，从维数不超过索引基数得到同一结果。即使不同生成元有相同或为零的 F 像，也只会减小像集合，不能破坏下界。

P 无单项式、齐次、同次数、非零、线性无关或不可删除假设；组合系数 q 是任意多项式。域、线性空间与维数接口必须在最终源码里真实接通。一般 V 版本如果显式要求有限维，则应用到 V=E→K 时该实例自动存在；若不要求有限维，也可由上述有限张成证明有限维。不能把 Lean 中无限维时自然数 finrank 的退化值误读为一般无限维结论，不过实际有限 E 的最终应用不存在该问题。

## D. 最小值达到性与边界情形

R028已有同一 E 的实际生成集合 G={x^e:e∈E}，其真实 span 为 I。域的非平凡性保证系数1单项式映射单射，所以 |G|=|E|。将本轮对每个 P 的下界与这个 G 的存在合并，才能得到实际生成基数集合的 `IsLeast`；仅证明 G 每项不可删除不够。

建议最终的基数集合明确为 `{n | ∃ P : Finset A, Ideal.span (P : Set A)=I ∧ P.card=n}`（合取次序无关）。`IsLeast` 的成员部分必须由实际 G 给出；最小性部分必须量化所有上述 P。通过 R028的同一 E/G 精确计数，最小值是 a+1+ell；随后用已验收的严格界得该最小值 < choose(w+1,2)。这里不存在由“某个生成系小于上界”直接跳到“任何生成系都小于上界”的推理：冗余生成集合可以任意大。

边界复核：

- E=∅ 时 K^E 是零空间，F在任何 I 上满射为真，下界只是 0≤P.card。若同时要求 G 生成 I，则 I=0；零理想由空集合生成，所以达到最小值0。泛型下界无需排除空 E。
- I=A 时唯一极小指数是0，完整 E={0}，F就是常数系数，乘法公式对任意 p、q成立，G={1}给最小值1。无需为证明强加 I 为真理想。最终宽度定理中的 x 标准条件已排除单位理想。
- 任意非齐次/非单项式 P 可含零或有重复像；Finset 本身去除完全相等的多项式，并不限制上述性质。其生成最小基数与任意有限有重复的列表所能达到的最小长度相同，但本轮只需准确陈述 Finset 结论。
- 空 P 的 span 为零，所以任何非零极小坐标给出的正维数会自动排除空 P，不应暗加非空假设。
- 真实有限余长、lex、w≥4、全次数预算只用于接入R028的 E、计数与严格界；极小系数/线性维数一般引理没有必要携带这些假设。

## E. 冻结前核验清单与结论边界（过程记录）

纸面路线逻辑闭合，没有发现必须修正的数学缺口。最终验收尚需逐项读 PolynomialGeneratorNumber、GeneratingFamilyDimension、GeneratorNumberBounds 的冻结版本：真实支持引理的使用与卷积方向；I上满射的成员合取；span归纳中受限乘法公式的使用前提；有限坐标维数；任意 P 的量词；实际 `IsLeast` 的成员和下界两部分；精确计数/严格界连接。

当时待记录上述源码、根 import/依赖审计及统一构建日志的 SHA-256，核对禁用项与标准逻辑公理，并确认没有用改动前日志给改动后源码作证。在此阶段本报告仅接受**传统纸面路线**，尚未声称本轮新增 Lean 命题已编译；最终核验现已记入G。

本轮目标可以补齐任意有限多项式生成集合的真正最少基数，仍不等于已形式化 I/(x,y,z)I 的商空间识别、Tor/Betti定义或完整半群归约；也没有开展新颖性检索或取得外部专家认可。

## F. 首版源码语义核对与谐和界补充

已逐行审查 PolynomialGeneratorNumber 首次通过编译后的版本。`coeff_mul_of_minimalExponent` 的 `ab.2` 正是 p 的指数；`mem_support_iff`、真实支持判据与单项式成员判据串接到 `he.2`，然后由右消去得到 `ab.1=0`。`Finset.sum_eq_single (0,e)` 的最后分支实际证明该项在 antidiagonal 中，没有漏掉不存在项的处理。`minimalCoefficientMap_exists_preimage_of_mem` 显式构造有限单项式和，用 `I.mul_mem_left (C (v e))` 与 `I.sum_mem`证明在 I 内，再逐坐标证明原像。没有发现语义问题。

已逐行审查 GeneratingFamilyDimension 当前版本。`Submodule.span_induction` 的 smul 分支利用归纳携带的 span 成员 `hp` 和 span 等式恢复 `hpI:p∈I`，所以受限乘法公式调用合法；`hSurj` 明确要求原像属于 I。`finrank_le_card_of_ideal_generators` 显式要求 `Module.Finite K V`，实际以 `P.image F` 的有限 span 维数界及 `Finset.card_image_le`结束，允许不同生成元具有相同或零像。没有发现语义问题。

根新增的精确有理谐和界也已独立核对：真正初始次数 a≥2 时，在 d=a−1 的 Hilbert预算结合 `sum_hilbert3_initial` 给 `choose3(a+2)≤1+(a−1)w`，已有 `alpha_le_width_sub_two` 给 a≤w−2。与已验收 `Growth.sectionLength_le_harmonic` 的 ell≤3w+(2w−1)H_(2w−1)相加，得到

    μ=a+1+ell ≤ 4w−1+(2w−1)H_(2w−1).

`Growth.harmonicQ n` 的定义是 Σ_(r=0)^(n−1) 1/(r+1)，故下标确为通常的 H_n；新比较在 ℚ 中进行，不是浮点近似。w≥4使自然数 `2*w-1` 截断减法与所写数学式一致。这只是旧预算结果和最少生成数识别的组合，不增加 Real.log、Theta、Tor/Betti或半群结论。根当前的 `generatorCardinalities` 与 `isLeast_generatorCardinalities_of_bound` 定义/证明已确认同时包含可达到性和所有 P 的下界；主集成连接仍待最终冻结版本。

本节首次读取的两个核心源码 SHA-256 为 `9d5b7aa03255d6121ee522f009b42c00f40e782e8ae04df74acef97dee777cb1`、`5f972c793efde1bbed65fb1850e9d66c22287096d9a0fbed21062d442e544469`；这是中途识别值，不能代替最终统一日志及冻结核验。

## G. 最终冻结语义、统一构建与接受结论

根通知统一 `lake build` 退出码0后，本审查者重新读取关闭后的日志，确认末尾 `Build completed successfully.`，并独立重算下列 SHA-256。三个新增数学模块的冻结值与构建前根通知的一致；R032相对首次读版只有将不可用的 `Module.finrank_top` 改为正确的 `finrank_top`，证明命题及数学步骤不变。未在冻结后改动源码。

| 文件 | 最终 SHA-256 |
| --- | --- |
| `lean/WidthBounds/PolynomialGeneratorNumber.lean` | `9d5b7aa03255d6121ee522f009b42c00f40e782e8ae04df74acef97dee777cb1` |
| `lean/WidthBounds/GeneratingFamilyDimension.lean` | `f019dbe54192905c2b684e9b16c961ab4786d6c70191c0f0335cc53c99853601` |
| `lean/WidthBounds/GeneratorNumberBounds.lean` | `dd1be04554f6bac8af10f5bcf2268971a8e87e085658de8830a871218d095b45` |
| `lean/WidthBounds/DependencyAudit.lean` | `a6f90cd1a9ccc0f8213054d9ead8276b4134bfd3efd0da5e8f0a448598264679` |
| `lean/WidthBounds.lean` | `b78bc3eb9b575fa659b2c82c6224d76d4e101e90ceb696427ac86773bd91c876` |
| `results/lean_polynomial_generator_number_build.txt` | `b6b48e11dd968c672b3a8c6d9a656937e755c7a40421432a9b3431bb13be7ee1` |

最终集成语义核验：

1. `minimal_exponents_card_le_generators` 的真实输入是任意有限多项式集合 P，只有 `Ideal.span P=monomialIdeal S`；其将 V 实例化为有限 E 的函数空间，接入 R031 的实际乘法公式和 I 上满射，再用 `Module.finrank_fintype_fun_eq_card` 与 `Fintype.card_coe` 得 E.card≤P.card。没有把系数映射的性质重新作为未证明的模型假设。
2. `isLeast_generatorCardinalities_of_minimal_exponents` 同时使用实际 G=exponentMonomials E 的 span 等式、实际基数等式与上述对所有 P 的下界，得到 `IsLeast ... E.card`。这是能达到的全体有限多项式生成系最小基数，不是单纯不可删除性。
3. `finiteColength_generator_number_bounds` 明确保留域、指数上集、lex、真实商环 `Module.Finite`、x标准、w≥4、全部次数真实商空间维数累计预算。它从R028同一 E 取得完整极小指数分类、实际span、G基数及严格界；逐项接入后得真正最小值 μ=a+1+finrank_K(xySubspace I)，其中 a≥2 为初始纯x禁指数，同时 μ<choose(w+1,2) 及精确有理谐和界。有限余长没有被预算替代，x标准及所有次数预算没有悄然减弱。

日志中本轮九条 `#print axioms`（R031四条、R032两条、根集成三条）均仅输出 `propext`、`Classical.choice`、`Quot.sound`。新增三模块重新扫描 `sorry|admit|native_decide|^axiom` 无命中（rg无匹配返回1是正常无命中，不是编译失败）。已读根 import 与 DependencyAudit 代码：两个新增被审计根为 `minimal_exponents_card_le_generators`、`finiteColength_generator_number_bounds`；其实际传递声明依赖禁止旧有限证书/小宽度证书及 `sorryAx`，统一日志确认这些检查通过。根库仍导入历史小宽度模块，并不意味着新主定理使用它们；依赖审计检查的是声明依赖而非仅看 import 文本。

**最终结论：接受，无待修正的数学或量词问题。** 现在可以将“任意有限多项式生成系的真正最少基数及两个上界”列为本轮已 Lean 编译且经独立内部语义审查的结果。空 E/零理想、单位理想等一般引理边界已在纸面逐项核对，未额外为这些特例新增单独 Lean 定理。依然不得写成 Tor/Betti定义识别、半群完整归约、Real.log/Theta形式化、原创性认证或人类外部审稿；冻结v0.1/v0.2稿件也不因此自动更新。

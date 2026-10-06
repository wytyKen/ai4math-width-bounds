# R025：真实lex理想生成集合计数

状态：已完成并经根智能体验收，2026-09-23。R026独立语义审查接受；新增三模块已纳入统一构建。

本轮调整：先完成显式生成集合上界，不先证明极小性。已采用纯x幂、所有 `i<a` 的xy列边界、每个标准xy单项式的最小z阈值三部分；生成性直接按x指数、y列界分为三类，用实际理想内单项式整除闭性完成。

实际接口：`monomialIdeal_exists_generators_of_columns` 先对任意交换半环与列函数 `n` 给出 `Ideal.span G = monomialIdeal S` 及 `G.card ≤ a+1+∑_{i<a}n_i`，然后 `monomialIdeal_exists_generators_le` 在 `hUp`、lex、`w≥4`、全部次数Hilbert预算、纯x幂成员与显式纯z幂成员存在性下连接 `sectionLength`。不要求a最小，不要求初始区间标准，不声称极小生成集合或Betti识别。

## 最终精确命题与构造

源码命名空间：`WidthBounds.MonomialInterface`。

1. `exists_vertical_mem`：对于任意交换半环上的实际理想I，若存在b使系数1纯z幂 `monomial3 0 0 b∈I`，则每对i、j均存在k使 `monomial3 i j k∈I`。
2. `zThreshold`：用 `Nat.find` 定义该k的最小值。`zThreshold_mem` 证明阈值在I；`zThreshold_le` 证明任意I中该列指数都不少于阈值。
3. `monomialIdeal_exists_generators_of_columns`：R仅需 `CommSemiring`。给定任意S、自然数a、列长函数n，假设 `x^a∈monomialIdeal S`、存在纯z幂成员，以及所有i、j满足 `standard I i j 0 ↔ j<n i`。结论存在有限多项式集合G，G中每项均明确是系数1单项式，`Ideal.span (G:Set _) = monomialIdeal S`，且 `G.card≤a+1+∑ i∈range a,n i`。
4. `monomialIdeal_exists_generators_le`：R为非平凡交换半环；S向上闭且同次lex向上闭；`w≥4`；每个次数d的累计 `hilbert3` 不超过 `1+d*w`；`x^a`在理想中；显式假设存在纯z幂成员。结论同3，计数上界换为 `a+1+sectionLength (standard I) w`。
5. `monomialIdeal_exists_generators_finrank_le`：K为域，将预算换为真实 `quotientHomogeneous` 的累计K维数，将结论计数上界换为 `a+1+Module.finrank K (xySubspace I)`；其余条件与4相同。

构造细节：

- B包含所有 `i<a` 的 `x^i*y^(n i)`。
- C为有限sigma索引 `{(i,j): i<a, j<n i}`；V是C在 `x^i*y^j*z^(zThreshold I hZ i j)` 下的像。
- `G = insert x^a (B ∪ V)`；允许重复候选在Finset中合并，因而给出上界而不强行给出相等或极小性。
- 每项属于I，故 `span G≤I`。反向按任意S中的指数e分类：若 `a≤e 0` 则 `x^a`整除；否则若 `n(e 0)≤e 1` 则列边界整除；否则对应V中项的z阈值不超过 `e 2`，故V中项整除。再用 `Ideal.span_le` 将所有原始单项式生成元包含关系提升为真实理想相等。
- B.card≤a、V.card≤∑n_i；`sum_columns_eq_sectionLength` 将列长和转为已证截面长度。无需证明任何极小性。

## 编译与公理核查

工作目录 `D:\project\ai4math\lean`；命令：

```text
lake env lean WidthBounds/MinimalGenerators.lean
```

最后一次执行退出码0，输出为三个主定理的 `#print axioms`；每个定理均仅依赖：

```text
propext, Classical.choice, Quot.sound
```

源码SHA-256：`9E2FE3D4F65B4218C690CA4606C882007534175B2F55DDDB9A11B9736D93083B`。

静态搜索 `sorry|admit|axiom|native_decide` 只有三行 `#print axioms` 命中；没有禁止项。命令输出本报告记录，最终独立构建日志由主智能体保存，报告不冒充全库构建证据。

## 尝试、限制、下一步

初次编译因Nat.find谓词缺少经典可判定实例失败；仅在阈值定义及两个阈值引理加入 `classical`，随后整个核心编译通过。补充finrank版本后再编译通过；无其他失败路线，无增设研究假设。

未证明：G极小、G.card精确值、任意多项式生成元的最少个数、Betti数/自由分解/Tor识别。`a`不必为最小纯x禁指数。纯z幂成员属于单独假设；不能由当前线性HS预算擅自推出。

根已在新模块 `GeneratorBounds.lean` 接入已有严格choose界和 `FiniteColength.lean` 的 `Module.Finite`→纯z幂接口；详见下节。

## 根集成与最终验收

`GeneratorBounds.lean` 的 `monomialIdeal_exists_generators_card_lt` 以域K、指数上集S、lex、x标准、存在纯z幂成员、w≥4和全部次数的真实齐次商空间维数预算为假设，构造有限系数1单项式集合G，证明其实际 `Ideal.span G = monomialIdeal S` 且 `G.card < (w+1).choose 2`。初始次数a由已有真实理想接口构造，没有把任意大a传入严格组合界。

`finiteColength_exists_generators_card_lt` 将纯z幂成员替换为实际商环的 `Module.Finite K` 假设，调用R027接口。这个最终命题不是仅对自定义组合计数的上界，而是实际多项式理想的有限生成集合上界；仍未声称极小性、精确生成元数、Betti数或完整半群定理。

最终根验收命令：在 `lean/` 运行 `lake build`，返回0。完整日志 `results/lean_generators_build.txt`，SHA-256为 `878b961412ef4152a7d7138e275551592017f16db07dff3f84859fbe84b0633e`。新主定理仅依赖 `propext`、`Classical.choice`、`Quot.sound`；实际传递声明依赖审计确认没有旧有限枚举证书和 `sorryAx`。根import已集成三个新模块。

运行说明：Python封装在lake成功退出且完整日志关闭保存之后，打印含Unicode符号的日志尾部时遇GBK编码错误；该错误未影响Lean构建或日志文件。随后直接读取日志确认成功及哈希，没有为此重复构建。

独立审查报告：`research/tasks/R026_generator_review.md`。下一项R028优先形式化整除极小单项式集合与精确计数，保持它与任意多项式最少生成数及Betti识别的区别。

## 原恢复种子（保留其极小性路线为后续工作）

优先目标：对已有真实monomialIdeal S，在明确有限余长条件（或足够的纯z幂成员条件）下构造有限单项式生成集合，证明数量不超过 `a+1+ell`。这样可继续连接关系数，避免立即搭建完整Tor/自由分解基础设施。

建议拆分：

1. xy截面的列长度n_i严格递减；z=0的边界单项式应有a+1个。利用标准单项式同次lex向下闭：`x^(i+1)y^j`标准迫使`x^i y^(j+1)`标准。
2. 对每个标准xy单项式u，利用纯z幂在理想内及向上闭性，定义最小正t使`u*z^t`进入理想。
3. 证明该单项式所有直接因子均标准。除z由最小性；若除x或y后仍在理想，lex向上把一个z换回x/y会迫使`u*z^(t-1)`也在理想，矛盾。
4. 反向把每个含z的极小单项式生成元对应到其标准xy部分，得到与标准xy集合的双射。
5. 用次数良基归纳证明这些极小单项式确实生成实际Ideal.span，不能只数一个未证明生成的边界集合。

若本轮只能得到明确生成集合的上界，也应如实交付；精确极小性、最少任意多项式生成元数、Betti数识别是不同层次，不要混称。

可复用：MonomialInterface 的成员/整除判据，MonomialBasis 的真实商环基，IdealBounds 的实际xy子空间维数，ColumnBounds 的列结构及截断。原理想有限余长必须单独保留；仅线性HS预算不能排除无限标准z幂。

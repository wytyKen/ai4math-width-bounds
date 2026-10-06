# ai4math 研究全过程、最终边界与后续扩展报告

版本：研究交付 v0.3；基准日期：2026-09-29（Asia/Shanghai）。本报告供脱离聊天记录后的独立阅读、复核与接续研究使用。数学证据基线为 [claims.json](claims.json) 中 C001–C023 及统一日志 [lean_lex_theta_build.txt](../results/lean_lex_theta_build.txt)。

用户已经选择以“研究交付”结束本阶段：整理最终结论、全过程、文稿和可复核归档，不再自动增加数学子题。这里的结束不表示原数值半群定理已经端到端 Lean 形式化，也不表示获得人类同行认可或确认原创性。v0.3文稿与载荷准备验收见 [DELIVERY.md](DELIVERY.md)、[R049 收尾记录](tasks/R049_delivery_closeout.md) 和 [R051 独立交付审查](tasks/R051_delivery_audit.md)；最终ZIP字节校验数值以包外 [receipt.json](../output/ai4math_research_delivery_v0_3.receipt.json) 为准，数学证明证据仍以claims和成功Lean日志为准。

阅读目录：

- [1. 从什么问题出发，最终交付了什么](#part-1)
- [2. 统一记号和假设：先认清对象，再使用结论](#part-2)
- [3. 最终数学结论及其证明层级](#part-3)
- [4. 原数值半群结论怎样接到这条主线](#part-4)
- [5. 磁盘可核对的全过程与路线变化](#part-5)
- [6. 反例、未走通的捷径和恢复经验](#part-6)
- [7. 证明依赖与证据定位](#part-7)
- [8. 状态分类、未完成范围和新颖性](#part-8)
- [9. 文件导航、冻结版本和复现](#part-9)
- [10. 可选后续工作包：未来授权后再启动](#part-10)
- [11. 将来如何从交付重启](#part-11)

<a id="part-1"></a>

## 1. 从什么问题出发，最终交付了什么

研究起点是四个最小生成元的数值半群宽度问题。设

\[
\Gamma=\langle g_0,g_1,g_2,g_3\rangle,
\qquad 0<g_0<g_1<g_2<g_3,
\]

四个数确实是最小生成元，且生成数值半群；令重数 \(m=g_0\)、宽度 \(w=g_3-g_0\)。对任意域 \(k\)，考虑完备半群环

\[
R=k\llbracket t^\Gamma\rrbracket,
\qquad P=k\llbracket X_0,X_1,X_2,X_3\rrbracket,
\qquad P\longrightarrow R,\quad X_i\longmapsto t^{g_i}.
\]

目标 Betti 数为最小正则表示上的

\[
b_i^P(R)=\dim_k\operatorname{Tor}_i^P(R,k),
\qquad b_i^P(R)\le i\binom{w+1}{i+1}\quad(i\ge1).
\]

它们不是 \(\operatorname{Tor}^R(k,k)\) 的维数。范围不能写成 \(i\ge0\)，因为 \(b_0^P(R)=1\)。四个互异最小生成元使 \(w\ge3\)；这个一维 Cohen–Macaulay 环的余维是 3，传统代数理论给 \(b_i^P(R)=0\) 对 \(i\ge4\)，实质目标是前三个正次数 Betti 数。

原始文献主线是 Caviglia–Moscariello–Sammartano 的 *Bounds for syzygies of monomial curves*，项目核对的是 arXiv:2307.05770v2 及其 PAMS 152 (2024), 3665–3678 版本。该版本给出四生成元 \(w\ge40\) 的结论，并在 Remark 5.2 讨论 \(4\le w\le39\) 的剩余范围。该文的 lex 归约、预算问题及截面控制是研究起点，并非本项目自行发现的背景。原文定位与既有工作的界线见 [文献记录](literature_review.md)、[R015](tasks/R015_novelty.md)、[R023](tasks/R023_growth_literature.md)。这些是当时有限检索的记录，本次收尾没有重新开展外部查新。

项目最终形成了三个互相连接、但可信范围不同的成果：

1. **传统数学成果。** 在明确接受文献中的 Artinian 约化、初始理想和 lex Betti 比较等定理后，给出四生成元全部宽度的证明；对 \(w\ge4\) 第一界还可严格改进为 \(b_1^P(R)\le\binom{w+1}{2}-1\)。代数归约有独立 AI 内部审查；v0.2 新增低重数严格分支由主智能体纸面核对，未单独声称外部或额外独立审查。
2. **已编译的形式化成果。** 新组合证明适用于全部 \(w\ge4\)，不依赖原 267 组有限参数证书；随后已接到真实三变量单项式理想的商空间、全部极小单项式、任意多项式真正最少生成数、实际 \(I/\mathfrak m I\)、实际残差张量以及标准第一 Tor 对象。
3. **更强的抽象极值成果。** 对满足全部次数线性预算的真实有限余长 lex 理想类，其完整 xy 商子空间维数的最大值确实达到，且为标准意义的 \(\Theta(w\log w)\)。上下界和最终 `Asymptotics.IsTheta` 已 Lean 编译并经独立 AI 审查。这不是数值半群的匹配下界，也不是说类中每个理想的维数都具有该增长阶。

<a id="part-2"></a>

## 2. 统一记号和假设：先认清对象，再使用结论

以下用任意域 \(K\) 和多项式环 \(A=K[x,y,z]\)，区别于原半群的四变量完备正则环 \(P\)。Lean 中 \(A\) 是 `MvPolynomial (Fin 3) K`。设指数集合 \(S\subseteq\mathbb N^3\) 对逐坐标偏序上闭，

\[
I=\operatorname{monomialIdeal}(S)
 =\langle x^iy^jz^k:(i,j,k)\in S\rangle\subset A.
\]

这是实际 `Ideal.span`，并非把某个计数对象改名为理想。lex 次序固定为 \(x>y>z\)，同次数 lex 更大的单项式属于理想；标准单项式则对整除和同次 lex 向下封闭。`StandardLex` 是后一组合条件，`IsLexExponentSet` 是真实指数上集上的 lex 条件。

定义

\[
Q_d(I)=\text{次数恰为 }d\text{ 的齐次多项式在 }A/I\text{ 中的像},
\qquad H_d(I)=\dim_K Q_d(I).
\]

Lean 的 `quotientHomogeneous` 确实由 mathlib 的齐次子模经实际商映射取像而定义。它已与组合 `hilbert3` 证明相等；项目没有据此宣称整个 graded quotient/direct-sum API 都已注册完成。

令

\[
V_{xy}(I)=\operatorname{span}_K\{[x^iy^j]:i,j\in\mathbb N\}\subset A/I,
\qquad \ell(I)=\dim_K V_{xy}(I).
\]

`xySubspace` 的定义包含所有自然数指数，没有先截断。预算和 lex 性证明其有限张成，继而证明 `finrank_xySubspace` 等于组合的 `sectionLength`。传统数学中它与 \(K[x,y]/(I\cap K[x,y])\) 有自然识别；本项目已经证明的是三变量商中的实际子空间及维数，不把尚未另建的二变量商环同构冒充完成接口。

主要的真实 lex 宽度模型使用以下全部条件：

| 条件 | 实际意义 | 不能删去或偷换的原因 |
|---|---|---|
| \(K\) 为任意域 | 包括正特征域 | 有理数、实数只估计自然数维数，不要求 \(K\) 特征零 |
| \(I=\operatorname{monomialIdeal}(S)\)，\(S\) 上闭且 lex | 真实单项式生成性及次序结构 | 一般理想仅满足含有单项式的 lex 性，不足以推出整体单项式生成性 |
| \(A/I\) 为有限维 \(K\) 向量空间 | Lean 的真实 `Module.Finite` | 一个 `finrank` 数值不能代替有限维证明；预算也不蕴含有限余长 |
| \(x\notin I\) | 一次的最大 lex 单项式标准 | 在该单项式 lex 模型中排除一次项及单位理想，产生初始次数 \(a\ge2\) |
| \(w\in\mathbb N,\ w\ge4\) | 组合定理的准确参数范围 | 抽象 lex 类在 \(w=3\) 有反例；原半群 \(w=3\) 须另证 |
| 对每个 \(d\in\mathbb N\)，\(\sum_{t=0}^d H_t(I)\le1+dw\) | 所有次数的实际累计维数预算 | 不能只检验有限采样次数，也不能将待证列预算预先放进假设 |

最早的纯组合三界只需要 `StandardLex`、真正初始次数、\(w\ge4\) 和累计计数预算，不需要三变量商有限余长。实际 xy 维数上界可在“理想非零”而不要求整个商有限维的条件下成立。**有限余长是在精确生成元构造、最终标准 Tor 宽度推论和极值类定义中明确保留的条件**；不要为了统一表格而误称所有辅助定理都用了最强条件。

记 \(a=\min\{r:x^r\in I\}\)。有限余长使理想非零，并保证纯幂阈值存在；在需要的较一般接口中，非零理想和 \(x\) 标准用于构造 \(a\)。又记 \(\mathfrak m=(x,y,z)\)。标准 Tor 的一般同构明确要求 \(I\subseteq\mathfrak m\)，最终 lex 模型由 `monomialIdeal_le_variableIdeal_of_x_standard` 推出这一点。

<a id="part-3"></a>

## 3. 最终数学结论及其证明层级

### 3.1 全宽度组合三界与严格第一界

对上述组合模型，\(a\ge2\)、\(w\ge4\)，令 \(\ell\) 为全部二维标准单项式数，则

\[
a+1+\ell<\binom{w+1}{2},\qquad
 a+2\ell\le2\binom{w+1}{3},\qquad
 \ell\le3\binom{w+1}{4}.
\]

自然数形式的第一界等价于 \(a+1+\ell\le\binom{w+1}{2}-1\)。主接口是 `WidthBounds.all_widths_analytic_bounds`、`WidthBounds.all_widths_strict_improvement`，位于 [AllWidths.lean](../lean/WidthBounds/AllWidths.lean)，登记 C006；实际商空间版本为 `WidthBounds.MonomialInterface.monomialIdeal_all_widths_dimension_bounds`，位于 [IdealBounds.lean](../lean/WidthBounds/IdealBounds.lean)，登记 C012。

证明核心不是扩展有限枚举上限，而是一次终端累计预算。令第 \(i\) 列长度为

\[
n_i=\#\{j\ge0:x^iy^j\text{ 标准}\},\quad 0\le i<a,
\qquad \ell=\sum_{i<a}n_i.
\]

lex 性推出 \(i+n_i\le n_0\)，并强制该列的全部 \(j+k<n_i\) 三变量单项式标准。把这些互不相交的三角形一起放进次数至多 \(n_0-1\) 的预算，得到

\[
\sum_{i<a}\frac{n_i(n_i+1)}2\le1+(n_0-1)w.
\]

低次数完全标准又给

\[
\binom{a+2}{3}\le1+(a-1)w,
\qquad a^2+4a+6\le6w,
\qquad a\le w-2.
\]

取带符号整数向量 \(v_0=2n_0+1-2w\)、\(v_i=2n_i+1\ (i>0)\)，完成平方和 Cauchy 比较得到严格二项式界。首项可以为负，证明没有额外假设其非负。列几何、终端预算、向量算术及最终拼接都已形式化，最终定理没有把这些中间结论当作假设。

### 3.2 精确谐和上界与实对数上界

累计包络进一步给出所有 \(d\ge a\) 的

\[
(d-a+1)h_d<2w,\qquad
h_d\le\left\lfloor\frac{2w-1}{d-a+1}\right\rfloor,
\]

其中 \(h_d\) 是二维标准单项式次数计数。结合已证明的截断，得到有限整除和，再得到有理数中的

\[
\ell\le3w+(2w-1)\mathcal H_{2w-1},
\qquad \mathcal H_n=\sum_{r=1}^n\frac1r.
\]

`WidthBounds.Growth.sectionLength_le_harmonic` 与 `quotient_xy_le_harmonic` 在 [Growth.lean](../lean/WidthBounds/Growth.lean)，登记 C013。后续 [LogGrowth.lean](../lean/WidthBounds/LogGrowth.lean) 把项目 `harmonicQ` 与 mathlib 谐和数严格对齐，使用库中对数比较，证明

\[
\ell\le3w+(2w-1)(1+\log(2w-1))\le10w\log w\quad(w\ge4).
\]

真实子空间入口为 `WidthBounds.LogGrowth.quotient_xy_le_log` 和 `quotient_xy_le_ten_mul_width_log`。常数 10 足够但未证明最优。精确谐和界在小宽度未必比严格二项式界数值更好；它承担的是更强增长阶控制。

### 3.3 实际生成集合、全部极小单项式与真正最少多项式生成数

研究先证明存在实际有限单项式生成集合，再证明该集合就是全部整除极小单项式，最后才比较任意多项式生成集合；三个层次没有互相替代。

有限余长 lex 情形中的边界分三类：\(x^a\)；各 \(i<a\) 的 xy 列末端 \(x^iy^{n_i}\)；每个标准 xy 单项式 \(u\) 的第一非标准 z 提升 \(uz^{t(u)}\)。纯 z 幂成员使所有 \(t(u)\) 存在。三类互不相交，完整覆盖所有极小指数，故其基数恰为

\[
\mu(I)=a+1+\ell.
\]

这里最终的 \(\mu\) 是实际意义的最少数：令

\[
\mathcal G(I)=\{|P|:P\subset A\text{ 是有限集合且 }\operatorname{Ideal.span}(P)=I\},
\]

Lean 证明 `IsLeast (generatorCardinalities I) (a+1+ell)`。竞争集合 \(P\) 不限于单项式、齐次多项式或线性无关元素。证明用极小指数系数映射：理想内 \(p\) 与任意多项式 \(q\) 相乘时，极小指数处系数只受到 \(q\) 常数项的缩放；该映射在实际理想上满射到有限坐标空间。因此任何生成集合至少需要同样多的元素。

最终

\[
\mu(I)<\binom{w+1}{2},\qquad
\mu(I)\le4w-1+(2w-1)\mathcal H_{2w-1}.
\]

这两个上界针对最少数，不是对故意加入冗余元素的每个生成集合给上界。主入口为 `finiteColength_exists_exact_minimal_generators` 和 `finiteColength_generator_number_bounds`，分别见 [GeneratorExact.lean](../lean/WidthBounds/GeneratorExact.lean)、[GeneratorNumberBounds.lean](../lean/WidthBounds/GeneratorNumberBounds.lean)，登记 C017、C018。

### 3.4 实际 \(I/\mathfrak mI\)、实际张量与标准 Tor₁

令 \(E\) 是真实完整有限极小单项式指数集合。项目按实际理想乘积定义 \(\mathfrak mI\)，再按其在 \(I\) 内的子模定义商；不是先把未知核命名为 \(\mathfrak mI\)。它证明

\[
p\in\mathfrak m I\iff p\in I\text{ 且所有 }E\text{ 坐标的系数为零},
\]

并构造实际线性同构与单项式商类基，得到

\[
I/\mathfrak mI\simeq_K K^E,
\qquad \dim_K(I/\mathfrak mI)=|E|=\mu(I).
\]

这个一般最少数等式保留完整极小单项式生成性；不能推广成任意多项式理想的全局最少数公式。见 C019 和 [GeneratorQuotientBounds.lean](../lean/WidthBounds/GeneratorQuotientBounds.lean)。

下一层构造真实张量积

\[
(A/\mathfrak m)\otimes_A I\simeq_K I/\mathfrak mI,
\qquad [1]\otimes g\longmapsto[g].
\]

该一般同构对任意实际理想 \(I\) 成立，张量底环始终是 \(A\)。另有实际 \(K\)-代数同构 \(A/\mathfrak m\simeq_K K\)，并核实商代表元的常数项公式；这不等于将张量底环悄悄改成 \(K\)。完整极小单项式情形下，\(1\otimes g\) 构成真实纤维基。见 C020、[GeneratorTensorFiber.lean](../lean/WidthBounds/GeneratorTensorFiber.lean)、[VariableResidue.lean](../lean/WidthBounds/VariableResidue.lean)、[GeneratorTensorBounds.lean](../lean/WidthBounds/GeneratorTensorBounds.lean)。

最后，R040 真正连接了 mathlib 标准派生对象，而不是定义一个“Tor 数”来等于上述维数。对任意实际理想 \(I\subseteq\mathfrak m\)，证明

\[
\operatorname{Tor}_1^A(A/\mathfrak m,A/I)
 \simeq_A (A/\mathfrak m)\otimes_A I,
\]

再沿实际系数域嵌入限制标量得到兼容 \(K\)-线性同构。实现固定第一因子为 \(A/\mathfrak m\)，派生第二因子 \(A/I\)，使用 `CategoryTheory.Tor (ModuleCat A) 1`。证明路线包含真实短正合序列 \(0\to I\to A\to A/I\to0\)、指定投射满射开头的实际分解、实际核同构、张量后核包含为零、标准 `leftDerived` 比较；没有假设 \(I\) 本身投射，也没有暗用 Tor 两因子交换。

于是最终 lex 模型中

\[
\dim_K\operatorname{Tor}_1^A(A/\mathfrak m,A/I)
=\dim_K((A/\mathfrak m)\otimes_A I)
=\dim_K(I/\mathfrak mI)=\mu(I)=a+1+\ell,
\]

并有前述严格二项式及有理谐和界。主接口为 `idealQuotientTorOneIsoTensor`、`idealQuotientTorOneEquivTensor`、`torOneBasis_toTensor`、`finiteColength_torOne_bounds`，见 [TorOneBridge.lean](../lean/WidthBounds/TorOneBridge.lean)、[TorOneBounds.lean](../lean/WidthBounds/TorOneBounds.lean)，登记 C021。**高阶 Tor、标准 Tor 两因子交换、完整半群归约未在这个结果中完成。**

### 3.5 显式真实下界族与全部次数预算

对每个整数 \(s\ge2\)，定义真实指数上集

\[
S_s=\{(i,j,k):s^2<(i+1)(i+j+k+1)\},\qquad L_s=\operatorname{monomialIdeal}(S_s).
\]

因此标准条件恰为 \((i+1)(i+j+k+1)\le s^2\)。项目证明了上闭、lex、实际有限余长、初始次数恰为 \(s\)、\(x\) 标准，以及与原纸面分段理想的等价。二维轮廓为

\[
h_d=\min\left(d+1,\left\lfloor\frac{s^2}{d+1}\right\rfloor\right)
=\begin{cases}d+1,&d<s,\\ \lfloor s^2/(d+1)\rfloor,&d\ge s.\end{cases}
\]

三维计数经显式注入给 \(H_d\le s^2\)，且 \(H_0=1\)，于是对所有次数

\[
\sum_{t=0}^d H_t(L_s)\le1+ds^2.
\]

预算因此也适用于任意 \(w\ge s^2\)。不是只证明一条抽象 Hilbert 数列，更不是从有限枚举猜测可实现性。完整 xy 维数精确为

\[
\ell_s=\sum_{i=0}^{s-1}\left(\left\lfloor\frac{s^2}{i+1}\right\rfloor-i\right),
\qquad s^2\mathcal H_s\le\ell_s+\frac{s^2+s}{2}.
\]

同时已证明标准第一 Tor 的 \(K\) 维数以及任意有限多项式真正最少生成数均为 \(s+1+\ell_s\)。主接口见 [LowerConstruction.lean](../lean/WidthBounds/LowerConstruction.lean)、[LowerProfile.lean](../lean/WidthBounds/LowerProfile.lean)、[LowerConstructionBounds.lean](../lean/WidthBounds/LowerConstructionBounds.lean) 中 `lowerIdeal_admissible`、`lowerIdeal_xy_finrank`、`lowerIdeal_xy_harmonic_lower`、`lowerIdeal_torOne_finrank`、`lowerIdeal_generator_number`；登记 C022。部分辅助公式允许 \(s=0,1\)，最终真实 xy/Tor/最少数陈述保留 \(s\ge2\)。

### 3.6 可达到的最大值与标准 \(\Theta\)

对固定任意域 \(K\) 和任意 \(w\in\mathbb N\)，令 \(\mathcal C_K(w)\) 为满足第2节几何条件与全部次数预算的真实有限余长 lex 类：指数上集、lex、实际商有限维、x标准以及累计预算。类本身在每个自然数w上都有定义，\(w\ge4\)是随后非空与最大值达到定理的阈值，并非 `Admissible` 的字段。定义

\[
M_K(w)=\sup\{\dim_KV_{xy}(I):I\in\mathcal C_K(w)\}.
\]

Lean 的 `lengthSet K w` 收集实际理想达到的自然数维数，`maxLexLength K w` 是它的自然数 `sSup`。对 \(w\ge4\)，\(L_2\) 证明类非空，已证全宽度界证明维数集合有上界，再用 `Nat.sSup_mem` 证明最大值属于该集合。`maxLexLength_isGreatest` 同时给出达到性和上界性质，排除了“逐次数包络都能同时取到”的错误推断。

对每一个 \(w\ge64\)，取 \(s=\lfloor\sqrt w\rfloor\)。已形式化 \(s\ge2\)、\(s^2\le w<(s+1)^2\)、\(w\le4s^2\) 及所需对数正性，因此同一个真实 \(L_s\) 属于预算 \(w\) 的类，且

\[
\frac1{16}w\log w\le\ell_s\le M_K(w)\le10w\log w.
\]

这覆盖所有足够大的自然数预算，而非仅平方子序列。最终 `WidthBounds.LexExtremal.maxLexLength_isTheta` 证明标准

```lean
Asymptotics.IsTheta Filter.atTop
  (fun w : ℕ => (maxLexLength K w : ℝ))
  (fun w : ℕ => (w : ℝ) * Real.log (w : ℝ))
```

见 [LexGrowthTheta.lean](../lean/WidthBounds/LexGrowthTheta.lean)、[LogLower.lean](../lean/WidthBounds/LogLower.lean)，登记 C023。达到性从 \(w=4\) 起，下界及最终双侧估计从 \(w=64\) 起。\(w<4\) 有函数的总定义，不等于这些参数的类也已经证明有可达到最大值。两个增长常数不声称最优，也没有另证最大值跨域逐点相同。

<a id="part-4"></a>

## 4. 原数值半群结论怎样接到这条主线

[代数归约审查](algebra_bridge_audit.md) 逐项核对了以下传统推导。它接受所引已发表定理，没有重新证明全部文献结论；应与第3节的具体 Lean 成果分开使用。

首先，\(t^m\) 是半群环的正则参数。沿 \(X_0\) 取 Artinian 约化保持最小自由分解的秩：\(\overline R=R/(t^m)\) 的长度为 \(m\)，在三变量正则环上具有与原目标相同的 Betti 数。随后通过最低次数初始形式、Gröbner 初始理想，再取同 Hilbert 函数的 lex 理想 \(L\subset K[x,y,z]\)。局部到关联分次、Gröbner、Bigatti–Hulett–Pardue 比较给

\[
b_i^P(R)\le b_i^A(A/L)\quad(i\ge1).
\]

这里没有断言任意局部环与切锥 Betti 数相等；真正相等的是沿同时正则的参数约化这一步。lex 比较使用一般特征版本，不需要域无限、特征零或原切锥 Cohen–Macaulay。

有限余长和无一次项来自这个代数构造：\(A/L\) 长度为 \(m\)，一次分量维数为3。不能倒过来从累计预算补出有限余长。CMS 定理3.3 的预算前提是 \(w\le m-2\)。若 \(w\ge m-1\)，则另用总长度：\(d\ge1\) 时

\[
\operatorname{HS}(A/L,d)\le m\le w+1\le1+dw,
\]

而零次为1。v0.2 因此把严格第一界也接到低重数分支。

对有限余长三变量 lex 理想，传统公式为

\[
b_0^A(L)=a+1+\ell,\quad b_1^A(L)=a+2\ell,\quad b_2^A(L)=\ell.
\]

理想作为模与商环的下标相差1：\(b_{i+1}^A(A/L)=b_i^A(L)\)。目前第一式已通过真实最少数和标准 Tor₁ 层形式化到第3节所列顺序；后两式及其标准高阶 Tor 对象尚未完成。不能用三个纯数值表达式均有组合界，便声称三个真实 Betti 数都已经机器识别。

\(w=3\) 时生成元只能为 \(m,m+1,m+2,m+3\)，使用算术序列半群的既有定理单独处理；从正分次仿射表示到局部完备表示需保留平坦局部化、完备化及最小性说明。这个分支没有被抽象 \(w\ge4\) 定理覆盖。

<a id="part-5"></a>

## 5. 磁盘可核对的全过程与路线变化

下表以任务之间的逻辑阶段组织 R001–R048。日期只采用任务报告中实际出现的记录；任务编号是登记顺序，不等于实际完成顺序，例如 R024 的显式族在后续 R044、R045 配合后才于9月29日完成。R009 是用户暂缓的外部审阅，不能因周围任务完成而标成已审稿。

| 阶段与任务 | 磁盘记录的工作与变化 | 结果和证据入口 |
|---|---|---|
| 2026-09-23 起步，R001–R004 | 固定根 uv 环境与 Lean/mathlib 4.22.0；先由原文的三变量 lex 问题入手。R002的Python包络与独立整数检查得到267组有限参数证书，R003以Lean证明小宽度组合部分；传统归约接上既有大宽度结论，形成v0.1。 | [first_pass](first_pass.md)、[combinatorial_proof](combinatorial_proof.md)、[Arithmetic](../lean/WidthBounds/Arithmetic.lean)、[SmallWidth](../lean/WidthBounds/SmallWidth.lean)、[v0.1稿](../paper/width_bounds.tex)；C001、C002、C004。 |
| 可恢复工作流，R005、R013 | 开发不可覆盖源码快照、逐文件哈希、原子LATEST、WIP标识和队列校验；15项工具测试。空聊天历史子智能体只读恢复入口，正确找到下一任务和当时未完成层。 | [R005](tasks/R005_checkpoint_engine.md)、[R013](tasks/R013_handoff_rehearsal.md)；C007。恢复工具保障审计和连续性，不证明数学或保证未来发现。 |
| 2026-09-23 全宽度解析路线，R006–R008、R010–R012、R016 | R006把逐次数包络转为终端列三角预算，得到严格第一界。R010独立重推。R011处理带符号向量算术，R016实现真实列计数，R012把两者接成全部 \(w\ge4\) 定理。R007并行建立实际 `MvPolynomial` 理想成员接口，R008负责验收选择。 | [R006](tasks/R006_analytic.md)、[R010](tasks/R010_analytic_review.md)、[R011](tasks/R011_analytic_arithmetic.md)、[R012](tasks/R012_all_widths.md)、[R016](tasks/R016_columns.md)、[R007](tasks/R007_interface.md)；C005、C006。新声明实际依赖不含旧有限证书。 |
| 2026-09-23 v0.2与有限查新，R014、R015；外部R009暂缓 | 另存全宽度解析稿，移除作为新主线必需部分的267组附录和大宽度末段引用，保留v0.1。补入低重数严格应用；定向查新没有定位同条件结果，未认证原创。 | [R014](tasks/R014_v0_2.md)、[R015](tasks/R015_novelty.md)、[v0.2说明](../paper/README_v0_2.md)；C003、C008、C009。R009为parked。 |
| 2026-09-23 真实维数与增长路线，R017–R023 | R017证明真实商环标准基；R022把全范围xy张成与次数像维数接到组合模型。R018发现谐和包络和显式下界族，R020独立审查；R021先形式化精确整数/有理上界。R019从实际半群Apéry集独立反查1807例，R023定向查新。 | [R017](tasks/R017_monomial_basis.md)、[R022](tasks/R022_ideal_bounds.md)、[R018](tasks/R018_growth.md)、[R020](tasks/R020_growth_review.md)、[R021](tasks/R021_growth_formal.md)、[R019](tasks/R019_confidence_audit.md)、[R023](tasks/R023_growth_literature.md)；C010–C014。有限反查只查错；真实下界族当时尚未完整形式化。 |
| 2026-09-23 从生成集合到极小性，R025–R030，含R027 | 先证明明确有限生成集合及上界，避免在第一步同时承担所有极小性义务。R027补真实有限商与纯z幂桥梁。R028、R029分别处理三类极小性与边界集合、精确基数，再由根完成全体极小指数分类和逐项不可删除。R026、R030分别独立审查。 | [R025](tasks/R025_generators.md)、[R027](tasks/R027_finite_colength.md)、[R028](tasks/R028_generator_minimality.md)、[R029](tasks/R029_boundary_generators.md)、[R026](tasks/R026_generator_review.md)、[R030](tasks/R030_minimality_review.md)；C015–C017。 |
| 2026-09-23 真正最少数，R031–R033 | “单项式集合逐项不可删除”尚不能直接代替任意多项式生成集合的最少基数；R031用极小系数的乘法公式与满射，R032建立一般线性维数下界，根集成为实际 `IsLeast`。R033审查完整量词和冻结证据。 | [R031](tasks/R031_polynomial_generator_number.md)、[R032](tasks/R032_generator_dimension.md)、[R033](tasks/R033_generator_number_review.md)；C018。 |
| 2026-09-24 实际生成元商，R034–R036 | 证明真实 \(\mathfrak mI\) 的成员判据与受限系数映射核相等；R035独立建立一般实际子商接口，根连接商类基、有限维和最少数。R036审查。 | [R034](tasks/R034_generator_quotient.md)、[R035](tasks/R035_ideal_subquotient.md)、[R036](tasks/R036_generator_quotient_review.md)；C019。 |
| 2026-09-24至25 张量纤维，R037–R039 | 连接实际 \((A/\mathfrak m)\otimes_A I\) 与 \(I/\mathfrak mI\)，独立识别残差环与系数域，保留标量塔和纯张量公式。执行者或审查者因额度中断后，根和新审查者按落盘文件续验冻结版本，于25日完成验收。 | [R037](tasks/R037_generator_tensor_fiber.md)、[R038](tasks/R038_variable_residue.md)、[R039](tasks/R039_tensor_fiber_review.md)；C020。当时按用户要求止于该步骤，没有把张量冒称Tor。 |
| 2026-09-26恢复、29日闭合标准Tor，R040–R043 | 中断时R041/R042一度只有计划报告；先核对实际文件再续接。固定库的 `ProjectiveResolution.of` 与原计划想象的签名不符，改为实际链复形构造。随后补齐标准派生核计算、真实短正合与核同构、残差张量零映射，完成A模与K线性标准Tor₁接口。 | [R040](tasks/R040_tor_one_bridge.md)、[R041](tasks/R041_chosen_resolution.md)、[R042](tasks/R042_ideal_exact_sequence.md)、[R043](tasks/R043_tor_bridge_review.md)；C021。不是只验收短正合序列的阶段成果。 |
| 2026-09-29 显式下界族，R024、R044、R045 | 将原纸面分段族改写为统一乘积指数条件，真实理想、lex、有限余长先实现；R044处理二维轮廓和所有次数预算，根连接真实xy维数、谐和有限下界、标准Tor₁及最少数。R045独立审查。 | [R024](tasks/R024_lower_construction.md)、[R044](tasks/R044_lower_profile.md)、[R045](tasks/R045_lower_construction_review.md)；C022。 |
| 2026-09-29 实对数与极值收束，R046–R048 | 谐和数连接库的Real.log界；平方根参数把下界扩到所有 \(w\ge64\)；以实际理想达到的维数定义最大值并证明达到；最终标准IsTheta与两向Big-O闭合。R048独立核对冻结源码、统一日志和依赖根。 | [R046](tasks/R046_log_growth.md)、[R047](tasks/R047_log_lower.md)、[R048](tasks/R048_theta_review.md)；C023。数学里程碑完成，之后进入研究交付收尾。 |

R049–R051是此次交付、长期报告和独立口径审查，不是新的数学研究路线。它们负责把以上状态整理成当前可读交付，冻结的旧稿不会因此被覆盖。

<a id="part-6"></a>

## 6. 反例、未走通的捷径和恢复经验

### 6.1 确实排除过哪些数学推断

**预算不蕴含有限余长。** \(I=(x^2,xy,xz,y^2)\) 是三变量 lex 单项式理想，次数0、1的标准数为1、3，之后每次为2。对 \(d\ge1\)，累计数为 \(2d+2\le1+4d\)，但每个 \(z^n\) 都标准，故 \(A/I\) 无限维。这是 [R026](tasks/R026_generator_review.md) 中的直接反例。因此不能从预算删掉 `Module.Finite`，也不能用 Lean 无穷维时同样有总定义的 `finrank` 代替有限性。

**抽象lex宽度3不能并入主定理。** \(I=(x^2,xy,xz)+(y,z)^3\) 满足预算 \(w=3\)，列长为 \((3,1)\)，但 \(a+1+\ell=7>\binom42=6\)。另一方面，\(w=4\) 的 \((x^2,xy,xz)+(y,z)^5\) 给 \(a+1+\ell=9=\binom52-1\)，表明在所有允许宽度上统一把减一换成减二不可行。这些是 [R010](tasks/R010_analytic_review.md) 的纸面边界核验，不作为另外新增的 Lean 特例定理。

**固定预算不控制三维总余长。** [R015](tasks/R015_novelty.md) 的 \((x^2,xy,xz,y^2,yz,z^N)\) 满足统一线性预算，而商长度随 \(N\) 增长。固定总余长的既有极值定理不能单独替代当前 xy 截面问题。

**一般纤维不自动等于全局最少生成数。** 对 \(I=(x-1,y)\)，纸面范围核验给 \(\dim_K I/\mathfrak mI=1\)，但理想不是主理想，真正最少生成数为2。故一般张量同构虽然对所有理想有效，最少数识别仍须保留本项目完整极小单项式生成性。见 [R039](tasks/R039_tensor_fiber_review.md)。

**Tor识别不能省略 \(I\subseteq\mathfrak m\)。** 若 \(I=A\)，则 \((A/\mathfrak m)\otimes_A I\simeq K\) 一维，而 \(A/I=0\)，标准 \(\operatorname{Tor}_1^A(A/\mathfrak m,A/I)=0\)。最终一般同构明确携带该条件，lex 应用再证明它。

**lex大下界不能倒传给半群。** 已有方向是 \(\operatorname{Betti}(\text{半群})\le\operatorname{Betti}(\text{lex})\)。即使将来发现某半群实现相同 Hilbert 函数，lex Betti 很大仍不足以证明原半群 Betti 很大。半群匹配下界需要自己的实际关系数或同调下界证据，或可靠的取等机制。

### 6.2 哪些只是实现问题，不能包装成数学失败

项目保存了真实失败编译，但不将每个类型错误描述成被否定的数学路线。R011初次完成平方出现自然数/整数推断与cast引理名问题，修正为带符号整数证明；不能为了通过编译补错误的 \(v_0\ge0\) 假设。R025的阈值需局部经典可判定实例；R028的集合像需要合适类型接口；R034的核等式出现方向和隐式系数类型问题；这些都在同一数学路线内修复。

R037过度 `simp` 在商对象标量实例搜索中超时，改为显式展开既有等价和纯张量公式，没有添加新数学假设。R040原计划误判固定库的投射分解API，检查实际源码后改用可验证的链复形构造；缺少依赖 `.olean` 是缓存/构建状态，不是已发现证明反例。R047从有理数到实数的整式强制转换需显式处理乘法、平方和cast，最终阈值和常数没有靠数值调参得到。

R011、R037/R039、R041/R042都有可核对的中断或续接记录。恢复时先读报告、源码和已保存构建产物，核对旧执行者是否仍在工作；不能因为旧会话消失便删除 `running` 任务，也不能把“报告说单文件成功”直接升级成最终统一构建。历史任务文件中早期的“尚未完成”段落保留为过程记录，必须看后来追加的根最终验收及最新 claims，不能截取旧段落反推当前状态。

另有日志封装在成功构建结束后打印到GBK控制台时发生Unicode错误、或日志尚未关闭时暂不能读取hash等记录。这些必须与Lean实际退出码区分。当前最终证据仅指向写入完成、已关闭并计算哈希的成功日志；失败WIP输出和临时 `sorryAx` 诊断不是最终验证证据。

<a id="part-7"></a>

## 7. 证明依赖与证据定位

数学结构可按下图阅读。实线是本项目已接通的形式化接口；传统半群层单独列出，避免把全部链条都画成机器证明。

```text
真实单项式理想、指数上集与lex
  ├─ 标准单项式商基 ─ 次数像维数 = hilbert3
  │                    └─ 实际全部次数预算
  ├─ StandardLex ─ 截断/列几何 ─ 终端三角预算 ─ 带符号Cauchy ─ 全宽度三界
  │                    └─ 逐次数包络 ─ 整除和 ─ 有理谐和 ─ Real.log上界
  ├─ 完整xy张成 = 有限标准基张成 ─ 实际xy维数 = sectionLength
  └─ 真实有限余长 ─ 纯z幂 ─ 全部边界极小单项式 ─ 精确基数a+1+ell
                                └─ 极小系数满射 ─ 任意多项式真正最少数
                                      └─ 真实mI核 ─ I/mI ─ 实际张量纤维
                                                           ↑
                       实际短正合/指定投射分解/标准leftDerived ─ 标准Tor₁

显式L_s ─ upper/lex/有限余长/全部预算 ─ 精确ell_s ─ 非平方参数log下界
    与实际xy上界合并 ─ lengthSet非空有界/最大值达到 ─ 标准IsTheta

传统层：原数值半群 ─ Artinian约化 ─ 初始理想/lex Betti比较 ─ 有限余长lex
        （这整条归约与高阶Betti公式尚未端到端Lean）
```

以下表中的名称保留大小写，可直接在源码搜索。`MI` 在本表仅是 `WidthBounds.MonomialInterface` 的文字缩写，不是源码新命名空间。所有已接受形式化声明当前统一验证日志为 [lean_lex_theta_build.txt](../results/lean_lex_theta_build.txt)；较早日志保存各阶段当时证据，不代替修改后源码的重编译。

| 结论 | 关键声明及源码 | claims / 独立审查 |
|---|---|---|
| 全宽度组合与严格界 | `WidthBounds.all_widths_analytic_bounds`、`all_widths_strict_improvement`，[AllWidths](../lean/WidthBounds/AllWidths.lean)；[ColumnBounds](../lean/WidthBounds/ColumnBounds.lean)、[AnalyticArithmetic](../lean/WidthBounds/AnalyticArithmetic.lean)为核心依赖 | C006；[R010](tasks/R010_analytic_review.md)纸面审查，R012集成依赖审计 |
| 实际商基和齐次像维数 | `MI.standardMonomialBasis`、`MI.finrank_quotientHomogeneous`，[MonomialBasis](../lean/WidthBounds/MonomialBasis.lean) | C011；R017实现、R022集成语义核验 |
| 完整xy维数与三界 | `MI.finrank_xySubspace`、`MI.monomialIdeal_all_widths_dimension_bounds`，[IdealBounds](../lean/WidthBounds/IdealBounds.lean) | C012；R022报告 |
| 谐和增长界 | `WidthBounds.Growth.degree_divisor_bound`、`sectionLength_le_harmonic`、`quotient_xy_le_harmonic`，[Growth](../lean/WidthBounds/Growth.lean) | C013；[R020](tasks/R020_growth_review.md)传统审查、R021形式化 |
| 真实有限余长 | `MI.quotient_finite_iff_standard_finite`、`quotient_finite_iff_exists_pure_z`，[FiniteColength](../lean/WidthBounds/FiniteColength.lean) | C016；[R026](tasks/R026_generator_review.md) |
| 全部极小指数与精确计数 | `MI.monomialIdeal_exists_exact_minimal_exponents`、`finiteColength_exists_exact_minimal_generators`，[GeneratorExact](../lean/WidthBounds/GeneratorExact.lean) | C017；[R030](tasks/R030_minimality_review.md) |
| 任意多项式最少数 | `MI.minimal_exponents_card_le_generators`、`isLeast_generatorCardinalities_of_minimal_exponents`、`finiteColength_generator_number_bounds`，[GeneratorNumberBounds](../lean/WidthBounds/GeneratorNumberBounds.lean) | C018；[R033](tasks/R033_generator_number_review.md) |
| 真实生成元商 | `MI.ker_generatorCoefficientMap`、`generatorQuotientEquiv`、`generatorQuotientBasis_apply`、`finiteColength_generatorQuotient_bounds`，[GeneratorQuotientBounds](../lean/WidthBounds/GeneratorQuotientBounds.lean) | C019；[R036](tasks/R036_generator_quotient_review.md) |
| 实际残差张量与残差域 | `MI.generatorTensorEquiv`，[GeneratorTensorFiber](../lean/WidthBounds/GeneratorTensorFiber.lean)；`MI.variableResidueEquiv`，[VariableResidue](../lean/WidthBounds/VariableResidue.lean)；`MI.finiteColength_generatorTensor_bounds`，[GeneratorTensorBounds](../lean/WidthBounds/GeneratorTensorBounds.lean) | C020；[R039](tasks/R039_tensor_fiber_review.md) |
| 标准派生与Tor₁ | `WidthBounds.DerivedKernel.isoLeftDerivedOne`，[DerivedKernel](../lean/WidthBounds/DerivedKernel.lean)；`MI.idealQuotientTorOneIsoTensor`，[TorOneBridge](../lean/WidthBounds/TorOneBridge.lean)；`MI.finiteColength_torOne_bounds`，[TorOneBounds](../lean/WidthBounds/TorOneBounds.lean) | C021；[R043](tasks/R043_tor_bridge_review.md) |
| 真实下界族/有限公式 | `WidthBounds.Lower.lowerIdeal_admissible`、`lowerIdeal_xy_finrank`、`lowerIdeal_torOne_finrank`、`lowerIdeal_generator_number`，[LowerConstructionBounds](../lean/WidthBounds/LowerConstructionBounds.lean) | C022；[R045](tasks/R045_lower_construction_review.md) |
| 实对数、达到极值与Theta | `WidthBounds.LogGrowth.quotient_xy_le_ten_mul_width_log`，[LogGrowth](../lean/WidthBounds/LogGrowth.lean)；`WidthBounds.LogLower.lowerIdeal_xy_log_lower`，[LogLower](../lean/WidthBounds/LogLower.lean)；`WidthBounds.LexExtremal.maxLexLength_isGreatest`、`maxLexLength_log_bounds`、`maxLexLength_isTheta`，[LexGrowthTheta](../lean/WidthBounds/LexGrowthTheta.lean) | C023；[R048](tasks/R048_theta_review.md) |
| 原半群传统归约 | [algebra_bridge_audit](algebra_bridge_audit.md)、[v0.2稿](../paper/width_bounds_v0_2.tex)；没有同名的完整Lean半群定理 | C002、C009；代数桥内部AI审查，低重数严格补充为根纸面核对 |

`DependencyAudit.lean` 递归检查实际声明使用的常量，而非从 import 列表猜测依赖；新的主线可同时与旧有限证明共存，但所审计新声明不使用旧有限包络、小宽度证书或 `sorryAx`。标准公理记录为 `propext`、`Classical.choice`、`Quot.sound`，未引入研究自定义公理。禁止 `sorry`、`admit`、自定义 `axiom` 和 `native_decide`；文本扫描只是辅助，真正的内核构建、公理打印和声明依赖检查才是相应形式化证据。

最新数学统一日志的 SHA-256 为

```text
0b43de4c75bf3eeedc6af52ca63417c53aae798e6593aefda2255eea40d230b8
```

R048最终审查报告的 SHA-256 为

```text
e1441027896a3e4103e6213d330f9d7586d5daf63ebbcbe4768d0dc809fce572
```

完整源码、配置及日志哈希以 [claims.json](claims.json) 为索引。哈希一致说明当前字节与已记录证据匹配，不等于重跑了证明；源码变化后必须重新构建和重新审查受影响命题，不能保留旧日志冒充新版本验证。

<a id="part-8"></a>

## 8. 状态分类、未完成范围和新颖性

本项目至少区分六种状态：猜想或待证路线；有限实验支持；传统证明经内部审查；具体 Lean 命题已编译；文献已知结果；新颖性未定。文档/归档校验又是独立的产物状态，不应混入数学证明强度。

当前最强的机器证据只覆盖第3节和表中明确命名的对象与量词。原半群应用仍缺整体的数值半群环、参数约化、关联分次/初始理想、lex Betti 比较、宽度预算来源和高阶 Betti 识别；标准 Tor 两因子交换、完整 graded API 也没有被本项目这批定理一并宣称完成。数学上有经典证明或文献支持，不等于这里有同等范围的 Lean 声明。

1807个实际四生成元半群的语义反查覆盖报告列明的有限参数和少量指定族，通过 Apéry/Hilbert/lex 路径核查模型、列预算和边界计数；它未直接计算所有原半群最小关系数，更不是无限归约或新颖性的证明。267组原始包络证书则是有限参数阶段中的明确计算证据；全宽度解析主线已用独立的无限参数证明替代它作为依赖。

C003记录新颖性未定。lex归约、逐次数预算方向、单项式系数思想和经典除数求和均有既有数学背景，不能把这些部件全称原创。有限文献检索没有定位同一精确结论，只能形成候选研究增量的定位，不能证明无人已经做过。外部人类领域审稿由用户暂缓，R009继续parked；当前“独立审查”均指独立AI任务的内部纸面、源码语义或冻结证据审查。本阶段没有对外发信、上传或发表，也不以外审尚未恢复作为交付的前置条件。

<a id="part-9"></a>

## 9. 文件导航、冻结版本和复现

### 9.1 从哪里开始读

| 目的 | 入口 |
|---|---|
| 了解当前研究闭合范围 | 本报告、[STATE](STATE.md)、[HANDOFF](HANDOFF.md)、[FINISH_PLAN](FINISH_PLAN.md) |
| 核对交付PDF、ZIP及校验结果 | [DELIVERY](DELIVERY.md)、[R049](tasks/R049_delivery_closeout.md)、[R051](tasks/R051_delivery_audit.md) |
| 找某条结论的证据和文件所有权 | [claims](claims.json)、[queue](queue.json) |
| 阅读传统证明与归约 | [组合证明](combinatorial_proof.md)、[解析证明说明](analytic_formalization.md)、[代数审查](algebra_bridge_audit.md)；这些历史说明的“尚未完成”需按本报告最新状态解释 |
| 读当前形式化入口 | [WidthBounds.lean](../lean/WidthBounds.lean)、第7节的定理映射、[DependencyAudit](../lean/WidthBounds/DependencyAudit.lean) |
| 追踪过程、失败与验收 | [tasks目录](tasks/)、第5节时间线 |
| 理解恢复规则和快照边界 | [AGENTS](../AGENTS.md)、[PROTOCOL](PROTOCOL.md)、[checkpoint工具](../scripts/checkpoint.py) |

### 9.2 三个交付版本的边界

| 版本 | 当时内容和产物 | 后续使用原则 |
|---|---|---|
| v0.1 | 小宽度新增组合证明、有限证书、传统半群归约与文献大宽度分支；[源码](../paper/width_bounds.tex)、[六页PDF](../output/pdf/width_bounds.pdf)、[审阅包](../output/width_bounds_review_v0_1.zip) | 冻结快照。不能把其中较早的形式化范围当作当前上限，也不能改名替换成新内容。 |
| v0.2 | 全宽度无枚举解析证明、严格第一界及传统半群应用；[源码](../paper/width_bounds_v0_2.tex)、[五页PDF](../output/pdf/width_bounds_v0_2.pdf)、[说明](../paper/README_v0_2.md) | 同样冻结。其“商环/Betti接口未完成”等当时状态不抹掉，最新增量另存。 |
| v0.3 | 本次研究交付汇总：真实维数、最少数、商/张量/标准Tor₁、真实下界族、达到极值与标准Theta，以及全过程和未来扩展说明；[新源码](../paper/width_bounds_v0_3.tex)、[新PDF](../output/pdf/width_bounds_v0_3.pdf)、[新归档](../output/ai4math_research_delivery_v0_3.zip) | 文稿与载荷准备验收见DELIVERY及R049/R051；最终ZIP字节校验数值以包外receipt为准。旧v0.1/v0.2不覆盖。 |

### 9.3 最小恢复与验证入口

在项目根目录执行；Python只用本项目根 uv `.venv`。当前 `pyproject.toml` 固定 Python 3.13 系列，研究脚本依赖为标准库。不要用系统Python替代已经规定的解释器。

```powershell
.venv\Scripts\python.exe -B scripts/checkpoint.py --check
.venv\Scripts\python.exe -B scripts/checkpoint.py --verify-latest
```

`--check`只检查队列的任务编号、状态、文件所有权与依赖；`--verify-latest`检验最新归档及其中记录的证据，再单独报告工作区相对快照的修改。`archive_valid: true` 与 `workspace.changed: true` 可以同时成立，含义是有效旧快照之后发生正常工作，不是归档损坏。源码检查点按文件读取，并非跨工作区的事务快照；默认不打包可重建依赖缓存，部分冻结二进制仅作为外部哈希引用，不能指望仅靠源码快照还原其字节。

Lean固定为 `leanprover/lean4:v4.22.0`，mathlib固定 `v4.22.0`，实际依赖提交由 [lake-manifest.json](../lean/lake-manifest.json) 锁定。现有记录的mathlib提交为 `79e94a093aff4a60fb1b1f92d9681e407124c2ca`。构建入口为

```powershell
Push-Location lean
lake build
Pop-Location
```

缓存保持项目内：Python使用 `.uv-cache`，mathlib下载缓存使用 `.mathlib-cache`，Lake产物在 `lean/.lake`。全新机器重建依赖的准确操作及交付包自检用 [DELIVERY](DELIVERY.md) 的最终命令；不要无意升级toolchain或mathlib来消除报错。第一次构建若缺依赖模块，应先辨认缓存缺失和源码证明错误。真正重跑构建后另存新日志、核对退出码与公理/依赖输出，不覆盖当前冻结统一日志。

原始实验可在需要检查相应历史证据时，选择性运行根 `.venv\Scripts\python.exe -B -X utf8` 加 [envelope_certificate.py](../scripts/envelope_certificate.py)、[research_analytic.py](../scripts/research_analytic.py) 或 [semigroup_semantic_check.py](../scripts/semigroup_semantic_check.py)。它们不是每次恢复必跑的前提，也无需为了阅读报告重新开展全枚举。v0.3归档工具入口为 [package_delivery.py](../scripts/package_delivery.py)。发布流程中以默认创建命令执行一次，已存在的冻结版会拒绝覆盖。日常复核使用 `--verify`，它直接读取ZIP内的清单、全部载荷SHA-256和包内claims，不依赖当前工作区的对应源码文件；文稿与载荷准备验收见DELIVERY，最终ZIP数值见包外receipt。

```powershell
.venv\Scripts\python.exe -B -X utf8 scripts/package_delivery.py --verify output/ai4math_research_delivery_v0_3.zip
```

打包设计收录当前源码、研究任务、文本日志、三版PDF、旧两版审阅ZIP，以及最终检查点的LATEST和其所指快照；不包含全部历史检查点或Lean/Python运行时。先创建稳定最终检查点，再建立ZIP。包内manifest不记录自己的哈希，以免产生自引用循环；包外 `output/ai4math_research_delivery_v0_3.receipt.json` 记录整体ZIP哈希及最终检查点。`--verify`不读取这份包外收据；核对整个ZIP还须另将ZIP实算SHA-256与receipt的 `sha256` 字段比较，准确命令见DELIVERY。该收据用于字节核验，不是密码签名、作者身份认证或一次新的Lean构建。

<a id="part-10"></a>

## 10. 可选后续工作包：未来授权后再启动

以下不是当前队列待办，也不影响本阶段按研究交付结束。它们提供将来继续研究的可执行起点；每一包都应先独立登记任务和文件所有权，再做有限验收。不要把“可以继续做”理解成当前已经承诺完成或有确定日期。

### A. 标准高阶Tor与lex Betti公式

**起点与输入：** C021的标准Tor₁同构、真实有限余长lex模型、完整极小生成元分类；[TorOneBridge](../lean/WidthBounds/TorOneBridge.lean)、[ChosenResolution](../lean/WidthBounds/ChosenResolution.lean)、[DerivedKernel](../lean/WidthBounds/DerivedKernel.lean)，以及传统公式 \(b_1(I)=a+2\ell\)、\(b_2(I)=\ell\)。

**首个有限目标：** 先选择一种可核验的分解路线，例如实际lex分解的更高微分或与标准Tor兼容的Koszul计算，明确第2、3阶同调对象、底环、因子顺序和K标量；先完成一个真实高阶对象的计算接口，不同时承诺整个半群定理。

**验收：** 对实际标准 \(\operatorname{Tor}_2^A(A/\mathfrak m,A/I)\)、\(\operatorname{Tor}_3^A(A/\mathfrak m,A/I)\) 得到准确维数、有限性和必要比较，并经独立语义审查、固定版本构建与claims登记。不能定义新数列为 \(a+2\ell,\ell\) 后称高阶Tor已完成。

**风险与停止条件：** mathlib固定版本的分解/同调API工作量可能高于纸面证明；必须证明真实微分和正合性。若两次实质路线尝试没有新增可验证接口，保存局部引理与明确障碍，停止扩张，由主智能体重新选有限目标；不通过自定义公理跳过。

### B. 原数值半群归约的端到端形式化

**起点与输入：** [algebra_bridge_audit](algebra_bridge_audit.md) 的逐条传统命题、原半群最小生成性与任意域假设，以及已完成的实际lex接口。先制作“已有mathlib API／需要新建对象／仅文献引用”依赖清单。

**首个有限目标：** 在实际数值半群对象上建立 \(R/(t^m)\) 与Apéry标准基及真实Hilbert维数的接口，或者先单列正则参数约化保持目标Betti数；两者只选一个作为首项，不把整条归约塞进一个任务。

**验收：** 每一步必须连接实际环、实际模和实际标准Tor，保留局部完备与分次仿射表示的区别；最终还要覆盖低重数预算、\(w=3\)算术序列分支、一般特征lex比较以及高阶消失。只有整条链闭合后才能宣布原半群定理端到端Lean完成。

**风险与停止条件：** 这可能需要大量完备局部环、过滤/关联分次和变形比较基础设施，没有证据支持固定结束日期。若清单显示核心依赖在固定库中缺失，应交付诚实的缺口及可复用第一块，而非假称已有C023足够；用户未重新授权前不启动此包。

### C. 精确极值、最优常数或跨域独立性

**起点与输入：** `LexExtremal.lengthSet`、`maxLexLength_isGreatest`、显式双曲阶梯族与精确整除和；当前常数为1/16与10，尚无最优首项系数。

**首个有限目标：** 可在已定义的同一真实类中寻找更紧解析上下界，或先证明最大值对系数域的独立性。若进行小参数枚举，必须清楚标为候选发现工具，并给完整可行性与截断理由；不能把逐次数包络和当作真实可达到最大值。

**验收：** 一条明确新不等式、确定的跨域双向构造，或一个经验证反例；若主张最优系数，须有匹配上界、下界及极限/渐近接口，而非仅改进数值常数。

**风险与停止条件：** 当前构造族不一定极值，经典除数渐近也不自动说明整个类的最优系数。设定有限搜索范围和解析尝试数，到界后保存失败约束并停，不以无限枚举寻找漂亮曲线。

### D. 实际半群的下界或lex比较取等机制

**起点与输入：** R019的Apéry/Hilbert语义反查脚本和C022真实lex族。第一步必须明确需要的是半群自身的最小关系数或标准Tor下界，而非只实现Hilbert轮廓。

**首个有限目标：** 对一个明确四最小生成元参数族，证明最小性、数值半群性和宽度，并独立计算/估计实际关系数；或者证明满足可核查条件时lex比较取等。

**验收：** 真实半群族的下界定理和可核验参数范围；若仅有有限实验，结果只能标experimental。若发现目标lex族根本不能实现，也应交付有理由的排除命题。

**风险与停止条件：** 最大lex Betti数可能远大于原半群；不能倒用上界比较。若仅得到同Hilbert函数而无实际Betti连接，停在该准确层，不升级为匹配 \(\Theta\) 半群结论。

### E. 文献定位、人类审稿与公开版本

**起点与输入：** v0.3交付、C003、R015/R023历史检索及精确定理表。经典归约与候选增量应分开列给审阅者。

**首个有限目标：** 用户重新授权后，可限定检索时间和问题，核对是否已有同一预算类的全宽度严格界或 \(\Theta\) 结论；人类审稿再检查代数拼接、候选新颖性和发表价值。

**验收：** 得到可以定位的原始定理对照、具体数学意见或必要修订；“没有搜到”仍不等于原创认证。

**风险与停止条件：** 外部审稿受他人时间影响，不作为当前交付前提。发信、上传、发表需用户明确授权具体动作；R009在此之前保持暂缓。达到既定检索范围即收束，不能无限重复查新。

### F. 迁移或维护形式化基础设施

**起点与输入：** 冻结4.22.0源码、claims和成功日志、交付归档。维护需要与数学扩展分开。

**首个有限目标：** 若用户要求升级Lean/mathlib，在独立副本或新版本中处理少量API迁移，先重建全部现有声明，不同时更改结论。

**验收：** 同一精确陈述、公理和实际依赖检查在新版本统一通过，保留旧版本可复现证据；记录每一处语义而非纯语法差异。

**风险与停止条件：** 升级可能引入隐式实例和库定理变化；失败时保存迁移报告并保留原稳定4.22.0，不用删除旧日志或覆盖旧快照掩盖差异。

<a id="part-11"></a>

## 11. 将来如何从交付重启

重启首先读取本报告、AGENTS、STATE、HANDOFF、queue，运行两项检查点检查。再核对 [DELIVERY](DELIVERY.md) 中冻结归档清单和claims证据。若旧 `running` 执行者不存在，先看它已写的报告、源码和日志，区分计划、局部编译、最终统一验收；不要从任务名猜测进度，也不要删除后重做。

用户选择具体未来包之后，主智能体才新增有限任务、依赖、独占文件和验收条件。同时最多两个子智能体（含执行者与审查者），按可用槽安排；子智能体以文件任务启动、不再自行派生，根维护import、配置、状态和结论登记。重要中间结果及时落盘，长任务约30分钟保存一次明确标WIP的检查点；完成可验收里程碑、改路线或停止前更新STATE、HANDOFF、queue、claims并建新检查点。

若修改证明，保存新的构建日志和源码hash，重新核对相关声明的实际数学含义；字节完整性验证不能替代编译，编译也不能替代“是否形式化了原本想证明的命题”的审查。未来文稿使用新版本文件名，v0.1、v0.2、已冻结v0.3以及历史检查点均不覆写。没有新的数学授权时，读者可以检查、学习和复现本交付，当前研究阶段保持关闭。



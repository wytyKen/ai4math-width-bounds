# 四生成元数值半群宽度界：第一轮研究记录

日期：2026-09-23。

本记录保留最初的研究推导。最新状态（第三轮）：新增组合部分已完整形式化，包括指数集合计数、单调性、累计包络、截断和三个小宽度界。主定理见 `lean/WidthBounds/SmallWidth.lean`，可读证明见 `research/combinatorial_proof.md`。**半群环、lex 理想及 Betti 数之间的代数识别与文献归约尚未整体形式化。** 有限查新未发现相同改进，不能据此宣称已确认新颖性或可发表性。

## 来源与选定问题

- Caviglia–Moscariello–Sammartano, *Bounds for syzygies of monomial curves*, Proc. AMS 152 (2024), 3665–3678，最终 arXiv v2，2024-07-20。<https://arxiv.org/html/2307.05770v2>。
- 主要依据：原文式 (7)、定理 3.3、定理 5.1、定理 1.5、备注 5.2。
- 原文证明四生成元且宽度 `w >= 40` 的 Betti 数宽度界；备注 5.2 明确讨论 `4 <= w <= 39` 的未覆盖范围。
- Moscariello–Sammartano 综述（出版年份2025，v2修订于2026-05-26）仍列出 `w >= 40` 的结果：<https://arxiv.org/html/2406.00790v2>。

我们研究原文已经归约到的有限余长 lex 理想问题；不枚举有界重数的半群。

## 候选组合引理

设 `S = k[x,y,z]`，变量顺序 `x > y > z`。设 `L` 是有限余长的 lex 单项式理想，`L ⊆ (x,y,z)^2`，且对每个整数 `d >= 0`，

\[
\operatorname{HS}(S/L,d)\le 1+dw.
\]

记 `K = L ∩ k[x,y]`，它等同于原文 `(L+(z))/(z)`；令

\[
h_d=\dim_k(k[x,y]/K)_d,\quad
\alpha=\min\{a:x^a\in L\},\quad
\beta=\min\{b:y^b\in L\},\quad
\ell=\sum_{d\ge0}h_d.
\]

有限余长保证纯幂存在，且 `2 <= alpha <= beta`。lex 性保证 `alpha` 是 `L` 的初始次数。

### 1. 二维 Hilbert 函数的形状

对于 `d < alpha`，有 `h_d=d+1`。对于 `d >= alpha-1`，有 `h_(d+1) <= h_d`。

证明后一断言：次数 `d+1 >= alpha` 的纯 `x` 幂在 `K` 中，所以该次数的每个标准单项式都含 `y`。除以 `y` 是到前一次数标准单项式集合的单射。特别地，对 `d >= alpha`，`0 <= h_d <= alpha`。

对 `d >= beta`，有 `h_d=0`：`y^beta ∈ K`，同次所有二维单项式均在 lex 理想中。

### 2. 用二维标准单项式强制三维标准单项式

固定 `d`，设 `h=h_d`。二维标准单项式恰为

\[
x^i y^{d-i},\qquad 0\le i<h.
\]

由于 `L` 是 lex 理想，每个这样的单项式以下的同次单项式也标准。因此，对固定 `i`，

\[
x^i y^j z^{d-i-j},\qquad 0\le j\le d-i
\]

全部标准。这些集合对不同的 `i` 不交，故

\[
\operatorname{HF}(S/L,d)\ge q_d(h_d),\qquad
q_d(h)=\sum_{i=0}^{h-1}(d-i+1)
=h(d+1)-\frac{h(h-1)}2.
\]

这里是**下界**，不是声称任意 `L` 都取等。

### 3. 逐次数包络

次数 `0,...,alpha-1` 的总维数恰为

\[
P_\alpha=\binom{\alpha+2}{3}\le1+(\alpha-1)w.
\]

固定 `d >= alpha`，记 `h=h_d`。对 `alpha <= t <= d`，单调性给出 `h_t >= h`；在这里的取值范围，`q_t` 关于高度单调，因为 `q_t(h+1)-q_t(h)=t+1-h>0`。因此

\[
P_\alpha+\sum_{t=\alpha}^d q_t(h)
=P_\alpha+\frac{(d-\alpha+1)h(\alpha+d+3-h)}2
\le1+dw.
\]

定义完全有限的整数

\[
r_d(\alpha,w)=\max\left\{h\in\{0,\ldots,\alpha\}:
2P_\alpha+(d-\alpha+1)h(\alpha+d+3-h)\le2+2dw\right\}.
\]

集合非空：`h=0` 可行，因为 `P_alpha <= 1+(alpha-1)w <= 1+dw`。
于是 `h_d <= r_d`。不同次数的上界未必能同时取到；将它们相加仍是合法上界。

### 4. 有限截断

由 lex 性，所有次数小于 `beta` 的 `y,z` 单项式都标准，故

\[
\binom{\beta+1}{2}\le1+(\beta-1)w.
\]

因 `beta >= 2`，整理后得到 `beta <= 2w-2`；原文的较松界 `beta <= 2w+1` 也足够。
为直接对接原文，现有 Python 与 Lean 证书均使用较松但安全的截断 `2w`。
同时 `alpha <= beta <= 2w+1`，所以 alpha 的枚举上限完整。

因此

\[
\ell\le B(\alpha,w):=
\binom{\alpha+1}{2}+\sum_{d=\alpha}^{2w}r_d(\alpha,w).
\]

### 5. 从长度回到 Betti 数

二维有限余长 lex 理想 `K` 恰有 `alpha+1` 个极小生成元：对 `0 <= i <= alpha`，记 `t_i` 为使 `x^i y^(t_i) ∈ K` 的最小非负整数。则 `t_alpha=0`，且 lex 性给出 `t_(i+1) <= t_i-1`。因此这些 `alpha+1` 个边界单项式互不整除，恰好生成 `K`。又因为二维有限余长理想的自由分解长度为 1、秩为 1，有 `b_1(K)=b_0(K)-1=alpha`。
原文式 (7) 给出

\[
b_0(L)=\alpha+1+\ell,\qquad
b_1(L)=\alpha+2\ell,\qquad
b_2(L)=\ell.
\]

这里 `b_i(L)` 是**理想作为模**的 Betti 数，不是商环的同下标 Betti 数。
相应的商环正次数 Betti 数为 `b_(i+1)(S/L)=b_i(L)`。

## 有限算术证书

对所有 `4 <= w <= 39`，枚举全部满足

\[
2\le\alpha\le2w+1,\qquad
\binom{\alpha+2}{3}\le1+(\alpha-1)w
\]

的参数，共 **267 组**。逐一核验

\[
\alpha+1+B\le\binom{w+1}{2},\quad
\alpha+2B\le2\binom{w+1}{3},\quad
B\le3\binom{w+1}{4}.
\]

全部通过。边界例子：

| 宽度 | 三个包络最大上界 | 三个目标界 |
|---:|---|---|
| 4 | (10,16,7) | (10,20,15) |
| 5 | (13,22,10) | (15,40,45) |
| 10 | (34,62,29) | (55,330,990) |
| 39 | (197,383,187) | (780,19760,274170) |

完整输出：`results/envelope_certificate.json`。
独立动态规划输出：`results/dp_audit.json`。DP 保留每个 `(次数,末项高度,累计长度)` 的最小累计维数，采用所有次数的累计约束，得到更紧的数值。候选证明只需要更简单的包络证书。

## 与原半群问题的连接及边界

对于四生成元数值半群 `Gamma`，其宽度至少为 3。

1. 若 `w >= m(Gamma)-1`，原文推论 2.4 已经给出目标结论。
2. 否则，原文定理 3.3 构造有限余长单项式理想 `J_Gamma`，满足上述 Hilbert–Samuel 界。取具有相同 Hilbert 函数的 `L=Lex(J_Gamma)`。
3. 原文的 Artinian 约化、初始理想及 Bigatti–Hulett–Pardue 比较，给出 `b_i(R_Gamma) <= b_i(S/L)`。上面的三个界因此分别用于 `i=1,2,3`；更高 Betti 数为零。
4. `w >= 40` 使用原文已发表的定理 1.5。
5. `w=3` 时四个最小生成元必为连续四整数。准确依据为 Herzog–Stamate, *On the defining equations of the tangent cone of a numerical semigroup ring*, arXiv:1308.4644v3，**命题 2.7**：对于最小生成元为算术序列、生成元数为 `r` 的半群，`b_i(k[Gamma]) <= i*binom(r,i+1)`。取 `r=4=w+1` 即得所需界；局部化及完备化保持这里的 Betti 数。命题 2.5、2.8 还给出相应切锥结论，但本步骤用命题 2.7 已足够。原文：<https://arxiv.org/pdf/1308.4644>，PDF 第 9 页。不能用本引理直接覆盖 `w=3`。

一个必要的反例检查：

\[
L=(x^2,xy,xz)+(y,z)^3
\]

满足 `HS(S/L,d) <= 1+3d`，但 `mu(L)=7 > 6`。这表明将一般 lex 断言扩到 `w=3` 是错误的；它不构成半群猜想的反例。

## 核验范围与下一步

- 已完成：公式独立推导、两次数学挑错、两种 Python 算法、独立第三次参数计算、Lean 4.22.0 编译与内核计算核验。
- `lake build` 成功，Lean 的 `#print axioms` 报告 `finite_envelope_certificate` 不依赖任何公理。原始关键输出保存在 `results/lean_check.txt`。
- 原 `Arithmetic.lean` 仅证明有限 Bool 计算；新增 `LexCounting`、`Prefix`、`Cutoff`、`Envelope`、`Length`、`Certificate`、`SmallWidth` 已从具体指数集合的闭包条件证明完整的组合连接。全部通过统一 `lake build`，日志见 `results/lean_combinatorial_build.txt`。
- 第二轮已核对：CMS 式 (7) 的模/商环下标、有限余长条件、末变量截面，以及 `w=3` 的准确原始引用。
- 待完成：代数应用由领域专家独立复核，或进一步形式化该文献归约；继续核查新颖性。
- 当前允许的表述：**新增组合引理已获得 Lean 证明；其四生成元代数应用依赖原论文的归约，原创性与发表性尚未确认**。
- 当前不允许的表述：已经完成全部 Lean 形式化、已经确认原创、已经获数学界认可、一般生成元数的猜想已解决。

本记录没有对外提交、发邮件或上传论文。

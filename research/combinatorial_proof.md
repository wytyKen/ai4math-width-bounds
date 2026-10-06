# 小宽度组合引理：证明与形式化范围

2026-09-23。本文独立说明本轮新增的组合论证。Lean 主定理为 `WidthBounds.small_width_binomial_bounds`，位于 `lean/WidthBounds/SmallWidth.lean`。

## 1. 精确命题

用 `A(i,j,k)` 表示单项式 `x^i y^j z^k` 是标准单项式。设它满足：

1. **整除下闭**：标准单项式的因子仍标准。
2. **同次 lex 向下闭**：在变量顺序 `x>y>z` 下，同次且字典序较小的单项式仍标准。

这两个条件在 Lean 中由 `StandardLex A` 明确表达；lex 单项式理想的补集满足它们。

记 `h_d` 为次数 `d` 的二维标准单项式 `x^i y^(d-i)` 的数量，`H_d` 为次数 `d` 的全部三维标准单项式数量。假设整数 `w,alpha` 满足

\[
4\le w\le39,\qquad \alpha\ge2,
\]

`x^d` 对 `d<alpha` 标准，`x^alpha` 不标准，并且对每个 `d>=0`，

\[
\sum_{t=0}^{d}H_t\le1+dw.
\]

则 `h_d=0` 对所有 `d>=2w-2` 成立。因此

\[
\ell:=\sum_{d\ge0}h_d=\sum_{d=0}^{2w}h_d
\]

是有限整数，并有

\[
\alpha+1+\ell\le\binom{w+1}{2},\qquad
\alpha+2\ell\le2\binom{w+1}{3},\qquad
\ell\le3\binom{w+1}{4}.
\]

Lean 采用右边的有限和定义 `sectionLength`，另外证明任意更长的部分和都与之相等。

## 2. 单调性与列计数

由于 `x^alpha` 不标准，整除下闭性保证更大的纯 `x` 幂也不标准。次数至少为 `alpha` 的二维标准单项式因此都含 `y`。除以 `y` 给出到前一次数标准单项式的单射，所以

\[
h_{\alpha-1}\ge h_\alpha\ge h_{\alpha+1}\ge\cdots.
\]

另一方面，同次 lex 向下闭性保证二维标准单项式恰为

\[
x^i y^{d-i},\qquad 0\le i<h_d.
\]

每个这样的单项式强制以下整列单项式标准：

\[
x^i y^j z^{d-i-j},\qquad 0\le j\le d-i.
\]

不同的 `i` 对应互不相交的列。于是

\[
H_d\ge q_d(h_d),\qquad
q_d(h)=\sum_{i=0}^{h-1}(d-i+1)
=\frac{h(2d+3-h)}2.
\]

Lean 中这一步是实际有限集合的注入及基数比较，没有把计数结论作为假设。

## 3. 低次数的精确计数

当 `d<alpha` 时，纯 `x^d` 标准，lex 向下闭性使所有同次单项式标准。因此

\[
h_d=d+1,\qquad H_d=\binom{d+2}{2}.
\]

求和得到

\[
\sum_{d=0}^{\alpha-1}h_d=\binom{\alpha+1}{2},\qquad
P_\alpha:=\sum_{d=0}^{\alpha-1}H_d=\binom{\alpha+2}{3}.
\]

三维公式在 Lean 中通过指数集合与逐列集合的显式双射证明，再应用二项式求和。由预算条件还有 `P_alpha <= 1+(alpha-1)w`。

## 4. 截断与参数覆盖

若 `h_d>0`，lex 向下闭性使 `y^d` 标准。整除下闭性和 lex 向下闭性继而使每个低次数 `t<=d` 的全部 `y,z` 单项式标准，故

\[
\frac{(d+1)(d+2)}2\le\sum_{t=0}^dH_t\le1+dw.
\]

对 `d>0`，整理为 `d+3<=2w`。所以 `d>=2w-2` 时 `h_d=0`。

这也证明 `alpha<=2w+1`：否则初始次数条件会让 `x^(2w+1)` 标准，产生一个截断之后仍非零的二维分量，矛盾。实际截断更强，但有限证书沿用较松上限以便对接原计算。

## 5. 累计约束给出逐次数上界

固定 `d>=alpha`，令 `h=h_d`。对 `alpha<=t<=d` 有 `h_t>=h`。由于 `q_t` 在这里的高度范围内单调，

\[
P_\alpha+\sum_{t=\alpha}^d q_t(h)
=P_\alpha+\frac{(d-\alpha+1)h(\alpha+d+3-h)}2
\le1+dw.
\]

定义整数

\[
r_d(\alpha,w)=\max\left\{0\le h\le\alpha:
2P_\alpha+(d-\alpha+1)h(\alpha+d+3-h)\le2+2dw\right\}.
\]

集合含零；真实高度 `h_d` 是候选之一，因此 `h_d<=r_d`。结合低次数计数和截断，

\[
\ell\le B(\alpha,w):=
\binom{\alpha+1}{2}+\sum_{d=\alpha}^{2w}r_d(\alpha,w).
\]

这里没有假设各次数的最大高度能同时实现。逐次数最大值的和仍然是合法上界。

## 6. 有限且穷尽的最后一步

真实参数必满足

\[
4\le w\le39,\quad 2\le\alpha\le2w+1,\quad
\binom{\alpha+2}{3}\le1+(\alpha-1)w.
\]

全部可行参数共267组。`Arithmetic.lean` 用 Lean 内核可核验的 `decide` 证明，逐一将 `B` 代入三个目标不等式均成立。`Certificate.lean` 从布尔证书推出量化整数定理，`Length.lean` 证明逐点上界可累加为总长度界，`SmallWidth.lean` 将它们与上面全部组合引理连接。

这一步穷尽的是经证明覆盖全部对象的**辅助参数**，并不是仅测试某个重数以内的半群。

## 7. 形式化文件与范围

| 模块 | 已证明内容 |
|---|---|
| `LexCounting.lean` | 指数集合、标准性闭包、二维单调性、三维计数下界 |
| `Prefix.lean` | 从集合定义得到精确低次数计数与两个前缀和 |
| `Cutoff.lean` | 从累计预算证明支持有限、参数范围完整 |
| `Envelope.lean` | 有限和恒等式、累计约束、逐次数上界 |
| `Length.lean` | 从逐次数上界推总长度上界 |
| `Arithmetic.lean` | 内核核验的有限算术证书 |
| `Certificate.lean` | 证书对应的量化整数定理 |
| `SmallWidth.lean` | 从标准单项式条件到常规二项式记法下三个界的统一定理 |

新增主定理依赖 mathlib 通常使用的 `propext`、`Classical.choice`、`Quot.sound`；没有 `sorry`、新增公理或 `native_decide`。原来的有限计算证书本身仍不依赖公理。不要把二者的依赖报告混淆。

## 8. 代数应用及仍待完成的工作

若 `A` 是有限余长 lex 理想 `L ⊂ k[x,y,z]` 的标准单项式集合，则 `h,H` 分别是二维截面和三维商环的 Hilbert 函数，`ell` 是二维截面余长。CMS 原文式(7)给出

\[
b_0(L)=\alpha+1+\ell,\quad b_1(L)=\alpha+2\ell,\quad b_2(L)=\ell.
\]

由此可将本组合结论用于其小宽度 Betti 数问题，再按 CMS 的半群约化、初始理想及 lex 比较连接原问题。[CMS 原论文](https://arxiv.org/html/2307.05770v2)

**上述代数对象与组合模型之间的识别、Betti 数公式以及半群归约尚未整体形式化。** 它们在本项目中作为有准确出处的传统数学论证使用。宽度3需要另用算术序列情形，宽度至少40使用 CMS 已有定理。

需要保留一个边界条件：组合定理本身并不要求三维标准集有限，只证明二维截面的支持有限。回到式(7)时必须另行携带原理想的有限余长条件。例如 `L=(x^2,xy,xz,y^2,yz)` 的标准集中保留任意高的 `z` 幂，能满足组合预算，却不是有限余长理想；不能对它套用上述 Betti 数等式。

本轮完成的是新增组合部分的完整机器证明；结果是否已有文献覆盖、完整代数应用是否得到人类专家认可，仍需继续核查。定向文献记录见 `literature_review.md`。

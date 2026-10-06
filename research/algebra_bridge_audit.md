# 四生成元宽度界：独立代数归约审查

审查日期：2026-09-23。已独立读取 `research/combinatorial_proof.md`、`research/first_pass.md`、`lean/WidthBounds/SmallWidth.lean` 的最终命题及 `StandardLex` 定义；逐项核对本地 `references/cms2024.html`（arXiv:2307.05770v2）和 Herzog–Stamate 的 arXiv:1308.4644v3 命题 2.7。没有沿用前轮审查结论，也没有修改其他文件。

**结论：在接受已发表代数结果的通常数学意义下，新组合定理足以补齐全部四生成元数值半群的局部半群环宽度界，没有发现尚缺的数学归约步骤。** 精确结论应写为：任意域 $k$、恰有四个最小生成元的数值半群 $\Gamma=\langle g_0,g_1,g_2,g_3\rangle$，令 $m=g_0$、$w=g_3-g_0$、$R=k\llbracket t^\Gamma\rrbracket$，则
\[
b_i^P(R)\le i\binom{w+1}{i+1}\quad(i\ge1),\qquad P=k\llbracket x_0,x_1,x_2,x_3\rrbracket.
\]
这里不是 $\operatorname{Tor}^R(k,k)$ 的 Betti 数，也不能把范围写成 $i\ge0$（因为 $b_0^P(R)=1$）。以下列出足以直接用于论文证明的各命题。

## 命题一：域、正则表示和余维

CMS 第 1、2 节从任意域出发；$R$ 是一维 Cohen–Macaulay 局部整环，给定表示是最小正则表示。最小生成元对应的 $t^{g_i}$ 在 $\mathfrak m_R/\mathfrak m_R^2$ 中线性独立，故 $I=\ker(P\to R)\subseteq\mathfrak m_P^2$。若某个线性项能被更高次项抵消，相应的 $g_i$ 就会是至少两个正半群元素之和，与最小性矛盾。

因此 $\operatorname{edim}(R)=4$、$\operatorname{codim}(R)=3$；Auslander–Buchsbaum 给出 $\operatorname{pd}_P R=4-1=3$，所以 $b_i^P(R)=0$ 对所有 $i\ge4$ 成立。四个互异整数最小生成元还保证 $w\ge3$。

来源：[CMS 第 2 节](https://arxiv.org/html/2307.05770v2#S2)，尤其一维 Cohen–Macaulay 性、最小正则表示及 Betti 数约定。上述高阶消失也可由命题二的三变量商环比较得到。

## 命题二：Artinian 约化、初始理想和 lex 比较

设 $\overline P=P/(x_0)$、$\overline I=(I+(x_0))/(x_0)$。因为 $t^m$ 是 $R$ 的非零因子，令 $\overline R=R/(t^m)$，则
\[
b_i^P(R)=b_i^{\overline P}(\overline R),\qquad \ell(\overline R)=m.
\]
这是沿同时在 $P,R$ 上正则的参数作约化；原最小自由分解张量 $P/(x_0)$ 后仍正合且最小。**不是**断言任意局部环与其切锥 Betti 数相等。

在 $Q=k[x_1,x_2,x_3]$ 中置 $G=(\overline I)^*$（最低次数初始形式理想）、$J=\operatorname{in}_{\mathrm{revlex}}G$、$L=\operatorname{Lex}(J)$。CMS 式 (1) 和定理 2.1 给出，对 $i\ge1$，
\[
\begin{aligned}
b_i^P(R)&=b_{i-1}^{P}(I)=b_{i-1}^{\overline P}(\overline I)\\
&\le b_{i-1}^{Q}(G)\le b_{i-1}^{Q}(J)
\le b_{i-1}^{Q}(L)=b_i^{Q}(Q/L).
\end{aligned}
\]

第一个不等式来自局部环到关联分次环的 Betti 上半连续性；第二个来自 Gröbner 初始理想；第三个是 Bigatti–Hulett–Pardue。无需假设切锥 Cohen–Macaulay、半群环同质、域无限或特征零。CMS 定理 2.1 的证明明确分别引用特征零版本和 Pardue 的一般特征版本。

$Q/G=\operatorname{gr}(\overline R)$ 有有限长度 $m$，传到 $J$ 和 $L$ 时 Hilbert 函数不变，故 $Q/L$ 也有有限长度 $m$。又 $\overline I\subseteq\mathfrak m_{\overline P}^2$，所以 $G,J,L\subseteq(x_1,x_2,x_3)^2$：后三者商环的一次分量维数均为 3。这同时核实了有限余长和“无一次项”，不需要从累计预算反推它们。

来源：[CMS 第 2 节](https://arxiv.org/html/2307.05770v2#S2)、[定义 3.1 与式 (1)](https://arxiv.org/html/2307.05770v2#S3.E1)、[定理 2.1](https://arxiv.org/html/2307.05770v2#S2.Thmthm1)。

## 命题三：预算与组合模型逐项匹配

只有在 $w\le m-2$ 的分支才使用 CMS 定理 3.3；它确实给出
\[
\operatorname{HS}(Q/J,d)\le1+dw\quad(d\in\mathbb N).
\]
取同 Hilbert 函数的 $L$ 后预算不变。定理还给出一个理想包含关系，但本次组合论证不需要它。

改记 $Q=k[x,y,z]$，lex 顺序为 $x>y>z$，置 $A(i,j,k)\iff x^iy^jz^k\notin L$。标准单项式对整除下闭，同次 lex 较小单项式也标准，恰好满足 Lean 的 `StandardLex A`。

有限余长保证存在 $\alpha=\min\{a:x^a\in L\}$；无一次项保证 $\alpha\ge2$。于是 `hInitial` 与 `hx` 正是该最小性的两面。`hilbert3 A d` 等于 $\dim_k(Q/L)_d$，所以 Lean 的 `hHS` 就是上述累计 Hilbert–Samuel 预算。

令 $K=L\cap k[x,y]$。因为 $L$ 是单项式理想，$K$ 等于 $(L+(z))/(z)$ 在 $k[x,y]$ 中的识别，且是有限余长 lex 理想。`hilbert2 A d` 等于 $\dim_k(k[x,y]/K)_d$。Lean 已证明截断后的二维分量为零，故 `sectionLength A w` 确实等于 $\ell=\ell(k[x,y]/K)$，没有遗漏无限尾项。

来源：[CMS 定理 3.3](https://arxiv.org/html/2307.05770v2#S3.Thmthm3)、`lean/WidthBounds/LexCounting.lean`、`lean/WidthBounds/SmallWidth.lean` 中的 `sectionLength_eq_sum_of_ge` 与 `small_width_binomial_bounds`。

## 命题四：二维长度转回三个 Betti 数

在二维有限余长 lex 理想 $K$ 中，对每个 $0\le i\le\alpha$ 恰有一个边界生成元 $x^iy^{t_i}$，其中 $t_\alpha=0$，而 lex 性使 $t_{i+1}<t_i$。因此 $\mu(K)=\alpha+1$；$K$ 的投射维数为 1、秩为 1，故 $b_1(K)=\alpha$、$b_j(K)=0$ 对 $j\ge2$ 成立。

CMS 引理 4.2 证明中的式 (7) 明确以 $Q/L$ 有限长度为前提。取三变量，得到
\[
b_0^Q(L)=\alpha+1+\ell,\qquad
b_1^Q(L)=\alpha+2\ell,\qquad
b_2^Q(L)=\ell.
\]
所以当 $4\le w\le39$，`small_width_binomial_bounds` 的三个结论分别成为 $b_1^Q(Q/L)$、$b_2^Q(Q/L)$、$b_3^Q(Q/L)$ 的所需上界，再用命题二即可。

式 (7) 的证明使用末变量上的分解及 Koszul 分解，并无特征限制。此处必须保留原三变量商环的有限长度；新组合定理单独仅保证二维截面有限，不能因此对任意满足组合假设的三变量集合套用式 (7)。

来源：[CMS 式 (7)，含其引理前提](https://arxiv.org/html/2307.05770v2#S4.E7)、[第 5 节式 (12) 后的二维生成元计数](https://arxiv.org/html/2307.05770v2#S5)。

## 命题五：边界分支完整覆盖

1. **$w\ge m-1$。** CMS 推论 2.4 直接给出结论，包含等号边界。其依据是推论 2.3 的 $b_i(R)\le i\binom m{i+1}$ 以及 $m\le w+1$。因此不能无条件在全部半群上援引定理 3.3。
2. **$w=3$。** 四个最小生成元只能是 $m,m+1,m+2,m+3$。Herzog–Stamate 命题 2.7 的准确上界是 $\beta_i(k[\Gamma])\le i\binom r{i+1}$，范围 $1\le i\le r-1$；取 $r=4=w+1$ 即处理 $i=1,2,3$，更高项由命题一消失。该文的全局约定是任意域，命题没有附加特征条件。
3. **$4\le w\le39$ 且 $w\le m-2$。** 按命题二至四应用新组合定理。
4. **$w\ge40$。** CMS 定理 1.5 已直接给出全部 $i\ge1$ 的目标界。

第 2 项从仿射环到所需完备局部环还应写一句解释：$k[\Gamma]$ 按 $\deg x_i=g_i>0$ 正分次，取其关于 $k[x_0,\ldots,x_3]$ 的最小加权分次自由分解。所有微分矩阵元素在 $(x_0,\ldots,x_3)$ 中；先在此极大理想局部化、再完备化，平坦性保持正合，矩阵仍在极大理想中而保持最小性。因此各总秩不变，所得商环正是 $k\llbracket t^\Gamma\rrbracket$。这里所说“分次与局部 Betti 相等”是这一步，不是一般切锥等号。

来源：[CMS 推论 2.4](https://arxiv.org/html/2307.05770v2#S2.Thmthm4)、[CMS 定理 1.5](https://arxiv.org/html/2307.05770v2#S1.Thmthm5)、[Herzog–Stamate v3，命题 2.7，印刷页 9](https://arxiv.org/pdf/1308.4644v3#page=9)。

## 命题六：CMS 定理 5.1 的准确作用与剩余范围

CMS 定理 5.1 的陈述仅列 $w\ge40$ 时理想的 $b_0(L)$、$b_1(L)$ 上界，不能直接说它逐字给出了三个理想 Betti 数界。对于当前有限余长对象，式 (7) 补出
\[
b_2(L)=\ell\le\tfrac12 b_1(L)\le\binom{w+1}{3}\le3\binom{w+1}{4}\quad(w\ge4),
\]
故第三个界没有实质缺口；亦可直接引用其已发表的定理 1.5。定理 5.1 的陈述未重写有限余长，但所引用的式 (7) 在引理 4.2 中明确有该前提。定稿应在自己的 lex 命题中明确写入有限余长，避免复制这个措辞上的隐含条件。

来源：[CMS 定理 5.1 及定理 1.5 的证明](https://arxiv.org/html/2307.05770v2#S5)。

**剩余范围：**没有发现上述传统数学推导的缺口。当前 Lean 结果覆盖新增组合证明，未形式化半群环、局部约化、Gröbner/lex Betti 比较、式 (7)、完备化或大宽度文献定理。本审查没有重新编译 Lean，也没有重新证明 CMS 和 Herzog–Stamate 所引用的全部既有定理；它核查的是这些已发表命题的准确陈述、适用条件和拼接逻辑。新颖性、发表优先权和人类同行认可不由本审查推出。

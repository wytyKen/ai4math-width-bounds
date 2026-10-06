# R023：谐和增长界与极值 lex 类的定向查新

状态：完成，交主智能体验收；2026-09-23。执行者：growth_literature。仅修改本文件；三轮定向检索已收束。

## 判断与覆盖范围

**没有定位到直接证明此类截面 O(w log w) 或极值 Theta(w log w) 的一手文献；新颖性仍未定。问题、lex 截面归约与调和/除数计数各自已有明确先例，不能将它们一并称为新方法。** 对象限定为 S=k[x,y,z]、有限余长 lex 理想 L⊂(x,y,z)²、全部 d 的 HS(S/L,d)≤1+dw，以及 ell=dim_k S/(L+(z))。本次不重新审查 R018/R020 的证明，不涉及半群下界。

CMS《Bounds for syzygies of monomial curves》**arXiv:2307.05770v2，2024-07-20**（期刊版 PAMS 152 (2024), 3665–3678）Problem 4.1 正式提出完全相同的累计预算问题。Lemma 4.2、式(7)用 lex 超平面截面控制 Betti 数；§5 式(13)、(16)、(18)、(19)给出 ell≤binom(alpha+1,2)+alpha(beta-alpha)、alpha=O(sqrt(w))、beta=O(w)，即可推出 O(w^(3/2))。其 Remark 5.2 还明确建议利用所有中间次数预算。因此“使用所有次数预算”的方向已有先例；该版本所示推导没有给出本项目的谐和包络或匹配下界族。[CMS原文](https://arxiv.org/html/2307.05770v2)

White《Upper bounds for Betti numbers from constraints on the Hilbert function》**arXiv:2011.03401v1，2020-11-06**，Definition 1.3 和 §§2–3 给出固定最终 Hilbert 函数、限制函数及其一阶差分时计算最大 Betti 数的算法。不能仅以“饱和理想”排除关联：扩环 (S/L)[t] 的 Hilbert 函数就是原累计 HS，故固定最终长度后可与其框架联系；这是本报告的归约观察。它仍不是预算参数 w、最终长度未指定的统一渐近定理，也未给出上述双曲阶梯族。[White原文](https://arxiv.org/html/2011.03401v1)

下界的**数论计数已知**。设 D(N)=sum_{r=1}^N floor(N/r)=#{(r,q)∈Z_{>0}²:rq≤N}。R018 的 w=s²、n_i=floor(w/(i+1))-i 经 (i,j)↦(r,q)=(i+1,i+j+1)，恰对应 rq≤w、r≤q；对角线有 s 点，故

\[
\ell=\frac{D(s^2)+s}{2}.
\]

这也是从经典双曲恒等式 D(s²)=2 sum_{r≤s}floor(s²/r)-s² 立即得到的**本报告推论**。因 D(N)=N log N+(2γ−1)N+O(sqrt(N))，该族更精确满足 ell=(1/2)w log w+(γ−1/2)w+O(sqrt(w))（仅平方参数）。Manuel Eberl 的作者维护 AFP 条目《Dirichlet Series》（初始条目2017-10-12，本次查阅 current 版本）§13.4 已形式化双曲法及此除数和渐近；不是本项目 Lean 的验证证据。[作者条目](https://isa-afp.org/entries/Dirichlet_Series.html)、[证明纲要§13.4](https://www.isa-afp.org/browser_info/current/AFP/Dirichlet_Series/outline.pdf)

因此，尚待定位的不是谐和求和本身，而是：将该剪切后的双曲阶梯提升为三变量 artinian lex 理想、证明全部 HS 预算，以及证明该预算类的匹配最优增长阶。本次未找到相同理想构造的直接出处；三轮检索不能排除未索引文献、不同术语或后续改进。**下界只属于抽象 lex 类；即使有半群 Hilbert 函数实现，大 lex Betti 数也不能沿上界比较反推半群 Betti 下界。** 后续可把它表述为“CMS Problem 4.1 的三变量谐和增长改进候选，查新未完”，不称原创认证。

## 检索记录与恢复检查

每轮四个 query，并对命中项打开原文；非一手聚合页面仅用于定位，未作为结论依据。

1. `"lex" "Hilbert-Samuel" "width" Betti numbers`；`"lexsegment" "linear" "Hilbert" "log" generators bound`；`"Hilbert function" "w log w" ideal`；`"monomial ideal" "divisor" "harmonic"`。
2. White 全题名；`"lexsegment" "Hilbert-Samuel" bounds`；`"monomial ideals" "hyperbolic" "divisors"`；`"lex" "harmonic" "Hilbert function"`。
3. `"lexsegment" "log" "width" Betti`；`"monomial ideal" "divisor problem"`；`"hyperbola" "floor" "Dirichlet" "divisor" lecture notes`；`"Hilbert-Samuel" "harmonic" lex`。

另直接打开项目已知 CMS v2，并读 White v1 的定义/算法范围及上述 AFP 作者原始条目；Moor Xu 的 Soundararajan 2010 课程笔记§16.2.1亦交叉印证经典除数和，但最终结论引用作者维护的 AFP。未检索泛泛 Wilf 问题，未对外联系、上传或派生任务。

启动已读取 STATE、HANDOFF、queue、R018、R020。根 .venv 的 checkpoint --check 返回 queue_valid=true；--verify-latest 返回 archive_valid=true，列出的主线程/其他任务工作区改动不代表归档损坏。没有改动状态、源码、日志或冻结稿件；检查点与 claims 由主线程集成。

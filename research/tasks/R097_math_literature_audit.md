# R097 数学界与相近极值文献对照

日期：2026-10-03。状态：完成，交根智能体验收；支持 R091，完成本报告后停。执行者 math_literature_audit；仅修改本文件，不派生、不改数学源码、不运行新实验、不外联。

## 合同与两轮计划

本次固定比较对象为任意域 K 上 A=K[x,y,z] 的真实有限余长 lex 理想 I，x 为标准单项式，w≥4，所有 d 满足累计 Hilbert–Samuel 预算 HS(A/I,d)≤1+dw；ell 是真实 xy 截面商维数。候选为全宽度第一 Betti 严格界 b1<binom(w+1,2)、谐和界 ell≤3w+(2w−1)H_(2w−1)、真实 lex 预算类最大 ell 的 Theta(w log w)。半群 O(w log w) 仅按已接受传统归约的推论评价，不当成本轮新 Lean。

第一轮读 CMS 2307.05770v2 Problem 4.1/式(7)/Theorem 5.1/Remark 5.2 及 O(w^(3/2)) 的推导；White 2011.03401 的 Hilbert 约束 Betti 算法；Caviglia–Sammartano 1903.08770v3 固定余长与 expansive 极值结论。逐项记录对象、假设、量词、参数及真正读过的范围。

第二轮定向处理旧算法/极值定理加简单推论是否覆盖本项目严格界与相同累计预算的 Theta(w log w)，仅必要追相关引用/近期后续；不能因固定余长排除 White，因为添加自由变量可把累计 HS 变成通常 Hilbert 函数。两轮结束保留未排除项，不把无命中当原创。

启动已读 AGENTS、STATE、HANDOFF、queue、R091、R023、R087 与发表准备计划 R091 合同。checkpoint --check 通过；--verify-latest 确认 20261001T124405422977Z-fe5e4f9a 的 archive_valid=true，STATE/HANDOFF/queue 与新 R091 文档是正常工作区修改，不是归档损坏。状态/claims/检查点由根智能体集成。

## 1 结论与候选贡献定位

**未在本次实读原始定理中定位到同时覆盖本项目全宽度严格第一界、明确谐和界及同累计预算类匹配下界的结果。它们仍是候选数学增量，新颖性未定。** 这比“查无论文”更具体：CMS 的参数范围和估计量级已核清；固定余长极值定理不能直接保持预算；White 算法却确实能联系到本题，甚至结合已知截断观察可覆盖每个固定 w 的有限优化。因此“首次能计算该极值”或“现有算法完全不适用”都不是可支持的贡献措辞。

| 本项目候选 | 最近已读来源的覆盖 | 本轮允许的定位 | 未排除项 |
|---|---|---|---|
| 所有 w≥4 的 b1<binom(w+1,2) | CMS Theorem 5.1 给 w≥40 的非严格界；Remark 5.2 保留小宽度 | 对 CMS 三变量预算情形的全范围、严格强化候选 | White 算法加有限检查可能给另一证明；本轮未执行，不能声称不可能已有 |
| ell≤3w+(2w−1)H_(2w−1) | CMS §5 已有 O(w^(3/2))；式(7)已把截面与 Betti 联系 | 具体预算分析与统一 O(w log w) 强化候选 | White 目标函数的另一个已有解析估计、未读博士论文相关章节、未索引后续 |
| 同一真实 lex 预算类最大截面 Theta(w log w) | 已知极值/算法提供每个固定参数的最大值；经典除数和解释增长计数 | 全部预算成立的真实理想族及匹配阶是需要对照的核心 | 同构/改名构造或算法极值的既有渐近未完全排除；不能把除数计数本身列新贡献 |
| 半群前三 Betti 的 O(w log w) | CMS 归约与已知 lex Betti 公式，加本地谐和界 | 既有本地结果的传统数学推论 | 原半群整链尚非端到端 Lean；lex 下界不能反推半群下界 |

## 2 第一轮已核实事实

- CMS [2307.05770v2](https://arxiv.org/html/2307.05770v2)（2024-07-20）Problem 4.1 与本项目预算精确对接；式(7)是理想 Betti 数，换到商需平移一阶。Theorem 5.1 明列 w≥40、L⊆m² 和非严格界；Remark 5.2 留下 4≤w≤39，并已提出用所有中间次数预算。式(16)、(18)、(19)明确给出 O(w^(3/2)) 比较基线，不宜仅拿二项式阶数比较。
- White [2011.03401v1](https://arxiv.org/html/2011.03401v1)（2020-11-06，arXiv 历史仅 v1）Definition 1.3 固定尾部 G=F（d≥D），允许同时约束 h 与 Δh。Lemma 2.1/2.3 将问题化为 lex Hilbert 函数的加权优化；带真正上界 F 的相关算法是 Algorithm 3.2 / Complete，不应拿无上界的简化 Algorithm 3.1 代替。算法可对固定最终长度切片适用，未发现其中已经写出 w 统一的谐和渐近或匹配下界族。
- Caviglia–Sammartano [1903.08770v3](https://arxiv.org/html/1903.08770v3)（2023-01-06，作者标 Final version）标题为 *Syzygies in Hilbert schemes of complete intersections*。Theorem 3.7 是固定 d、固定 Clements–Lindström ring 的 Hilb^d 上极值；该最终版本全文检索“expans”无命中，使用 C(d) 记号。不能沿用早期 expansive 版本的一般多项式陈述/定理编号而标成 v3；第二轮核版本差异和它是否仍能通过预算参数化覆盖本题。两版本题名相同。

第一轮四次 web 调用；实际读 CMS §§2/4 相关定义、Lemma 4.2 的证明和 §5 主证明/Remark 5.2；White 引言、Definition 1.3、§2 目标函数与 §3 两算法（未运行软件）；CS v3 引言、§1 定义、§2 分解部分、Corollary 3.4、Lemma 3.5/3.6、Theorem 3.7 及其证明开头。未把未读的全文或代码当作已审计。

### 2.1 CMS：对象与下标

CMS 的 K 为任意域，HS 是通常 Hilbert 函数的累计和；Problem 4.1 对一般 n、余长有限但未指定的齐次理想提出所有 d 的同一预算。lex 归约是已有工具，本项目只覆盖其中三变量、无一次项的一类；按 x>y>z 的通常 lex 顺序，x 标准即排除了所有一次项。

式(7)针对理想：b_i(L)=b_i(Ĺ)+ell·binom(n−1,i)。在 n=3、α 为最小纯 x 幂指数时，§5 的 xy 理想有 α+1 个最小生成元、α 个一阶关系，换成商得到 (b1,b2,b3)=(α+1+ell,α+2ell,ell)。这是文献公式的专门化，不是本项目新公式。Theorem 5.1 的显示陈述列 L⊆m²、lex、预算和 w≥40；其显示句没有再列有限余长，本项目有限余长对象在适用范围内。式(13)、(16)、(18)、(19)使用 α=O(sqrt(w))、β=O(w)，已产生 O(w^(3/2))；因此谐和改进须与该量级比较。[准确原文位置：§4–5](https://arxiv.org/html/2307.05770v2)

本轮没有重审半群传统归约全部证明；只用原文 §2 的底环定义与 Theorem 3.3/Problem 4.1 区分原半群宽度和预算参数。

### 2.2 White：不是可以用“固定余长”排除的来源

固定环变量数后，Definition 1.3 的输入是 G,F,g,f 和最终相等的尾部 G(d)=F(d)（d≥D）；目标是饱和理想的各个总 Betti 上界。Lemma 2.1/2.3 将其变为 lex Hilbert 函数、Macaulay 条件及 V_q 的优化。§3.2/Algorithm 3.2 保留真正的 Hilbert 上界；§3.1/Algorithm 3.1 丢弃该上界而作特殊简化，不能直接代替。本次读到的陈述没有特征零限制。Remark 1.4 说明一般可能只有多个不可比的极大 Betti 向量，不能把逐坐标最大值当作同一理想同时达到。[White v1](https://arxiv.org/html/2011.03401v1)，[版本历史](https://arxiv.org/abs/2011.03401)

**以下是适用性比较推论，不是 White 原文声称的宽度定理。** 令 B=A[t]、J=IB，则 J 饱和，HF(B/J,d)=HS(A/I,d)，ΔHF=HF(A/I)，且添自由变量保持 Betti 数。固定总长度 m 后，其最终 Hilbert 多项式为常数 m；可把线性预算放入 F，并通过 Δh(0)=1、Δh(1)=3 等数据保持本项目无一次项条件。故算法能处理这类切片。它的 q=0 理想 Betti 对应本项目 b1，而 q=2 对应 b3=ell。论文提供的是参数化有限优化方法；没有在实读部分给出关于预算参数 w 的谐和闭式、全宽度严格二项式结论或同预算双曲下界族。

### 2.3 Caviglia–Sammartano：最终版本与早稿必须分开

最终 [1903.08770v3](https://arxiv.org/html/1903.08770v3)（2023-01-06，[历史标 Final version](https://arxiv.org/abs/1903.08770)）Theorem 3.7 固定点数 d 及 Clements–Lindström 环 R=S/(x1^e1,…,xn^en)，2≤e1≤…≤en≤∞；对 Hilb^d(Proj R) 的饱和理想，C(d) 同时最大化所有 β_i^S(R/I)。基础域任意；Definition 3.1 的 C(d) 是集中于相邻次数的 almost lex 理想。c=0 恢复固定长度的 Valla 情形。Corollary 3.4 也有截面极值，但仍固定 d、环与强稳定条件。

第二轮核到 [v1](https://arxiv.org/html/1903.08770v1)（2019-03-20）题名相同，其 Theorem 4.3 则表述一般 Hilbert 多项式 p 的 Exp(p) 极值。v3 已没有 expansive 术语；v3 的 Theorem 4.3 是另一个涉及二次 Clements–Lindström 环、特征零和无限分解的结果。不能混用版本/编号，也不能据版本收窄猜测作者修改原因。本次只读 v1 摘要、引言及 Theorem 4.3/Remark 4.4 定位，不对早稿证明作完整认证。

## 3 第二轮：哪些简单组合仍有覆盖可能

### 3.1 原余长无界不阻止固定宽度的算法优化

原对象的总长度确实不受 w 单独控制。例如 I_N=(x²,xy,xz,y²,yz,z^N)，N≥2，是无一次项 artinian lex，标准单项式为 1,x,y,z,…,z^(N−1)，累计函数在 1≤d<N 为 d+3、以后为 N+2；它满足任意 w≥3 的预算而长度 N+2 无界。这仅是本轮检查适用条件的初等例子，没有登记新科学结论。

但不能因此断言必须在 White 外处理无限长度。CMS 已得最小 y 纯幂 β≤2w+1。取 D=2w+1，并把 L 换成 L'=L+m_A^D：它仍是 artinian lex，累计 HS 只会降低；xy 截面在 D 以后本已为零，故 Ĺ'=Ĺ；由 CMS 式(7)所有总 Betti 不变。L' 的总长度至多 1+w(D−1)=1+2w²。因此原则上可以对有限个 m 和固定有限尾部数据使用 White Algorithm 3.2，求每个固定 w 的确切坐标极值。

这说明“每个固定 w 的可计算性”由既有方法加一个短截断观察即有合理路线；本项目不应把它当独占新贡献。**尚未由此得到的是无限 w 的解析不等式、同预算下显式极端族，或算法输出的渐近分析。** 本轮没有执行该算法，没有据有限计算认证全宽度严格界。对小宽度用算法补检查、再接 CMS 大宽度估计，可能提供另一条证明，但仍需要真实执行与严谨严格性核验，不能把潜在路径写成已发表结果。

目标函数也须分清：Algorithm 3.2 固定 q，最大化对应的一个总（跨内次数求和）Betti 数；不是自动把各同调次数相加。§3 的变体还可以比较 Betti 向量并返回所有 Pareto 极大候选。对本项目截面目标，选择三变量 R 上理想的 q=2；CMS 式(7)给 b2^R(L)=ell（xy 理想射影维数1），所以该坐标才对应 M_K(w)。若要最大化第一商 Betti 则选择 q=0。共同极大向量、坐标最大值和所有 Betti 的和不可混为一谈。

本轮只完成这个数学目标对应及有限截断的比较；**尚未把每个切片的 G,F,g,f、截止 D 与 Macaulay2 接口逐项编码并验收**，也没有处理返回的 V_q 与参考函数常数的实际软件转换、运行结果或复杂度。理论编码需明确 Δh(0)=1、Δh(1)=3、非负性及尾部 Δh=0，并核所有合法函数与所需 artinian lex 切片的双向对应，再跨有限 m 取最大值。不能把本段写成“本轮已运行旧算法直接算出 M_K(w)”或一份现成的数值证书。

### 3.2 固定长度的极值通常不保留全部预算

CS/Valla 的操作放宽了本项目的每次数约束。一个具体适用性检验：w=4 时上述 I_18 长度为20、满足预算；同长度 very compressed 理想为 m_A^4，其 d=2 累计值为10，超过1+2w=9。因而“把 L 换成固定余长最大 Betti 理想，再宣称该极大理想仍满足预算”是错误步骤。

保留 pure-power 次数选择 Clements–Lindström 环可能给更精细上界；但要同时保留每次累计预算并从参数中导出谐和阶，仍需额外优化论证。已读 Theorem 3.7/Corollary 3.4 本身没有该论证。它也不提供本预算类的可达下界，因为在更大集合取得最大值不意味着该点在较小预算集合内。

### 3.3 追到的近邻原始来源

| 来源与版本 | 实读范围 | 判断及限制 |
|---|---|---|
| [Caviglia–Murai，ANT 7 (2013), 1019–1064](https://msp.org/ant/2013/7-5/ant-v7-n5-p01-p.pdf)，DOI 10.2140/ant.2013.7.1019 | 引言 Theorems 1.1/1.2（印刷页1020）、§3 Theorem 1.2 证明（1026）及相关定位 | 固定 Hilbert 多项式的饱和极值；作者明确提供构造而不列一般闭式。添自由变量把 HS 多项式转为 Hilbert 多项式的桥亦已写在此处，不能列作新方法。仍非变最终长度的全部预算极值定理；未审全文组合证明。 |
| [White，2021博士论文](https://uknowledge.uky.edu/math_etds/81/)，*Maximums of Total Betti Numbers in Hilbert Families*，2021-05-06，DOI 10.13023/etd.2021.187 | 原始大学库元数据与摘要；[Dordt作者机构记录](https://digitalcollections.dordt.edu/faculty_work/1439/)交叉定位；全文下载返回403 | 摘要说有比固定函数/多项式更一般的框架、算法以及保证共同最大值存在的情形。**高度相关全文未排除**；不能假定它就是2020短文的重复，也不能以摘要未提log判定不覆盖。 |
| [Moscariello–Sammartano，2406.00790v3](https://arxiv.org/html/2406.00790v3)，2026-09-28 | 当前版本题头、§3 Width，尤其 Theorem 9 与附近讨论 | 最近作者综述仍列 edim=4、w≥40 的 CMS 结果；未在该节给出本项目全宽度严格界或谐和结论。这是可观察的文献状态，不是后续不存在的证明。 |

本轮最实质的新未排除线索是 White 博士论文；未因遇到它启动第三研究轮、联系作者或实施新的数学实验。

## 4 两轮搜索记录与停止边界

共10次 web 调用。初拟约6–8次，第二轮新发现高度相关博士论文后追加有限定位/下载尝试；仍只围绕两轮目标，没有开启第三轮泛搜。

第一轮（调用1–4）：直接打开 CMS v2、White v1、CS v3；核版本历史；定位 CMS Problem 4.1、Lemma4.2/式(7)、§5、White Definition1.3/§2/Algorithms3.1–3.2、CS Definitions1.3/3.1、Corollary3.4、Theorem3.7。实际没有阅读全文证明、运行软件或重做 Lean。

第二轮（调用5–10）：核 CS v1/v3 差异、White 的上界算法与引用；追 Caviglia–Murai 原始期刊 PDF、White 2021 博士论文；定向刷新最新作者综述的 Width 一节。查询原文如下：

- `"Upper bounds for Betti numbers from constraints on the Hilbert function" "White"`
- `"expansive ideals" "Hilbert" Caviglia Sammartano`
- `"Bounds for syzygies of monomial curves" "log"`
- `"Hilbert-Samuel" "Betti" "harmonic"`
- `site.msp.org "White" "Hilbert function"`
- `site.macaulay2.com "MaxBettiNumbers"`
- `"Sharp upper bounds for the Betti numbers of a given Hilbert polynomial" Caviglia Murai`
- `"2011.03401" Betti harmonic`
- `"Maximums of Total Betti Numbers in Hilbert Families" White`
- `"MaxBettiNumbers" "Hilbert" "bounds"`

噪声搜索命中未用作数学证据；第三方聚合页、机器综述、ResearchGate 零引用等没有用于“排除覆盖”。White 大学库 Download 链接 `https://uknowledge.uky.edu/cgi/viewcontent.cgi?article=1083&context=math_etds` 返回403，本报告没有取得其全文；没有绕过限制。未覆盖 MathSciNet/zbMATH 的完整引文网络、其他术语/语言、未索引稿件、私人结果，也没有审计 MaxBettiNumbers 源码。

## 5 对根的集成建议与验收范围

推荐贡献定位为“CMS 三变量累计预算问题的解析强化候选：全宽度严格第一界、明确谐和截面界和同预算真实 lex 类匹配增长阶；已知 lex/退化/极值工具和经典计数不作新贡献”。半群 O(w log w) 保留传统推论标签，实际 lex 标准 Tor 机器覆盖由 R098 另核。

本项的成功标准是来源、对象、推论与不确定性清楚，不是原创认证。本报告只添加文献比较与适用性推理；没有改源码、重新构建、扩大数学范围或改冻结件。根可将本报告用于 R091 贡献表，但不应据此宣布完整领域查新完成、原半群全形式化或论文可发表。完成本项即停；R092 以后仍需用户另行授权。

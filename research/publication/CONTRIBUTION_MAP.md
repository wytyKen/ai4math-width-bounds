# 贡献与文献对照

核查日期：2026-10-03。状态：两轮有限核查完成，以下是贡献与文献对照，不是原创性认证。本文件只界定贡献和文献覆盖，不新增数学、改写冻结稿件或认证原创性。

## 快速结论

**结论：当前最有根据的定位是“CMS三变量累计预算问题的解析强化候选，附真实lex标准Tor的形式化实现”。本次没有认证原创性，也没有发现足以否定全部候选增量的已读定理。** 推荐保留数学主稿候选，同时把已知公式、标准库工具和直接推论从首创主张中剥离。

| 候选 | 本地已验收内容 | 最接近基线与本次判断 |
|---|---|---|
| M1 全宽度严格界 | w≥4的lex三界及标准Tor，原半群应用为传统层 | CMS已覆盖w≥40非严格界；全范围解析严格强化仍为候选，不等于确认首创 |
| M2 谐和上界 | ell的明确谐和界，接三公式得到三个O(w log w)上界 | 正确比较基线包含CMS的O(w^(3/2))；半群版本是传统推论，不另算独立发现 |
| M3 真实极值增长阶 | 同一lex预算类的最大截面存在、实际下界族与标准Theta | 候选重点是统一解析阶与可行下界；除数计数、自然数有界集取最大值不作新方法 |
| F1 形式化设计 | 具体边界分解、全核/单射、标准Tor和实际K维数闭合 | 公式传统已知，许多接口为mathlib复用；实现整合有价值，但“首次形式化”未认证 |

**必须保留的两个限制：** White 2021博士论文高度相关但全文未取得；White 2020算法结合截断已有固定w优化路径，不能声称“现有算法完全不适用”或“首次可计算极值”。跨证明助手核查也不完整，不能用关键词无命中宣称世界首次。

后续获授权可进入R092的内部证明叙事整理，但应使用“本文证明的界/实现”而非未经排除的“首个/首次/完全解决一般问题”。R093的人类责任记录可按后续授权另做；本轮到R091停止。

## 比较合同

以下K为任意域，A=K[x,y,z]，m=(x,y,z)。共同类C(K,w)由实际有限余长lex单项式理想I构成，x∉I，w≥4，并对每个d∈N满足

\[
\sum_{t=0}^d\dim_K Q_t(I)\le 1+dw.
\]

Q_t是次数t齐次多项式在实际A/I中的像。由于是lex单项式理想，x标准等价于没有一次单项式，故与传统叙述I⊂m²的条件相合；不能把有限余长从预算反推出来。这里的w对抽象类是预算参数，不要求来自半群的最小生成元差。

a=min{r:x^r∈I}≥2，ell=dim_K xySubspace(I)。在传统单项式基识别下，ell也是K[x,y]/(I∩K[x,y])或A/(I+(z))的K维数；Lean端点是实际商中的xySubspace，不声称本轮新增了二维商环同构。记b_i(I)=dim_K Tor_i^A(A/m,A/I)，K作用沿原algebraMap限制；文献若写ideal的beta_j(I)，对应本文件商的b_(j+1)，不得遗漏一位。

半群对象另记R=K[[t^Γ]]、P=K[[X0,X1,X2,X3]]；Γ恰有四个最小生成元g0<g1<g2<g3，宽度w=g3−g0。其beta_i^P(R)通过已审查传统比较不大于某个C(K,w)中理想的b_i。w=3的连续生成元分支单独传统处理。不能把此比较当成当前端到端Lean结论，也不能把lex下界反向转成半群下界。

## 四类候选的精确陈述与本地证据

### M1 全宽度严格二项式界

对所有C(K,w)中I，

\[
b_1(I)<\binom{w+1}{2},\quad
b_2(I)\le2\binom{w+1}{3},\quad
b_3(I)\le3\binom{w+1}{4},
\]

并且i≥4的标准Tor是实际零对象，因此所有i≥1有b_i(I)≤i binom(w+1,i+1)。严格第一式在自然数上是至多binom(w+1,2)−1。当前Lean入口是[HigherTorBounds](../../lean/WidthBounds/HigherTorBounds.lean)中的finiteColength_higherTor_width_bounds与finiteColength_tor_all_positive_bounds；C031已有成功构建与语义验收，本轮没有重建。

对原半群的全部宽度结论是传统转移后的应用，不能把“原半群所有宽度”的叙述反过来放宽抽象lex模型的w≥4条件。此候选需要与CMS的精确范围和严格性逐项对照，而不是只对照题名。

### M2 谐和增长上界及半群推论

既有截面界为ell≤3w+(2w−1)H_(2w−1)，且a≤w−2；标准三公式给出下列逐分量推论：

\[
\begin{aligned}
b_1&\le4w-1+(2w-1)H_{2w-1},\\
b_2&\le7w-2+2(2w-1)H_{2w-1},\\
b_3&\le3w+(2w-1)H_{2w-1}.
\end{aligned}
\]

因此固定三个正次数均为O(w log w)，经传统比较也是四生成元半群beta_i^P(R)的上界。这里的三式是对既有结果的直接推论整理，不冒称全部已在一个独立的新Lean定理中登记；截面谐和界与b1接口已有形式化，实际高阶维数公式亦已形式化。传统半群O(w log w)推论在这些传统公式和谐和界具备时就已可用，不是v0.4首次在数学上成立。

本地入口：[Growth](../../lean/WidthBounds/Growth.lean)、[GeneratorNumberBounds](../../lean/WidthBounds/GeneratorNumberBounds.lean)、[LogGrowth](../../lean/WidthBounds/LogGrowth.lean)、[HigherTorBounds](../../lean/WidthBounds/HigherTorBounds.lean)。它应与已有O(w^(3/2))路线比较；在小w上谐和式不一定数值更紧，M1和M2可同时使用。

### M3 真实lex预算类的极值Theta

令M_K(w)为同一C(K,w)中ell的最大值。已有形式化证明w≥4时类非空、自然数值有界且最大值实际达到；w≥64有

\[
\frac{w\log w}{16}\le M_K(w)\le10w\log w,
\]

并接到标准Asymptotics.IsTheta。达到最大值的存在性不等于给出显式极大理想；下界用显式族，未声称该族对每个w精确极大。

族为I_s=(x^iy^jz^k:(i+1)(i+j+k+1)>s²)，s≥2。真实上集/lex、有限余长、x标准和所有次数预算均已证明；s²≤w可嵌入同一预算类。其ell_s=Σ_(i<s)(floor(s²/(i+1))−i)。s=floor(sqrt(w))连接一般充分大宽度。传统除数计数给ell_s=(D(s²)+s)/2，是已知算术的应用，不把除数和或其经典渐近列为原创。

本地入口：[LowerConstructionBounds](../../lean/WidthBounds/LowerConstructionBounds.lean)、[LogLower](../../lean/WidthBounds/LogLower.lean)、[LexGrowthTheta](../../lean/WidthBounds/LexGrowthTheta.lean)，C022/C023。当前标准IsTheta端点是截面最大值，不是已新建的全部Betti极值函数；也不是半群下界或一般变量数的答案。

### F1 具体分解到标准Tor的形式化闭合

本地构造了实际F1/F2/F3，证明range(d2)=ker(d1)、range(d3)=ker(d2)与d3单射，原商增广为准同构，所有项有限自由且4次起为零。模m全部微分为零；随后利用mathlib标准派生比较、零微分同调和真实张量基坐标，证明标准Tor与K维数公式及高阶IsZero。

精确增量应是这个具体实例及其接口组合的形式化，而不是发明lex Betti公式、投射分解、Tor或标量变换。候选复用价值和传统/库来源将按R098报告逐项列出。本轮不认证“世界首次形式化”或“新的通用同调框架”。

## 直接数学基线

### CMS给了问题与关键已有工具

[CMS v2](https://arxiv.org/html/2307.05770v2)（2024-07-20）Problem 4.1采用同一全部次数预算，但允许一般变量数；本项目是三变量、无一次项的情形。Lemma 4.2证明中的式(7)已给lex理想Betti的截面公式，商环需平移一阶。Theorem 5.1显示w≥40的非严格界，Remark 5.2讨论4≤w≤39；§5式(19)的估计已属O(w^(3/2))路线。因此问题设置、lex比较、三公式和“利用更多次数预算”的方向不能列作本项目原创。

这一对照支持M1/M2与已有文本的实质差别，但不证明其他文献或旧方法的进一步推论不存在。尤其较大宽度的严格性可能从既有估计进一步取得；本项目可比较的重点是统一解析论证与完整范围，而不是宣称每个宽度的每条严格不等式此前都未知。

本轮读原文相关定义、§4公式与§5推导；并核[综述v3](https://arxiv.org/html/2406.00790v3)（2026-09-28）Theorem 9仍陈述edim4且w≥40。综述状态只作对照，不承担“未收录即不存在”的证明。

### 固定余长极值不能直接保持累计预算

[Caviglia–Sammartano v3](https://arxiv.org/html/1903.08770v3)（2023-01-06）Theorem 3.7在固定点数d、固定Clements–Lindström环中给C(d)的Betti极值；[Moscariello–Sammartano v1](https://arxiv.org/html/2405.19810v1)的Theorem 2.2重述固定余长的Valla界，Proposition 2.5比较截面。它们是相关工具，不能因为参数不同就从文献表里删除；但所给最大化对象不自动满足本题每个d的预算。

一个适用性检查说明这个问题：w=4时I_18=(x²,xy,xz,y²,yz,z^18)长度20且满足预算；同长度压缩理想m^4的d=2累计维数为10，超过1+2w=9。因此用固定长度的极大理想替换后再宣称预算仍在，是错误的推理。此为对文献适用条件的初等比较，不是新增Lean或实验。

版本需区分：CS的[v1](https://arxiv.org/html/1903.08770v1)（2019-03-20）Theorem 4.3使用一般Hilbert多项式的Exp(p)，最终v3的相应点数结果是Theorem 3.7/C(d)；题名并未改变。不能把早稿术语与编号贴到最终版本，也不猜测版本改变原因。还追读了[Caviglia–Murai原刊论文](https://msp.org/ant/2013/7-5/ant-v7-n5-p01-p.pdf)的引言定理与相关证明定位，它给固定Hilbert多项式的饱和极值，而非本文参数w的统一谐和结论。

## White算法的重合风险不能简单排除

[White 2020 v1](https://arxiv.org/html/2011.03401v1)的Definition 1.3允许约束Hilbert函数h及其差分Δh，并要求尾部G=F。此题相关的是保留上界的Algorithm 3.2（Complete）；它可固定一个同调次数q，最大化该次数的total Betti。逐坐标最优、所有极大向量、以及最大化Betti数之和不是同一个问题，不能混写；其软件还提供相应变体。本轮没有运行软件或审计实现。

### 适用性比较观察

以下是本轮对已有结果的短比较推理，不是White原文已陈述的宽度定理，也不新增已编译结论。

先添一个自由变量：B=A[t]、J=IB，J饱和且HF(B/J,d)=HS(A/I,d)，添变量保持Betti数。因此固定最终长度的切片可通过h与Δh约束进入该框架；“它研究饱和理想，所以不相关”不成立。

原I的长度确实可在固定w下无界：I_N=(x²,xy,xz,y²,yz,z^N)（N≥2）有长度N+2，并满足w≥3的预算。不过，CMS已有最小纯y禁指数β≤2w+1。取D=2w+1、L'=L+m^D，xy截面在总次数D以后原本已为零，所以L'与L有相同xy截面、a和ell；两者都仍为lex，HS只降低，已知三公式给相同总Betti。L'所有次数≥D都为零，故

\[
\operatorname{length}(A/L')=\operatorname{HS}(A/L',D-1)
\le 1+w(D-1)=1+2w^2.
\]

这给固定w的有限长度/尾部优化路径，纠正了“原长度无界就必然排除旧算法”的推断。White固定q=2的理想Betti目标在本三变量商模型对应b3=ell；q=0对应b1。仍需把G,F,g,f、无一次项条件和尾部数据精确编码，处理合法函数与目标类的对应及参考常数，再实际复现算法。**本轮只确认这条联系，未执行优化、输出任何固定w极值或新有限证书。**

有限参数可计算不等于已有全w解析证明或渐近分析。当前可保留的M2/M3候选是明确谐和估计、满足所有预算的实际下界族及匹配阶；不能把最大值存在性或可计算性本身包装成主要新贡献。需要进一步排除的是旧框架或算法目标函数的既有解析估计，而不是仅检索论文标题有没有“log”。

### 高相关全文尚未取得

White的2021博士论文[大学原始记录](https://uknowledge.uky.edu/math_etds/81/)，DOI 10.13023/etd.2021.187，题为 *Maximums of Total Betti Numbers in Hilbert Families*；摘要称讨论更一般的Hilbert函数族、算法和保证共同最大值的若干情形。[作者任职机构记录](https://digitalcollections.dordt.edu/faculty_work/1439/)最终仍链接同一全文。下载返回403，本轮只读了元数据与摘要。

这是明确的未排除项，不能假定它只是2020短文重印，也不能用摘要没有写log来排除覆盖。R091的有限任务可以完成，但发表级“首次”措辞在取得并比对该来源及其他必要线索之前不成立；本轮没有联系作者或绕过访问限制。

## 近期半群来源的范围

本轮核对[2507.11738v3](https://arxiv.org/html/2507.11738v3)的族定义及Corollary 4.8：对象为特定Sally型S^e(m,n)，结论涉及定义理想的最少生成数/第一Betti宽度界。又核对[2609.26752v1](https://arxiv.org/html/2609.26752v1)（2026-09-22）的摘要、引言、分解构造和第3/6节相应定理/猜想定位，得到两类Sally型族的显式Betti计算及相关问题。它们值得列为近邻工作，但已读陈述不是任意四生成元的全宽度谐和结论；本轮没有逐页排除这两篇的所有潜在推论。

[作者研究目录](https://sites.google.com/site/alessiosammartano/research)只作导航，不能替代完整引文网络。arXiv公开版本信息、论文实际适用范围、搜索未命中是三种不同证据。

## 形式化贡献的实际边界

[CMS式(7)](https://arxiv.org/html/2307.05770v2#S4)与传统stable理想理论已解释四个秩。EK原始论文 *Minimal resolutions of some monomial ideals*（1990，[DOI](https://doi.org/10.1016/0021-8693(90)90237-I)）本轮正文获取失败；R098读到其他一手论文对EK生成元公式的使用，可支持传统已知的定位，但没有逐项核对本地d3与EK矩阵。因此不称新Betti公式，也不称已经完成一般EK定理或二者的链同构。

| 实现部分 | 与既有工具的关系 | 合理的贡献说法 |
|---|---|---|
| 标准Tor及P的派生比较 | 直接复用mathlib `CategoryTheory.Tor`、`P.isoLeftDerivedObj` | 对既有标准对象实例化，非发明Tor理论 |
| 零微分同调与K限制标量 | `HomologyData.ofZeros`、`restrictScalars.mapIso`已有 | 可审查的同构组合与标量相容 |
| 实际残差张量K维数 | 基张量坐标/Finsupp等价已有；项目补实际m商域识别与专门接口 | 真实对象整合；当前仍专门化到K[x,y,z]，不是任意局部环定理 |
| 长度三标准分解打包 | 任意交换环，但输入给定三箭头的正合与顶端单射，目标是实际A/I | 有用有限打包器；本身不证明任意矩阵正合，也非任意长度框架 |
| 具体lex边界第三关系列 | 实际证明低支撑、m系数、核身份与全核/单射 | 本地实质证明组织候选；用已证存在和Classical.choose，不声称规范可执行矩阵算法 |

固定库来源：[Tor定义](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/CategoryTheory/Monoidal/Tor.lean)、[派生比较](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/CategoryTheory/Abelian/LeftDerived.lean)、[张量基坐标](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/LinearAlgebra/TensorProduct/Basis.lean)。精确本地端点、固定库行号及通用性限制见[R098](../tasks/R098_formal_contribution_audit.md)，不是按包装文件数量评估创新。

### 已有相邻形式化不能忽略

[Isabelle AFP Gröbner Bases](https://isa-afp.org/entries/Groebner_Bases.html)的[Syzygy源码](https://isa-afp.org/browser_info/current/AFP/Groebner_Bases/Syzygy.html)已有实际关系模与筛取其Gröbner基的端点，允许迭代关系计算。因此不能称首次形式化syzygy；所读端点没有直接给本项目的lex秩及标准Tor/K维数，亦未审完其所有下游来排除组合覆盖。

AxiomMath的[Fel原始工程](https://github.com/AxiomMath/fel-polynomial)是相关的既有Lean项目。根补读其[problem](https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/problem.lean)和[solution](https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/solution.lean)的定义与最终定理：所读端点是数值半群gap、Hilbert分子和形式幂级数系数恒等式，不能因题名含syzygies就等同于本题实际标准Tor链。problem是问题模板，不能用其中的占位否定solution。没有在本地编译、固定该库commit或审全部配套材料；不同网页的工具链显示有缓存/版本差异，不能据版本号作排除。

另一个作者项目网站自述有基于给定分解/桥接数据的Tor1示例，但本轮未审其源仓库，留作未核实线索，详见R098。有限跨库搜索只允许说“未找到已逐项核实且合同相同的工程”，不允许写“世界首次”或断言其他库没有同类能力。

## 未排除项与后续措辞

| 项目 | 仍缺什么 | 对本轮结论的影响 |
|---|---|---|
| U1 White博士论文 | 全文相关定理及与2020算法/本类的关系 | 数学首创仍未定；不能用访问失败作排除 |
| U2 旧算法与解析优化 | 具体编码、合法对象对应、坐标目标转换、软件核验或已有解析结果 | 不主张首次可计算；没有把潜在算法路线写成已经证明全w界 |
| U3 既有极值/下界构造变体 | 其他术语下的同构构造、相关引文和固定长度工具的更细组合 | 明确谐和/Theta仍为候选，不作全领域查新认证 |
| U4 传统分解方法的同一性 | EK/cellular/Schreyer等与本地三角列的精确比较 | 不称新分解算法或一般EK形式化 |
| U5 跨库形式化 | 未索引工程、AFP下游、所读公共项目的完整源码/版本/编译 | F1不宣称优先权；设计见解仍需额外实例或比较 |

**推荐定位：** 优先把M1–M3组织成一个数学主线候选，说明全宽度解析严格界、明确谐和控制和真实lex预算类的匹配增长阶；半群O(w log w)列为传统应用，F1列为已完成的形式化支撑和独立设计候选。若后续原文核验发现数学已被覆盖，应改定位而非继续添加微小变式。

可用表述是“我们给出上述明确条件下的解析证明，并形式化实际lex商到标准Tor的链条”；现在不宜使用“首次解决一般CMS问题”“首次构造lex分解”“首次计算该极值”或“已认证原创”。最大值存在性、传统计数、标准派生比较与现有库方法各归其出处。

对R092的具体输入是本文件的对象合同、M1–M3精确陈述、已知/推论/候选标签与U1–U5清单。它可以整理自足证明和声明映射，但不能把未排除项静默删除；R093可在后续授权下并行收集真实责任记录。本轮不写上述后续产物，也不进行外部提交。

## 本轮记录

执行范围与两轮查询见[R091搜索记录](R091_SEARCH_LOG.md)，本地科学状态仍C031/C023等既有验收。当前未开始R092证明叙事或R093责任记录，不对外联系/发表。

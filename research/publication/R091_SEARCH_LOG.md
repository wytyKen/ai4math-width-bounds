# R091 两轮定向核查记录

核查日期2026-10-03。当前WIP；一次“轮”指有目标的研究阶段，不等于一次web API调用。第一轮核最接近的原始命题，第二轮只处理第一轮留下的高相关覆盖风险。阴性检索不证明不存在；访问失败与读过原文分开。

分工：R097数学基线/极值来源；R098传统分解/形式化来源；根核当前成果的精确假设、近期动态与未排除项，并整合。详细原文定位见各支持报告，根在完成时汇总已读/仅摘要/未取得全文范围。

## 根第一轮 最接近基线和当前范围

本地逐声明读取HigherTorBounds的原模型维数/三界/全部正次数结论，LexGrowthTheta的Admissible、lengthSet、maxLexLength及标准IsTheta端点，定位GeneratorNumberBounds/LogGrowth/LowerConstructionBounds中的谐和与实际下界接口。没有编译或实验；不能把此次阅读当作重复验收。

网页定位：CMS abs2307.05770目前仍为v2（2024-07-20）；综述abs2406.00790目前为v3（2026-09-28）。打开作者研究目录作为线索，不视为完整文献库。第一组关键词为`"numerical semigroup" "width" "harmonic"`、`"Hilbert-Samuel" "log" "Betti"`、`"Bounds for syzygies of monomial curves" improvement`；结果噪声大，多数涉及其他不变量/几何问题或非一手转载，未据其做排除判断。

直接打开2507.11738v3及2609.26752v1。前者读取摘要、族定义和Corollary4.8，后者读取摘要、引言、Construction3.1、Proposition3.3、Theorem3.7及Conjecture6.1附近；确认它们研究特定Sally型族的关系数/Betti公式，不把这些专门结论写成任意四生成元宽度问题的完整解答。后者引用2025 Apéry specialization论文作为已知分解来源，本轮不转入半群分解新研究。

主要URL：
- https://arxiv.org/abs/2307.05770
- https://arxiv.org/abs/2406.00790
- https://sites.google.com/site/alessiosammartano/research
- https://arxiv.org/html/2507.11738v3
- https://arxiv.org/html/2609.26752v1

## 根第二轮 针对覆盖风险

针对固定余长极值/不同参数风险，打开On minimal presentations of numerical monoids（2405.19810v1），直接核Theorem2.2的固定余长压缩lex界、Proposition2.5的截面比较及上下文；综述v3 Theorem9原文仍为edim4且w≥40。更细的White与Caviglia–Sammartano原始命题由R097专门核对。有限总长度控制不等于当前w预算控制，但必须保留可能经附加推导得到相同界的风险。

第二组字符串查询含`"w log w" "lex" ideal`、`"width" "4-generated" "bound" 2026`（arxiv域）、`"Herzog Stamate" "strict" width bound`。结果主要为无关词义/转载，未产生可用的新覆盖定理；不以此证明不存在，也不继续扩大同义词泛搜。

直接核查URL：
- https://arxiv.org/html/2405.19810v1 （Thm2.2、Prop2.5及固定m语境）
- https://arxiv.org/html/2406.00790v3 （Theorem9与宽度问题语境）

根未读MathSciNet/zbMATH的完整引用网络，也没有完整追踪全部引用CMS的文献。相关来源若只读摘要或定理附近，在最终贡献表中保留该限制。各子项各自两轮的定位、失败访问和未排除项见R097/R098最终报告；不混称所有相关论文已逐页审过。

## 第二轮关键线索的有限补读

R097第二轮新定位White2021博士论文，原库正文下载403。根只追加核作者现任机构Dordt记录，其Link to Full Text仍回到同一UKnowledge页面，没有取得全文；没有将这条线索排除，也未继续寻找非授权来源或联系作者。

R098在最后一轮才定位Fel原始工程正确目录，根为处理明确未读风险，有限补读raw main的FelConjecture/problem.lean与solution.lean：核NumericalSemigroup、gapPolynomial/hilbertSeries/hilbertNumerator、alternatingPowerSum/K_invariant和末尾fels_conjecture；检索solution中的Tor无命中。所读目标是多项式/形式幂级数系数恒等式，不能据题名直接认作本项目的实际标准Tor链。problem是问题模板，里面的占位不能用于否定solution。根未编译、固定该工程commit或检查所有配套材料；网页4.26与4.34元数据显示缓存/版本差异，因此不作版本号优先权判断。

根还直接回读White2020 Definition1.3、§3.2/Algorithm3.2及其前后关于固定q、sum及maximal向量变体的说明，确认坐标total Betti目标与Betti总和不同。此补读没有运行其Macaulay2包，也没有产生固定w枚举结果。

补读URL：
- https://uknowledge.uky.edu/math_etds/81/
- https://digitalcollections.dordt.edu/faculty_work/1439/
- https://github.com/AxiomMath/fel-polynomial
- https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/problem.lean
- https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/solution.lean
- https://arxiv.org/html/2011.03401v1

## 已纠正的判断和结束条件

1. 原长度无界只能阻止直接套一个固定长度的极大值，不能排除预算下的截断代表与算法优化。D=2w+1保留xy截面/总Betti且长度≤1+2w²是本轮适用性比较观察，不是新Lean或White原文的宽度结论。
2. 不能仅以饱和理想对象排除White；添自由变量将累计HS变为Hilbert函数。精确G/F/g/f编码、合法函数对应与实际软件复现尚未完成，留在未排除项中，不展开为新任务。
3. CS v1/v3题名相同，不能把早稿Exp(p)/Theorem4.3与最终C(d)/Theorem3.7混成一条引用。R097已修正早先口头的题名变化说法。
4. 标准Tor、P的派生比较、零微分同调和一般基张量API为既有库能力；本地封装不能按新增文件数称新理论。
5. 数值计数、恒等式、真实syzygy计算与标准Tor对象是不同端点，既不能因标题类似就认同，也不能凭本次没读到就宣称其他工程绝不包含。

两轮已经围绕上述具体风险收束，没有启动第三轮泛搜。未排除项被显式带入CONTRIBUTION_MAP，完成本项不意味着发表级查新完毕。本轮未修改数学源码、重跑Lean、改稿、运行新实验或外联。

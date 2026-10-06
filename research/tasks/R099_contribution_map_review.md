# R099：R091贡献表独立口径复核

日期：2026-10-03。执行者：contribution_map_review；只写本报告，不派生，不运行实验或Lean，不启动后续任务。

**结论：接受当前贡献表作为R091两轮有限核查的交付；未发现阻止本轮完成的实质问题。** 接受的是对象、声明、文献覆盖及未排除项的口径，不是数学原创性、世界首次形式化、可发表性或外部同行认可认证。R092及以后仍需后续授权。

审查版本：`research/publication/CONTRIBUTION_MAP.md`，最终SHA-256 `4b37a1330eed9e4e09ab49f23b9ea0740e24a2d95d5a0f7b8787f4113a23a279`。根在审查期间将首段待复核标签改成“两轮有限核查完成”，未预写独立接受；随后采纳下述R092授权措辞建议。本报告已核对最终文本与哈希，数学内容未改。

## 复核依据和边界

已读AGENTS、STATE/HANDOFF、queue中本轮合同、贡献表全文、R097/R098支持报告和R091搜索记录；R087只定向核既有三条谐和推论及战略结论，没有重审全部旧证明。启动`checkpoint.py --check`为`queue_valid=true`；`--verify-latest`确认`20261003T151025846715Z-da094df3`归档有效、状态WIP，工作区仅搜索记录后续修改，不是归档损坏。状态、claims和最终检查点由根集成。

本次直接定位`HigherTorBounds.lean`的真实对象/维数/三界与全部正次数声明，`LexGrowthTheta.lean`的Admissible、最大值达到与IsTheta，`GeneratorNumberBounds.lean`的a≤w−2及谐和声明，`LowerConstruction.lean`的族定义，以及`MinimalResolutionTor.lean`和`BoundaryThirdDifferential.lean`的复用/选择端点。历史“Lean已编译”沿用原验收，本次源码阅读不构成重建证据。

网络仅沿现有链接回读CMS v2、White v1以及CS v1/v3相关原始段落，没有新增搜索或第三轮查新。Fel端点的原始补读由根完成，R098已明确标作根回报；本报告核其分层记录，不冒称又独立审完该仓库。

## 逐项检查

| 项目 | 复核结果与证据 |
|---|---|
| 共同对象合同 | 任意Field、三变量、真实有限余长、lex、x标准、w≥4和所有次数预算均与`HigherTorBounds.lean:109`及`LexGrowthTheta.lean:24`一致。预算参数与半群实际宽度、理想与商的Betti下标已分开；未从预算推有限余长。 |
| M1 | `HigherTorBounds.lean:137`确为第一严格界、第二/三非严格界和≥4的IsZero；`:170`接全部正次数。传统半群比较没有冒称Lean整链，w=3未纳入抽象合同。 |
| M2 | 由a≤w−2、ell界及已知三公式得到4w−1、7w−2、3w三个常数，算术一致；已注明是既有结果的推论整理，不能冒称新增三个Lean定理。CMS的O(w^(3/2))基线和半群传统推论均保留。 |
| M3 | `LexGrowthTheta.lean:72–108`确为真实类的最大值达到、w≥64两侧常数及标准IsTheta；下界族定义和s²≤w预算嵌入相符。未把下界族说成逐w精确极大，也未把lex下界移给半群。 |
| F1 | `MinimalResolutionTor.lean:24,64,89`直接复用零微分同调、派生比较和实际限制标量；第三关系列`:244`在存在性后使用Classical.choose。主文正确区分传统公式、库包装、具体核像证明与实例整合，未认证新通用理论或首次。 |

## White比较的关键核验

[White v1](https://arxiv.org/html/2011.03401v1)的Definition 1.3、Remark 1.4、Lemma 2.3及Algorithm 3.2支持主文区分：固定q的total Betti跨内部次数求和；逐坐标最优、Betti和最大、Pareto极大向量不是同一目标。保留Hilbert上界时应使用Complete。主文q=2对应三变量商b3=ell、q=0对应b1的平移正确。

截断是本轮适用性比较推理，未冒称White的已发表宽度定理。回读[CMS v2式(7)、(18)](https://arxiv.org/html/2307.05770v2)：式(18)虽位于w≥40定理的证明中，其β估计只用所有次数预算与β≥2，不依赖40。lex使y^β禁用同时保证全部xy次数≥β禁用；D=2w+1于是保留xy截面和a、ell。L+m^D仍lex且预算只降低，式(7)保留各同调次数的总Betti；截止D−1给长度≤1+2w²。这里保留的是总Betti，不是分次Betti表。

主文同时留下G/F/g/f、合法Hilbert函数对应、尾部和参考常数的精确编码及软件复现缺口，所以没有把理论路径写成已执行固定w优化、已有数值证书或全w解析结论。White博士论文的403和只读摘要/元数据已明确保留为未排除项；有限任务完成不等于该覆盖风险消失。

## 版本、相邻形式化与收尾

直接回读确认[CS v1 Theorem 4.3](https://arxiv.org/html/1903.08770v1)是一般Hilbert多项式的Exp(p)，[CS v3 Theorem 3.7](https://arxiv.org/html/1903.08770v3)是固定点数的C(d)；题名相同，主文没有混用版本编号。固定长度20的m^4在d=2超出w=4预算，确能说明替换后预算不自动保持。

F1保留EK原文未取得、AFP已有真实关系模、其他项目未完整核读的边界；Fel问题模板占位未用于否定solution，数值半群系数恒等式与实际标准Tor端点也未混同。原始补读、报告作者亲读及未读范围分层清楚。

唯一非阻断文字建议已由根采纳：快速结论“可以进入R092”改为“后续获授权可进入R092”，以便读者无需读到句尾就明确当前即停。已回读确认；无剩余必须修改项。

本报告到此完成；不新增科学claim，不重跑Lean，不开展算法编码、论文补查、外联或R092。根可完成R091状态集成并建立收尾检查点。

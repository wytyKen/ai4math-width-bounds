# R098 显式分解与形式化设计贡献对照

2026-10-03。支持 R091；执行者 `formal_contribution_audit`。**两轮有限核查完成，待根集成验收；本报告不认证新颖性或首次形式化。** 独占且只修改本文件。不派生、不编译、不改源码/配置/状态/冻结物，不实施后续研究或外联。

结论：精确 Betti 公式与 stable/lex 理想存在有限最小分解属于传统已知数学；标准 Tor 的给定分解计算、零微分同调与有限自由基变换主体已经在 mathlib。当前最有内容的形式化增量候选，是三变量真实 lex 边界的关系生成/三角消元证明及其到标准商对象、真实 K 作用的端到端整合。尚不足据此声称新的数学分解方法、一般 EK 定理的形式化或首次完成这一类形式化。

## 范围与两轮计划

1. 第一轮：读取 R054/R069 的固定库审计、R057/R058 的已验收语义，以及 `MinimalResolutionTor`、`ResidueFreeDimension`、`FiniteThreeResolution`、`BoundaryThirdDifferential` 的关键入口。将传统 lex/stable 单项式理想的显式分解与 Betti 数公式（CMS 式(7)、Eliahou–Kervaire）和本地 Lean 实现逐项分开；沿精确调用追到固定 mathlib API，明确已有包装而非新同调定理。
2. 第二轮：有目标检索 Lean/mathlib、Isabelle AFP 及相关形式化论文原始仓库，寻找与本项目同一实际链条的证据：有限单项式分解、标准 `Tor^A_i(A/m,A/I)`、真实 K 限制标量和 K 维数。最多约 5–7 次 web 调用；记录检索式、原始链接、版本及已读范围。无命中只作有限搜索结果，不能认证首次或原创性。
3. 产物：可复用设计候选、实际通用性限制、传统已知部分、其他已形式化内容、未排除项及可用于贡献表的保守措辞。完成本报告即停，由根统一验收、更新状态并建检查点。

## 恢复与证据约束

已读 AGENTS、STATE/HANDOFF/queue 及 R091；`checkpoint.py --check` 为 `queue_valid=true`。`--verify-latest` 的归档 `20261001T124405422977Z-fe5e4f9a` 有效，工作区只有本轮 R091 并行文档/状态后续修改，不是归档损坏。固定 mathlib 为 v4.22.0 / `79e94a093aff4a60fb1b1f92d9681e407124c2ca`。本报告只审阅已有编译证据，未新增构建或实验；以 R057/R058 及其验证清单证明历史编译状态。

## 第一轮：传统数学与当前源码

CMS v2（2024-07-20）Lemma 4.2 证明中的式(7)为

`b_i^S(L) = b_i^(S-hat)(L-hat) + length(S-hat/L-hat) * choose(n-1,i)`，`i ≥ 0`。

这里计算的是**理想 L**的 Betti 数，不能直接把 `i` 当成本地商环 `A/I` 的同次指标。三变量时二维截面理想的 Betti 数为 `(a+1,a)`，加上长度 `ell` 的 `(1,2,1)` 贡献，再对商环右移一位，才得到 `(1,a+1+ell,a+2ell,ell)`。因此这些精确数值属于已知传统数学；本地贡献候选是针对真实对象完成形式化链，而非发现新 Betti 公式。CMS 自身从 `L/x_n L` 的模分解与 Koszul 残差域分解推出公式，不能将其误称为 CMS 写出了与本地完全同一 `d3` 矩阵。

原始来源：[CMS arXiv:2307.05770v2，§4 Lemma 4.2 及式(7)–(8)](https://arxiv.org/html/2307.05770v2#S4)。本轮浏览已读 §2 的 Betti 指标约定和式(7)附近证明。EK 原文 DOI `10.1016/0021-8693(90)90237-I` 与 ScienceDirect 直接入口两次未取得正文；保留书目线索，不能写成已逐页核读 EK 的微分公式。

源码精确复用链：`MinimalResolutionTor.idealQuotientTorIsoHomology` 直接等于 `P.isoLeftDerivedObj residueTensorFunctor n`；零微分同调同构由 `ShortComplex.HomologyData.ofZeros` 提供；K 线性相容由真实 `restrictScalars (algebraMap K A)` 的 `mapIso` 提供。`ResidueFreeDimension` 组合固定库的基张量坐标 `TensorProduct.equivFinsuppOfBasisRight`、有限 `Finsupp`/函数等价、项目已证 `variableResidueEquiv` 和选定自由基基数。它们是有用接口整合，没有新增通用 Tor 平衡、通用 base-change 或派生函子计算定理。

### EK 对照的证据强度

原始书目为 S. Eliahou–M. Kervaire, *Minimal resolutions of some monomial ideals*, Journal of Algebra 129 (1990), 1–25，[DOI](https://doi.org/10.1016/0021-8693(90)90237-I)。本轮原文访问失败，故**没有核对原文具体 theorem/微分编号或与本地矩阵的逐项相同**。作为已读的一手研究论文补充，[Some properties of Borel ideals, §3 Theorem 3.3](https://doi.org/10.1016/S0022-4049(99)00011-0) 的在线正文明确按 EK 给 stable 理想的生成元 Betti 公式；[VandeBogert 的研究论文导言](https://doi.org/10.1016/j.jalgebra.2021.10.022) 明确说明 stable 理想的 EK 分解是已知显式分解并与迭代映射锥相关。这支持“传统已知”，但不是已核读 EK 原文的替代说法。

在通常变量序下，该生成元公式写作 `β_q(I)=Σ_(u∈G(I)) choose(max(u)-1,q)`。本地边界的最大变量类别数量是 `1,a,ell`，相应贡献为 `(1,0,0)`、`a*(1,1,0)`、`ell*(1,2,1)`，与 CMS 特化相同。这是**本次传统层面的数值对照**，不是新的 Lean 声明，也不证明本地 `d3` 与 EK 的标准微分按指定基相同。本地目前没有一般 stable 谓词→任意变量数 EK 分解的接口；不能称为“EK 定理全形式化”。

### 源码端点与固定库来源

所有本地行号相对 `lean/WidthBounds/`；mathlib 行号对应锁定提交，不使用后来的 `master` 替代历史版本。

| 本地接口及已读位置 | 实际完成/复用 | 贡献口径与限制 |
|---|---|---|
| `MinimalResolutionTor.lean:19` 的 `homologyIsoTermOfZeroDifferentials` | 任意有零态射范畴、任意复形形状，零微分同调到该项；直接用 `ShortComplex.HomologyData.ofZeros` | 小型通用便利包装；并非新的同调定理 |
| 同文件:35–61，`IdealQuotientTor`、`idealQuotientTorIsoHomology` | mathlib 标准 `CategoryTheory.Tor`，第一因子 `A/m`、解析第二因子 `A/I`；直接调用 `isoLeftDerivedObj` | 标准 Tor 已存在；分解依赖性/计算定理不能算本项目发明 |
| 同文件:68–103 | 同构组合、沿实际 `algebraMap K A` 限制标量、零对象运输 | 保留正确对象的接口工程；未证明一般 Tor/Tor' 平衡或交换 |
| `ResidueFreeDimension.lean:25–72` | 实际 `((A/m)⊗_A M)` 的 K 线性坐标、有限性、维数等于 A 自由秩 | 主要复用一般基张量 API；代码仍把 `A` 固定为 `MvPolynomial (Fin 3) K`，不是任意局部环/任意残差域定理 |
| `VariableResidue.lean:21–68` | span 定义的 `m` 等于常数项核，再用商的标准代数同构得到 `A/m ≃ₐ[K] K` | 真实残差对象的识别桥；商第一同构定理已有。本轮读完整文件，非新编译 |
| `FiniteThreeResolution.lean:24–265` | 任意交换环 A，给定三箭头、复合零、正合、顶端 Mono 和实际商增广，形成标准 `ProjectiveResolution(A/I)`，高次填零 | 可复用的长度三打包器；**输入**已有正合，不能独立冒充构造具体分解，也非任意长度/任意目标模的通用有限分解框架 |
| `BoundaryThirdDifferential.lean:32–103` | 高共同次数下规范化，**同时**控制低高度支撑和系数属于 m | 边界特定的证明组织候选；还依赖具体三变量 lex 高度/目标次数不增 |
| 同文件:150–292 | `face = y e_x − x e_y − (c_y−c_x)` 的存在、三角性质、真实核身份，代入 `range_thirdDifferential` 和单射准则 | 实质源码增量；`lexThirdColumn` 在已证存在之后用 `Classical.choose`，并非可执行规范矩阵算法 |
| 同文件:335–378；`TriangularSecondSyzygies.lean:228–350` | 实际全部多项式系数的第二核被第三列生成；非仅同次/单项式测试；d3 单射、残差零、指标数 | 是真实数学对象的证明，不是把预期秩写入定义；理论方法新颖性仍未定 |
| `HigherTorBounds.lean:29–94` | 将已构造 P、真实残差零及有限自由逐项代入通用桥；无预算边界接口给全次数 K 有限、0..3维数与 ≥4 实际零对象 | 最主要整合端点；最终带宽度模型还增加原预算条件，不能反过来称具体分解必须依赖 w |

固定库精确来源可复查：

- [Tor.lean（固定提交），定义第40/46行](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/CategoryTheory/Monoidal/Tor.lean#L40)：本轮读完整定义文件。
- [LeftDerived.lean，第106行](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/CategoryTheory/Abelian/LeftDerived.lean#L106)：本轮读 `Functor.leftDerived`、`ProjectiveResolution.isoLeftDerivedObj` 及紧随的自然性；其余分解比较范围依 R069，而未重做全库搜索。
- [ShortComplex/Homology.lean，第145行](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/Algebra/Homology/ShortComplex/Homology.lean#L145)：`HomologyData.ofZeros` 已有。
- [TensorProduct/Basis.lean，第63/84行](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/LinearAlgebra/TensorProduct/Basis.lean#L63)：已有一般 `Basis.baseChange` 及 `equivFinsuppOfBasisRight`，本轮读其定义和坐标作用，不把专门封装称为新的基变换能力。
- [Dimension/Free.lean，第83行](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/Mathlib/LinearAlgebra/Dimension/Free.lean#L83)：自由秩等于选定有限基指标数已有。

### 标准对象和计数不能混淆

1. `A = K[x,y,z]`，`m` 是实际变量理想；标准对象是 `Tor^A_i(A/m,A/I)`。CMS 通常写 `Tor^A_i(A/I,K)`：传统上有交换性，但本地实现特意解析第二因子 `A/I`，本轮没有补一般平衡同构来把两个代码表达式互换。
2. K 作用来自 `ModuleCat.restrictScalars (algebraMap K A)`；随后使用 `A/m ≃ₐ[K] K` 的已证兼容，而非按数值答案搬运一个人为 K 作用。
3. 有限自由 `F_i` 是 **A 有限**，通常不是 K 有限；K 有限的是 `(A/m)⊗_A F_i` 以及同构的 Tor。`finrank=0` 对无限维对象不能自行证明零性，所以高次保留 `IsZero`。
4. R057/R058 的“最小”准确指模 m 后全部微分为零；并未注册完整 graded shifts、分次 Betti 表、标准 graded 最小性分类或与经典 EK 基的显式链同构。

## 第二轮：有目标的跨库对照

### 已确认的相邻形式化

**mathlib。** 锁定 v4.22.0 的通用 Tor、投射分解计算、同调与张量基变换已确认。另本轮读取 [当前 `master` 的 Tor.lean](https://raw.githubusercontent.com/leanprover-community/mathlib4/master/Mathlib/CategoryTheory/Monoidal/Tor.lean) 全文：仍按第二因子派生，保留关于 Tor/Tor' 比较的 TODO。`master` 是 2026-10-03 访问的可变路径，未钉 commit；这个单文件读数不能用来证明最新整个 mathlib 不含任何 elsewhere 的比较或单项式分解。R054/R069 对固定库全树未定位 EK/lex/linear-quotients/Taylor/Scarf 成品实现的结果仍有效，本轮没有扩大它为不存在定理。

**Isabelle AFP。** [Gröbner Bases Theory](https://isa-afp.org/entries/Groebner_Bases.html) 是 Immler–Maletzky 的公开形式化，条目初始日期 2016-05-02；本轮读当前可变在线版本（条目还列 2019 修订），未取得 commit。[Syzygy 源码](https://isa-afp.org/browser_info/current/AFP/Groebner_Bases/Syzygy.html) 的开头定义真实模关系；已读 `syzygy_module_list`、`syzygy_module_listI'`、`pmdl_filter_syzygy_basis`（在线约1375行）及末尾 Gröbner 基证明片段。其明确端点是在域上、适当项序和 distinct 列表等条件下，从扩充系统的 Gröbner 基筛出真实关系模的生成基；文件导言明确允许迭代求关系的关系。这是实质且更一般的 syzygy 基础，不能说本项目首次形式化关系模。本轮所读端点没有给本项目的三变量 lex 秩、标准派生 Tor 或真实 K 维数；没有审完整个 AFP 及其所有下游，所以不能排除进一步拼接或其他同目标文件。

**Fel 猜想原始工程。** [Axiom 官方介绍](https://axiommath.ai/research/proof-of-concept/) 描述的是输入数值半群、gap、Hilbert 系列分子和多项式不变量的恒等式形式化；[原始仓库](https://github.com/AxiomMath/fel-polynomial) README 指向 `FelConjecture/problem.lean` 与 `FelConjecture/solution.lean`。返回的官方介绍谈 4.26.0，而返回的仓库 README 输出说明为 **Lean 4.34.0-rc2**；存在页面/缓存版本差异，未以它们确定当前 commit 的工具链，更未据版本字串作排除。R098 最后一轮才定位正确子目录，此前误试仓库根 `solution.lean` 返回失败；R098 自身未继续读取。

**根 R091 的定向补读（收到根回报后记录，非 R098 独立源码复核）：** 根读取了 [problem.lean](https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/problem.lean) 和 [solution.lean](https://raw.githubusercontent.com/AxiomMath/fel-polynomial/main/FelConjecture/solution.lean) 的对象定义与末尾端点：`NumericalSemigroup` 是余有限的载体结构；`gaps`、`hilbertSeries`、`numeratorCoeff`、`alternatingPowerSum`、`K_invariant` 以多项式/形式幂级数系数定义；最终 `fels_conjecture` 是这些系数的恒等式，所读 solution 中 `Tor` 检索无命中。据此可说**所读端点与本项目实际标准 Tor/K 维数链不同**。未固定 commit、未运行、未审全部配套材料，不能断言不存在别的同调桥；问题模板中的 `sorry` 不能用来否定 solution 的证明。补读凭据由根 R091 搜索日志统一记录。

**新检索线索，未作验证背书。** [H. Nakahata 的公开项目附录](https://iroha1203.dev/aat/appendix/) 有 principal monomial 示例并声称接到 mathlib `Tor_1` 非零，同时正文边界明确依赖 supplied resolution and bridge data。本轮只读网站相应段落，未审关联仓库、具体假设或编译证据；不能当作已核实等价项目，也不能将其遗漏后宣称不存在单项式标准 Tor 示例。其自述目标与本项目的任意真实三变量 lex 理想整链不同，精确假设强弱尚待源码对照。

### 有限搜索结论与不能排除的内容

两轮内未定位到**已逐项核实且与本地最终合同一致**的公开形式化：从真实三变量有限余长 lex 理想，构造具体长度三标准投射分解及残差零性，接 `Tor^A_i(A/m,A/I)`、真实 K 有限性、四个精确维数和高次零对象。该句只表述本次检索结果，不是“此前无人做过”。

未排除：未索引/新近/不同术语的 Lean、Coq/Rocq、Isabelle、Mizar 工程；AFP 其他模块的组合；Axiom 工程未读的配套桥或分支；新检索网站的源仓库；传统三变量 cellular/Scarf/EK/Schreyer 变体与本地三角消元的精确方法对照。没有从“公开搜索无命中”推导任何首次或新颖性结论，也没有把传统计算代数软件的分解计算自动算作 proof-assistant 证明。

## 可复用设计候选及当前实际限制

| 候选 | 已有材料能支持的说法 | 当前不支持的说法 |
|---|---|---|
| 根据派生方向选取具体分解目标 | 在固定库和此项目中直接解析 A/I，可调用现成 `isoLeftDerivedObj`，避开尚未接好的因子比较 | 新的 Tor 理论；对所有项目都最省的路线；数学上不能先解析残差域 |
| 将支撑下降与 m 系数控制放入同一归纳不变量 | 本地存在性构造一次同时给出 d3 的核身份、三角支撑和残差最小性 | 已提出优于 EK/Schreyer 的新普适算法或规范可执行矩阵 |
| 多项式核/像到标准范畴分解的分层接口 | `range=ker` 和单射先证，再用有限打包器得到实际商的 `ProjectiveResolution` | 条件打包器本身证明任何给定矩阵正合；无限变量/任意长度通用构造 |
| 真实商—张量—限制标量—维数链 | 区分 A 自由秩与 K 维数、先证有限性，并以 IsZero 处理高次尾部，便于审查 | 新的一般残差基变换定理；所有字段已无条件泛化到任意环/代数 |

这些适合作为将来形式化稿的设计问题与可复用接口候选。能否构成论文级新见解，仍需独立例子/抽象复用或更充分的既有实现比较；本任务没有自动开始这些工作。当前最稳妥定位是**已知同调代数结果在具体 lex 边界模型上的形式化实现与整合**，而非把库包装数量作为创新指标。

建议贡献表可直接使用：

> 实现并核验了三变量真实 lex 理想的具体边界关系、长度三分解及残差最小性；复用 mathlib 的投射分解计算派生函子、零微分同调和张量基接口，将该分解连接到标准 Tor 的真实 K 维数与消失。精确 Betti 公式为经典已知结果；一般 EK 分解、完整分次结构和半群到 lex 的全链未形式化。有限跨库核查未认证首次，方法与形式化新颖性仍未定。

## 检索记录、已读范围与停止

总计 **7 次 `web.run` 调用**，只作两轮有目标核查；第3次在传统来源补定位时同时作第二轮导航，之后没有第三轮扩展。

| 调用 | 查询/打开范围 | 结果及边界 |
|---|---|---|
| 1 | `Eliahou Kervaire Minimal resolutions of some monomial ideals 1990 pdf`；`Caviglia Moscariello Sammartano width numerical semigroups Betti numbers equation 7` | 得原始 DOI、作者目录/相关论文线索；聚合站只作导航，未作数学结论依据 |
| 2 | CMS v2、EK DOI、Mermin 作者站 PDF | CMS 可读；后两入口失败。未读成功的 PDF 不记为已读 |
| 3 | CMS §4定位；EK 原题+ScienceDirect；`"Eliahou Kervaire" "formalization"`；`site:isa-afp.org syzygies Groebner free resolutions` | 得 AFP Syzygy 与后续原始研究论文重述 EK；未见直接 EK 形式化命中，不作阴性认证 |
| 4 | CMS式(7)、AFP条目/源码、EK ScienceDirect；`"monomial" "resolution" "Lean" formalization`、`"Tor" "formalization" "resolution" Coq Isabelle`、`"Eliahou" "Kervaire" Lean mathlib Isabelle Coq` | 精确读取CMS公式；EK仍失败；结果多噪声，定位 Fel 原始工程及相邻线索 |
| 5 | AFP 指定源码段、Axiom官网、mathlib master Tor；`"formalization" "syzygies" "free resolutions"`、`"monomial ideals" "formal" "Tor" Lean`、`"Fel" "conjecture" Lean github syzygies` | 定向相关性筛选，定位原始仓库与另一个Tor1网站；不接受第三方语义摘要作为源码证明 |
| 6 | Axiom仓库、Nakahata附录、AFP符号/CMS Lemma4.2定位 | CMS §4到§5开头读到；AFP首个带lemma的精确字符串未匹配，不误写接口不存在 |
| 7 | AFP真实 `syzygy_module_list`/筛选基端点、Axiom README与工具链入口、Tor master全文、Nakahata Mathlib/边界段 | 得上述精确端点与版本差异；误试根solution失败且正确目录最后才显现，列为未读源码限制，停止网络检索 |

本地已读：R054完整路线、R069摘要/接口表与探针范围、R057/R058完整报告；三个包装文件完整源码；BoundaryThirdDifferential 的归纳、列存在、选取、range/ker、单射、最小性和计数；HigherTorBounds 29–94；VariableResidue全文；TriangularSecondSyzygies 的单射与核像主归纳入口；LexQuotientResolution 声明入口。未重新阅读全旧论文、缓存或完整项目源码。

本轮读数 SHA-256（与历史编译证据分开）：

| 文件 | SHA-256 |
|---|---|
| `MinimalResolutionTor.lean` | `5f3f883bcb2a188698aecdaee61164759855c375485e9fc9a82f9cec0b1ce3aa` |
| `ResidueFreeDimension.lean` | `64415e375a16e7253e77a343d96aa0a973ebfd5ca86b494697a4c4f69453d1e9` |
| `FiniteThreeResolution.lean` | `f75552a79464e92a94f06c967813790fc218fa1c20a3f66a0b8289457ba47a30` |
| `BoundaryThirdDifferential.lean` | `c54459d2cc3b0646d5584f90d11061b9f800f11b1f0941b71e08942c0b06d025` |
| `HigherTorBounds.lean` | `81bd72c661a22e187882c2b00c1beedb269a8cb4f6e828419f185da2dd263d42` |

R057/R058 的已编译和审查状态沿用原验证记录；本次仅是源码/文献审阅，未增加任何数学 claim、实验或构建日志。R098到此停止，由根决定 R091 最终措辞与检查点；不自行启动 R092、源码泛化、外部作者联系或发表。

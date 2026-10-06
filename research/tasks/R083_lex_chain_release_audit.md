# R083：v0.4 实际 lex 高阶 Tor 整链独立审查

日期：2026-10-01。执行者：`/root/lex_chain_release_audit`。独占本报告，不派生、不外搜、不修改数学源码或其他交付文件、不重新运行 Lean 构建。

当前结论：**正式接受实际 lex 高阶 Tor 整链及 v0.4 最终新稿的数学陈述。R058 成功证据与当前源码对应，最终稿 Section 6、Section 9 和摘要范围一致，无本审查范围内剩余阻断。** 本结论不替代主智能体对 PDF 布局及整个 v0.4 包的最终验收。

## 恢复与核查方法

先读 AGENTS、STATE、HANDOFF、queue、R059 报告及 NEXT_STAGE_PLAN 的 R059 合同。根 `.venv` 执行 `scripts/checkpoint.py --check` 返回 `queue_valid: true`；`--verify-latest` 确认 `20261001T090243180713Z-07071c19` 归档有效。工作区差异为 R059 的 STATE/HANDOFF/queue 修改及新 R059 报告，是正常发布准备增量，不是归档损坏。

本次不把既有 R070/R073/R076/R082 的接受结论当作源码证据。直接阅读当前实际对象定义、d1/d2/d3 及相关核生成证明、标准分解打包器、残差最小性、标准派生比较、限制标量与有限自由残差坐标、终端全部宽度定理；旧审查只作定位和交叉检查。固定 mathlib 的 `CategoryTheory/Monoidal/Tor.lean` 也已直接读取，确认其 `Tor` 定义派生第二因子。

## 精确接受的对象与假设

任意域 K，A=`MvPolynomial (Fin 3) K`，m=`variableIdeal`。I 是实际 `monomialIdeal S = Ideal.span`，S 是指数上集且固定总次数上按 x>y>z 满足 lex 上闭。原模型入口保留：

- `[Module.Finite K (A ⧸ I)]`，即真实商的 K 有限维性；不是由预算擅自推得；
- `standard I 1 0 0`，即 x 不在 I；
- 自然数 w 且 `4 ≤ w`；
- 对所有自然数 d，实际 `quotientHomogeneous S t` 的累计 K 维数不超过 `1+d*w`。

`quotientHomogeneous` 是标准齐次多项式子模经实际商映射的像（`MonomialBasis.lean:136`），`xySubspace` 是所有 xy 单项式商类的完整 K 张成（`IdealBounds.lean:29`），其定义没有先做截断。a 是第一个纯 x 禁指数，a≥2；ell 是真实 `xySubspace I` 的 K 维数。

在这些假设下，标准 `Tor^A_i(A/m,A/I)` 沿实际 K→A 限制标量后每次 K 有限；0、1、2、3 次的 K 维数为 1、a+1+ell、a+2ell、ell；i≥4 时标准 A 模 Tor 对象满足 `IsZero`。第一界严格小于 `choose(w+1,2)`，第二界不超过 `2*choose(w+1,3)`，第三界不超过 `3*choose(w+1,4)`，并合成每个 i≥1 的 `dim_K Tor_i ≤ i*choose(w+1,i+1)`。

不含宽度预算的 `lexQuotient_tor_dimensions` 另有实际 boundary 版本，但其参数仍明确保留 hZ、hx、IsLex、完整 hn、a 的初始性、实际 hSpan 及 I≤m。删掉预算不等于删掉这些条件，也不允许单位理想。

## 逐边证据地图

下面给当前源码中的主接口和实际被证明的边；所有路径以 `lean/WidthBounds/` 为前缀。

| 边 | 当前源码证据 | 独立核对的内容 |
| --- | --- | --- |
| 指数 S → 实际理想与标准单项式 | `MonomialInterface.lean:79` 的 `monomialIdeal`，`:113` 的 `monomial_mem_monomialIdeal_iff`，`:132` 的 `monomialIdeal_isLex` | I 为真实 Ideal.span；上集通过库的单项式支撑判据给准确成员关系；lex 假设落实为理想单项式的同次数闭包。 |
| 真实有限余长 → 所有 z 阈值可定义 | `FiniteColength.lean:22` 的 `quotient_finite_iff_standard_finite`、`:46` 的 `exists_pure_z_mem_of_finite_quotient` | 实际标准单项式基使商有限等价于标准指数有限；有限集合不可能含全部 z 幂，因此产生 hZ。没有把 Hilbert 预算代替有限余长。 |
| 实际商维数 → 列数据、a、ell | `IdealBounds.lean:81` 的 `hilbertBudget_of_finrankBudget`、`:125` 的 `finrank_xySubspace`、`:137` 的 `monomialIdeal_all_widths_dimension_bounds`；`MonomialFirstSyzygies.lean:272` 的原模型集成 | 预算先按已证齐次商维数=标准单项式数转为计数；完整 xy 张成由已证截止覆盖；Columns 给每个 i,j 的 hn，a 保留所有更小纯 x 幂标准。 |
| 列数据 → 完整实际生成集合 | `BoundaryGenerators.lean:15` 的 `boundaryExponents`、`:103` 的 `card_boundaryExponents`、`:159` 的 `span_boundaryExponents`；`GeneratorMinimality`、`GeneratorExact` 的 `mem_boundaryExponents_iff_isMinimal` 与 `span_boundary_exponentMonomials` | 三类边界为 x^a、x^i y^(n_i)、x^i y^j z^(t_ij)。阈值正性确保互不重叠；它们属于 I，且每个 I 中单项式被某边界整除，故实际张成等于 I。原模型集成同时返回完整最小指数分类。 |
| 边界 → d1 与原商增广 q | `FiniteMonomialPresentation.lean:29` 的 `differential`、`:85` 的 `range_differential_eq_ker_quotient`、`:136` 的 `presentation_exact` | d1 是真实单项式列的 A 线性组合；先证像为 I，再接 `ker I.mkQ=I`。`idealQuotientMap I` 是原商映射且 Epi。`firstSyzygies` 明确定义为 d1 的实际 kernel，并与范畴 kernel 同构，未假设该核自由。 |
| 任意多项式关系 → 全部共倍单项式关系 | `MonomialRelationSpan.lean` 的 `relationLift_column`、`ker_differential_le_of_commonRelation` | 在关系子模的 K 标量限制商中，用真实单项式基构造 K 线性 lift，并证明 lift∘d1=商映射。故任意多项式系数 kernel 向量均在给定关系子模中；不假设 A 线性分裂。 |
| 共倍关系 → 有限相邻关系与 d2 全核 | `BoundarySyzygies.lean:218` 的高度严格下降、`:236` 的 `exists_boundary_step`；`MonomialFirstSyzygies.lean:89` 的 `commonRelation_canonical_mem`、`:133` 的 `boundaryRelationSpan_eq_ker`、`:164` 的 `secondDifferential`、`:186` 的 `range_secondDifferential` | 相邻指标为 `Fin a ⊕ ((Σ i:Fin a,Fin(n i)) × Fin 2)`。对真实自然数高度强归纳，把任意边界规范化到 canonical divisor；两个规范化差给任意共倍关系。d2 定义是这些列的实际线性组合，定义中没有 kernel。所得等式是完整 `range d2=ker d1`，不是只证复合零或只计数。 |
| 具体 lex 几何 → 真实第三列、hk/hf 及系数在 m | `BoundaryResolutionDegree.lean:50` 的 `boundaryRelationTarget_total_le`；`BoundaryThirdDifferential.lean:32` 的 `exists_normalizingCoefficients`、`:150` 的 `exists_lexThirdColumn`、`:246` 的 `lexThirdColumn_spec` | lex 用替换 z 或 y 证明相邻目标总次数不增。受控规范化系数具有低支撑且在 m 中；每个 face 的 `y e_rx − x e_ry − (cy−cx)` 由实际构造给出，直接证明 d2 列=0、顶部为 y/−x/0、其余高处为0和所有系数在 m。`Classical.choose` 只选择已证明存在的列。 |
| 已构造第三列 → d3 全核和单射 | `TriangularSecondSyzygies.lean` 的 `secondDifferential_top_coordinate`、`polynomial_xy_relation` 调用、`range_thirdDifferential`、`thirdDifferential_injective`；`BoundaryThirdDifferential.lean:275`、`:286`、`:335` | 最高行的横向单项是 c*x=0，故 c=0；成对行是 xf+yg=0，由真实多项式除法与整环消去得 f=yh,g=−xh。逐层减 face 消去全部第二关系；有限指标的最大高度给终止。单射也由最高项非零变量消去。具体接口用 `lexThirdColumn_spec` 供应所有 hk/hf，无未知 face、低支撑或 exactness 假设遗留。 |
| d1/d2/d3 的实际正合 → 标准 ProjectiveResolution | `FiniteThreeResolution.lean` 的 `objects/maps`、`complex_exactAt_succ`、`resolution`；`LexQuotientResolution.lean:24` 的 `lexQuotientResolution` | 通用打包器确实有条件，但具体 lex 构造全部供应：d1–q 正合、d2–d1 正合、d3–d2 正合、d3 Mono。0次使用原 q 的 Epi 与正合证明 quasiIso；1/2次正合、3次单射、4次起零项覆盖每个次数。没有把欲证正合性当最终研究假设。 |
| 标准 P → 有限自由各项、四秩、原 q、m 残差微分零 | `LexQuotientResolution.lean:38` 起的各实例及秩、augmentation/zero_tail；`:85` 的 `lexQuotientResolution_residue_d_zero`；`:98` 的 `finiteColength_exists_residue_minimal_resolution` | P的项实际为 A、A^E、A^J、A^faces 和零对象，各项分别有限自由。F1/F2/F3 的 A 秩由真实有限指标基计数。d1由 I≤m，d2由总次数控制，d3由构造列系数给残差零；通用打包器再涵盖所有 i,j 的微分。I≤m 在原模型由 `GeneratorTensorBounds.lean:24` 的 x 标准引理证明。 |
| 标准 P → 同一标准 Tor 的实际张量同调 | `MinimalResolutionTor.lean:35` 的 `IdealQuotientTor`、`:56` 的 `idealQuotientTorIsoHomology`、`:68` 的残差项同构 | 标准 Tor 定义直接使用库 `CategoryTheory.Tor`；固定 A/m 为第一因子，解析第二因子 A/I。`P.isoLeftDerivedObj` 给标准对象到实际张量复形同调的同构，`HomologyData.ofZeros` 再给同调到实际中项的同构。没有改名计数为 Tor，也未使用一般 Tor 换序。 |
| 真实残差张量项 → 真实 K 有限性和维数 | `ResidueFreeDimension.lean:38` 的 `residueTensorFreeCoordinates`、`:51` 的有限性、`:58` 的 finrank；`HigherTorBounds.lean:29`、`:40` | 所有 K 作用均由 `restrictScalars (algebraMap K A)` 得到。真实 A 自由基经 tensor Finsupp 坐标、有限函数等价、实际 `variableResidueEquiv` 给 K 坐标。先有 `Module.Finite.equiv` 的 K 有限性，再有维数=原 A 自由秩；绝未假设自由项本身 K 有限。 |
| 标准 Tor 同构与零尾 → 全次数公式和 IsZero | `HigherTorBounds.lean:74` 的 boundary 公式、`:108` 的原模型公式；`MinimalResolutionTor.lean:94` 的 IsZero 传递 | 0..3次接同一个实际 P 的四秩。4次起先由保零函子和同构证明标准 A 模 Tor 实际 IsZero；数值0再通过限制标量保零及 Subsingleton 得到，不依赖无限维 finrank=0。原模型所有 j 的 K 有限性独立返回。 |
| 同一 a 与全次数公式 → 所有宽度界 | `HigherTorBounds.lean` 的 `initialExponent_unique`、`:137` 的三界、`:170` 的所有正次数界 | 组合端与分解端的 a 都是首个纯 x 禁指数，用两边初始性证明相同后代入。保留第一严格界；最后按 i=1,2,3 或 i≥4 分类，后者由 IsZero，故包含任意大 i，也不遗漏 i>w。 |

### face/exactness 是否闭合

**已闭合。** `TriangularSecondSyzygies` 作为通用条件工具确实接收 hk 和 hf，但具体 `BoundaryThirdDifferential` 先以高度和总次数受控的规范化证明 `exists_lexThirdColumn`，其 choose_spec 同时给核等式、三角顶部／低支撑条件和 m 系数。`range_lexThirdDifferential` 与 `lexThirdDifferential_injective` 分别传入这些已证数据。`LexQuotientResolution` 进一步把完整核等式化成标准 ShortComplex.Exact，并供应打包器需要的 Mono。不能再把旧 R075 的条件合同误列为 v0.4 当前缺口。

### A 秩、K 维数与旧 C021

R055–R057 的 F1/F2/F3 是有限自由 A 模，其 A 秩只是有限基指标数。R058 并没有直接把这些数字重命名成 K 维数：标准派生比较先到真实 `(A/m)⊗_A P_i`，限制标量后的实际有限自由坐标才给 K 有限性及相同维数。该顺序排除了“Module.finrank K 对无限维对象也可能为0”的语义漏洞。

`IdealQuotientTor I 1 = IdealQuotientTorOne I` 与 K 版本的等式均为 rfl；其第一/第二因子、K 标量作用和 C021 定义相同。`higherTor_one_dimension_compatibility` 直接应用旧 `finrank_torOne_eq_tensor I hI`，因此旧标准 Tor1 与实际 `GeneratorTensorFiber I` 的维数比较继续成立。这里证明的是同对象及维数接口相容，没有额外声称两条构造路径的所有选定比较映射定义相等。

## 源码、成功日志和公理证据

根 `.venv` 运行只读 Python，逐条比较 R055–R058 validation 中的 source_and_log。R055–R057 的旧根 import 和 DependencyAudit 被 R058 合法扩展，故它们的历史 hash 仅作历史证据，不要求等于现行聚合入口；其数学源码和旧成功日志均仍匹配原记录。R058 六条记录全部要求匹配当前文件。结果如下：

| 阶段 | 仍匹配的当前源码／日志记录 | 在 R058 实际日志逐项确认的命名公理输出 | 在 R058 实际日志逐项确认的依赖根 |
| --- | ---: | ---: | ---: |
| R055 | 3 | 14 | 9 |
| R056 | 4 | 19 | 14 |
| R057 | 7 | 35 | 22 |
| R058 | 6 | 16 | 17 |

共20个不同源码／日志文件对应正确。另直接验证 claims 中 C021/C027/C028/C029/C031 的51/19/23/26/21条 evidence 记录，总共140条记录（跨 claim 允许重复文件），全部匹配。检查输出 `errors: []`。被检新数学源码的 sorry/admit/自定义 axiom/native_decide 禁项扫描无命中。

对 R058 当前统一日志的核对包含：`Build completed successfully.`、`PROCESS_EXIT_CODE=0`，error/warning 诊断扫描无命中，84个上述命名公理输出逐项均恰为 `propext`、`Classical.choice`、`Quot.sound`；62个上述依赖根逐项有成功输出。依赖审计源码遍历声明实际常量依赖闭包，排除四个旧有限枚举／小宽度证书及 sorryAx，不是仅比较 import 列表。

关键 hash：

| 文件 | SHA-256 |
| --- | --- |
| `results/lean_higher_tor_build.txt` | `29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4` |
| `results/r058_validation.json` | `3417fdc58105394ecd08271467e7580661798d36822bcc0a700190c6c22a2816` |
| `lean/WidthBounds/ResidueFreeDimension.lean` | `64415e375a16e7253e77a343d96aa0a973ebfd5ca86b494697a4c4f69453d1e9` |
| `lean/WidthBounds/MinimalResolutionTor.lean` | `5f3f883bcb2a188698aecdaee61164759855c375485e9fc9a82f9cec0b1ce3aa` |
| `lean/WidthBounds/HigherTorBounds.lean` | `81bd72c661a22e187882c2b00c1beedb269a8cb4f6e828419f185da2dd263d42` |

`lean-toolchain` 为 `leanprover/lean4:v4.22.0`，mathlib 实际 HEAD 为 `79e94a093aff4a60fb1b1f92d9681e407124c2ca`，其 tracked diff 为空。本次没有运行新的 lake build。科学编译证据仍是 R058 的统一增量构建（包含缓存成功依赖回放），不是 clean rebuild；本次 hash 核对证明当前源码／日志对应，不能被写成重新编译或重新证明。

## 新稿首轮语义核对

已读取 `paper/width_bounds_v0_4.tex` 的摘要、Section 5 假设、完整新增 Section 6 及 Section 9 证据／边界声明，并搜索全文旧“高阶未完成”口径。

- Section 6 通过 Theorem `thm:actual` 明确继承任意域、实际有限余长 lex、x 标准、w≥4和完整预算。四项实际分解、原商增广、全部核生成、d3 单射、实际零尾、m 残差微分零、第二因子标准 Tor、真实 K 有限性与公式及全部正次数界均和源码一致。
- 第三列的校正项符号 `−(cy−cx)` 与实际构造相同；两步关系的像差确为 `cy−cx` 的像。正文说明校正项已构造，未把它写成未证参数。最高高度消元的摘要与实际证明对应；横向单行消去在源码也已处理。
- 原模型从 x 标准得到 I≤m，预算外版本明确保留 I≤m及实际 boundary/span 数据。最小性精确标为所有残差微分零；没有声称完整 graded shifts API。
- Section 9 正确区分已经 Lean 编译的 lex 高阶链与传统半群比较，保留参数约化、关联分次／初始理想／一般特征 lex 比较、半群 w=3 和必要 Tor 因子约定等缺口。没有将 lex 高次消失写成原半群模型的形式化消失。
- 证据说明准确写成本次文档／打包修改复核已接受的源码／日志，而非新 Lean build；16个新 R058 公理输出、17个新依赖根、固定版本与摘要 hash 均对应。
- 摘要没有残留“只完成一次 Tor”或“lex 高阶仍未完成”的旧范围。建议首句补明 `x not in I` 或 `under the hypotheses stated below`，以免摘要孤立阅读时像是允许单位理想；正文已有正确假设。这是摘要范围澄清，不是数学源码缺陷。

## 实际剩余缺口和停止边界

本次核查的实际 lex 整链内，未发现未证明的 face、全kernel、单射、增广正合、残差最小性、标准派生对象、K 有限性或维数桥缺口。传统数值半群归约则仍没有端到端 Lean 闭合：真实半群及完备局部表示、Apéry/参数约化与预算、所需基变换、关联分次和 Gröbner 比较、一般特征 lex 比较、w=3分支以及最终目标的 Tor 因子约定仍须将来另立任务。

本结果不供应一般 Tor 因子换序，不供应完整 graded shifts API，不认证新颖性，不是人类同行认可。没有启动 R060、对外联系、上传或发表。v0.3 原件和其历史边界不得被改写成 v0.4 成果；本报告只改独占文件，打包和旧产物字节保存由 R084／主智能体验收。

## 最终稿核对

主智能体确认最终稿后，独立再次读取摘要及 d2 列公式相邻段，并重新计算 TeX 的 SHA-256。摘要现明确写为有限余长 lex 理想 I 且 x不在I；d2 的多变量单项式记号改为 `\mathbf{x}^{\nu}`，并加指数记号说明，与实际 exponent/multivariate monomial 对象一致。两处改动都不改变已审核的数学正文和证明范围。

最终接受的 `paper/width_bounds_v0_4.tex` SHA-256 为：

`26c1ebdcf796969ca3f829b93393d291e04c5c9f23b3bbf652f76641f37a54d5`

**R083 正式接受并在此停止。** 接受范围为：真实理想→具体有限自由分解及全部正合／单射→标准第二因子 Tor→真实 K 有限性、维数与高阶 IsZero→所有正次数宽度界，及新稿对此链和剩余半群缺口的准确陈述。未发现 face/exactness 遗留、裸 A 秩冒充 K 维数、因子顺序偷换或 C021 不相容。

主智能体报告最终本地 LaTeX 构建退出0、PDF为10页；本审查未把该消息当作自行完成 PDF 视觉检查。PDF 布局、包 manifest、ZIP／receipt 完整性由主智能体及 R084 负责；R083 的终验范围是数学陈述、整链语义和对应科学证据。主智能体继续集成本报告、队列、claims 与检查点，不需再开启数学任务。

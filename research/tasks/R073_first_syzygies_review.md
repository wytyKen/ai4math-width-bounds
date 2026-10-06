# R073 独立审查实际第一关系生成与第二微分

日期：2026-09-30。状态：**R056 最终独立审查接受。语义、冻结源码校验值、统一构建、公理输出与实际依赖审计均已核对，未发现阻塞缺陷。** 下文保留中间检查的递进记录；最终验收以末节列出的固定字节为准。

本审查只支持用户授权的 R056，独占本报告，不修改源码、根 import、状态或依赖，不派生子智能体，不推进 d3、完整有限分解或高阶 Tor。恢复时已读 AGENTS、STATE、HANDOFF、queue 及 R055/R056/R071/R072 相关报告。根 `.venv` 执行 `checkpoint.py --check` 通过；`--verify-latest` 返回 `archive_valid=true`，新增三源码/任务报告及 queue 变化是已授权开发，不是归档损坏。

## 已核对的通用核生成准则

`MonomialRelationSpan.lean` 针对真实 `differential E : (E→A)→ₗ[A]A`，其中 `A=K[x,y,z]`、`K : Type*` 为任意域、`E` 为任意有限指数集合。所需假设为 A 子模 `N` 包含**所有同多重次数单项式差**，并未把待证的 `ker(differential E)≤N` 作为假设或定义。

独立重构如下：对每个次数 d 选可除列 u，取 `single u (monomial (d-u) 1)` 在 `F1 / N.restrictScalars K` 中的类；无可除列时取零。共同倍数差的 N 成员性使类与选择无关。使用实际多项式 K 基构造 `relationLift : A→ₗ[K]Q`，先对任意系数单项式证明公式，再经 `MvPolynomial.induction_on'` 推到任意列系数 p，最后经 `Finset.univ_sum_single` 推到任意向量 c：

`relationLift (differential E c) = (N.restrictScalars K).mkQ c`。

因此 `differential E c=0` 强制 c 的商类为零，得到整个实际核包含于 N。源码没有把此提升写成 A 线性，也没有仅处理多重齐次向量。`commonRelation_smul` 中 u,v≤d≤δ 的条件足以取消自然数指数截断减法；LCM 推论的最小共同倍数真实为坐标 `u⊔v`。空 E 的准则同样有效，选择分支及有限和无需非空假设。

结论：通用准则、共同次数缩放及 LCM span 推论的语义成立；未发现假设循环、标量变换错误或量词遗漏。

## 已核对的边界几何

`BoundarySyzygies.lean` 的指标为 `Fin a ⊕ ((Σ i : Fin a, Fin (n i)) × Fin 2)`，实际 Fintype 基数严格等于 `a + 2*∑ i∈range a,n i`。这个基数是关系**索引数**，不自动等于关系核的秩、最少生成数或 Tor2 维数。

规范指数显式按坐标分三支：pure x；xy 列末端；实际 zThreshold。其边界成员性无条件成立；整除给定次数 d 的 z 支明确使用 `monomial d 1∈I` 与 `zThreshold_le`，没有静默引入“规范项可除”的结论假设。

相邻源、公共次数和规范目标全部是真实边界指数。`boundaryRelationDegree_mem` 先用 `hx`、完整 `hn` 与 hZ 得到源单项式实际属于 I，再由理想乘法闭包得到次数单项式属于 I；`boundaryRelationTarget_le_degree` 因而是真正整除。

| 条件 | 实际用途 |
| --- | --- |
| `hZ : ∃ b, z^b∈I` | 定义真实最小 z 阈值并证明该阈值属于 I/整除已知理想单项式 |
| `hx : x^a∈I` | pure x 边界实际属于 I，进而全部源和相邻次数属于 I |
| `hn : ∀ i j, standard I i j 0 ↔ j<n i` | 完整、未截断的真实 xy 列刻画；xy 边界属于 I |
| `hInitial : ∀ d<a, standard I d 0 0` 与 `hLex : IsLex I` | 从真实 lex 列严格递减得到 `n i≤n 0`，控制下降高度所需有限矩形 |

`exists_boundary_step` 对 pure x、xy、z 三类穷尽：pure x 若整除 d 则已经规范；xy 只可能需要 x 步；z 若 x 尚未达到 d 的 x 坐标则走 x，否则需要 y 步，两个坐标均达到则已规范。每个步骤公共次数≤原 d，目标再由实际整除传递得到≤d。

高度 `(a-e₀)*(n 0+1)+(n 0-e₁)` 是自然数。x 步使 x 恰加一，虽然 y 可能回落，但一个 x 权重 `n 0+1` 严格大于允许的全部 y 回落；y 步保持 x 且 y 恰加一。`boundary_coordinates_le` 提供两端 y≤n 0 和 x≤a，截断减法的两个严格下降算术引理因此适用。这个证明未要求未记录的正性或 a≥2。

特别地，a=0 时 `Fin a` 与 sigma 支均为空，边界只有 pure x，任何可除边界都已规范；不存在需证明下降的索引。配合 hx，I 含 1，完整 hn 强制 n 为零。故这个退化分支不会遗漏非零关系，也没有在 generic 层偷偷加 a>0。

结论：已完成的边界接口足以支持根的高度强归纳，无具体数学漏洞或假设缺口。它们本身尚不是全核生成证明；本报告未把根仍在编写的归纳、d2 或 lex 特化缺失记成已完成模块的缺陷。

## 中间证据与当时的待验收项

已只读核对源码 SHA-256，与各执行报告一致：

| 文件 | SHA-256 |
| --- | --- |
| `MonomialRelationSpan.lean` | `2d563dfd4cc444b0edef89578417b9cf0041f34b2c37a10188cb0b9f981c8df3` |
| `BoundarySyzygies.lean` | `1d3b5eeeb57aefcec18c414baf89f81fc856e5e870ebd736f0587299c6b728ce` |

R071 局部成功日志 `tmp/r071_final_build.txt` 已读取，确有目标 build 成功及四个新关键声明仅标准三公理输出。R072 报告记录其局部成功和六个公理输出。依分工不重复全 build；两份局部证据不替代最终 R056 统一构建。

完整验收还需核对根的最终 `MonomialFirstSyzygies.lean`：高度归纳得到所有共同次数差属于有限相邻 span；真实 `range(d2)=ker(d1)`；F2 为有限自由 A 模且 A 秩等于实际索引数；原有限余长 lex/预算类从真实初始次数、真实列和纯 z 幂提取模型并接正合；相同源码字节对应统一成功日志、公理及实际依赖审计。最终不得声明核自由、d2 单射、d2 极小、Tor2 维数、d3 或完整有限分解。

## 集成归纳的中间复核

根追加的 `commonRelation_canonical_mem` 已经只读审查。它固定共同次数 d，对每个自然数高度 m 的**全部**边界 u 量化，不是仅沿一个先行选择的链归纳。非规范分支取得 s 后，由 `target≤degree≤d` 保留后继除子条件，以 `boundaryRelationTarget_height_lt` 取得严格更小高度；将有限关系 s 乘以 `monomial (d-degree) 1` 得到原共同次数的边，再与后继到规范项的关系相加。相消符号和强归纳不变量正确。

`boundaryRelationSpan_eq_ker` 的正包含逐列调用实际核成员性，反包含调用 R071 的任意多项式核准则，将两个可除列到同一规范项的关系相减。此处真正证明 span=ker，而不是以 d1d2=0、预期指标数或“关系核”定义代替反包含。该归纳及核生成部分语义审查通过，最终编译和字节验收仍待统一证据。

随后追加的第二微分部分亦已核对：`secondDifferential` 是 `Fintype.linearCombination` 的实际列组合，定义中不提核；`range_secondDifferential` 先用真实 range=span 再用已经证明的 span=ker；`secondPresentation_exact` 是同一映射的 ModuleCat `ShortComplex.Exact`。`secondToFirstSyzygies` 只是同一 d2 的 codRestrict，其满射从该真实像等式取得；`boundary_firstSyzygies_finite` 仅经有限源满射推出 A-有限性，未声称自由。`boundary_secondFree_finrank` 的底环明确为 A，`boundary_secondFree_projective` 使用实际函数自由模。没有把 A 秩当 K 维数。

`finiteColength_second_presentation_bounds` 的实际模型提取亦已核对：hZ 从原商有限维得到，a 与 hInitial 来自真实非零 lex 理想的初始次数结论；n 定义为既有 columnLength，但 `standard_iff_lt_columnLength` 经原全次数预算证明其刻画**全部**标准 xy 单项式，而不是仅给有限截断。hSum 由真实列和与实际 xy 子空间维数定理连接。hSpan、完整极小指数分类、R055 呈示及 R056 第二呈示始终使用同一个显式 boundary E。

最终源秩等式为 `finrank A F2 = a + 2*finrank K(xySubspace I)`，并得到 `≤2*choose(w+1,3)`。旧组合 hSecond 只在最后一步替换已经证明的实际源秩；它未用于证明 span=ker 或正合。因此本次确实把旧数字表达式接到了已构造 F2，而没有把它直接定义成关系核或 Tor2 维数。该特化没有额外有限特征、泛型坐标或未记录自由性假设。

## 冻结版本的最终验收

2026-09-30 收到根的源码冻结通知后，重新读取最终 `MonomialFirstSyzygies.lean` 全文、根 import、`DependencyAudit.lean` 的根集合与实际遍历代码，以及统一日志中的全部新声明公理/依赖审计记录。最终修改为单向量公式所需的 `DecidableEq J` 参数和存在量词中未使用证明名称 `_hInitial`；后者仍明确保留相同初始次数存在性命题，实际证明继续用 hInitial 进行归纳与极小性证明。不存在数学合同弱化。

逐个重新计算 SHA-256，全部与冻结通知相符：

| 文件 | SHA-256 |
| --- | --- |
| `lean/WidthBounds/MonomialRelationSpan.lean` | `2d563dfd4cc444b0edef89578417b9cf0041f34b2c37a10188cb0b9f981c8df3` |
| `lean/WidthBounds/BoundarySyzygies.lean` | `1d3b5eeeb57aefcec18c414baf89f81fc856e5e870ebd736f0587299c6b728ce` |
| `lean/WidthBounds/MonomialFirstSyzygies.lean` | `758a867f5d1ae1bd0ca829030cf0ad67f932328b0f6b1089f6a9706edb445997` |
| `lean/WidthBounds.lean` | `c89a465ac9b5b79ce1463ce69dc5ee317ca55938532821df982abfacf8ed1b8a` |
| `lean/WidthBounds/DependencyAudit.lean` | `7cf76547257cc3e018459fdcefbebab9ef703475a9150d0ba6dc827e565c135f` |
| `results/lean_first_syzygies_build.txt` | `de1b067c17870bd24995a03540aa30e6640ece7d0b88129cf4038ec399b93eb5` |

实际统一日志 [lean_first_syzygies_build.txt](../../results/lean_first_syzygies_build.txt) 包含三新模块、更新 DependencyAudit 与根 WidthBounds 的构建/重放记录，结尾为 `Build completed successfully.` 及 `PROCESS_EXIT_CODE=0`。独立只读解析确认没有 error/warning；固定工具链文件仍为 `leanprover/lean4:v4.22.0`。依指令没有重复运行已经通过的全构建。

新模块命名声明的 `#print axioms` 输出共 **19 项**（R071 四项、R072 六项、主集成九项），逐条解析均只含 `propext`、`Classical.choice`、`Quot.sound`。三新源码的禁用项扫描为空：无 `sorry`、`admit`、`native_decide` 或自定义 `axiom` 声明。

DependencyAudit 新增 **14 个实际声明根**，覆盖通用核准则/LCM span、指标数、规范整除、存在步骤、严格下降、规范归纳、边界全核生成、d2 像、Exact、到核满射、核 A-有限性、F2 A 秩及最终 lex 特化。逐根在统一日志找到通过记录。审计代码实际递归 `getUsedConstantsAsSet`，排除旧有限包络/小宽度证书四根和 `sorryAx`，不是仅审查 import 名单。

**验收结论：接受 R056。** 已编译结论为实际有限关系列生成完整 `ker(d1)`；实际 d2 的像等于该核，第二呈示在 F1 处正合，到实际核的限制映射满射并给核 A-有限性；真实 F2 是有限指标上的函数自由 A 模（标准坐标基），为投射模，其 A 秩恰为 `a+2ℓ`，在原有限余长 lex/预算类中 `ℓ=finrank K(xySubspace I)` 且秩不超过 `2*choose(w+1,3)`。

接受范围不包括核自由、d2 单射或极小性、d2 的核生成、残差张量 d2 为零、d3、完整有限 ProjectiveResolution、Tor2/Tor3 识别或半群端到端归约。公理审计和独立内部审查也不认证数学新颖性或外部专家认可。仅本报告被本审查者修改，状态/claims/checkpoint 由根按协议集成；完成本审查后停止，不自动启动 R057。

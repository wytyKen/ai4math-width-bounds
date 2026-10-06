# R070：R055 有限自由呈示与真实核入口独立审查

日期：2026-09-30。状态：**接受：R055 精确有限合同已完成，实际源码语义与冻结统一构建证据相符**。独占本报告，不修改 Lean、队列或状态文件，不派生、不外搜。本项服务于用户本轮单项授权 R055；不启动 R056。以下保留必要 WIP 观察的时间顺序，最终判断及哈希见末节。

## 恢复与审查范围

已读根目录 AGENTS.md、research/STATE.md、research/HANDOFF.md、research/queue.json 与 R054 精确合同。STATE/HANDOFF 保留 R054 收尾字样；当前 queue 的 R055/R070 running 及主智能体任务指令共同限定本轮实际范围，不把旧入口当作新任务授权。

根 `.venv` 的 `scripts/checkpoint.py --check` 成功（queue_valid=true）。`--verify-latest` 返回 archive_valid=true、errors=[]，最近快照为 `20260930T041115749295Z-7f00b789`；工作区只有 queue.json 修改。该输出仅核对快照完整性，不是本轮 Lean 编译证据。

已核对必要旧源码：IdealExactSequence.lean、TorOneBridge.lean、GeneratorExact.lean、GeneratorTensorBounds.lean。启动时新增 core `FiniteMonomialPresentation.lean` 与根集成 `FinitePresentationBounds.lean` 尚待完成；之后逐项阅读实际声明，最终以冻结后的实际源码和对应成功日志验收。

## 独立语义验收清单

| 项目 | 必须核对的实际内容 | 当前状态 |
|---|---|---|
| 系数和指标 | 任意域 K，A=MvPolynomial (Fin 3) K，E 是有限指数集；F1 的类型确为 `↥E → A` | 通过；core:19–24 |
| 首微分 | 实际 A 线性组合 `Σ e, c e * monomial e.val 1`；基向量映射到指定单项式，有显式作用公式 | 通过；core:29–48 |
| 真实像 | 输入 `hSpan : Ideal.span (exponentMonomials E)=I`；由真实线性组合像得到 `LinearMap.range d1=I`，不能预设所需正合 | 通过；core:65–83 |
| 商增广 | epsilon 使用 I.mkQ/idealQuotientMap；range(d1)=ker(epsilon)，实际 ShortComplex.Exact 与 epsilon 的 Epi | 通过；core:85–87、127–142 |
| 非短正合 | 不给 F1→A 的 Mono、不称 F1→A→A/I 为 ShortExact；原 I→A→A/I 的 ShortExact 可以复用 | 通过；新文件无此错误声明 |
| 有限自由和投射 | F1 的实际标准基、Module.Free/Module.Finite（系数环 A）、投射实例；A 为自由秩一投射 | 通过；core:42、50–57 |
| 限制映射 | d1ToIdeal 的值确为 d1 且属于 I；满射由 range=I；组合包含后等于 d1 | 通过；core:94–124 |
| 真实 syzygy | FirstSyzygies 定义为 LinearMap.ker d1；和限制映射之核相等；标准 categorical kernel 的同构需证明包含兼容 | 通过；core:146–237 |
| 残差张量 | 使用旧 residueTensorFunctor/实际 A/m 左张量；I≤m 留在假设；给纯张量作用与 d1 分解或标准 map 相容，再推出零 | 通过；bounds:21–74 |
| 指标和 lex 特化 | 完整极小 E 的分类与实际 hSpan 来自既有定理；E.card=a+1+ell；只称 A 秩/基指标数（或确证的残差 K 维数） | 通过；bounds:78–135 |
| 范围停止 | 不构造 d2/d3、不称核自由、不打包完整 ProjectiveResolution、不声称标准 Tor2/3 或 v0.4 已完成 | 通过；源码与本项报告限制一致 |
| 证据 | 固定 Lean/mathlib4.22.0、统一成功构建与源码 hash 相配；禁止 sorry/admit/自定义公理/native_decide；命名结论公理输出只含标准逻辑公理 | 通过；末节给实际证据 |

## 已核对的可复用接口和前提

1. `WidthBounds.idealQuotientMap I` 的 `.hom` 按定义就是 `I.mkQ`；Epi 来自真实商映射满射。`idealQuotientShortComplex_exact` 用 `Submodule.ker_mkQ`，其 ShortExact 之单射项是 I 的包含，不可迁移为 d1 的单射。
2. `idealQuotientKernelIso` 来自标准 kernel universal property；正反两个包含相容定理都已有。新 syzygy 也须保留这种真实包含意义，不能只给无相容性的抽象等维/同构。
3. `exponentMonomials E` 是 E 的系数一单项式 image；域非平凡使此映射单射，故实际多项式基数等于 E.card。`monomialIdeal_exists_exact_minimal_exponents` 同时给完整极小分类、hSpan 和 E.card 公式。
4. 实际有限余长入口 `finiteColength_exists_exact_minimal_generators` 保留 hUp、hLex、Module.Finite K (A/I)、x 标准、w≥4 和全部次数预算；它给出的计数是 `(exponentMonomials E).card`，根特化须通过 `card_exponentMonomials` 转成 E.card。
5. `residueTensorInclusion_eq_zero I hI` 是 I.subtype.lTensor (A/m) 为零，hI 明确为 I≤variableIdeal。`residueTensorFunctor_map_inclusion_eq_zero` 是同一 map 的范畴版本；新 d1 必须先实证为到 I 的限制映射复合包含，或直接证明纯张量被消去。
6. `monomialIdeal_le_variableIdeal_of_x_standard` 只需 hUp 与 x 标准即可供 hI，不需删除 properness，也不需把预算塞进一般呈示层。
7. 旧 `generatorTensorCoordinates`/`generatorTensorBasis` 是实际 `(A/m)⊗_A I` 的 K 线性结果；不能直接把其维数公式套到 F1，除非另有真实张量 F1 的对应。

## 预先标记的风险

- “有限自由呈示”在本项目合同指 F1→A→A/I 的右正合起点；若文件注释写成短正合，容易误称所有关系均为零。真实关系一般存在。
- 一般呈示不需要 E 极小，也不需要 I≤m；前者只在最小生成数/lex 计数特化使用，后者只在残差首微分零使用。应分别保留正确最小假设。
- `Module.finrank A F1` 可以表示有限自由 A 模的秩；A 不是域。不得据此宣称 `Module.Finite K F1` 或 `Module.finrank K F1=E.card`。
- 标准张量左因子必须保持 A/m，底环必须保持 A；K 作用沿现有标量限制取得。普通 tensor 交换不应被用作 Tor 因子交换。
- `.Exact`、Epi 与真实 ker 对象满足 R055 合同，但都不自动提供 ker 的有限显式生成系或自由性，后者属于 R056/后续。

## 后续验收入口

最初计划为：待新增源码出现后逐条核对；收到根统一成功日志、源码冻结 hash 后核对实际声明/公理输出/日志边界，再作接受或具体阻断结论。本审查者未执行重复全 lake build，最终核验根保存的新统一日志，不以旧科学日志验证新文件。

## 第一轮实际源码阅读（实现中，非验收）

13:40 左右出现的 core 草稿已定义真实 `FreeModule K E := E → Ring K`、`Fintype.linearCombination` 首微分、单基向量公式和标准 coordinate basis；range 通过 `Fintype.range_linearCombination` 接实际 hSpan；实际 `codRestrict` 映射、满射、复合包含、ShortComplex.Exact 与末端 Epi 已有声明。当前阅读未发现将目标结论偷换为定义或偷偷假设 d1 单射的语义问题。此时尚未加入 FirstSyzygies/张量集成，不以未完成部分判作最终缺陷。

固定 mathlib 的 `ModuleCat.kernelIsoKer` 连同 `kernelIsoKer_hom_ker_subtype` 和 `kernelIsoKer_inv_kernel_ι` 是可直接复用的标准核同构与两向包含相容 API。`Fintype.range_linearCombination` 的确是有限函数系数源，无需把 F1 换为抽象投射覆盖。

根集成草稿 `generatorFree_finrank` 声明的系数环明确是 `MvPolynomial (Fin 3) K`，不是 K；注释也明确避免 K 有限维误读。此处语义符合合同，编译及最终 lex 特化仍待统一证据。

## 完整源码语义阅读（统一构建前）

核心执行者已通知 core 局部构建成功并暂冻结。本审查独立读取全部 core，并独立算得 SHA-256 `acfc0c6db316e9c8fcbee40e338b431c05106a79c1df269c9b76869f73294be6`，与执行者通知相同。core 当前 `K : Type*`，未限制系数域的特征。

- `firstSyzygies E` 确为 `LinearMap.ker (differential E)`；未使用期望生成数/维数替代该核。`firstSyzygiesKernelIso` 直接使用标准 `ModuleCat.kernelIsoKer`，两个方向均给出包含兼容。
- `ker_differentialIntoIdeal` 由 `LinearMap.ker_codRestrict`；`restrictedKernelEquiv` 由实际子模相等诱导，其 coercion 是原向量。这保证 `mapToIdealKernelIso_hom_inclusion` 所对应的核不是一个无关同构副本。
- `mapToQuotientKernel` 是 `kernel.lift`，且复合标准 `kernel.ι` 恰等于 differentialMap。与既有 `idealQuotientKernelIso` 复合后等于真实 `mapToIdeal`，证明通过实际 ideal inclusion 的 Mono 取消完成，未使用 d1 单射。
- 根集成的 `tensorDifferential` 是 d1 的实际 `lTensor (A/m)`；一般纯张量和基向量公式均直接保留左因子 q 与底环 A。范畴零映射通过已证 `mapToIdeal_comp_inclusion` 及旧理想包含张量零得到，不依赖未给出的平坦性，也不假设 syzygy 包含张量后为零。
- `tensorDifferentialK` 是同一 A 线性映射的 `restrictScalars K`；没有重设 K 作用。hSpan 与 I≤m 在一般零定理中明列。实际 lex 零映射由 hUp 与 x 标准推导 I≤m。
- `finiteColength_presentation_bounds` 同时提供同一个实际 E、实际 hSpan、完整极小指数分类、呈示 Exact、限制满射、A-rank 精确公式与严格组合界、K 线性残差首微分零。末端 Epi 与自由/投射证书可对这个同一 E 使用 core 的通用声明。

在该时点，R054 合同的数学对象与前提均已在实际声明中出现，未发现语义阻断；仍需根统一日志、源码冻结哈希及禁止项检查，未以执行者成功通知替代统一证据。下节记录已完成的终验。

## 冻结证据终验与结论

根已明确确认以下源码及统一日志冻结、无进一步源码修改计划。本审查者独立重算 SHA-256，与根记录逐项一致：

| 冻结证据 | SHA-256 |
|---|---|
| lean/WidthBounds/FiniteMonomialPresentation.lean | `acfc0c6db316e9c8fcbee40e338b431c05106a79c1df269c9b76869f73294be6` |
| lean/WidthBounds/FinitePresentationBounds.lean | `a02675f535e26699b66df5b35aad9e324758d615bca7bde339279c3ef11b131f` |
| lean/WidthBounds/DependencyAudit.lean | `1c9d550920d82d32a3d429f7cb944563379f3064bbbb0d00373aa23d0feeb48b` |
| lean/WidthBounds.lean | `7c2b5bd95261ecb88ca2f1d1f59234d3be91b64c9dc4e26a449457e5ae86ac71` |
| results/lean_finite_presentation_build.txt | `ce1f53c64c45b6b92b3c74602c0ebc113ef7a344b54123a44f335d05bff927ab` |

统一日志明确记载 `COMMAND: lake build`、`CWD: lean/`，以 `Build completed successfully.` 与 `PROCESS_EXIT_CODE=0` 结尾。根入口实际 import 两个新增模块；DependencyAudit 实际 import 根集成并递归读取声明使用的 constants，而非仅看 import 列表。独立脚本读取日志得到：

- 新增 `WidthBounds.MonomialPresentation` 命名声明的公理输出共 **14 项**，公理集合均仅含 `propext`、`Classical.choice`、`Quot.sound`。
- 新增依赖审计根共 **9 项**，覆盖像、正合、两种关系核包含、商核相容、张量零/基向量作用与最终 lex 命题；均未依赖旧有限枚举/小宽度证书，且递归检查未发现 sorryAx。这是这些具体根的依赖结论，不扩大到未检查的未来结果。
- 日志中 **0 error、0 warning、0 sorryAx**；两份新增 Lean 源码的禁止词检查无 sorry/admit/native_decide/自定义 axiom。
- 本地 `lean-toolchain` 为 `leanprover/lean4:v4.22.0`；mathlib HEAD 为 `79e94a093aff4a60fb1b1f92d9681e407124c2ca`，tracked diff 为空。

最终判断：**接受 R055 的实际有限自由呈示、真实关系核入口、首微分残差张量零与实际 lex 自由项秩特化；无须修改证明。** 数学状态为这些具体声明的 Lean 已编译并经本次内部独立语义审查；不认证新颖性或外部同行认可。

准确命名与边界：`firstSyzygies` 指所列理想生成元之间的关系，即 ker(F1→A)。不因该名称就把它认作商 A/I 的某次 Tor。F1→A→A/I 是中间正合且商增广为 Epi 的有限自由呈示；没有声明 d1 单射。没有证明关系核自由、没有给出它的有限显式生成系，没有 d2/d3、完整有限 ProjectiveResolution 或标准 Tor2/3 计算。一般呈示保留实际 hSpan；张量零保留 I≤m；lex 特化保留全部既有输入。旧 v0.3 范围和冻结交付不因此扩张。

R070 仅修改本报告，现停止。主智能体据此集成 claims/STATE/HANDOFF/queue 与新检查点；R056 及其后续继续等待用户授权。

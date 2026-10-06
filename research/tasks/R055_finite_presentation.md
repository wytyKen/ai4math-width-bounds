# R055 实际有限自由呈示：核心执行记录

日期：2026-09-30。状态：核心已 Lean 编译，待根统一构建/独立审查集成；本报告由核心执行者维护，根另负责张量、秩、lex特化与最终集成。

## 输入与边界

任意域 K，A=MvPolynomial (Fin 3) K，有限指数集合 E，真实理想 I 与等式 Ideal.span(exponentMonomials E)=I。仅实现 F1=(E→A)、实际线性组合微分 d1、呈示正合、满射到 I、实际核及标准 categorical kernel 相容。不假定 ker(d1) 自由，不构造后续微分或完整投射分解，不声称高阶 Tor 已完成。

## 计划与稳定接口

独占源码 lean/WidthBounds/FiniteMonomialPresentation.lean；命名空间 WidthBounds.MonomialPresentation。将依次实现 Ring、FreeModule、differential、differentialMap，真实像/核等式和 presentation；然后实现 differentialIntoIdeal、mapToIdeal、firstSyzygies 及核同构与包含交换。

启动已读 AGENTS/STATE/HANDOFF/queue 与 R054 精确合同。checkpoint --check 通过；--verify-latest archive_valid=true，工作区仅 queue 的已授权登记修改，非归档损坏。Lean/mathlib 保持 4.22.0，不外搜，不更新依赖，不运行全根构建；源码局部编译证据后补。

## 中间里程碑

核心前半段（实际 differential、Pi.single/标准基作用、Free/Finite/Projective、range=I=ker(I.mkQ)、restriction 满射、ModuleCat factorization、presentation Exact 和商 Epi）经第二轮局部 `lake env lean WidthBounds/FiniteMonomialPresentation.lean` 退出0。

随后追加真实 firstSyzygies、ModuleCat.kernelIsoKer 的标准核同构与包含交换、限制到 I 的核相等及对应同构，以及 lift 到商映射标准核并经过旧 idealQuotientKernelIso 后等于 mapToIdeal 的交换式。完整文件待下一编译验收；K 已按根集成需求泛化为 Type*。

## 完整核心交付

所有定义位于 `WidthBounds.MonomialPresentation`，K 的宇宙任意（`Type*`），系数只假定 `Field K`。一般呈示不需要 lex、预算、有限余长或 I≤m。

| 接口 | 精确用途 |
| --- | --- |
| `Ring K`, `FreeModule K E` | A=K[x,y,z] 与真实函数模 E→A |
| `differential E`, `differential_apply` | `Fintype.linearCombination A`，逐项和为 Σ c(e)·monomial(e,1) |
| `differential_single`, `freeBasis`, `differential_freeBasis` | Pi.single 与实际标准坐标基作用；不另造抽象投射覆盖 |
| `freeModule_free`, `freeModule_finite`, `freeModule_projective` | 真实首自由项的 A-自由、A-有限及 ModuleCat 投射接口 |
| `ring_free`, `ring_finite`, `ring_projective` | 真实零次项 A 的相同接口 |
| `range_differential`, `range_differential_eq_ideal` | 实际线性映射像等于单项式 span，并在真实 hSpan 下等于 I |
| `range_differential_eq_ker_quotient` | 实际像等于 `ker I.mkQ` |
| `differentialIntoIdeal`, `differentialIntoIdeal_surjective` | 真正 codRestrict 到 I 的实际满射 |
| `subtype_comp_differentialIntoIdeal`, `mapToIdeal_comp_inclusion` | 线性映射与 ModuleCat 两种实际分解相容 |
| `presentation`, `presentation_exact`, `presentation_epi` | `F1→A→A/I` 的 ShortComplex、Exact 及商映射 Epi；没有声明 ShortExact |
| `firstSyzygies`, `firstSyzygiesInclusion` | 实际 `ker(differential E)` 及其子模包含 |
| `firstSyzygiesKernelIso` | 复用 `ModuleCat.kernelIsoKer` 的标准 categorical kernel 同构 |
| `firstSyzygiesKernelIso_hom_inclusion`, `firstSyzygiesKernelIso_inv_kernel_ι` | 同构两向与实际包含交换 |
| `ker_differentialIntoIdeal`, `restrictedKernelEquiv`, `restrictedKernelEquiv_coe` | 限制值域到 I 不改变真实核，等价保持基础向量 |
| `mapToIdealKernelIso`, `mapToIdealKernelIso_hom_inclusion` | mapToIdeal 的标准核亦为该 syzygy，包含交换 |
| `mapToQuotientKernel`, `mapToQuotientKernel_comp_ι` | 真实 d1 lift 到标准商映射核，并保持复合等于原 d1 |
| `mapToQuotientKernel_comp_idealQuotientKernelIso`, `mapToQuotientKernel_eq_mapToIdeal_comp` | 经过旧 Tor 接口的 idealQuotientKernelIso 正好得到真实 mapToIdeal |

其中带理想参数的接口按 `E I hSpan` 调用；`hSpan : Ideal.span (exponentMonomials (R := K) E : Set (Ring K)) = I`。没有把 hSpan 留在证明外或以任意范围的函数替代真实生成映射。

## 编译证据与口径

- 最终核心命令（工作目录 `D:\project\ai4math\lean`）：`lake build WidthBounds.FiniteMonomialPresentation`。
- 实际进程退出码 0，结尾 `Built WidthBounds.FiniteMonomialPresentation` / `Build completed successfully.`；这是指定目标的局部构建，非主根全构建。
- 最终源码 SHA-256：`acfc0c6db316e9c8fcbee40e338b431c05106a79c1df269c9b76869f73294be6`。
- 源码末尾 7 项 `#print axioms`（基向量、像、Exact、实际满射、两种 kernel 包含交换、旧 quotient-kernel 相容）均只输出 `propext`, `Classical.choice`, `Quot.sound`。
- 最終完整构建无 error/warning；源码搜索没有 sorry、admit、native_decide 或自定义 axiom。`#print axioms` 字样本身不是自定义公理。
- 开发时遇到的错误仅为 `Module.Basis` 命名、section binder 显式保留 hSpan、Set.range/image 等同及任意宇宙下显式 K 参数；最终版本全部消除，没有修改固定依赖。

真正最小生成集合及 lex 指标数、首自由项秩、I≤m 下的张量零由根的 `FinitePresentationBounds.lean` 接入。其统一最终日志和 claims 由根另记，当前核心局部构建不替代全 R055 验收。

## 停止范围

核心达到本项有限合同后冻结。没有证明 firstSyzygies 自由、没有构造 d2/d3、没有构造有限 ProjectiveResolution，也没有计算或宣称标准 Tor2/Tor3 公式。这里的自由/有限均为 A 模性质；没有把 A^E 宣称有限维 K 空间。结果属于“Lean 已编译的有限呈示/核接口”，新颖性未作认证。

## 根集成的残差张量与实际自由项秩

新增 [FinitePresentationBounds.lean](../../lean/WidthBounds/FinitePresentationBounds.lean)，没有改写旧Tor1定义或旧数学证明。核心 [FiniteMonomialPresentation.lean](../../lean/WidthBounds/FiniteMonomialPresentation.lean) 保持执行者交付字节。

- `tensorDifferential E` 是真实 `(differential E).lTensor (A/m)`，底环始终A；`tensorDifferential_tmul`和`tensorDifferential_tmul_freeBasis`明确作用于原纯张量和原单项式列。
- `residueTensorFunctor_map_differential_eq_zero`先用实际 `mapToIdeal≫idealInclusion=differentialMap`，再用既有I≤m下包含张量为零的定理。由此得到真实A线性 `tensorDifferential_eq_zero`。
- `tensorDifferentialK`沿已有系数域标量塔restrictScalars K；保留纯张量公式并证明为零，没有从目标人为搬运K作用，也没有交换Tor两因子。
- `generatorFree_finrank`证明 `Module.finrank A (E→A)=E.card`。A不是域，该有限自由A模的秩不代表K维数；未宣称 `Module.Finite K (E→A)`。
- `finiteColength_generatorFree_rank`将旧完整极小生成集合的多项式image.card转换为E.card，接到真实自由项秩。
- `finiteColength_presentation_bounds`在原指数上集/lex、真实A/I有限维、x标准、w≥4与每个次数的实际累计预算下，选择真实初始次数a和完整极小E，同时给hSpan、实际呈示Exact、到I满射、自由项秩=a+1+实际xy维数、严格小于choose(w+1,2)、以及首微分的K线性残差张量为零。

一般呈示层并不要求E极小、lex、预算或I≤m；只有张量零使用I≤m，只有原宽度特化使用完整相应条件。一般冗余E的自由项秩是E.card，不能把严格界套到任意扩大后的生成集合。

`firstSyzygies`在这里按定义是理想生成元的关系核ker(d1)。若按A/I的自由分解数层，它是下一关系层；不能仅凭这个名称认成某个Tor或宣称该核自由。呈示只在A与A/I处右正合，**F1→A不被假定单射**。

## 最终统一构建与审计

根将两新模块加入WidthBounds.lean，并在DependencyAudit增加9个实际声明根：像等式、呈示Exact、两类标准核包含相容、商核lift相容、张量d1零、纯张量基公式、K线性张量零及最终lex呈示/秩界。

最终命令（cwd=lean/）：`lake build`。统一日志 [lean_finite_presentation_build.txt](../../results/lean_finite_presentation_build.txt) 实际退出0，结尾`Build completed successfully.`；无error/warning。两新模块14项命名声明公理输出只含propext、Classical.choice、Quot.sound；9个新增真实依赖根均排除旧有限/小宽度证书和sorryAx。

源码/日志SHA-256：

| 文件 | SHA-256 |
|---|---|
| FiniteMonomialPresentation.lean | acfc0c6db316e9c8fcbee40e338b431c05106a79c1df269c9b76869f73294be6 |
| FinitePresentationBounds.lean | a02675f535e26699b66df5b35aad9e324758d615bca7bde339279c3ef11b131f |
| WidthBounds.lean | 7c2b5bd95261ecb88ca2f1d1f59234d3be91b64c9dc4e26a449457e5ae86ac71 |
| DependencyAudit.lean | 1c9d550920d82d32a3d429f7cb944563379f3064bbbb0d00373aa23d0feeb48b |
| lean_finite_presentation_build.txt | ce1f53c64c45b6b92b3c74602c0ebc113ef7a344b54123a44f335d05bff927ab |

集成阶段先遇到K参数未显式给出导致的类型推断heartbeat超限、Limits命名空间未打开、`lTensor_tmul`显式参数少一个。通过显式K、正确命名空间和完整参数消除；没有提高心跳预算或添加占位。早期失败输出位于tmp/r055，只作为开发记录，不能当最终构建证据。

独立审查见 [R070](R070_finite_presentation_review.md)，最终冻结验证摘要见 [r055_validation.json](../../results/r055_validation.json)。旧科学声明的根import/依赖审计hash在本次实际统一构建通过后才更新；其原成功日志保留，冻结v0.3的PDF/TeX/ZIP和验收记录不变。

本项止于实际有限自由呈示、关系核接口、首微分张量零及选定自由项秩。未构造d2/d3、未证明关系核自由、未构造有限ProjectiveResolution或目标高阶Tor维数。R056等待用户下一条指令，不自动执行。

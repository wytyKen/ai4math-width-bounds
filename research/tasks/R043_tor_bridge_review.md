# R043：标准 Tor₁ 接口的独立审查

日期：2026-09-29（Asia/Shanghai）。状态：最终冻结源码、统一构建日志与语义审查已完成；接受当前标准 Tor₁ 同构及其 K 维数/最少数/两界范围。以下保留早期阶段记录，不将其阶段限制误作最终仍未完成。

独占文件：本报告。未修改证明、根 import、依赖、状态或声明；未外搜、枚举、派生子任务或对外动作。

## 恢复与证据范围

已读 AGENTS、STATE、HANDOFF、queue 和 R040/R041/R042 报告。根 `.venv\\Scripts\\python.exe -B scripts/checkpoint.py --check` 返回 `queue_valid: true`；`--verify-latest` 返回归档完整，工作区正常包含本轮状态修改及 TorOneBridge/R041/R042 新文件。这是字节完整性检查，不是本轮 Lean 验收。

R040 旧计划称 `ProjectiveResolution.of` 可以从给定 epi 开始，和固定 mathlib 4.22.0 的实际签名不符；R041 已在任务报告指出并改用同一 `ChainComplex.mk'` 构造。计划不能作为成果。STATE/HANDOFF 仍夹有此前“本轮不启动”等历史停止语句，应由根在最终状态收束时消歧，不影响本次任务范围。

## 已独立核对的语义

1. `Mathlib/CategoryTheory/Monoidal/Tor.lean` 的标准 `Tor C n` 固定第一因子，然后左派生第二因子。此项目目标对象须保持为
   `((CategoryTheory.Tor (ModuleCat A) 1).obj (ModuleCat.of A (A ⧸ m))).obj (ModuleCat.of A (A ⧸ I))`。
   这是通常记作 `Tor₁ᴬ(A/m,A/I)` 的对象；不依赖未经证明的平衡性或两因子交换。同态和所有张量的底环均为 `A = MvPolynomial (Fin 3) K`，不能换成 `K`。
2. `I → A → A ⧸ I` 应使用真实 `I.subtype` 和 `I.mkQ`。像为 I、商映射核为 I，包含单射、商映射满射，因此真实短正合性在任意交换环已成立；此步骤不需要 `I ≤ m`。`ModuleCat.of A A` 是自由秩一对象，故投射；没有假定 I 投射或自由。
3. 从给定投射 epi `f : P ⟶ X` 构造标准 `ProjectiveResolution X` 时，须证明每项投射、首项 P、零次增广 f、正次数正合及增广 quasi-isomorphism。`exact_d_f f` 给起始两箭头正合，`Epi f` 在零次 quasiIso 中不可遗漏。非零次目标是 single₀ 的零对象，不能只证明链复形成立便称分解。
4. 当前 `residueTensorInclusion` 的签名是真实 `I.subtype.lTensor (A ⧸ m)`，从 `(A/m) ⊗[A] I` 到 `(A/m) ⊗[A] A`。对纯张量 `[r] ⊗ p`，经右单位同构为 `[p*r]`；`p∈I≤m` 与理想乘法闭性给零。此证明数学正确，并保持 A 为底环。由已有 x-standard/上闭集条件推 `I≤m` 的专用包装也保持必要假设。
5. `I≤m` 是 Tor₁ 与整块纤维识别的实质限制：I=A 时生成元纤维与 K 同构，但 A/I=0、标准 Tor₁ 为零。短正合性和一般张量纤维定理的成立不允许删去该限制。
6. `ProjectiveResolution.isoLeftDerivedObj` 把**标准**派生对象接到选定分解张量后的同调。这证明计算对象来源正确，但单有它仍未识别该同调为纤维。原分解的 quasiIso 也不声称张量后增广仍是 quasiIso；后者一般为假。

## 剩余桥梁的具体形式与本地 API

设 q:A→A/I，选定分解低次为 `P₂ --d₂--> P₁ --d₁--> A`。还需取得实际 epi `p:P₁→I`，满足 `d₁=p≫incl`，以及 `P₂→P₁→I` 正合；这才能证明 I 是 d₂ 的余核。

可复用的固定版本路线：

- `Projective.syzygies q = Projective.over (kernel q)`，`Projective.d q = Projective.π (kernel q) ≫ kernel.ι q`。将 `kernel q` 通过真实短正合序列的核泛性质识别为 I，得到 p 及 epi。
- `exact_d_f d₁` 与包含 Mono 可转移成 `P₂→P₁→I` 的正合性；已有 `ShortComplex.exact_iff_of_epi_of_isIso_of_mono` 可比较两短复形。随后 `ShortComplex.Exact.gIsCokernel` 以 p 的 epi 得到真实余核 cofork。
- `Mathlib/Algebra/Category/ModuleCat/Monoidal/Closed.lean` 提供 ModuleCat 的 MonoidalClosed 实例，从左张量的左伴随性取得保余核。`CokernelCofork.mapIsColimit c hc F` 将上述余核张量，给 `(A/m)⊗I` 为 `F.map d₂` 的余核。
- `Mathlib/Algebra/Homology/ShortComplex/Homology.lean` 的 `ShortComplex.HomologyData.ofIsColimitCokernelCofork S hg c hc` 在 S.g=0 时直接用指定余核给同调数据。其 `.left.homologyIso` 接 `isoLeftDerivedObj` 可得到目标同构，无须手算抽象 homology 的实现。
- 若需要具体线性商描述，`ShortComplex.moduleCatHomologyIso` 给 `ker S.g / range S.moduleCatToCycles`；但抽象余核路线更直接保留实际纤维目标。

这些是源码已核对的 API 建议，还没有作为本项目定理编译。特别地，张量后 `d₁=0` 只使 `H₁=coker(F.map d₂)`；缺少余核为张量 I 的证明时不能省略 d₂ 或宣称 `H₁=(A/m)⊗I`。

## 验收口径

本阶段可分别验收真实 ShortExact、给定 epi 的标准分解、标准 Tor 到选定张量复形同调的计算同构及真实张量包含零映射。R040 整体只有在标准 Tor₁ 到实际纤维的同构成立后才可标 done；若继续传递 K 维数，还需明确其 K 标量作用及与已有 `GeneratorTensorFiber` 的一致性。上述一般同调事实属已有标准数学，不提供新颖性认证；完整半群归约与高阶 Betti 仍未在此处理。

最终源码冻结、统一构建日志、公理/传递依赖及 SHA-256 的复核将在下节追加。当前不得引用本报告为完整 Tor₁ 同构或本轮统一编译成功的证据。

## 2026-09-29 续接独立审查（实现冻结前）

已保留上面的纸面/API审查，不重做原计划。再次读取 AGENTS、STATE、HANDOFF、queue、PROTOCOL 与 R040/R041/R042 当前报告。根 `.venv\Scripts\python.exe -B scripts/checkpoint.py --check` 返回 `queue_valid: true`；`--verify-latest` 返回 `archive_valid: true`，源码与状态的新增/修改为已登记 WIP，不能据此声称新代码已构建。

### 已完成的源码语义核对

- `IdealExactSequence.lean` 的当前 SHA-256 是 `bec2f846f71a1962615171d2dfa654ab59ce9446487a10407d6d2294b1a766c2`，与 R042 单模块成功交付版本完全一致。实际包含/商映射、`range_subtype = ker_mkQ`、Mono/Epi、`ShortExact` 和 A 自由秩一投射的命题范围正确。`idealQuotientKernelIso` 由真实短正合的核泛性质构造，正逆包含兼容均来自标准极限同构；不是通过重定义范畴核规避证明。
- `ChosenResolution.lean` 的当前构造使用 `Projective.syzygies` 递推，逐项投射证明仅首项依赖 `[Projective P]`；I 本身没有投射假设。零次 augmentation 的 quasi-isomorphism 显式使用 `[Epi f]` 与 `exact_d_f f`，正次数使用递推正合以及 single-zero 目标的正次数零同调。`isoLeftDerivedObj` 直接调用标准 `ProjectiveResolution.isoLeftDerivedObj`，不是自行改写派生函子定义。
- 当前 `DerivedKernel.lean` 候选中，先由核包含 Mono 得到 `d₂ ≫ π(kernel f)=0`，再以短复形比较把 `exact_d_f (Projective.d f)` 转成对实际 `kernel f` 的呈示正合性。`π(kernel f)` 的 Epi 与正合给真实余核；`PreservesFiniteColimits F` 保留该余核。只有在 `F.map (kernel.ι f)=0` 时才令张量后首微分为零，继而调用 `HomologyData.ofIsColimitCokernelCofork` 识别 H₁。此路线在数学语义上闭合；本节点仍等待执行者最终编译及冻结，不把候选当已验收接口。
- `TorOneBridge.lean` 的标准别名保持 `Tor(ModuleCat A,1)(A/m)(A/I)`，固定 A/m 第一因子并派生第二因子。真实张量包含零、由实际核同构转成标准核包含零的路线保持 I≤m，不借 Tor 平衡性。
- `TorOneBounds.lean` 当前 `IdealQuotientTorOneK` 使用 `ModuleCat.restrictScalars (algebraMap K A)`。`restrictScalarsNaturalEquiv` 的底层是恒等映射，线性性由 `IsScalarTower.algebraMap_smul` 证明，因此与既有 `GeneratorTensorFiber` 的 K 作用兼容，不是从目标向量空间反向搬运一个任意标量作用。

当前未见上述局部构造的数学缺口。剩余验收依然是完整 Tor₁→实际张量纤维的同构、最终 K 线性推论量词、源码冻结哈希及统一成功日志；本节不提前接受 R040 整体。

### 完整连接及 K 层量词审查

随后读取根新增的完整 `idealQuotientTorOneIsoTensor` 与 `TorOneBounds.lean`。源码语义接受，统一构建证据仍待下节冻结：

1. `idealQuotientTorOneIsoTensor I hI` 首先将标准 `IdealQuotientTorOne I` 定义化为实际残差左张量函子的 `(leftDerived 1).obj (A/I)`，调用 `DerivedKernel.isoLeftDerivedOne (idealQuotientMap I)` 到 `F.obj (kernel q)`，最后串接 `F.mapIso (idealQuotientKernelIso I)` 到真实 `ModuleCat.of A ((A/m)⊗[A]I)`。其中 q 是实际商映射，首项 A 投射且 q 为 epi；只对 `I≤m` 使用已证明的映核包含为零。整条链保持 A 模同构，而不是仅证明两个未连接空间维数相同。
2. `IdealQuotientTorOneK I` 通过实际 `algebraMap K A` 对标准 Tor 对象限制标量；`idealQuotientTorOneEquivTensor` 对上一步 A 模同构执行 `restrictScalars.mapIso`，再接前述恒等线性等价。由此 Tor 与旧 `GeneratorTensorFiber` 的 K 作用一致，张量的底环始终是 A。
3. `torOneCoordinates`、`torOneBasis`、`torOne_finite`、`finrank_torOne` 和 `torOne_finrank_isLeast` 对一般完整有限极小单项式生成集合 E 保留 `IsUpperSet S`、E 中每项真正极小、E 的实际多项式 span 等于 I、以及 `I≤m` 四组假设。`torOneBasis_toTensor` 明确给同一个等价下基向量的像为原系数一单项式的 `1⊗g`。`IsLeast` 使用原有的任意有限多项式生成基数集合，不只比较单项式生成系。
4. `finiteColength_torOne_bounds` 原样保留域 K、指数上闭、lex、真实 A/I 的 `Module.Finite K`、x 标准、w≥4 和每个次数的真实商空间维数预算。它以已验收的 `monomialIdeal_le_variableIdeal_of_x_standard` 提供必需的包含，随后从实际张量纤维等价传递有限维、`a+1+dim(xySubspace)`、真正最少数、严格二项式界及精确有理谐和界。没有由预算偷换有限余长，也没有将任意生成集大小当作最少数。
5. 边界案例与范围正确：I=0 允许且得到零纤维/零 Tor；I=A 不满足所需包含，不能拿一般张量定理误得 Tor₁≅K。该新增结果只涉及 `Tor₁ᴬ(A/m,A/I)`，未形式化两因子交换、完整数值半群归约、更高阶 Tor 或半群匹配下界。

独立重新核对 R041 两冻结源码哈希分别为 ChosenResolution `383057c1ee69e16e34b6196b10d229a66004f717045130fffd7d900b227b1ce9`、DerivedKernel `ef31d5e7a0b7ba4ef699e388020e6f85470a947046d329b84150c645d5a1e70e`，与执行者成功交付记录相符；五个新增证明模块的禁止项搜索此时无命中。

## 最终冻结验收（2026-09-29）

**结论：接受。无待修正问题。** R040 现已完成标准 `Tor₁ᴬ(A/m,A/I)` 到真实 `(A/m)⊗[A]I` 的 A 模同构（假设 I≤m），并沿实际系数域嵌入给出 K 线性等价；后续有限维、极小单项式对应基、真正最少生成数、严格二项式界和有理谐和界的量词均与上述审查一致。此处接受的是完整第一阶标准 Tor 接口，不再只是短正合/张量零映射的阶段命题。

### 构建和逻辑证据

根在 `D:\project\ai4math\lean` 执行统一 `lake build`，报告退出码 0。审查者独立读取已关闭的 `results/lean_tor_one_build.txt`，确认末尾 `Built WidthBounds` 及 `Build completed successfully.`，日志 SHA-256 与根交付值一致。日志覆盖五个新增模块，`TorOneBounds` 与实际 `DependencyAudit` 完成构建；其他模块的成功记录由 Lake 重放。本审查没有为了复述相同成功结果再次执行完整构建。

- 新增五模块共 22 条 `#print axioms` 记录只含 `propext`、`Classical.choice`、`Quot.sound`，没有把研究性未证假设藏作公理。
- 对冻结五模块执行 `rg -n '\b(sorry|admit|axiom|native_decide)\b'` 无命中。
- 根 import 明确纳入 ChosenResolution、DerivedKernel、IdealExactSequence、TorOneBridge、TorOneBounds。
- 独立阅读 `DependencyAudit.lean`：它递归 `getUsedConstantsAsSet` 追踪实际声明依赖，非按 import 列表猜测。新增五根为 `DerivedKernel.isoLeftDerivedOne`、`idealQuotientTorOneIsoTensor`、`idealQuotientTorOneEquivTensor`、`torOneBasis_toTensor`、`finiteColength_torOne_bounds`。统一日志的五项审计均通过，传递依赖不含旧有限包络/小宽度证书和 `sorryAx`。标准 Tor 连接与最终维数界的实际证明链都被覆盖。
- 固定配置仍为 Lean/mathlib 4.22.0；本审查只写本报告，不修改源码、根状态、依赖配置、稿件或 PDF。

### 最终 SHA-256

| 文件 | SHA-256 |
|---|---|
| `lean/WidthBounds/ChosenResolution.lean` | `383057c1ee69e16e34b6196b10d229a66004f717045130fffd7d900b227b1ce9` |
| `lean/WidthBounds/DerivedKernel.lean` | `ef31d5e7a0b7ba4ef699e388020e6f85470a947046d329b84150c645d5a1e70e` |
| `lean/WidthBounds/IdealExactSequence.lean` | `bec2f846f71a1962615171d2dfa654ab59ce9446487a10407d6d2294b1a766c2` |
| `lean/WidthBounds/TorOneBridge.lean` | `b10879dc685babd693f24e0cd2b9c807d7e317851898f882cfbc899053173dd3` |
| `lean/WidthBounds/TorOneBounds.lean` | `046329559b46108404a8b5c2d67c556661acf61c2e6fc2354059608cf6b9dfbe` |
| `lean/WidthBounds.lean` | `ca239e20dff02e1c71fcee6ca4c7c3efc3f711b6c94989c691932f7e395af422` |
| `lean/WidthBounds/DependencyAudit.lean` | `2308744ffed4852265e4f655cc7acc9d359c200b2cad065e4664ff3dc96a6536` |
| `results/lean_tor_one_build.txt` | `7eb47d1cd5e03bcda8111aab5e042bb09748405217834ca04696b02cbbaf434c` |

五个新增证明文件的哈希已逐一独立核对，与成功编译冻结版本一致；根 import、审计模块和统一日志的哈希亦独立计算并匹配。后续修改任一证明后，不能继续把本冻结日志作为修改版本的编译证据。

### 结论口径和停止边界

当前结论可标为 **Lean 已编译，独立源码语义与冻结证据审查接受**。所用一般同调/代数事实为标准数学，此项形式化及整体研究的新颖性仍未定。没有把 Tor 两因子交换作为已证明定理；对象顺序始终为第一因子 A/m、第二派生因子 A/I。完整数值半群代数归约、更高 Tor/Betti、完整 Theta 形式化与人类外部审阅均不属于这次接受范围。

本审查到此冻结。下一步由根登记 claims/queue/STATE/HANDOFF 并创建本里程碑检查点；本审查者不自行改这些根所有文件。

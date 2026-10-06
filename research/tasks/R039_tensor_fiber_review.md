# R039：实际张量纤维与残差环的独立审查

日期：2026-09-25（Asia/Shanghai）。状态：最终冻结验收接受。纸面与源码语义经独立内部审查；三个新增模块已统一 Lean 构建通过，冻结源码、统一日志和六项实际传递依赖审计已独立复核。准确范围与证据见第七节；这不是 Tor/Betti 或完整半群归约的形式化。

独占本报告；未改 Lean 源码、依赖或状态文件，未派生执行者。启动读了 AGENTS、STATE、HANDOFF、queue、R037 计划及现有子商/生成元商定义。独立运行 checkpoint `--check` 成功，`--verify-latest` 的归档完整；工作区差异是本轮已登记的状态更新与根新建张量界文件，不是归档损坏。检查点不代替编译。

## 一、对象与一般同构的纸面核对

令 K 为域，A=K[x,y,z]，m=Ideal.span(range X)，I 为任意 A 的实际理想。I 作为 A 模是实际子类型；它的自然 K 向量空间由常数嵌入 K→A 限制标量得到。目标张量必须是实际 `(A/m) ⊗[A] I`：底环为 A，第一因子为真实理想商。K 作用是常数嵌入诱导的自然作用，不能将底环换成 K，也不能另选一个向量空间作为张量的定义。

在 I 内令 N=m • ⊤（A 子模）。包含映射 ι:I→A 把 N 映为由有限和 Σ aᵢpᵢ（aᵢ∈m、pᵢ∈I）组成的理想乘积 mI。因此 N=ι⁻¹(mI)，不是仅包含或把定义重命名。由于 mI≤I，comap 表示全部 mI，而非有潜在额外交的分母。mathlib 的 `Submodule.mem_smul_top_iff` 与 `Ideal.smul_eq_mul` 可直接实现此成员等价。限制标量后，N 的底层成员不变，应等于 R035 的 `idealSubmodule I (m*I)`；后者独立定义为实际 mI 经包含的 K 线性 comap。

同构 Φ 的公式应为 Φ([q]⊗p)=[qp]。若 q 换成 q+a，a∈m，则差 ap∈mI；A-平衡由 (qr)p=q(rp) 给出。逆映射为 Ψ([p])=1⊗p；它杀掉 mI，因为 1⊗(ap)=[a]⊗p=0。两次复合在商代表元与纯张量上分别为恒等，故给出自然 A 线性同构；限制标量得到自然 K 线性同构。与 R035 商类型的接合还需显式调用或证明商的 `restrictScalarsEquiv`，不能只借两个商的底层集合相同跳过 K 线性检查。

一般同构无需单项式、指数上集、lex、有限余长、有限生成、I⊆m 或 I≠A。R037 可按项目固定 A、K 写出这个一般理想接口；它不声称一般理想的全局最少生成数自动等于纤维维数。

## 二、残差域与标量核对

常数项映射 ε:A→K 是 K 代数映射；所有变量在核内。反过来 ε(p)=0 时，p 的所有支持指数非零，每项被某个变量整除，故 p∈m。因此 m=ker ε。ε 在常数多项式上满射，诱导 A/m≃ₐ[K]K，商代表元 [q] 映到 constantCoeff(q)，逆映射 c↦[C c]。

该识别只解释第一因子的残差域身份；不改变张量底环 A。若写作 K⊗[A]I，必须说明 K 的 A 模结构由 ε 给出，并构造相应运输；本轮不要求这个额外换型，也不允许凭 A/m≃K 就把 A-张量改成 K-张量。

## 三、基、维数与最少数范围

根可将 R034 的真实商类基经 Φ⁻¹运输。除了抽象 Basis 定义，必须证明第 e 个向量正是 `1 ⊗ monomial e 1`，右因子具有属于实际 I 的证明。有限维性须单独建立；再由线性同构或实际基得到 finrank=E.card，避免利用无限维空间 finrank=0 的约定。

完整有限 E 的假设必须保留：I=monomialIdeal S、S 上闭、所有 e∈E 极小、所列单项式的实际 Ideal.span 等于 I。lex、有限余长和预算只在最终宽度界层使用，不能倒灌成一般同构的条件。真正最少数结论应调用既有对全部有限多项式生成集合的 IsLeast 结果，不应把最少性作为假设。

不能将最少数等式扩张到任意实际理想：例如 I=(x−1,y) 与 m 互素，mI=m∩I，因而 I/mI≃A/m 维数为 1；但 I 是真理想，x−1 与 y 无公共非单位因子，故 I 不是主理想，实际最少生成数为 2。这只作为纸面范围检验，未声称新增该反例的 Lean 命题。

最终两个界应仍是原有限余长 lex 模型：域、S 上闭、lex、A/I 真实有限维、x 标准、w≥4 以及全部次数的真实维数预算。结论针对纤维维数/真正最少数，不能量化到加入冗余项后的任意生成集合。

## 四、零/单位理想与 Tor 边界

- I=0：张量、实际 I/mI 均为零空间。完整 E 为空，基为空，维数和最少生成数为 0。
- I=A：mI=m，张量 `(A/m)⊗[A]A≃A/m≃K`，Φ 把 1⊗1 映到 1 的商类。完整极小指数集合是 {0}，基有一个向量，维数和最少生成数为 1。
- I=A 时 A/I=0，`Tor₁^A(A/I,K)=0`，与当前纤维不同。因此不能无条件称当前一般对象为 Tor₁，也不能仅定义新的 Betti 数等于该维数作为标准接口。

未来由 0→I→A→A/I→0 导出的同调长正合列，在 I⊆m 时才让 I⊗K→A⊗K 的映射为零，从而取得所需 Tor₁ 识别；仍需明确标准 Tor 定义、因子顺序和实际正合性接口。本轮不执行该后续任务。

## 五、最终验收待办（2026-09-24 历史记录，已由第七节完成）

等待根给冻结版本后，逐读 GeneratorTensorFiber.lean、VariableResidue.lean、GeneratorTensorBounds.lean 与 DependencyAudit 的新增声明，确认上述语义、量词及纯张量公式；独立计算源码/关闭后的统一日志 SHA-256，确认匹配根声明。检查统一构建成功、禁止项扫描无命中、关键声明仅使用标准逻辑公理，传递依赖审计不含旧有限证书及 sorryAx。

当前未发现纸面数学障碍。此时尚不标记本轮 Lean 最终接受；本报告不是外部人类审稿，也不作新颖性认证。冻结 v0.1/v0.2 未改，无网络、枚举或对外操作。

## 六、候选源码语义核对

已逐读三个候选模块，尚未把候选读取当成最终编译证据。

`GeneratorTensorFiber.lean` 的缩写直接使用 `(MvPolynomial (Fin 3) K ⧸ variableIdeal) ⊗[MvPolynomial (Fin 3) K] I`。`generator_smul_top_restrictScalars` 通过 ext 及 `Submodule.mem_smul_top_iff` 证明实际分母相等；其右侧 m•I 与真实理想乘积 m*I 是 mathlib 中的定义等同，因此并未省略成员证明。`generatorTensorEquiv` 首先对标准 A 线性张量/商同构限制标量，再复合商的 `restrictScalarsEquiv` 的逆和真实子模等式对应的商同构。三个公式分别明确给出 [q]⊗p↦[q•p]、1⊗p↦[p]、[p]↦1⊗p，量词涵盖任意 I。

`VariableResidue.lean` 从旧的核包含与支持项展开证明反向，随后把真实核等式用于商的 K 代数同构。常数项代数映射的 `commutes'` 由 constantCoeff_C 给出，满射由 C 这一右逆提供。正向商代表元与逆方向公式均显式列出。未把 variableIdeal 更改为核定义，也未更改任何既有源码。

`GeneratorTensorBounds.lean` 的坐标是已经证明的张量同构与既有商坐标同构复合。代表元公式最终调用 `minimalCoefficientMap_mul`，因此常数项确实是 q 的 K 标量；任意残差类公式经 mk_surjective 及 `variableResidueEquiv_mk` 给出同一标量。基由商类基传回，`generatorTensorBasis_apply` 用 Φ 的单射及 1⊗p 公式把它识别为原极小单项式的真实纯张量。有限维单独由有限函数空间转移，维数及 IsLeast 由实际同构和旧定理传递；原有限余长 lex 的全部假设在最终两界中保留。候选源码语义未发现需修正问题；编译或冻结变化须再核对。

新增 `monomialIdeal_le_variableIdeal_of_x_standard` 的量词仅为 S 上闭与 x 标准，范围正确。其证明对实际 p∈I 反设常数项非零，支持判据给出 0∈S，从而常数单项式 1∈I，再由理想乘法/单项式指数单调性得到 x∈I，与 x 标准矛盾。因此所有成员常数项为零，R038 真实核等式给出 I≤m。无需 lex、预算或有限余长；证明只提供将来同调接口的必要结构，不声称 Tor 识别。

用户继续后，审查者按已落盘状态续接并复读当前三个源码，未重做纸面分析。当前 VariableResidue.lean 的独立 SHA-256 为 `9ba7cf9356ab12b7f70d91f57af7da67890e58216e71e790ca838a2a90ba6e12`，与执行者编译成功后冻结的值一致。执行者 R038 报告记录单文件 `lake env lean WidthBounds/VariableResidue.lean` 退出 0、五项声明公理仅为 propext/Classical.choice/Quot.sound；此单文件记录不代替根统一构建及最终版本验收。

根接手编译时，R037 的初版纯张量公式使用 `simp [generatorTensorEquiv]`，触发在 GeneratorQuotient 上搜索 A 标量作用而超时；同构本体已经通过。根改为显式 `change` 展开三段等价，使用 `TensorProduct.quotTensorEquivQuotSMul_mk_tmul` 后以 rfl 结束，未增加实例或数学假设。审查者已复读修正，数学语义不变。根报告单文件退出 0，五项公理仅为三标准逻辑公理；审查者独立得到修正后源码 SHA-256 `24320e28c149efc7f0f7ce4dfd9494677db601a1cd9c4cba80f127666f7584a0`，与根冻结值一致。旧 R037 候选哈希不作证据。当前三新源码禁止项 `sorry|admit|native_decide|^axiom` 扫描无匹配。

## 七、2026-09-25 最终冻结验收

旧审查执行者不再存在后，新独立审查者按本报告的已完成工作续接，只复核最终冻结版本，未重做全路线。启动重新读取恢复入口，并独立运行根 `.venv\Scripts\python.exe -B scripts/checkpoint.py --check` 与 `--verify-latest`，两者退出 0；队列有效、归档 `archive_valid: true`。最新归档仍是此前 WIP，列出的源码、根 import、审计、任务报告和新日志变化是其后的已登记工作，不是归档损坏。检查点核验本身不构成 Lean 编译证据。

逐读当前三个新增源码、根 import、`DependencyAudit.lean`；定向复核了真实 `idealSubmodule`/`GeneratorQuotient`/`generatorCardinalities` 定义及 mathlib 的 `Submodule.mem_smul_top_iff`、`TensorProduct.quotTensorEquivQuotSMul`。确认最终源码与第一至六节审查的对象和量词一致：

- `GeneratorTensorFiber I` 就是实际 `(A/m) ⊗[A] I`，底环 A=`MvPolynomial (Fin 3) K`，两侧 K 作用是自然限制标量；一般同构对任意实际理想 I 成立。
- `generator_smul_top_restrictScalars` 证明 m•⊤ 限制标量后等于真实 mI 在 I 中的 comap；现有 `mI≤I` 使分母确实是 mI。同构使用标准 A 线性张量/商同构、商的限制标量同构与已证分母等式，没有重定义目标空间。
- 三个同构公式分别为 `[q]⊗p↦[qp]`、`1⊗p↦[p]`、`[p]↦1⊗p`。残差环由 span 定义的 m 证明等于常数项核，再得到真实 `A/m≃ₐ[K]K`，包括正反商代表元公式；没有把张量底环换成 K。
- 坐标公式对任意残差类以 `variableResidueEquiv q` 为 K 标量。基向量明确等于原极小系数 1 单项式的 `1⊗g`。有限 E、极小性与实际完整生成 `hSpan` 假设全部保留；有限维性独立证明，随后传递 finrank 与对所有有限多项式生成集合的真正 `IsLeast`。
- 最终宽度定理保留域、S 上闭、lex、真实 A/I 有限维、x 标准、w≥4、所有次数真实维数预算，结论为同一纤维维数 `a+1+dim_K(xySubspace)`、真正最少数、严格二项式上界及精确有理谐和上界。没有给冗余生成集合的基数上界。
- `monomialIdeal_le_variableIdeal_of_x_standard` 只用 S 上闭与 x 标准，正确推出 I≤m；没有添加 lex、有限余长或预算作为该包含的假设，也没有声称该包含已完成同调识别。

根已执行统一 `lake build` 并报告退出 0。本审查者独立读取关闭后的 `results/lean_generator_tensor_build.txt`，确认三个新增模块、审计与根模块均在统一构建输出中，末行是 `Build completed successfully.`；未以检查点替代构建，也未重复编译未变源码。三个新模块共 15 项 `#print axioms` 输出全部仅含 `propext`、`Classical.choice`、`Quot.sound`。独立扫描三源码无 `sorry`、`admit`、`native_decide` 或自定义 `axiom` 声明；统一日志无 `error:` 或 `sorryAx`。

实际传递依赖审计的代码从声明本身递归遍历 `getUsedConstantsAsSet`，并检查 `sorryAx` 与四个历史有限证书/小宽度声明，而非根据 import 列表推断。六个新增根 `generatorTensorEquiv`、`variableResidueEquiv`、`generatorTensorCoordinates_tmul`、`generatorTensorBasis_apply`、`monomialIdeal_le_variableIdeal_of_x_standard`、`finiteColength_generatorTensor_bounds` 在冻结源码的根列表和成功日志中逐一对应；均未依赖上述被排除声明。根模块实际导入三个新增模块。

以下 SHA-256 由本审查者独立按文件字节重算；三个证明源码及统一日志均与根提供的冻结值完全一致。根 import 和审计也固定到本次读取的版本。

| 文件 | SHA-256 |
| --- | --- |
| `lean/WidthBounds/GeneratorTensorFiber.lean` | `24320e28c149efc7f0f7ce4dfd9494677db601a1cd9c4cba80f127666f7584a0` |
| `lean/WidthBounds/VariableResidue.lean` | `9ba7cf9356ab12b7f70d91f57af7da67890e58216e71e790ca838a2a90ba6e12` |
| `lean/WidthBounds/GeneratorTensorBounds.lean` | `9299fe69c4906acc864b3c757ed0f1bac92e12ebe936523e944107ac4cd1dac8` |
| `lean/WidthBounds.lean` | `8919ac6d81bc9a27fe8ca529ac04b38a53bac4b72a7268873e8db6a9727d1427` |
| `lean/WidthBounds/DependencyAudit.lean` | `854c0641f071c6afa1ac877a8194b50dbc15cadccfbd3a977cdf5bdfd4ce2188` |
| `results/lean_generator_tensor_build.txt` | `703b698074e1619e83902c88d681f61538e6f7504d51d2e6bfc63162e5224f7b` |

**最终决定：接受 R037/R038 及根的张量基/维数/最少数/宽度界集成，R039 本报告冻结。** 本次未发现阻碍验收的问题；状态是“所列具体 Lean 命题已编译，源码语义经独立内部审查”，新颖性仍未定，亦无外部人类审阅。

限制保持不变：本轮尚未把张量纤维识别为标准 Tor/Betti，也未完成整个半群归约。一般 I=A 时纤维≃K、维数为 1，而 Tor₁(A/I,K)=0；即使最终 lex 场景已证 I≤m，仍须另做标准同调定义、因子顺序和正合接口。用户最新要求仅完成当前步骤，因此本审查到此停止，不启动 R040 或其他后续研究。只修改本报告；状态、claims 与稳定检查点由根集成；冻结稿件未改。

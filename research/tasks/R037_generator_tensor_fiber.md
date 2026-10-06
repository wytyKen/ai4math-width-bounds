# R037：实际残差张量纤维与生成元商

日期：2026-09-25（Asia/Shanghai）。状态：已完成。真实张量同构、残差环识别、纯张量基及维数/最少数传递均已统一Lean构建通过，R039最终独立验收接受。按用户明确要求，本轮收束证据与稳定检查点，不启动后续任务。

## 执行记录：真实张量接口

- 执行者独占 `lean/WidthBounds/GeneratorTensorFiber.lean` 与本报告；根负责基/维数/最少数传递、状态与集成。
- 已写真实 `GeneratorTensorFiber I := (A ⧸ variableIdeal) ⊗[A] I`，准备以mathlib标准tensor/quotient同构和现有K标量结构组合；不引入新Module实例。
- 分母路线：`Submodule.mem_smul_top_iff` 对真实子模I给出成员等价，`Ideal.smul_eq_mul`定义等式把右端接到实际理想乘积。
- 首次 `lake env lean WidthBounds/GeneratorTensorFiber.lean` 在导入前失败：本地mathlib尚缺 `Mathlib.LinearAlgebra.TensorProduct.Quotient.olean`。正在固定版本4.22.0内运行 `lake build Mathlib.LinearAlgebra.TensorProduct.Quotient` 补建该依赖，未修改依赖版本或配置。
- 当前源码是WIP，不以未编译文本作为数学验收证据。

目标：对A=K[x,y,z]、真实变量理想m=(x,y,z)和实际理想I，连接真实张量积 `(A/m) ⊗[A] I` 与已构造的实际 `GeneratorQuotient I = I/mI`，建立K线性同构，并把基、维数与最少生成数结果传过去。这是通向同调的张量接口，本任务不自动声称Tor_1识别。

建议独占新文件 `lean/WidthBounds/GeneratorTensorFiber.lean` 与本报告。先读R034/R035/R036报告、IdealSubquotient.lean、GeneratorQuotientBounds.lean。旧的真实mI核等式、商基、最少数与宽度界不重做。

已有本地mathlib 4.22.0接口（根只做定向源码核对，尚未实现本任务）：

- `Mathlib/LinearAlgebra/TensorProduct/Quotient.lean` 中 `TensorProduct.quotTensorEquivQuotSMul`，将 `(A/m) ⊗[A] M` 与 `M / (m • ⊤)` 连接；有纯张量及商mk作用公式。
- `Mathlib/CategoryTheory/Monoidal/Tor.lean` 中确有 `CategoryTheory.Tor` 与 `Tor'`，分别派生不同因子，但文件主要提供定义及projective对象高次消失。本任务不能仅凭这个文件存在就声称低次Tor和当前商空间已识别。

候选步骤（均需实际Lean证明）：

1. 把I作为A模，证明其子模 `m • ⊤` 的成员，正好是实际理想乘积mI经包含映射拉回的成员。这一步须接真实Ideal乘积；不可把两者直接定义相同。
2. 接现有张量/商同构，再处理restrictScalars到K与R035按K子模定义的商之间的对应。检查实际K作用与A/m上的作用，不能只构造不相容的加法群同构。
3. 给纯张量 `(q mod m) ⊗ p` 的明确商类作用公式，特别 `1 ⊗ p` 对应p的商类。可另证A/m与K的常数项等价，但不必过早更换所有底环实例。
4. 接R034完整极小单项式E，得到张量纤维的基和维数E.card，并与R031真正最少生成数及原有界对应。

验收：真实TensorProduct、真实m及理想乘积、明确K线性结构与纯张量公式；无sorry/admit/native_decide/自定义公理；统一构建与独立审查。维数/基是代数对象的实际识别，不能仅把目标重命名为已知向量空间。零/单位理想边界照常保留。

后续若开始Tor_1，应单独明确底环A、残差域K或A/m的A模结构、派生因子的顺序、I⊂m条件，以及短正合序列/解析式与mathlib标准Tor定义的连接；不能用自定义Betti数等于当前维数来绕过接口。

## 根接手与单模块验收（2026-09-24）

执行者已补建固定mathlib4.22.0内的 `Mathlib.LinearAlgebra.TensorProduct.Quotient` 缓存，但在回传最终校验前遇额度限制。用户再次继续后，根读取落盘源码及R039候选审查，未发现存活的旧lean/lake进程，记录接手并创建WIP检查点，没有从头重做。

实际 `GeneratorTensorFiber I` 是 `(A⧸variableIdeal)⊗[A]I`。K作用来自原有标准标量塔，没有新建Module实例或改成K上的张量积。

`generator_smul_top_restrictScalars` 用Submodule.mem_smul_top_iff证明 `(m•⊤).restrictScalars K=idealSubmodule I (m*I)`；右侧是实际mI的comap。`generatorTensorEquiv`依次使用标准A线性商张量同构、restrictScalars K、商restrictScalarsEquiv的逆及已证分母相等，得到真实K线性同构。适用于任意实际理想，不要求单项式、lex、有限余长或I≤m。

纯张量公式：`generatorTensorEquiv_mk_tmul I q p` 将[q]⊗p映到[q•p]；`generatorTensorEquiv_one_tmul`给1⊗p↦[p]；`generatorTensorEquiv_symm_mk`给[p]↦1⊗p。

根第一次目标构建发现宽泛 `simp [generatorTensorEquiv]` 在mk_tmul证明中试图合成GeneratorQuotient上的不需要的A作用并超时。同构本体和分母等式已通过。根只将该公式证明改为显式展开三段同构、重写mathlib纯张量公式、rfl；没有新增实例或数学假设。

修正后在lean/运行 `lake env lean WidthBounds/GeneratorTensorFiber.lean` 退出0；五项#print axioms都只依赖propext、Classical.choice、Quot.sound。冻结源码SHA-256为 `24320e28c149efc7f0f7ce4dfd9494677db601a1cd9c4cba80f127666f7584a0`。失败构建的占位诊断不作为最终证据，旧源码hash也不用于新证明。

## 根传递模块与实际数学范围

新增 `lean/WidthBounds/GeneratorTensorBounds.lean`，根已完成单模块编译，最后统一证据见后续验收记录。

- `generatorTensorCoordinates` 将真实张量同构与已证明的极小系数商坐标连接，得到实际张量积与E→K的K线性同构。
- `generatorTensorCoordinates_mk_tmul` 给出[q]⊗p的坐标是constantCoeff(q)乘p的极小系数向量；`generatorTensorCoordinates_tmul`对任意残差类使用R038的真实K代数同构variableResidueEquiv给同一公式。此处没有更换张量底环A。
- `generatorTensorBasis_apply`证明基向量恰为1⊗原极小系数1单项式。基、有限维、finrank=E.card、真正最少生成数IsLeast均由实际线性同构与旧已验证定理连接，不把目标定义成已知坐标空间。
- `finiteColength_generatorTensor_bounds`在原有域、指数上集、lex、真实A/I有限维、x标准、w≥4与全部次数真实维数预算下，证明实际张量纤维有限维，其维数为a+1+dim(xySubspace)=a+1+ell=μ，且μ<binom(w+1,2)、μ≤4w−1+(2w−1)H_(2w−1)。H界仍为精确有理数界。
- `monomialIdeal_le_variableIdeal_of_x_standard`只用指数上集和x标准，由支持判据排除任何常数项非零成员，证明实际I≤m。这是未来标准Tor₁连接的必要条件，不是Tor结论。

一般张量同构适用于任意理想；最少数等式保留完整极小单项式生成性。不能把后者扩大到任意非单项式理想，见R039纸面范围检验。零理想/单位理想未被一般接口排除；I=A时纤维≅K，不能无条件称Tor₁(A/I,K)。

根传递模块初次编译在纯张量声明因variableIdeal隐式系数类型推断超时；仅补显式(K:=K)后通过，无新假设或实例。最终清理无用simp参数并登记纯张量坐标公式的公理输出。冻结根源码SHA-256 `9299fe69c4906acc864b3c757ed0f1bac92e12ebe936523e944107ac4cd1dac8`。

下一项R040计划连接mathlib标准CategoryTheory.Tor的低次对象与本纤维。根仅定向读取本地Tor、LeftDerived与ProjectiveResolution接口并落盘计划；尚未建立新的标准Tor或短正合序列定理。冻结稿件未改，无新枚举/网络/对外动作，新颖性未认证。

## 统一构建完成与本次收束

最终在lean/执行 `lake build`，退出0，日志末尾为Build completed successfully。完整日志 `results/lean_generator_tensor_build.txt`，SHA-256 `703b698074e1619e83902c88d681f61538e6f7504d51d2e6bfc63162e5224f7b`。三新增模块均进入根import，所有新#print输出仅propext、Classical.choice、Quot.sound。实际声明依赖审计新增张量同构、残差同构、坐标纯张量公式、基作用公式、I≤m和最终宽度定理六个根，全部确认无旧有限枚举/小宽度证书或sorryAx。

2026-09-25恢复时，归档仍完整，工作区变化恰为WIP后修正的源码、root import/审计、报告与上述成功日志。根重新核对冻结源码hash与此前编译版本相符，不为无变源码重复构建；旧R039执行者已不存在，保留其详细审查并另派独立执行者完成最终版本/日志核验。数学范围及最终接受意见见R039报告。

用户随后明确要求只完成当前步骤，不推进后续。本轮收束到R037/R038/R039的稳定验收；R040文件保留为此前未执行的计划，不启动、不宣称有任何Tor新结果。R024亦未启动。冻结v0.1/v0.2保持原样。

最终独立验收（2026-09-25）：R039接受冻结源码与成功日志，15项公理输出仅标准三公理、六个新增实际声明依赖审计通过、禁止项无命中；审查报告SHA-256 `9da2fb5d440faf3a5fe89602673e9ac9ac25f0dbbaa13d21aa83b7b09bd3e2b6`。任务已达成，后续未启动。

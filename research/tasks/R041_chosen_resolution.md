# R041：指定首个投射满射的标准投射分解

日期：2026-09-29（Asia/Shanghai）。状态：两个模块独立编译通过，待根统一集成验收；执行者仅修改本报告、`lean/WidthBounds/ChosenResolution.lean` 与新增 `lean/WidthBounds/DerivedKernel.lean`。

## 目标与路线

在一般 Abelian 范畴 `[EnoughProjectives C]` 中，对 `f : P ⟶ X`、`[Projective P]`、`[Epi f]` 构造 mathlib 标准 `ProjectiveResolution X`，明确零次项等于 `P`、augmentation 零次分量等于 `f`、一次微分等于 `Projective.d f`。继而复用 `ProjectiveResolution.isoLeftDerivedObj` 给标准左派生函子的计算同构。

本轮只处理选定分解基础设施，不声称完成 Tor₁ 与生成元张量纤维同构。无外部服务写入。

本地固定版本 `Resolution.lean` 的 `ProjectiveResolution.of` 实际固定从 `Projective.over X` 及 `Projective.π X` 开始；R040 原计划对它可直接选首个 epi 的描述不准确。采用同一递推 `ChainComplex.mk'`，把首项换成给定 `P` 与 `f`；正合性以库定理 `exact_d_f` 证明，quasi-isomorphism 以给定 epi 与正次数正合性证明。

## 验收与停止条件

- 新模块须 `lake env lean WidthBounds/ChosenResolution.lean` 实际通过；无 `sorry`、`admit`、`native_decide`、自定义公理。
- 给出公式和标准派生对象同构的完整签名，记录必要假设与未完成范围。
- 两次实质路线均无新增进展则保存精确障碍交根，不无限重试。

## 工作记录

- 已读取 AGENTS.md 与 R040 计划，定向检查固定 mathlib 源码。根已完成状态恢复和登记。
- 当前为构造中，尚无编译通过结论。

### 中断后续接（2026-09-26）

- 已核对原执行者仅留下上述计划，未有源码；根确认检查点归档完整、工作区有正常后续修改，并重新登记文件所有权。
- 已落盘 `lean/WidthBounds/ChosenResolution.lean` 初稿（尚待编译），命名空间为 `WidthBounds.ChosenResolution`：`complex`、`complex_exactAt_succ`、`resolution`、`resolution_X_zero`、`resolution_X_one`、`resolution_π_f_zero`、`resolution_d_one_zero`、`isoLeftDerivedObj`。
- 输入假设：`[Category C] [Abelian C] [EnoughProjectives C]`，给定 `f : P ⟶ X`；构造标准分解时再用 `[Projective P] [Epi f]`。目标范畴 `D` 为 Abelian、`F : C ⥤ D` 为 additive，派生对象 iso 无须额外 right exact 假设。
- 根集中构建缺失的 mathlib 固定版本依赖；本执行者不并发重复构建依赖。
- 首次 `lake env lean WidthBounds/ChosenResolution.lean` 在导入行因 `Mathlib.CategoryTheory.Abelian.LeftDerived.olean` 尚不存在而停止，未检查本模块证明。这是依赖构建中的状态，不是证明失败，也不计入两次实质路线无进展的停止条件。

### 续接阶段一已编译（2026-09-29）

- 根重新授权原任务与新增独占 `lean/WidthBounds/DerivedKernel.lean`；本执行者不派生。
- 已核对状态与检查点：queue合法、既有归档完整；工作区差异属于后续修改。未重做既有稳定证明。
- 原稿递推正合性、逐项投射与非零次quasiIso均直接通过；仅修正指定augmentation在零次的两处化简，显式调用 `ChainComplex.toSingle₀Equiv_symm_apply_f_zero`。
- 命令 `lake env lean -o .lake/build/lib/lean/WidthBounds/ChosenResolution.olean WidthBounds/ChosenResolution.lean` 退出0。四项公理输出 `complex_exactAt_succ`、`resolution`、`resolution_π_f_zero`、`isoLeftDerivedObj` 均只含 `propext/Classical.choice/Quot.sound`。
- 阶段二目标签名：`isoLeftDerivedOne (f : P ⟶ X) [Projective P] [Epi f] (F : C ⥤ D) [F.Additive] [PreservesFiniteColimits F] (h : F.map (kernel.ι f) = 0) : (F.leftDerived 1).obj X ≅ F.obj (kernel f)`，C、D均Abelian且C有足够投射。此目标尚未编译，阶段一不能替代完整Tor₁识别。

### 阶段二泛型派生核接口已编译（2026-09-29）

- 最终接口为 `WidthBounds.DerivedKernel.isoLeftDerivedOne f F h`，返回标准 `(F.leftDerived 1).obj X ≅ F.obj (kernel f)`。精确假设是 C、D 为 Abelian 范畴，C 有 EnoughProjectives，`f : P ⟶ X` 满射，P 投射，F additive 且保有限余极限，`F.map (kernel.ι f) = 0`。
- `presentation f` 的箭头为真实 `Projective.d (Projective.d f)` 与 `Projective.π (kernel f)`。前者复合后者为零由 `kernel.ι f` 的mono消去取得；`presentation_exact` 从库 `exact_d_f (Projective.d f)` 经末项mono比较得到。后者epi，于是 `kernelIsCokernel` 给真实 kernel f 的余核泛性质。
- 保有限余极限使 F 保留该余核。`map_d_zero` 明确从映核包含为零推出映后一次微分为零；`HomologyData.ofIsColimitCokernelCofork` 因而计算实际映后分解的一次同调为 `F.obj (kernel f)`。
- `homologyOneIso` 用 `homologyIsoSc' 2 1 0` 及显式短复形同构接到上述余核同调；为核对低次箭头，在 `ChosenResolution` 新增并编译了 `complex_d_two_one`。`isoLeftDerivedOne` 最后串接阶段一的 `ChosenResolution.isoLeftDerivedObj`，不是孤立短复形同调。
- 最终命令依次为 `lake env lean -o .lake/build/lib/lean/WidthBounds/ChosenResolution.olean WidthBounds/ChosenResolution.lean` 与 `lake env lean -o .lake/build/lib/lean/WidthBounds/DerivedKernel.olean WidthBounds/DerivedKernel.lean`，均退出0，无warning；两模块olean已生成供根集成。
- 新模块四项公理输出 `presentation_exact`、`kernelIsCokernel`、`homologyOneIso`、`isoLeftDerivedOne` 均只含 `propext/Classical.choice/Quot.sound`。标准数学构造；新颖性未定，不作原创性声明。
- 任务完成边界：泛型接口已编译；实际ModuleCat理想实例、核同构、张量零映射、标准Tor顺序与K线性维数口径由根及R042集成。本报告不独立声称完整R040或半群Betti归约已完成。
- 未修改根import、配置、queue、claims或检查点。最终统一构建与证据哈希由根维护。
- 本执行者冻结源码SHA-256：ChosenResolution `383057c1ee69e16e34b6196b10d229a66004f717045130fffd7d900b227b1ce9`；DerivedKernel `ef31d5e7a0b7ba4ef699e388020e6f85470a947046d329b84150c645d5a1e70e`。两源码 `rg -n '\b(sorry|admit|native_decide|axiom)\b'` 无命中（退出1）。这里的哈希定位已编译的源码，不能替代根保存的最终统一日志。

## 根最终集成验收（2026-09-29）

本模块已进入根主线，并与实际核同构、残差张量零映射和标准派生对象计算共同闭合R040；K线性同构、Tor基/有限维/最少数/严格界与有理谐和界亦已完成。统一 `lake build` 退出0，日志 `results/lean_tor_one_build.txt`，SHA-256 `7eb47d1cd5e03bcda8111aab5e042bb09748405217834ca04696b02cbbaf434c`。本模块冻结源码未变；R043独立核对完整数学范围和最终证据。

此前WIP/局部交付段落为历史进度。当前模块已验收；完整R040边界以R040报告末尾为准，仍不包含更高Tor或完整半群归约。

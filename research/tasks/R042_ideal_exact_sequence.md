# R042：实际理想商的 ModuleCat 短正合序列

日期：2026-09-29（Asia/Shanghai）。状态：执行者直接 Lean 编译通过，已交付主智能体统一构建及语义验收。

独占文件：`lean/WidthBounds/IdealExactSequence.lean`、本报告。根已恢复状态并登记队列；本执行者只读交接/协议，不改根状态、配置或其他证明。

目标：对一般交换环 A 与理想 I，使用实际子模包含 `I.subtype` 及商映射 `I.mkQ`，构造 `ModuleCat A` 中 `I → A → A ⧸ I` 的 `ShortComplex` 并证明 `ShortExact`。给出底层映射公式、包含 Mono、商 Epi 和自由秩一对象 `ModuleCat.of A A` 的 Projective 接口。

证明路线：通过 `ModuleCat` 正合性的线性映射刻画，以 `range_subtype` 和 `ker_mkQ` 识别像与核；由包含单射、商映射满射得到 Mono/Epi；调用库的自由模 projective 实例。

边界：本任务建立真实短正合序列、中间对象 projective 及标准范畴核到真实理想的兼容同构；不构造或识别 Tor，不证明张量后包含为零，不声称完整同调归约。

后续补充：最终接口、实际命令、编译结果、公理及限制。

## 2026-09-26 恢复续接的首个落盘节点

原执行者只留下本报告，源码未存在；本次先核对计划并读取当前状态。独立再次运行根 `.venv\Scripts\python.exe -B scripts/checkpoint.py --check` 与 `--verify-latest`：队列合法、归档完整，工作区差异属于已知WIP，不解释为归档损坏。

已创建 `IdealExactSequence.lean` 候选实现，尚待编译。namespace 为 `WidthBounds`，一般 `{A : Type u} [CommRing A]`，不要求域、有限性、非零环或理想真性。

预定接口：
- `idealInclusion I : ModuleCat.of A I ⟶ ModuleCat.of A A`，底层为 `I.subtype`。
- `idealQuotientMap I : ModuleCat.of A A ⟶ ModuleCat.of A (A ⧸ I)`，底层为 `I.mkQ`，元素公式为 `Ideal.Quotient.mk I`。
- `idealInclusion_mono`、`idealQuotientMap_epi`、`idealInclusion_comp_quotient`。
- `idealQuotientShortComplex I : ShortComplex (ModuleCat A)`。
- `idealQuotientShortComplex_exact` 与 `idealQuotientShortExact`。
- `ringModuleProjective (A) : CategoryTheory.Projective (ModuleCat.of A A)`。

使用 `ShortComplex.moduleCat_exact_iff_range_eq_ker` 后直接化为 `Submodule.range_subtype` 与 `Submodule.ker_mkQ`。根统一构建依赖中；本worker没有启动重复依赖构建。

## 2026-09-29 续验与完成

接续时保留上述完整候选，没有从零重写。已读 AGENTS、STATE、HANDOFF、queue、PROTOCOL 及 R043 审查；根 `.venv\Scripts\python.exe -B scripts/checkpoint.py --check` 返回 `queue_valid: true`；`--verify-latest` 返回 `archive_valid: true`。工作区变化是已登记 R040–R043 的 WIP，不是归档损坏。根集中补建了 `Mathlib.Algebra.Homology.ShortComplex.ModuleCat` 和 `ModuleCat.Monoidal.Closed`；执行者未并发重复构建依赖。

### 最终命题与假设

全部声明位于 `WidthBounds`，假设仅 `{A : Type u} [CommRing A]` 和 `I : Ideal A`；不要求 `I ≤ m`，也不假定 I 本身投射。真实包含、真实商映射及短正合性接口保持上列原签名。

新增：

```lean
noncomputable def idealQuotientKernelIso (I : Ideal A) :
    CategoryTheory.Limits.kernel (idealQuotientMap I) ≅ ModuleCat.of A I

theorem idealQuotientKernelIso_hom_inclusion (I : Ideal A) :
    (idealQuotientKernelIso I).hom ≫ idealInclusion I =
      CategoryTheory.Limits.kernel.ι (idealQuotientMap I)

theorem idealQuotientKernelIso_inv_kernel_ι (I : Ideal A) :
    (idealQuotientKernelIso I).inv ≫
        CategoryTheory.Limits.kernel.ι (idealQuotientMap I) =
      idealInclusion I
```

两兼容公式均带 `@[reassoc (attr := simp)]`，产生相应 `_assoc` 接口。同构通过 `(idealQuotientShortExact I).fIsKernel` 的真实核泛性质与标准 `limit.isoLimitCone` 构造，没有把 `CategoryTheory.Limits.kernel` 定义成 I，也没有借用自定义 Tor 对象代替标准定义。正逆兼容公式分别由 `limit.isoLimitCone_hom_π` 与 `limit.isoLimitCone_inv_π` 在 `WalkingParallelPair.zero` 处给出。

### 编译命令和真实结果

工作目录 `D:\project\ai4math\lean`，固定 Lean/mathlib 4.22.0。

1. 原候选执行 `lake env lean WidthBounds/IdealExactSequence.lean`：退出码 0，原短正合序列和中间投射对象无需修正。
2. 增加标准核同构及两兼容公式后，同一命令再次执行：退出码 0，无错误或警告。完整输出如下：

```text
'WidthBounds.idealQuotientShortExact' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.idealQuotientKernelIso' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.idealQuotientKernelIso_hom_inclusion' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.idealQuotientKernelIso_inv_kernel_ι' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.ringModuleProjective' depends on axioms: [propext, Classical.choice, Quot.sound]
```

2026-09-29 02:18 +08:00 冻结源码 SHA-256：
`bec2f846f71a1962615171d2dfa654ab59ce9446487a10407d6d2294b1a766c2`。

`rg -n '\b(sorry|admit|axiom|native_decide)\b' lean/WidthBounds/IdealExactSequence.lean` 无命中。两次编译均直接通过，没有未解报错或失败数学路线；不将此前待编译计划作为验收证据。

### 验收边界与下一步

本文件已 Lean 编译的范围是实际 I→A→A/I 短正合、A 的投射性、标准范畴核与实际 I 的同构及包含兼容。数学内容属于标准一般代数事实，不构成新颖性认证。

执行者停止编辑此文件，交由根统一构建、独立核对并登记 claims/queue。下游可用 `idealQuotientKernelIso_hom_inclusion` 把给定投射 epi 的标准核包含张量为零条件转换成真实理想包含张量为零条件；R041/R040 仍须完成标准左派生对象到该张量纤维的同构，本任务没有代替该桥梁。根 import、其他源码、配置、状态及冻结稿件均未修改。

## 根最终集成验收（2026-09-29）

本模块已进入根主线，并与实际核同构、残差张量零映射和标准派生对象计算共同闭合R040；K线性同构、Tor基/有限维/最少数/严格界与有理谐和界亦已完成。统一 `lake build` 退出0，日志 `results/lean_tor_one_build.txt`，SHA-256 `7eb47d1cd5e03bcda8111aab5e042bb09748405217834ca04696b02cbbaf434c`。本模块冻结源码未变；R043独立核对完整数学范围和最终证据。

此前WIP/局部交付段落为历史进度。当前模块已验收；完整R040边界以R040报告末尾为准，仍不包含更高Tor或完整半群归约。

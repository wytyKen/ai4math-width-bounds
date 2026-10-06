# R081：标准 Tor 与实际残差零微分分解的项同构

日期：2026-10-01。状态：单文件 Lean 编译及 `lake build WidthBounds.MinimalResolutionTor` 均已通过；执行者完成后停止，等待根统一验收。

独占文件：`lean/WidthBounds/MinimalResolutionTor.lean` 与本报告。不派生子智能体，不更改旧源码、根 import、依赖配置或根状态文件。

目标固定任意域 K、A=K[x,y,z]、理想 I、实际标准 `ProjectiveResolution (ModuleCat.of A (A/I))`。标准 Tor 始终第一因子 A/m、派生第二因子 A/I；沿 `algebraMap K A` 限制标量，不使用换序、不把想要的维数设为定义。

## 已编译接口

以下命名空间均为 `WidthBounds.MonomialInterface`。

| 声明 | 精确功能 |
| --- | --- |
| `IdealQuotientTor I n` | 标准 `CategoryTheory.Tor (ModuleCat A) n` 在固定第一因子 A/m、第二因子 A/I 的对象 |
| `IdealQuotientTorK I n` | 上述对象沿实际 `algebraMap K A` 限制标量 |
| `idealQuotientTor_one I` | `IdealQuotientTor I 1 = IdealQuotientTorOne I`，rfl，标记 simp |
| `idealQuotientTorK_one I` | `IdealQuotientTorK I 1 = IdealQuotientTorOneK I`，rfl，标记 simp |
| `idealQuotientTorIsoHomology I P n` | 标准 Tor 对象同构于实际 `residueTensorFunctor.mapHomologicalComplex` 作用于 P 后的 n 次同调 |
| `idealQuotientTorIsoResidueTensor I P hzero n` | 标准 Tor 对象与 `residueTensorFunctor.obj (P.complex.X n)` 的 A 模同构 |
| `idealQuotientTorEquivResidueTensor I P hzero n` | `IdealQuotientTorK I n` 到上述张量项沿 `algebraMap K A` 限制标量后的 K 线性等价 |
| `idealQuotientTor_isZero_of_resolution_isZero I P hzero n hX` | 给定 `hX : IsZero (P.complex.X n)`，得到 `IsZero (IdealQuotientTor I n)` |

共同输入为 `I : Ideal (MvPolynomial (Fin 3) K)`、实际 `P : ProjectiveResolution (ModuleCat.of A (A ⧸ I))`。`hzero : ∀ i j, (residueTensorFunctor (K := K)).map (P.complex.d i j) = 0`，即所有下标的实际残差微分为零。没有有限生成、自由、有限维或数值维数假设；特别 n=0 也包含在内。

K 等价的目标精确为：

```lean
(ModuleCat.restrictScalars (algebraMap K (MvPolynomial (Fin 3) K))).obj
  ((residueTensorFunctor (K := K)).obj (P.complex.X n))
```

与 R080 的 `ResidueTensorK (P.complex.X n)` 定义相同；本模块不依赖 R080，所以两个支持子项可独立编译。根可用此等价将 R080 真实张量项的有限性和维数传给标准 Tor。

实现使用固定 mathlib 4.22.0 的 `P.isoLeftDerivedObj` 及 `ShortComplex.HomologyData.ofZeros`。通用辅助 `WidthBounds.homologyIsoTermOfZeroDifferentials L hzero n` 从实际同调对象到复形项给出同构；不构造替代 Tor 定义。

## 证明链与边界

任意带零态射范畴的实际同调复形 L，给定全部微分零及 n 次存在同调，`(L.sc n)` 的左右微分均为零，故库的 `HomologyData.ofZeros` 给出 `L.homology n ≅ L.X n`。这一辅助无额外 Abelianness 假设。

Tor 比较先用实际 P 的标准 `P.isoLeftDerivedObj`，再对实际张量复形套上同调同构。K 线性等价由这一 A 模同构经过 `restrictScalars.mapIso` 后取 `toLinearEquiv`；没有把已知答案上的 K 作用人为转移到 Tor。零对象结论由保零函子对实际零项的 `map_isZero`，沿上述同构传回标准 Tor。结论比 finrank=0 强，未借无限维对象也可能 finrank=0 的数值漏洞。

本模块只完成通用比较合同。具体 lex 分解的存在、各秩和所有残差零由 R057 提供；真实 K 有限性和秩公式由 R080 提供；具体 Tor2/Tor3 维数及宽度界由根 R058 集成。未计算 lex 宽度界、未交换 Tor 因子、未形式化完整半群比较或 graded shifts，也不声称新颖性。

## 局部验证

在 `lean/` 固定 `leanprover/lean4:v4.22.0` 下运行 `lake env lean WidthBounds/MinimalResolutionTor.lean`，退出 0，无 error/warning。源码末尾五个关键声明 `#print axioms` 均仅输出 `[propext, Classical.choice, Quot.sound]`：通用同调零微分比较、标准 Tor 到实际同调、标准 Tor 到张量项、K 线性等价、标准 Tor 零对象结论。

随后 `lake build WidthBounds.MinimalResolutionTor` 退出 0，返回 `Built WidthBounds.MinimalResolutionTor` 和 `Build completed successfully.`，已生成可供根导入的 `.lake/build/lib/lean/WidthBounds/MinimalResolutionTor.olean`。该模块输出无 error/warning，五项公理输出仍为上述标准三项。未创建独占范围外的新日志，根须重新纳入统一构建日志和 claims，不能把旧 R057 日志当作本源码证据。

源码禁止项搜索 `\bsorry\b|\badmit\b|\baxiom\b|native_decide` 无命中。当前源码 SHA-256：`5f3f883bcb2a188698aecdaee61164759855c375485e9fc9a82f9cec0b1ce3aa`。只使用库已有标准逻辑公理，无自定义公理、占位证明或 `native_decide`。

启动已按协议读取 STATE、HANDOFF、queue、AGENTS。根 `.venv` 执行 checkpoint `--check` 合法，`--verify-latest` 归档完整，工作区变化为当前 R058 队列及新文件正常增量。根负责最终统一日志、claims、STATE/HANDOFF/queue 与 checkpoint。

## 停止与集成

执行者不再编辑源码；根在 `HigherTorBounds.lean` 导入本文件，以 `idealQuotientTorEquivResidueTensor` 接 R080 的 `residueTensor_free_finite` / `finrank_residueTensor_free`，并用 `idealQuotientTor_isZero_of_resolution_isZero` 接实际 P 的零尾项。该比较的构造、对象顺序、K 标量来源和所有次数范围已完成，不需要重新构造 R057 的分解。

# R072 边界相邻关系

状态：已完成分工内全部边界几何接口，Lean 局部编译通过。用户授权 R056 的内部子项；独占 BoundarySyzygies.lean 和本报告；不派生，不实现 d3。实际相邻关系列、模生成性强归纳及 d2 由主智能体在 MonomialFirstSyzygies.lean 集成，本文件不重复定义。

计划：定义精确指标 `Fin a ⊕ ((Σ i : Fin a, Fin (n i)) × Fin 2)`，其基数为 `a + 2 * sum n`；定义显式规范边界除子（先 pure x，再 xy 边界，再 z 阈值），证明实际 ideal membership 下的边界成员性和整除性。构造每个相邻关系的源、公共次数、目标，并证明目标在 x/y 方向前进。随后提供全部公共倍数关系的归一化接口供主智能体整合实际 d2。

规范除子按实际坐标显式分支，不能使用不受控制的任意选择。核生成性不可作为定义或假设；最终由 R071 通用共同倍数关系准则与有限递降约化结合。

恢复检查：checkpoint --check 通过；--verify-latest 的归档字节有效，工作区改变为本轮 queue 和 R056 报告，属于正常后续修改。固定 Lean/mathlib 4.22.0。

## 已编译的接口

命名空间 `WidthBounds.MonomialPresentation`。系数 `K : Type*`、`[Field K]`；实际 `I : Ideal (MvPolynomial (Fin 3) K)`，未固定特征或有限域。

- `BoundaryRelationIndex a n`：`Fin a ⊕ ((Σ i : Fin a, Fin (n i)) × Fin 2)`；左支 xy 边界的 x 关系，右支每个 z 阈值的 x/y 关系。
- `card_boundaryRelationIndex`：实际 Fintype 基数严格等于 `a + 2 * ∑ i ∈ range a, n i`，没有预算假设。
- `canonicalBoundaryExponent`：若 `a ≤ d 0`，选 `(a,0,0)`；否则若 `n(d 0) ≤ d 1`，选 `(d 0,n(d 0),0)`；否则选 `(d 0,d 1,zThreshold(d 0,d 1))`。完全显式，非随机选择。
- `canonicalBoundaryExponent_mem`：任意 `d` 的该规范指数均属于边界集合；该声明不需要 `monomial d 1 ∈ I`。
- `canonicalBoundaryExponent_le`：实际 `monomial d 1 ∈ I` 时规范指数整除 `d`。z 分支调用实际 `zThreshold_le`，并非把所需整除条件新增为假设。
- `canonicalBoundary`：将上述指数及成员性封装为 `E=boundaryExponents I hZ a n` 的元素。
- `boundaryRelationSource`、`boundaryRelationDegree`、`boundaryRelationTarget`：源分别为 xy 边界或 z 阈值，公共次数由 x/y 乘法取得，目标为公共次数的显式规范边界除子。
- `boundaryRelationSource_le_degree`：源整除公共次数，无 lex/标准列假设。
- `boundaryRelationDegree_mem`、`boundaryRelationTarget_le_degree`：参数顺序 `I hZ a n hx hn s`；从边界实际属于 `I` 及 ideal 的乘法闭包得到次数属于 `I` 和目标整除次数。
- `canonicalBoundaryExponent_zero`：`d 0 ≤ a` 时规范指数的 x 坐标等于 `d 0`。
- `canonicalBoundaryExponent_one`：`d 0 < a` 且 `d 1 ≤ n(d 0)` 时规范指数的 y 坐标等于 `d 1`。
- `boundary_coordinates_le`：使用 `hLex hn hInitial`，实际边界坐标满足 `u 0 ≤ a` 和 `u 1 ≤ n 0`。`n i ≤ n 0` 从既有真实 lex 列严格递减得到。
- `boundaryHeight a n e = (a-e 0)*(n 0+1)+(n 0-e 1)`；另证 x/y 前进一步时的严格下降算术引理。
- `boundaryRelationTarget_forward`：每个相邻目标的 x 坐标恰为源 x+1，或 x 保持且 y 恰为源 y+1。无需 lex 假设；依赖明确规范除子的坐标分支。
- `boundaryRelationTarget_height_lt`：参数 `I hZ a n hLex hn hInitial s`，每个有限相邻步骤严格降低上述自然数高度。
- `exists_boundary_step`：参数 `I hZ a n d u hud hne`；若 `u.val ≤ d` 且 `u ≠ canonicalBoundary ... d`，则存在有限指标 `s`，满足 `boundaryRelationSource ... s = u` 且 `boundaryRelationDegree ... s ≤ d`。不需要另加理想成员或 lex 假设。

## 归一化依据与语义边界

`exists_boundary_step` 对边界三种类型分别证明：pure x 在任意共同倍数上已规范；xy 边界若 x 坐标已等于共同倍数则已规范，否则走 x；z 阈值若 x 尚未达到共同倍数则走 x，否则在 y 尚未达到时走 y，否则已规范。所有步骤仍整除原共同倍数。

配合目标整除次数及自然数高度严格递降，主智能体可以对高度作强归纳：把任意共同次数中的边界项沿有限相邻关系归一化到唯一指定的规范项，再对两个原项相减。完整核生成性需要 R071 的通用共同倍数关系准则；本文件仅提供严格的组合几何归约接口，不冒称单独完成核生成性、关系模自由、极小 d2、d3 或高阶 Tor。

这里 `hZ` 是真实纯 z 幂属于理想的存在性，`hx` 为真实 pure x 边界成员性，`hn` 是完整 xy 标准列刻画，`hInitial` 是 a 前所有 pure x 标准性，`hLex` 是真实理想的同次数 lex 闭包。没有假设待证的相邻关系全核生成性。

## 编译与证据

最终命令 `lake build WidthBounds.BoundarySyzygies`（项目 `lean/` 下，固定工具链）于 2026-09-30 退出 0；末行 `Build completed successfully.`，本模块无 warning/error。已生成 `.lake/build/lib/lean/WidthBounds/BoundarySyzygies.olean`。未运行全根构建；统一新日志由主智能体生成。

六个关键声明的 `#print axioms` 均只输出 `[propext, Classical.choice, Quot.sound]`：`card_boundaryRelationIndex`、`canonicalBoundaryExponent_le`、`boundaryRelationTarget_le_degree`、`boundaryRelationTarget_forward`、`boundaryRelationTarget_height_lt`、`exists_boundary_step`。源码扫描未发现 `sorry`、`admit`、自定义 `axiom` 或 `native_decide`。

源码 SHA-256：`1d3b5eeeb57aefcec18c414baf89f81fc856e5e870ebd736f0587299c6b728ce`。

实现时修复均为 Lean 表达式精化问题：`split_ifs` 后 `simp` 已关闭自反分支，无需额外 `rfl`；目标坐标表达式须显式给出指数参数并通过 `exponent_zero/exponent_one` 化简，不能仅靠定义相等。未改数学假设或弱化目标。

停止条件已满足，当前文件冻结并交由主智能体集成。STATE/HANDOFF/queue/claims/checkpoint 依分工由主智能体更新；本子智能体不修改这些文件。

# R077：四项实际复形的标准分解打包器

日期：2026-09-30。状态：局部 Lean 编译与 `lake build WidthBounds.FiniteThreeResolution` 已通过，执行者停止写入，等待主智能体将已证明的具体 lex 数据代入并统一验收。

独占交付为 `lean/WidthBounds/FiniteThreeResolution.lean` 和本报告；未修改根 import、队列、状态、依赖或其他源码。未派生子智能体，未启动 R058。

## 范围与结论等级

这是一个**Lean 已编译的条件构造器**：在给定三个实际微分的复合为零、三处实际正合与末微分单射后，构造标准 mathlib `ProjectiveResolution (ModuleCat.of A (A ⧸ I))`。这些假设在本模块中没有被当作 lex 定理自动证明；具体 lex face、核像等式、单射和残差系数证明仍由 R057 主文件提供。不存在 Tor 平衡假设、Tor 维数结论或新颖性声称。

数学对象为

`0 → F₃ --d₃→ F₂ --d₂→ F₁ --d₁→ A --idealQuotientMap I→ A/I → 0`。

前三项仅有投射性时得到有限长度投射分解；额外给定前三项的 `Module.Free A` 与 `Module.Finite A` 实例时，所有次数逐项具有自由性与有限生成性。没有把有限长度、有限生成和有限维混为一谈。

## 构造器精确参数

命名空间 `WidthBounds.FiniteThreeResolution`。`A : Type u`、`[CommRing A]`，所有 `Fᵢ : ModuleCat A`。

```lean
resolution F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂ hex₁ hex₂ I h₁₀ hex₀
```

各显式参数按如下顺序传入：

1. `F₁ F₂ F₃`。
2. `d₁ : F₁ ⟶ ModuleCat.of A A`、`d₂ : F₂ ⟶ F₁`、`d₃ : F₃ ⟶ F₂`。
3. `h₂₁ : d₂ ≫ d₁ = 0`、`h₃₂ : d₃ ≫ d₂ = 0`。
4. `hex₁ : (ShortComplex.mk d₂ d₁ h₂₁).Exact`、`hex₂ : (ShortComplex.mk d₃ d₂ h₃₂).Exact`。
5. `I : Ideal A`。
6. `h₁₀ : d₁ ≫ WidthBounds.idealQuotientMap I = 0`。
7. `hex₀ : (ShortComplex.mk d₁ (WidthBounds.idealQuotientMap I) h₁₀).Exact`。

还需要类型类 `[Projective F₁] [Projective F₂] [Projective F₃] [Mono d₃]`。其中 `[Mono d₃]` 位于 `hex₂` 后、`I` 前的隐式类型类参数位置。理想商映射的 `Epi` 由库提供，没有另加假设。

复形的 0、1、2、3 次对象定义上分别为 `ModuleCat.of A A`、`F₁`、`F₂`、`F₃`；所有 `n + 4` 次对象定义上就是范畴所选的 `0 : ModuleCat A`。相邻微分定义族为 `d₁,d₂,d₃,0,0,...`，由 `ChainComplex.of` 打包。

## 稳定接口

| 对象 | 接口 |
| --- | --- |
| 复形 | `complex F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂` |
| 复形各项 | `complex_X_zero`, `complex_X_one`, `complex_X_two`, `complex_X_three`, `complex_X_zero_tail` |
| 相邻微分 | `complex_d_succ`；具体 `complex_d_one_zero`, `complex_d_two_one`, `complex_d_three_two` |
| 正次数正合 | `complex_exactAt_succ ... hex₁ hex₂ n`，不需要投射性实例，只需要上述两个正合假设与 `[Mono d₃]` |
| 逐项投射性 | `complex_projective` 实例；标准 `ProjectiveResolution` 也自带逐项投射性 |
| 逐项自由性 | `complex_free`、`resolution_free` 实例，需要 `[Module.Free A F₁/F₂/F₃]` |
| 逐项有限生成性 | `complex_finite`、`resolution_finite` 实例，需要 `[Module.Finite A F₁/F₂/F₃]` |
| 分解各项 | `resolution_X_zero`, `resolution_X_one`, `resolution_X_two`, `resolution_X_three`, `resolution_X_zero_tail` |
| 标准零尾项 | `resolution_X_isZero_tail ... n : IsZero (P.complex.X (n + 4))` |
| 分解微分 | `resolution_d_one_zero`, `resolution_d_two_one`, `resolution_d_three_two` |
| 实际增广 | `resolution_π_f_zero ... : P.π.f 0 = WidthBounds.idealQuotientMap I` |

`resolution_` 接口一般先传与 `resolution` 完全相同的十三个显式参数；有次数参数时再传 `n`。各项和三个微分的等式接口带 `[simp]`。零尾项自由/有限实例先由 `ModuleCat.subsingleton_of_isZero (isZero_zero _)` 获得底层模块 `Subsingleton`，再调用库的实例，未以 `finrank = 0` 替代零对象。

## 函子映射微分为零

假设 `{D : Type*} [Category D] [HasZeroMorphisms D]`、`F : ModuleCat A ⥤ D`、`[F.PreservesZeroMorphisms]`，并给定：

```lean
hd₁ : F.map d₁ = 0
hd₂ : F.map d₂ = 0
hd₃ : F.map d₃ = 0
```

可调用：

```lean
map_maps_eq_zero F₁ F₂ F₃ d₁ d₂ d₃ F hd₁ hd₂ hd₃ n

map_complex_d_eq_zero F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂
  F hd₁ hd₂ hd₃ i j

map_resolution_d_eq_zero F₁ F₂ F₃ d₁ d₂ d₃ h₂₁ h₃₂
  hex₁ hex₂ I h₁₀ hex₀ F hd₁ hd₂ hd₃ i j
```

最后两个结论覆盖任意 `i j : ℕ`，不只相邻或正次数。证明在 `i = j + 1` 时逐项使用给定三式或保零性，在其他下标用 `ChainComplex.of_d_ne`。这里只要求保零；预加性范畴间的 additive 函子会由 mathlib 自动提供该实例。因此主智能体可直接代入实际 `residueTensorFunctor` 及其已证明的三个零式。

## 证明核验

续接了主智能体给出的原 WIP。修复了 `ShortComplex.exact_iff_mono` 的两个目标处理顺序；随后补入稳定接口时，明确写出了 `toSingle₀Equiv_symm_apply_f_zero` 的复形参数，避免新增 simp 引理影响增广证明的推断。

正次数 1、2 的正合来自 `hex₁`、`hex₂`；次数 3 由进入 `F₃` 的零映射和 `Mono d₃`；次数 ≥4 的中项为零对象。0 次准同构由实际商增广的正合及商映射满射得到。输出确为 mathlib 标准 `ProjectiveResolution`。

验证命令均在固定 Lean/mathlib 4.22.0 的 `lean/` 目录执行：

```text
lake env lean WidthBounds/FiniteThreeResolution.lean
lake build WidthBounds.FiniteThreeResolution
```

二者退出码均为 0，最终源码无 error/warning；最终 build 返回 `Built WidthBounds.FiniteThreeResolution` 和 `Build completed successfully.`，生成 `.lake/build/lib/lean/WidthBounds/FiniteThreeResolution.olean`。

另外通过 `lake env lean --stdin` 对以下八个真实接口执行 `#check`，退出码 0：`resolution`、`map_maps_eq_zero`、`map_complex_d_eq_zero`、`map_resolution_d_eq_zero`、`resolution_free`、`resolution_finite`、`resolution_X_isZero_tail`、`resolution_π_f_zero`。本报告的参数顺序来自该实际输出。

源码末尾六项 `#print axioms`：`complex_exactAt_succ`、`resolution`、`resolution_π_f_zero`、`map_resolution_d_eq_zero`、`resolution_free`、`resolution_finite`，全部仅输出 `[propext, Classical.choice, Quot.sound]`。源码禁止项搜索无命中，没有 `sorry`、`admit`、自定义公理或 `native_decide`。

最终源码 SHA-256：`f75552a79464e92a94f06c967813790fc218fa1c20a3f66a0b8289457ba47a30`。没有创建独占范围外的独立日志文件；上述局部构建由工具返回，主智能体仍须将该版本纳入统一日志和 claims。

启动时已运行根 `.venv\Scripts\python.exe -X utf8 -B scripts/checkpoint.py --check` 和 `--verify-latest`；队列合法，最新归档完整，报告中的工作区增量属于正常 R057 新文件/队列变化。主智能体负责最终 STATE/HANDOFF/queue/claims 与稳定 checkpoint；执行者不修改这些根拥有文件。

## 下一步与停止边界

主智能体将实际 `d₃`、`h₃₂`、`hex₂`、`Mono d₃` 与已有 `d₁/d₂` 呈示代入；对实际三个有限函数模块提供自由/有限实例；将实际残差三个零式代入 `map_resolution_d_eq_zero`。本任务完成后停止，不计算高阶 Tor、不扩展 R058，也不以此条件构造器单独宣称具体 lex 分解已完成。

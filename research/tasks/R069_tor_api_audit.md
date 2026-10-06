# R069：固定库标准 Tor 比较与直接分解接口审计

2026-09-30。执行者 `tor_api_audit`；支持 R054。独占本报告、`research/probes/R054_tor_api.lean`、`results/r054_tor_api_probe.txt`。状态：**接口审计完成；局部探针已编译；未证明真实 lex 商的 Tor2/Tor3 或高阶消失。**

## 范围、恢复与结论

已读取 STATE/HANDOFF/queue、AGENTS、NEXT_STAGE_PLAN、R053，以及 TorOneBridge、ChosenResolution、DerivedKernel、IdealExactSequence 和 GeneratorExact 的相关入口。根 `.venv` 执行 checkpoint `--check` 通过；`--verify-latest` 返回 `archive_valid=true`，当前 R054 工作区修改与原归档完整性分开。先落盘 WIP 计划后继续调查。本任务不修改依赖、主 import、状态或旧交付，不派生、不外搜、不构建全库、不下载缓存、不实现 R055。

**推荐直接解析现有 Tor 的第二因子 A/I。** 固定库已经提供给定 `ProjectiveResolution (A/I)` 计算全部标准 Tor 次数的同构；主要剩余数学负担是构造实际有限最小自由分解。残差 Koszul 路线还需要特定的平衡/比较证明。库中存在相关底层工具，不能说该路线从零起步；但本次未找到能直接消除比较缺口的成品 API。

这个推荐是基于固定版本与当前项目入口的实现风险选择，不是工作量定理。尤其不能断言 Koszul 必须先完成一般自然 Tor 平衡定理：只证明本项目有限三变量所需的比较也可能够用，只是仍有实质新同调工作。

首个有限入口可定为真实有限自由呈示 `A^E → A → A/I → 0` 及实际 syzygy 核，尚不承诺在该项内完成整个分解。详细合同在下文。

## 搜索范围与不存在结论的强度

搜索根固定为 `lean/.lake/packages/mathlib/Mathlib`，版本由 `lean-toolchain` 与 `lakefile.toml` 固定为 4.22.0。使用 `rg` 全树搜索，再逐个读命中源码的定义、上下文和假设。主要搜索族：

- `Tor`、`Tor'`、`leftDerived`、`dimension.shifting`、`delta.functor`；
- total/bicomplex 与 exact/quasiIso、spectral sequence；
- projective resolution/lift/homotopy、finite projective/free resolution、projective dimension、horseshoe；
- mappingCone 与 exact/quasiIso/projective；
- tensor/flat 与 exact、complex、derived；
- Eliahou、Kervaire、linear quotient、strongly stable、Taylor resolution、Scarf、syzygy，并定向查看单项式相关目录。

标准 Tor 内容命中 `CategoryTheory/Monoidal/Tor.lean`；另一实质命中 `RepresentationTheory/Homological/GroupHomology/Basic.lean` 定义的是 `Rep.Tor`，从群表示 coinvariants tensor 派生，并仍按给定第二因子分解计算，不是可直接套用到当前 ModuleCat Tor 的平衡定理。`RingTheory/Flat/CategoryTheory.lean` 对 Tor 的命中是 TODO。

对 `leftDerived` 的全库文件命中除该定义及 Tor 外，还有旧 Ext、群同调，以及 `CategoryTheory/Functor/Derived` 的 Kan-extension/局部化一般派生函子。后者不是已与当前 `Functor.leftDerived n` 接通的维数移位或 Tor 平衡接口。未命中标准 Tor 长正合/维数移位定理、有限 lex/EK/linear-quotients/Taylor/Scarf 分解实现或 horseshoe 实现。

这些是**搜索范围内未找到可用接口**，不是证明任何等价能力在全库逻辑上不可能组合。没有把 Tor 文件的 TODO 注释当作唯一证据。

## 实际可用接口及准确边界

以下 mathlib 路径均相对于 `lean/.lake/packages/mathlib/Mathlib/`。

| 接口与源码 | 实际假设/输出 | 对当前问题的作用和边界 |
|---|---|---|
| `CategoryTheory.Tor`、`Tor'`；`CategoryTheory/Monoidal/Tor.lean:40,46` | 在有投射分解的加性阿贝尔幺半范畴中，分别派生第二、第一因子 | 现有对象 Tor(A/m,A/I) 的第二因子是 A/I；普通张量交换不会自动交换派生方向 |
| `isZero_Tor_succ_of_projective`；同文件:58 | `[Projective Y]` 推出 Tor(X,Y) 在 n+1 为零 | 项目需要 A/I 的实际分解；不能因第一因子有有限自由分解就直接套此定理 |
| `isZero_Tor'_succ_of_projective`；同文件:63 | `[Projective X]`，对应 Tor' | 不等于标准 Tor 消失 |
| `ProjectiveResolution`；`CategoryTheory/Preadditive/Projective/Resolution.lean:37` | ℕ-链复形、逐项投射、到 single₀ X 的链映射、准同构 | 构造有限分解时须在高次数填零并证明增广准同构；结构不自带有限秩或最小性 |
| `ProjectiveResolution.lift/lift_commutes/liftHomotopy/homotopyEquiv`；`CategoryTheory/Abelian/Projective/Resolution.lean:86,93,155,173` | 对象间映射可提升；同一对象两分解同伦等价 | 已解决同一 A/I 的分解无关性；不比较 A/m 的分解与 A/I 的分解 |
| `ProjectiveResolution.isoLeftDerivedObj`；`CategoryTheory/Abelian/LeftDerived.lean:106` | `[Abelian C] [HasProjectiveResolutions C] [Abelian D] [F.Additive]`，给定 P 和任意 n | `(F.leftDerived n).obj X ≅ H_n(F(P.complex))`；无额外正合函子假设，这是直接路线的确定接口 |
| `isoLeftDerivedObj_hom_naturality`；同文件:116 | 给定链提升且度0与增广交换 | 后续可证明新同构与既有 Tor1 比较一致，不能只比较两边维数 |
| `NatTrans.leftDerived`；同文件:205 | 同一源类的两个加性函子间自然变换 | 可运输固定变量函子的同构；没有把不同变量上的两次派生变成同一次派生 |
| `Functor.leftDerivedZeroIsoSelf`；同文件:340 | 加性且保持有限余极限 | `L₀F ≅ F`；残差张量已有右正合实例。它本身不证明 `(A/m)⊗(A/I) ≅ K`，后者仍用 I≤m |
| `Functor.mapProjectiveResolution`；`CategoryTheory/Preadditive/Projective/Resolution.lean:145` | 同时要求 `F.PreservesProjectiveObjects` 与 `F.PreservesHomology` | 任意残差张量不满足所需保持同调假设；不能用此接口偷过非平坦张量的高阶同调 |
| `ModuleCat` 与 module-projective 相互实例；`Algebra/Category/ModuleCat/Projective.lean:23,29` | 从模块投射到范畴投射；反向要求合适 Small | 可将自由项接到标准 ProjectiveResolution，注意与 Flat 的 projective 类属于不同命名空间 |
| `Module.Flat.of_projective`；`RingTheory/Flat/Basic.lean:225` | 模块论 `[Module.Projective R M]` | 投射项平坦，可为双分解/维数移位方案提供逐项张量正合 |
| `Module.Flat.lTensor_exact/rTensor_exact`；同文件:357,374 | 固定张量因子平坦、原线性映射序列 exact | 实际线性映射正合，不自动是 Tor 消失或派生平衡 |
| `Module.Flat.lTensor_shortComplex_exact/rTensor_shortComplex_exact`；`RingTheory/Flat/CategoryTheory.lean:39,44` | `R` 交换环、`M : ModuleCat.{u} R` 平坦、给定 `C.Exact` | 给出张量短复形 exact；该文件仍未包装成平坦张量保持有限极限/同调的完整实例 |
| `HomologicalComplex₂`、`total`；`Algebra/Homology/HomologicalBicomplex.lean:34`、`TotalComplex.lean:250` | 双复形、total shape、适当余积 `HasTotal` | 构造总复形；没有在这些文件中提供从行列准同构推出 total 准同构的比较定理 |
| `HomologicalComplex₂.totalFlipIso`；`TotalComplexSymmetry.lean:104` | 两种 total shape、对称符号兼容及 HasTotal | 交换同一个双复形的两方向；不证明 total 到两种张量分解的增广准同构 |
| `HomologicalComplex.tensorObj`；`Algebra/Homology/Monoidal.lean:44` | 加性幺半结构、tensor signs 与 `HasTensor` | ℕ链复形张量积已定义；不能据此断言保持准同构 |
| `mapBifunctorFlipIso`、`mapBifunctorMapHomotopy₁`；`BifunctorFlip.lean:44`、`BifunctorHomotopy.lean:151` | 双函子及总复形符号/存在性；后者输入一个给定同伦 | 翻转张量/双函子复形、把已知同伦送到张量后；不是“准同构在平坦复形张量下保持”定理 |
| `CategoryTheory.ShortComplex.ShortExact.δIso`；`Algebra/Homology/HomologySequence.lean:349` | 真实链复形的短正合 S，相邻 i,j，中央复形两个相邻同调为零 | 得到 `H_i(S.X₃) ≅ H_j(S.X₁)`，是具体维数移位积木；尚需构造张量后的短正合复形并与标准 Tor 接通 |
| `CochainComplex.mappingCone`；`HomotopyCategory/MappingCone.lean:52` | ℤ 上链复形链映射及双积 | 有映射锥构造；直接用于 ℕ链的 ProjectiveResolution 需要重编号/截断和正合证明 |
| `CochainComplex.mappingCone.quasiIso_descShortComplex`；`HomotopyCategory/ShortExact.lean:114` | 给定 ℤ上链复形短正合 S | `cone(S.f) → S.X₃` 为准同构；并非从两个模分解与一个模态射自动生成商模的有限自由分解 |
| `HasProjectiveDimensionLT`、`ShortExact.hasProjectiveDimensionLT_X₃_iff`；`CategoryTheory/Abelian/Projective/Dimension.lean:35,186` | 前者定义为全部高阶 derived-category Ext 消失；后者给定短正合且中央对象投射 | 有投射维数的 Ext 界与维数移位性质，但没有自动给出特定长度、秩、最小性的分解，也未接到当前标准 Tor |

### 已有项目接口

- `TorOneBridge.lean` 的 `residueTensorFunctor` 正是固定第一因子的标准张量函子；`IdealQuotientTorOne` 只命名标准 Tor1。
- `ChosenResolution.resolution` 从指定投射 epi 开始不断任意覆盖 kernel；`isoLeftDerivedObj` 支持任意 n，但后续项不保证有限自由、不保证长度3或微分落在 m 中。
- `DerivedKernel.isoLeftDerivedOne` 只给第一派生对象，假设具体 kernel inclusion 在右正合加性函子下为零。不能把此条件在新 syzygy 层默认为成立。
- `IdealExactSequence.idealQuotientKernelIso` 已把真实理想 I 与 quotient map 的范畴 kernel 接通；这是下一步呈示的兼容目标。
- `GeneratorExact.span_boundary_exponentMonomials`（:140）给真实 span=I；`finiteColength_exists_exact_minimal_generators`（:192）提供 E、全部极小指数分类、真实生成性质及 `#E=a+1+ell`。已有呈示数据足够开始 R055，不需要重新枚举研究样本。

## 两条路线的比较

### 路线一：解析残差第一因子，再与标准 Tor 比较

即使三变量 Koszul 残差分解已经建好，标准 `isoLeftDerivedObj` 首先计算的是派生第一因子的 Tor'，或把参数交换后的标准 Tor；仍不等于当前标准 `Tor(A/m,A/I)`。

已搜索到的可行候选方案包括：

1. 取 Q→A/I 的标准投射分解，与有限残差 Koszul 分解 P 建双复形；利用 Q 项和平坦 P 项保持正合，证明总复形到 `(A/m)⊗Q` 与 `P⊗(A/I)` 的两个增广是准同构，再取同调。
2. 使用 P 的有限 syzygy 短正合列；Q 每项投射从而平坦，逐项张量得到短正合复形；以 `δIso` 和有限归纳建立所需的特定比较或端点计算。

方案1的“双复形构造/翻转”已有，但两增广准同构没有直接检出的现成接口。方案2的短正合长同调序列已有，但标准 Tor 的相应维数移位、特定 syzygy 比较及 H0 附近接口仍需新证明。两者都不要求逻辑上先构造最一般的 Tor 平衡自然同构，却也不是普通 tensor comm 加一次 simp 能完成的工作。

因此若选择该路线，R055 与 R056 至少各有一个实质接口关口：真实 Koszul 分解正合性；标准派生方向比较。应分别有退出点，不能把任意分解存在性或双复形 flip 当作第二关已经解决。

### 路线二：直接解析第二因子 A/I

给定真实 `P : ProjectiveResolution (ModuleCat.of A (A/I))` 后，取 `F = residueTensorFunctor`，`P.isoLeftDerivedObj F n` 就给全部 n 的现有标准 Tor 同构。因子顺序、A 标量与标准对象均不改变。沿真实 algebraMap K A（K→A）限制标量，并使用已有相容性接口得到K线性化；同构本身不能替代有限维性证明。

可选代数构造是三变量 lex 的显式有限最小自由分解，或通过稳定性/线性 quotients 逐个生成元建立 mapping-cone 分解。本次未找到 lex/EK/linear-quotients 成品接口。若采用后一种构造，还需生成元排序、colon 理想描述、加入生成元短正合、链提升与最小性；映射锥工具并不自动完成这些。没有证据支持“这条路线已几乎完成”。

直接路线的优势是缺口集中在真实分解：一旦能给 `F₀=A`、`F₁=A^(a+1+ell)`、`F₂=A^(a+2ell)`、`F₃=A^ell`、高次数零、真实正合和全部非增广微分模 m 为零，则 tensor 后同调直接识别为相应自由项的残差化。这些秩与正合性必须实际证明，不能从目标公式反向作为分解字段假设。

因此推荐这条路线作为下一轮的有限尝试；**不并行建立完整 Koszul 平衡理论**。如果显式 syzygy 生成/正合性成为持续障碍，应带已验收呈示与具体失败记录回到选路，而非无限扩大 R055。

## 建议下一有限合同（R055 尚未执行）

建议根把原 R055“完整 Koszul 残差分解”改为**实际 lex 商的有限自由呈示与 syzygy 入口**，文件路径由根重新登记。本合同只描述将来授权后的实现。

输入：任意域 K；A=`MvPolynomial (Fin 3) K`；真实 I=`monomialIdeal S`；上集/lex/真实有限余长和 x 标准等既有假设。先抽出一般有限生成接口：有限 E、`g(e)=monomial e 1`、`Ideal.span (Set.range g)=I`，然后用既有边界生成定理实例化。预算只在需要既有 `#E=a+1+ell` 推论时保留，不给纯呈示强加无关预算。

精确输出：

1. 实际 A-线性 `d₁ : (E → A) →ₗ[A] A`，在标准基上等于 g(e)，以及度0增广为现有 `idealQuotientMap I`。
2. 证明 `LinearMap.range d₁ = I`（I 视为 A-子模）；于是实际 `A^E → A → A/I → 0` 在 A 与 A/I 处正合。
3. 将 `d₁` 限制到 I 的映射证明满射，并通过已有 `idealQuotientKernelIso` 给出与范畴 kernel 的交换图；不能只构造同维抽象对象。
4. 逐项自由/投射与有限秩实例，E 的真实 cardinality 接回已有 `a+1+ell`（在该现有结论的假设下）。
5. 定义真实第一 syzygy 模 `ker d₁` 与其包含映射，给出对应的范畴 kernel 同构，供下轮 d₂ 的目标使用；可证明 `d₁` 的残差张量为零，但**不把 ker d₁ 的秩或其包含映射模 m 为零当作已知**。

验收：独立新文件局部编译、无禁用占位/自定义公理、精确 standard objects、与旧 quotient kernel 的交换性；不修改旧证明或覆盖冻结证据。本项不交 `ProjectiveResolution`，不交 Tor2/Tor3，不宣称长度或最小性。停止点是上述有限呈示完成并报告；下一项应明确研究哪组实际 syzygy 生成元及其生成性，而非自动接任意投射覆盖后称有限分解。

若发生两次实质尝试仍无法新增可核验的范围/核兼容接口，应保存已经得到的有限引理和具体 Lean 障碍回到 R054 决策，不引入“存在所需有限分解”假设来填空。

## 局部编译证据与缓存边界

探针：`research/probes/R054_tor_api.lean`；日志：`results/r054_tor_api_probe.txt`。命令在 `lean/` 执行：

```text
lake env lean ../research/probes/R054_tor_api.lean
```

通过根 `.venv` 的 Python subprocess 捕获 UTF-8 输出。**最终退出码0**。探针核对15项标准/项目 API，并包含三个完整小实例：

- `torWithRingIsZero`：第二因子是自由秩1的 A，任意 n 的 Tor_(n+1)(A/m,A)=0；不是 A/I 的目标结论。
- `residueDerivedZeroIso`：既有残差张量的 L0 自然同构；不计算真实 quotient 的 H0 维数。
- `sameQuotientResolutionComparison`：同一 A/I 的两个给定分解同伦等价；不跨两因子。

三项 `#print axioms` 均只有 `propext, Classical.choice, Quot.sound`。第一次开发调用漏传 Tor 消失定理的显式范畴参数，修正后上述最终完整日志通过；最终源码无任何占位。根自己的 `R054_root_api.lean` 另独立编译了“给定第二因子分解直接计算全部标准 Tor”的条件接口，本报告未重复实现它，也不把给定分解当作已构造分解。

以下源码存在，但对应 `.olean` 在本地缓存中不存在，故本任务只读其源码、没有导入编译验证：`RingTheory.Flat.Basic/CategoryTheory`、`Algebra.Homology.TotalComplexSymmetry`、`Algebra.Homology.Monoidal`、`Algebra.Homology.HomologySequence`、`Algebra.Homology.HomotopyCategory.ShortExact`、`CategoryTheory.Abelian.Projective.Dimension`。它们是**可见库源码接口而非本地缓存即用证据**；缺 `.olean` 不等于缺数学 API。未下载、升级或触发这些模块构建。

R069 到此停止。由根维护 queue/claims/STATE/HANDOFF 与检查点；本报告不新增高阶数学 claim，不授权启动 R055 或后续任务。


## 对根 R054 最终合同的独立复核

已独立阅读 `research/tasks/R054_higher_tor_route.md` 的接口表、路线决定、R055精确合同及R056–R059改排。**接受；没有阻断问题。** 根合同明确禁止把 F1→A 称为单射/短正合，不假设实际 syzygy 核自由，不把高阶秩和有限分解当作现有成果；预算、I≤m、真实 K 作用、有限性与待启动边界均保留。后续 d2/d3 的生成性和正合成本被列为待证工作。

已向根提出两项局部措辞精度建议，不影响路线接受：

- Flat 表项应写“保持短复形的 Exact”；单个 `lTensor_shortComplex_exact` 不自带整个 ShortExact 的 Mono/Epi 字段。
- R055一般输入明确 E 是指数 Finset、其对应 monomial 族真实 span=I；若要适用任意多项式生成族，则先用一般 g:E→A 的线性组合，再作 monomial 特化。

本地验证的最终 SHA-256：

| 文件 | SHA-256 |
|---|---|
| `research/probes/R054_tor_api.lean` | `7d4a9154d457c08e706017ff8686799cd2efd7919fea86a0f6073f76fbb54ac2` |
| `results/r054_tor_api_probe.txt` | `305562747005f87ee173a984bea18d067b113a2ba57b02546aff3a15ccceb9c2` |

最终源码的 `sorry`/`admit`/`axiom`/`native_decide` 词级扫描无匹配。仅三项标准公理的实际输出见最终日志；扫描不是编译证据的替代。报告与本段复核到此冻结，不继续搜索、编译或实施下一任务。

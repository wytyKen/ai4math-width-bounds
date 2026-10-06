# R028：整除极小单项式生成元及精确计数

状态：R028整体完成。三类候选极小性、完整分类、同一真实生成集合的精确计数与逐项删除性质已集成并统一编译，R030独立语义审查接受。2026-09-23。

目标：在R025实际lex单项式理想、纯z幂/真实有限余长、初始纯x禁指数a条件下，形式化整除极小单项式生成元的有限集合，证明其数量恰为 `a+1+ell`。不直接宣称任意多项式生成系最少基数或Betti识别。

建议先读R025报告、R026报告E节，以及MinimalGenerators.lean、FiniteColength.lean。已有真实生成上界和严格choose界无需重做。

可验收分步：

1. 从StandardLex推出i<a时列长正，且相邻正列严格递减。
2. 标准xy指数的zThreshold严格为正；除z后标准，由lex条件再证明除x/y后标准。
3. 对实际单项式定义“在理想内且所有真单项式因子均不在理想内”，证明候选正好是这些整除极小单项式。
4. 分别证明三类参数化单射且互不相交，得到精确计数，并用既有整除三分法证明生成性。

独占建议文件：`lean/WidthBounds/GeneratorMinimality.lean`、本报告。现有MinimalGenerators.lean中的G是局部构造；优先在新模块定义可复用边界集合，并复用zThreshold及整除引理。如确需重构旧模块，先由根调整所有权，再重跑涉及的构建和更新旧证据哈希，不能让旧日志充当新版本证据。

验收：模块与统一构建成功、无禁止项；精确区分整除极小单项式计数、任意多项式生成数与Tor/Betti。标准逻辑公理照例记录。停止条件：完成一个明确可验收阶段，或两次实质尝试没有进展时记录具体障碍交根决策。R024仍可独立并行，但常态最多两个具体执行任务。

## A. 三类候选的泛型整除极小性（2026-09-23，generator_minimality）

本执行者仅编辑 `lean/WidthBounds/GeneratorMinimality.lean` 与本报告，没有改旧模块、根 import、依赖配置、队列、状态文件或冻结稿件。根线程在派发前已恢复状态并核对检查点。按照分工，没有派生子智能体。

### 精确类型与假设

全部结果位于 `WidthBounds.MonomialInterface` 命名空间，系数只要求 `[CommSemiring R]`，理想 `I : Ideal (MvPolynomial (Fin 3) R)` 为实际理想。核心引理不要求域、非平凡系数、指数上集、单项式生成性、Hilbert预算或宽度 `w`。

定义：

```lean
def IsMinimalExponent (I : Ideal (MvPolynomial (Fin 3) R))
    (e : Fin 3 →₀ ℕ) : Prop :=
  monomial e (1 : R) ∈ I ∧
    ∀ f, f ≤ e → monomial f (1 : R) ∈ I → f = e
```

这里 `f ≤ e` 是逐坐标不等式，对应系数一单项式的整除。定义要求每个在理想内的单项式因子都等于该单项式，而不只排除三个直接因子。

已编译的公开结果：

1. `isMinimalExponent_of_standard_predecessors I hm hX hY hZ`：若 `monomial3 i j k ∈ I`，并且每个正坐标减一所得直接因子标准，则 `IsMinimalExponent I (exponent i j k)`。证明对任意因子逐坐标比较；某坐标严格减小时，该因子整除对应直接因子，理想乘法闭包给矛盾。因此处理的是全部真因子。
2. `isMinimalExponent_pure_x I hx hInitial`：`hx : monomial3 a 0 0 ∈ I`，`hInitial : ∀ d, d < a → standard I d 0 0`，结论 `IsMinimalExponent I (exponent a 0 0)`。不要求 `a>0`；`a=0` 时无真单项式因子，证明仍有效。
3. `column_pos_of_initial I n hn hInitial hi`：`n : ℕ → ℕ`，`hn : ∀ i j, standard I i j 0 ↔ j < n i`，上述 `hInitial`，`hi : i < a`；结论 `0 < n i`。
4. `column_strictAnti_of_initial I hLex n hn hInitial hii' hi'`：`hLex : IsLex I`，`hii' : i < i'`，`hi' : i' < a`，其余同上；结论 `n i' < n i`。从标准的列顶 `x^(i') y^(n(i')-1)` 向 lex 更小的 `x^i y^(i'-i+n(i')-1)` 转移，再用精确柱长判据。这一版本直接处理任意两根有序正列，强于相邻列版本。
5. `isMinimalExponent_xy_boundary I hLex n hn hInitial hi`：精确柱长 `hn`、初始纯 x 标准条件、`i<a` 与 lex；结论 `IsMinimalExponent I (exponent i (n i) 0)`。边界成员性来自 `hn` 在 `j=n i` 的反面；除 y 后标准来自 `n i>0`；除 x 后标准来自严格递减。
6. `zThreshold_pos_of_standard I hZ hstd`：`hZ : ∃ b, monomial3 0 0 b ∈ I`，`hstd : standard I i j 0`；结论 `0 < zThreshold I hZ i j`。不需要 lex。
7. `standard_of_lt_zThreshold I hZ hk`：`hk : k < zThreshold I hZ i j`；结论 `standard I i j k`。来自已验收 `zThreshold_le` 的逆否。
8. `isMinimalExponent_zThreshold I hLex hZ hstd`：实际理想的 lex 条件、显式纯 z 幂成员与标准 xy 底面；结论 `IsMinimalExponent I (exponent i j (zThreshold I hZ i j))`。除 z 后标准来自阈值最小性；若除 x/y 后在理想，把一个 z 换成 x/y 的同次 lex 上闭包将迫使原柱 `t−1` 在理想，矛盾。

特别地，xy边界极小性无需额外的 `x^a∈I`，只需要 `i<a` 的正列保证；竖向边界极小性完全不需要有限横截面或初始次数。根集成时可直接传入现有 `columnLength` 的精确判据，但此文件不把全部宽度预算混入核心命题。

### 编译与审计证据

命令（工作目录 `D:\project\ai4math\lean`）：

```text
lake env lean WidthBounds/GeneratorMinimality.lean
```

首次编译退出码 `0`。使用项目既有固定 Lean/mathlib 4.22.0。五条导出审计 `#print axioms`：

```text
isMinimalExponent_pure_x
column_strictAnti_of_initial
isMinimalExponent_xy_boundary
zThreshold_pos_of_standard
isMinimalExponent_zThreshold
```

每条均仅列出 `[propext, Classical.choice, Quot.sound]`。源码静态搜索 `sorry|admit|native_decide|^axiom` 无命中。源码 SHA-256：

```text
E48027A6B1D0FB176E8DD9894FFB2A64791994C3A7E8622226FC6B7166F4C61F
```

本执行者未额外写外部日志文件，以遵守独占文件边界；编译输出已在执行工具结果记录。统一构建和带校验值的持久日志由根线程集成时产生，尚不能用本单模块退出码替代整个新版本的统一构建证据。

### 路线、限制与交接

没有失败编译或失败数学路线；首版从通用“直接因子标准”判据统一三类，首次编译即通过。没有数学假设待隐藏补齐。

已完成层次仅为三类候选的真实理想成员性与整除极小性，以及正列严格递减、阈值严格正。此执行者没有构造有限边界集合，没有证明其穷尽全部极小单项式，没有计数或证明其真实 span，也没有证明任意多项式生成系的最少基数、Nakayama、Tor/Betti识别或新颖性。上述候选集分类、精确计数和 span 为根线程当前集成工作；模块停止条件已满足。

## B. 根集成：完整分类、真实生成性与精确基数

`lean/WidthBounds/GeneratorExact.lean` 连接R028与R029，旧证明源码没有重构。新定义 `exponentMonomials E` 为有限指数集合在系数1单项式映射下的实际多项式Finset；域或非平凡系数半环下该映射单射，故其基数等于E.card。

- `mem_boundaryExponents_iff_isMinimal` 将三类候选的极小性和R029整除覆盖组合，证明边界集合成员当且仅当实际 `IsMinimalExponent I e`。反向对任意极小指数e取得边界b≤e，再由b在真实理想内迫使b=e；因此确实穷尽全部极小单项式。
- `span_boundary_exponentMonomials` 复用R029实际 `Ideal.span` 等式；这里必须是 `monomialIdeal S`，没有把一般 `IsLex I` 当成单项式生成性。
- `monomial_mem_span_exponentMonomials_iff` 使用mathlib支持/整除判据证明真实有限单项式span中的系数1单项式恰被列表中某项整除。
- `exponentMonomials_irredundant_of_minimal` 因此证明删除E中任何一个指数后，该单项式不再属于其余列表生成的实际理想。该结论允许用任意多项式作组合系数；它仍不是对任意另一组多项式生成系的基数比较。

主定理 `monomialIdeal_exists_exact_minimal_exponents` 接受非平凡交换半环、指数上集、lex、w≥4、全部次数Hilbert预算、纯x成员a与其真正初始性、纯z幂成员。它构造同一个有限E，同时证明完整成员iff极小性、实际span等式、E.card=a+1+sectionLength、逐项删除不生成。列阈值和列长和由旧已验收定理推出，没有把有限截断当成全范围标准列的定义。

主定理 `finiteColength_exists_exact_minimal_generators` 接受域K、指数上集、lex、真实商环 `Module.Finite K`、x标准、w≥4和所有次数真实齐次商空间维数预算；由旧接口推得纯z幂成员及初始a≥2，再构造上述E。对同一个实际多项式集合G=exponentMonomials E，得到：

- Ideal.span G=原单项式理想。
- E恰为全部整除极小指数；G的每项为系数1单项式。
- G.card=a+1+finrank_K(xySubspace I)=a+1+ell。
- G.card<binom(w+1,2)。
- 删除任一所列单项式后不能再生成原理想。

未证明：任意多项式生成系的最少基数、I/(x,y,z)I的基、Betti/Tor定义识别、完整半群归约。下一项R031只推进前一层，候选路线在其计划报告，不能把计划当成果。

## C. 最终统一验收和证据

在lean/执行 `lake build`，退出码0。日志 `results/lean_minimal_generators_build.txt`，SHA-256 `588c4d7bce7843f42c919111e755267b2ba4466211bf4c26f5985f4827b77774`。

GeneratorExact.lean SHA-256 `2c44a514454c70395f4e5e83c526a683c3b39ffb833a99a537d4bac397fcf399`。R028执行者源码和R029源码hash见各报告；R030独立复核三个冻结版本及最终日志。两条集成主定理只使用propext、Classical.choice、Quot.sound。静态禁止项检查无命中；DependencyAudit新增两条主定理，实际传递声明依赖不含旧有限证书/小宽度结果或sorryAx。

根集成首次目标构建因在泛型系数上直接解包Finset.image需要DecidableEq实例而失败；随后改成复用R029 span定理的集合像接口，并移除四个不需要的Nontrivial实例。最终单模块及统一构建均通过，无增设数学假设，无数值实验。冻结稿件和既有R025三个源码未改。

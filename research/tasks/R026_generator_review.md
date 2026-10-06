# R026：R025 真实生成集合的独立语义审查

状态：完成，接受。纸面、最终源码语义、统一构建日志及源码哈希均已核对；本报告冻结。

日期：2026-09-23。执行者：`generator_review`。本任务仅编辑本报告，不编辑源码、队列、结论清单或状态入口。根线程已完成恢复与检查点校验。

## 结论摘要

拟议集合

\[
G=\{x^a\}\cup\{x^iy^{n_i}:0\le i<a\}
  \cup\{uz^{t(u)}:u\text{ 是标准 }xy\text{ 单项式}\}
\]

在**真实单项式理想**、已证实的有限 xy 截面、`x^a` 在理想内、各柱阈值正确以及存在纯 z 幂成员这些假设下，确实生成原理想，而且 `card G ≤ a+1+ell`。生成性不需要 CMS、Betti 数、极小自由分解或先验的极小生成元公式；不必作次数归纳。

初始次数确为最小值、同次 lex 闭包给出柱长严格递减后，纸面还可证明该集合恰为全部整除极小单项式，因而其基数恰为 `a+1+ell`。**这只是独立纸面推导；最终 Lean 未交付前，不计入已形式化范围。**从这个事实到任意多项式生成系的最少基数，仍需独立的分次 Nakayama/`I/(x,y,z)I` 论证；到 Betti 数还需定义与同调接口。

## 读取和核对的接口

- `research/tasks/R025_generators.md`：计划，尚不是已编译成果。
- `lean/WidthBounds/MonomialInterface.lean`：`monomialIdeal` 定义为真实 `Ideal.span`；`monomial_mem_monomialIdeal_iff` 在 `IsUpperSet S` 和非平凡系数条件下把成员性识别为 `S` 成员性；`IsLex` 仅断言系数为 1 的单项式的同次 lex 成员闭包。
- `lean/WidthBounds/LexCounting.lean`：`StandardLex.down` 和 `.lex` 的方向正确；标准集合沿整除及同次 lex 向下封闭。
- `lean/WidthBounds/ColumnBounds.lean`：`standard_iff_lt_columnLength` 给全部自然数 `j` 的精确柱阈值，截断合法性依赖 `w≥4` 与全部次数预算；`sum_columns_eq_sectionLength` 给 `Σ_{i<a}n_i=ell`；不把定义中的截断误当自然有限性。
- `lean/WidthBounds/IdealBounds.lean`：`xyStandardIndices` 的基数就是 `sectionLength`；`finrank_xySubspace` 证明完整 xy 商像子空间的实际维数等于该计数。
- `lean/WidthBounds/MonomialBasis.lean`：真实商环的标准单项式基，支持有限余长接口；本任务没有重新证明该已验收模块。

## A. 精确假设与构造

令 `K` 为域，`P=K[x,y,z]`，`I=monomialIdeal S`，`S` 是指数上集。实际 Lean 可以在足够的一般系数环上证明生成性；本审查以项目最终使用的域情形叙述。

令 `A(i,j,k)` 表示 `x^iy^jz^k∉I`。假设：

1. `x^a∈I`；若只证明上界和生成性，暂不要求 `a` 为最小值。
2. 对每个 `i`，有限 `n_i` 满足 `A(i,j,0) ↔ j<n_i`；由现有 `StandardLex`、`w≥4` 和全部次数预算可获得。
3. 所有标准 xy 单项式组成有限集合 `U`，`card U=ell`。`x^a∈I` 保证标准 xy 单项式必有 `i<a`，所以 `ell=Σ_{i<a}n_i`。
4. 存在 `N∈ℕ` 使 `z^N∈I`。

对每个 `u=x^iy^j∈U`，`uz^N∈I`（理想乘法闭包），所以可定义

\[
t(u)=\min\{t\in\mathbb N:uz^t\in I\}.
\]

`u∉I` 保证 `t(u)>0`；阈值满足 `t(u)≤N`，且凡 `uz^k∈I` 都有 `t(u)≤k`。不存在把最小值存在性隐藏在无证的 `Nat.find` 参数中的问题：存在性正来自纯 z 幂与向上闭包。

## B. 真实理想等式的直接证明

记 `J=Ideal.span G`。

**`J⊆I`：** `x^a∈I` 是假设；`x^iy^{n_i}∈I` 来自柱阈值在 `j=n_i` 处失败；`uz^{t(u)}∈I` 来自最小阈值的定义。因此 span 的所有生成元都在 `I`。

**`I⊆J`：** 因 `I` 的定义是其指数集合中系数 1 单项式的 span，只须证明任意其中单项式 `m=x^iy^jz^k` 属于 `J`。分三类：

1. `i≥a`：`x^a` 整除 `m`。
2. `i<a` 且 `j≥n_i`：`x^iy^{n_i}` 整除 `m`。
3. `i<a` 且 `j<n_i`：`u=x^iy^j` 是标准 xy 单项式。既然 `uz^k=m∈I`，最小性给 `t(u)≤k`，所以 `uz^{t(u)}` 整除 `m`。

每种情形都由理想对倍数闭包推出 `m∈J`。最后用 `Ideal.span_le` 得实际 span 等式，完全不需要把“边界集合”直接冒认为“生成集合”。

**必须保留的类型边界：** `IsLex I` 对任意多项式理想只约束它含有的系数 1 单项式；这个性质本身不保证 `I` 是单项式理想。若终定理从一般 `I` 出发，却没有 `I=monomialIdeal S` 或等价生成性前提，上面的反向 span 包含不成立。当前计划使用 `monomialIdeal S`，没有这项问题。

## C. 基数上界

三部分分别是一个单元素集合、`range a` 的像、`U` 的像。并集和像的基本基数不等式立即给

\[
|G|\le 1+a+|U|=a+1+\ell.
\]

这一上界允许任意重复和冗余，因此不依赖最小性、不依赖柱长严格递减，也不要求证明阈值映射单射。若终定理再经 `finrank_xySubspace` 改写，则右端确为真实 `xySubspace` 维数；改写本身不识别 Betti 数。

## D. 纯 z 幂、有限余长和 lex 的关系

**纯 z 幂对本构造的必要性：** 对适当理想 `I`，`1` 是标准 xy 单项式，故若为每个 `u∈U` 都定义有限 `t(u)`，其中 `u=1` 就要求某个纯 z 幂在 `I`。所以该假设不是只为 Lean 技术便利加入。若 `I=P`，可取 `N=0`，但项目 `x` 标准的前提已排除此退化情形。

**有限余长推出纯 z 幂：** 在域上，单项式理想的标准单项式商像是一组真实线性基。若商环是有限维的，所有不同 `z^k` 不可能都给互异标准基向量，所以某个 `z^N∈I`。这一步需要实际 `Module.Finite`/有限维假设，不能只用 Lean `finrank` 的一个无穷维时也可能为零的数值断言。

**lex 加纯 z 幂推出有限余长：** `z^N` 是次数 `N` 的 lex 最小单项式，故同次 lex 上闭包迫使所有次数 `N` 的单项式都在 `I`，再由整除上闭包得所有次数 `≥N` 的单项式在 `I`。标准基只剩次数 `<N` 的有限部分。这里不需要 Hilbert 预算。没有 lex 时，纯 z 幂本身不足，例如 `(z)` 的商环 `K[x,y]` 无限维；若另已有有限 xy 截面，则三个方向均有界也可推出有限余长。

**现有预算本身不推出纯 z 幂：** 取

\[
I=(x^2,xy,xz,y^2)\subset K[x,y,z].
\]

这是 lex 单项式理想：次数 `d≥2` 时，标准单项式恰为 `z^d,yz^{d-1}`，它们是该次数 lex 最小的两个单项式。次数 0、1 的标准数分别为 1、3。故累计 Hilbert 数在 `d≥1` 时为 `2d+2≤1+4d`，满足项目所有 `w≥4` 的预算；`x` 标准，首个非标准纯 x 幂为 `x²`，xy 截面为 `{1,x,y}`。但所有 `z^k` 都标准，商环无限维。该例排除了“只从已完成组合预算自动删除纯 z 幂/有限余长假设”的误读；无需任何计算枚举。

## E. 将来精确极小性的有限路线（纸面，未开展实现）

再假设 `a` 是首个非标准纯 x 幂，并保留 lex 条件。

1. 对 `i+1<a`，`x^{i+1}y^{n_{i+1}-1}` 标准。把一个 x 换成 y 得同次 lex 更小的标准单项式 `x^iy^{n_{i+1}}`，故 `n_i≥n_{i+1}+1`。另外 `n_i>0` 对 `i<a` 成立。
2. `x^a` 的唯一直接单项式因子 `x^{a-1}` 标准。对 `x^iy^{n_i}`，除 y 后标准；若 `i>0`，柱长严格递减给 `n_i<n_{i-1}`，所以除 x 后也标准。
3. 对 `uz^{t(u)}`，除 z 后由最小性标准。若可除 x 且除 x 后在 `I`，把其中一个 z 换成 x 得同次 lex 更大的 `uz^{t(u)-1}∈I`，矛盾；除 y 同理。这里 `t(u)>0` 是关键。
4. 每个候选单项式所有直接因子均标准，因此其任意真因子标准。结合 B 的生成性，每个理想内单项式均被候选整除，所以候选恰为全部整除极小单项式。
5. xy 边界之间的 x 指数不同；`x^a` 单列；含 z 部分的 z 次数正且不同 xy 部分保持不同。因此三部分不交、各参数化单射，得到精确 `|G|=a+1+ell`。

该路线没有调用 CMS。它仍只涉及**整除极小单项式生成元**：欲得任意多项式生成系的最少个数，应证明它们在 `I/(x,y,z)I` 的像为基；欲得 `β₀(I)` 或 `β₁(P/I)` 应再提供其同调定义、分次局部极小性及下标接口。本轮上界不自动包含这些层次。

## F. R027 有限余长接口的独立语义审查

根线程追加请求后，只读审查 `lean/WidthBounds/FiniteColength.lean`（2026-09-23）。审查版本 SHA-256：`61D1A3AD9387735533610C89156C297FF053E636C66E51F06E4278AD71025CFA`。

结论：**接受该版本的命题与证明语义；未发现阻塞性问题。** 根线程报告该单文件已成功编译且只有标准逻辑公理；本报告不以该口头报告替代最终主线构建日志。

- `quotient_finite_iff_standard_finite` 的左端是实际商环上的 `Module.Finite K`，右端是整个指数补集有限。两方向确实调用已有 `standardMonomialBasis`，不是把有限维直接当定义，也不滥用无穷维 `finrank=0`。
- `exists_pure_z_exponent_of_standard_finite` 将有限补集投影到 z 坐标，选大于全部投影的 `N+1`；若该纯 z 指数仍在补集就与上界矛盾。没有 lex 或理想假设隐藏在这一纯集合论引理中。
- `exists_pure_z_mem_of_finite_quotient` 通过精确单项式成员判据把前述指数结论转成真实理想成员性；`hUp` 被明确保留，域保证非平凡性。
- `standard_finite_of_pure_z` 先用指数上闭包将 `z^N` 提升到总次数为 `deg e` 的纯 z 幂，再用同次 lex 上闭包转成 `e`，从而证明每个标准指数总次数 `<N`；映射进有限类型 `Fin 3 → Fin N` 并证明单射。`N=0` 时该论证自动迫使标准集合为空，不遗漏退化情形。
- `quotient_finite_iff_exists_pure_z` 明确要求 `hUp` 与 `hLex`，正向无需 lex，反向确实使用 lex。该定理足以把 R025 显式纯 z 幂前提替换成真实商环有限余长前提，但不消除该数学假设。

## G. 最终 R025 源码语义审查

2026-09-23，执行者通知冻结后重新逐行读取 `MinimalGenerators.lean` 及 R025 报告，实际读取的 SHA-256 与执行者报送一致：`9E2FE3D4F65B4218C690CA4606C882007534175B2F55DDDB9A11B9736D93083B`。

结论：**接受；未发现阻塞性错误或需要修正的命题夸大。**

1. `monomialIdeal_exists_generators_of_columns` 在交换半环上工作。它无需 `S` 向上闭，因为反向 span 包含只检查 `monomialIdeal S` 定义里的原始单项式生成元，并从 `Ideal.subset_span` 直接获得成员性；不曾把任意指数的理想成员性误等同为 `e∈S`。其柱阈值 `hn` 是明确假设；并无未经证明的“所有理想都有有限柱”主张。
2. `exists_vertical_mem` 从显式纯 z 幂成员与乘法闭包构造每根柱的成员；`zThreshold` 的 `Nat.find` 谓词因此有实际存在性证据。`zThreshold_mem` 和 `zThreshold_le` 只使用最小值的标准性质。此版本没有声称或使用 `zThreshold>0`；因为计数与生成性不需要这一额外引理。
3. 实际 `G` 是 `Finset (MvPolynomial (Fin 3) R)`，包含全部三类候选；结论同时证明其每项为系数 1 的单项式、真正的 `Ideal.span (G:Set _) = monomialIdeal S`、同一个 `G` 的卡数上界。不存在只计数指数集合却未证明真实理想生成性的漏洞。
4. `hB` 在 `j=n_i` 应用精确柱阈值得成员性；`hG` 用每个阈值的成员证明全部候选在原理想；反向采用 B 节三分法。每步整除闭包方向正确，包括最后 `zThreshold_le` 的方向。
5. 卡数只用 `card_image_le`、`card_union_le`、`card_insert_le`，允许重复和冗余；因而不依赖任何未证明的注入、极小性或列长严格递减。
6. `monomialIdeal_exists_generators_le` 明确加入非平凡交换半环、上集、lex、`w≥4` 和全部次数预算。它从既有 `standard_iff_lt_columnLength` 获取精确柱长，再用既有 `sum_columns_eq_sectionLength` 改写和；只要求 `x^a∈I`，不偷偷假设 `a` 为初始次数。
7. `monomialIdeal_exists_generators_finrank_le` 在域上用已证的 `hilbertBudget_of_finrankBudget` 与 `finrank_xySubspace` 做实际商空间维数接口。它没有把未识别的 Hilbert 计数替代实际维数，也没有识别 Betti 数。

执行者报告单模块命令 `lake env lean WidthBounds/MinimalGenerators.lean` 退出码 0，三条主定理的公理仅为 `propext`、`Classical.choice`、`Quot.sound`。本审查静态搜索 `sorry|admit|native_decide|^axiom` 在三个新增模块均无命中；最终构建证据以根日志为准。

## H. 根集成 `GeneratorBounds.lean` 的独立语义审查

读取版本 SHA-256：`E958C3E33937A83BC7682538850C1081430E1BF76232BEAE1772EA0DC9053D6A`。

结论：**接受；未发现问题。**

- `monomialIdeal_exists_generators_card_lt` 要求域、指数上集与 lex 条件、`x` 标准、显式纯 z 幂成员、`w≥4` 及全部次数的实际齐次商空间累计维数预算。纯 z 幂成员通过成员判据推出 `S` 非空、再推出原理想非零；随后 `monomialIdeal_all_widths_dimension_bounds` 构造合适的最小纯 x 禁指数 `a`。把同一个 `a` 交给 R025 的真实生成集合定理后，经 `G.card≤a+1+finrank(xySubspace)<choose(w+1,2)` 得严格卡数界。未把任意选定的大 `a` 误当满足组合界的最小指数。
- `finiteColength_exists_generators_card_lt` 将显式纯 z 幂前提替换成实际商环的 `Module.Finite`，调用 F 节已审查的正向接口。它依然保留 lex、`x` 标准、`w≥4`、实际预算，未从预算擅自推有限余长。
- 两条结论都明确是存在一个有限系数 1 单项式集合，span 恰为原理想，集合基数严格小于 `choose(w+1,2)`。既不声称集合极小，也不把该基数称为 Betti 数。模块标题、注释及证明范围一致。

## I. 验收范围和剩余边界

接受范围是：实际单项式理想存在明确有限单项式生成集及其上界；在既有全宽度假设加实际有限余长后，得到实际生成集的严格宽度界。R027 的实际有限维/纯 z 幂接口也已独立检查。

没有任何新增的 CMS 依赖，没有证明极小性、精确生成元数、任意多项式生成系的最少基数、Betti/Tor 等式或完整半群归约。E 节是可选后续纸面路线而非本轮 Lean 结论。原始 `w=3` 例外仍不在本轮定理范围。新颖性未作检索或认证。

最终问题列表：空。没有待修正的数学问题或未完成的本任务验收动作。

## J. 统一构建证据核对

根线程在 `lean/` 运行统一 `lake build`，报告退出码 0。独立审查随后实际读取 `results/lean_generators_build.txt`，核对尾行为 `Build completed successfully.`，读取三个新模块的各条 `#print axioms` 输出，均仅含 `propext`、`Classical.choice`、`Quot.sound`。

日志 SHA-256：`878B961412EF4152A7D7138E275551592017F16DB07DFF3F84859FBE84B0633E`。

同次复核三个源码哈希，均与 F、G、H 节所记一致，没有源码改后仍引用旧日志的情况。

只读核对 `DependencyAudit.lean` 及日志：新审计根包含 `monomialIdeal_exists_generators_le`、`finiteColength_exists_generators_card_lt`、`quotient_finite_iff_exists_pure_z`；递归检查声明依赖，禁止旧有限枚举/小宽度证书四条声明和 `sorryAx`，日志显示审计成功。该诊断不承担数学证明本身。

根线程说明 Python 日志封装在 Lean 已成功退出、完整日志已关闭保存之后，打印尾部到 GBK 控制台时发生 `UnicodeEncodeError`。本审查直接读取了已保存的成功日志并核对哈希；该显示错误不构成 Lean 构建失败，没有因此重复构建。

最终可登记的层次为：**真实生成集合上界与严格宽度界 Lean 已编译、独立语义审查接受；精确极小性路线仅为纸面推导；Betti/半群整体形式化和新颖性仍未完成。**

本轮没有互联网检索、新枚举、源码改动或新任务派生。编译执行由实现者与根线程承担；本报告承担独立的纸面和源码语义核对。

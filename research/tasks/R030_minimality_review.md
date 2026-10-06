# R030：边界单项式极小性、分类与精确计数独立审查

状态：完成，接受。独立纸面、三份最终源码语义、统一编译日志及哈希均已核对。报告冻结；各阶段的“待验收”文字为按时间保留的过程记录，最终结论见 J 节。

日期：2026-09-23。执行者：`minimality_review`。独占文件仅本报告；未改源码、根 import、状态文件或队列，未派生任务、检索文献或做数值实验。

恢复核对：已读 AGENTS、STATE、HANDOFF、queue 与 PROTOCOL。根虚拟环境执行 `scripts/checkpoint.py --check` 返回 `queue_valid: true`；`--verify-latest` 返回 `archive_valid: true`。工作区当时新增 `GeneratorExact.lean`、修改状态/交接/队列，是本轮正常 WIP，不是归档损坏。归档校验不代替编译。

## A. 独立纸面结论及精确范围

令 `I` 是真实多项式理想，`A(i,j,k)` 表示系数 1 单项式 `x^i y^j z^k` 不在 `I`。假设：

1. `x^a∈I`，且所有 `d<a` 的 `x^d` 均标准；后半条是极小性所需的初始条件。
2. `I` 对同次 lex 次序 `x>y>z` 向上封闭。
3. 有自然数列长 `n_i`，对所有自然数 `i,j` 都有 `A(i,j,0) ↔ j<n_i`。
4. 存在纯 `z` 幂属于 `I`，从而每根竖柱的最小进入指数 `t(i,j)` 存在。

定义有限指数集合

\[
E=\{(a,0,0)\}\cup\{(i,n_i,0):i<a\}
\cup\{(i,j,t(i,j)):i<a,\ j<n_i\}.
\]

定义实际整除极小指数为

\[
\operatorname{Min}_I(e)\iff x^e\in I\ \land\
\forall f\le e,\ x^f\in I\Rightarrow f=e.
\]

纸面结论：`e∈E ↔ Min_I(e)`，且 `|E|=a+1+Σ_{i<a}n_i`。当 `I=monomialIdeal S` 时，这些系数 1 单项式确实 span 原理想；非平凡系数半环上指数到系数 1 单项式映射单射，因此**同一个实际有限多项式集合**也具有该精确基数。在项目既有域/预算接口下，列长和可改写成真实完整 xy 商像子空间的维数，并接严格二项式上界。

这里的极小性是实际理想成员性上的整除极小性，绝不是把有限集合成员性重新命名成“极小”。它也不直接等于“任意多项式生成系的最少个数”；后者和 Betti/Tor 识别仍须另行证明。

## B. 三类候选的极小性

### B1. 纯 x 边界

`x^a∈I` 是显式假设。若 `f≤(a,0,0)`，则 `f=(d,0,0)` 且 `d≤a`。当 `d<a` 时初始条件排除其属于 `I`；所以任何在 `I` 中的因子都等于原指数。

这证明可直接覆盖 `a=0`，无需书写 `a-1`：此时 `1∈I`，理想为全环；唯一整除极小指数为零指数，且所有标准列均空。`hInitial` 在此情形是空条件。

### B2. xy 列边界

当 `i<a` 时，初始条件给 `A(i,0,0)`，精确柱阈值推出 `n_i>0`。列边界本身在 `I`，因为 `n_i<n_i` 不成立；除以 y 后的 `x^i y^(n_i-1)` 标准。

若 `i>0`，把这个标准单项式中的一个 x 换成 y，得到同次且 lex 更小的 `x^(i-1)y^n_i`，所以除 x 后也标准。等价地，相邻正列满足 `n_i<n_(i-1)`：从 `x^i y^(n_i-1)` 标准可推出 `n_i<n_(i-1)`，没有把弱单调性误当严格递减。`i=0` 时不存在除 x 的检验，不能让自然数截断减法生成伪直接因子。

这类候选 z 指数为零，故也不存在除 z 的检验。任何真因子至少严格减少一个正坐标，因而整除某个刚证明标准的直接因子；标准集合的整除向下封闭保证全部真因子标准。

### B3. z 阈值边界

对 `i<a,j<n_i`，底部 `x^i y^j` 标准，因此 `t=t(i,j)>0`。若阈值为零，其阈值成员性立即与底部标准性矛盾；该正性不是未证假设。阈值成员属于 `I`，而 `x^i y^j z^(t-1)` 由阈值最小性标准。

若 `i>0`，则除 x 后的 `x^(i-1)y^jz^t` 与上述标准单项式同次且 lex 更小，所以标准。若 `j>0`，除 y 后的 `x^iy^(j-1)z^t` 同样是同次 lex 更小的标准单项式。`i=0` 或 `j=0` 时相应直接因子不存在，须分别跳过。除 z 后标准已经由阈值最小性给出。再次用向下封闭得到全部真因子标准。

lex 方向已独立核对：**理想成员向同次 lex 更大者传播；标准性向同次 lex 更小者传播**。这里从 z 次数 `t-1` 的标准单项式向较少 x 或 y、较多 z 的标准单项式传播，方向正确。正性 `t>0` 保证总次数恒等式中 `t-1+1=t`，不能忽略。

## C. 反向分类与真实 span

任意在 `I` 中的系数 1 单项式 `x^iy^jz^k` 分成恰好覆盖的三种情况：

1. `a≤i` 时，纯 x 边界整除它。
2. `i<a` 且 `n_i≤j` 时，对应 xy 列边界整除它。
3. `i<a` 且 `j<n_i` 时，最小阈值满足 `t(i,j)≤k`，对应 z 边界整除它。

因此任何实际整除极小指数 `e` 都被某个 `b∈E` 整除；候选属于 `I`，极小性强迫 `b=e`，得到反向成员性。这个逻辑不需要次数归纳，也没有循环使用极小性分类。

对一般理想，这只分类其**系数 1 单项式**。实际 `Ideal.span G=I` 需要 `I` 是真实单项式理想；在 `I=monomialIdeal S` 时，检查 `S` 所给原始生成单项式即可，三分覆盖和理想对倍数闭包给反向 span 包含。若只保留一般理想的 `IsLex I` 而删除单项式生成性，则不能推出实际 span 等式。

## D. 同一有限集合的精确计数

每一部分参数化单射，理由均为显式坐标：xy 边界的 x 坐标恢复 `i`；竖边界的 x、y 坐标恢复 `(i,j)`。纯 x 边界与两部分其他候选的 x 坐标分别为 `a` 和 `<a`；xy 边界的 z 坐标为零而竖边界的 z 坐标严格正，所以三部分互不相交。

因此 `card E=1+a+Σ_{i<a}n_i=a+1+Σ_{i<a}n_i`。这一**指数集合计数**实际上无需 lex 或初始最小性，只需底部精确标准柱保证竖阈值正性；极小性证明才需要前述更强假设。实现如果让计数引理适用更宽，不构成假设缺漏。

对实际多项式集合 `G={monomial e 1:e∈E}`，须使用非平凡系数条件下 `monomial_left_injective one_ne_zero` 一类真正的单射论证，才有 `card G=card E`。只用 `card_image_le` 不足以给精确基数，也不能用另一个存在的生成集合替换当前 `G`。

`a=0` 时 `range a` 与 sigma 参数集合都空，`E` 只含零指数；公式给 1，和全环由常数 1 生成完全吻合。`n_i=0` 时该列竖边界参数集为空；在极小性前提 `i<a` 内这种情形已由初始条件排除。

## E. 不可删除的假设与口径

- **初始最小性：** 只有 `x^a∈I` 时，纯 x 候选可能冗余，例如 `I=(x,y,z)` 却取 `a=2`。R025 的生成上界允许这种 `a`，R028 极小性不允许。
- **lex：** `I=(x²,y²,z²)` 有有限余长且 `a=2` 是初始值，但 `n_0=n_1=2`，候选 `xy²` 被 `y²` 整除，许多竖候选也冗余。因此单项式上集与有限余长本身不足以证明本边界公式的极小性。
- **有限竖阈值：** 纯 z 幂条件保证每根柱阈值存在。Hilbert 预算自身不能替代它；R026 的 `(x²,xy,xz,y²)` 反例仍有效。域上的真实 `Module.Finite` 可以经已证接口提供纯 z 幂，但不能只用无穷维时也定义为零的 `finrank` 数值代替实际有限性。
- **精确列阈值的全范围：** 需要所有自然数 `i,j` 的 `standard↔j<n_i`，不能把有限截断中的计数直接当作全体列长。最终项目接口应仍经已验收的预算/列长定理提供此事实。
- **非平凡系数与真实空间：** 指数到多项式的精确计数依赖 `1≠0`。完整 xy 维数和次数预算须接既有真实商空间接口，不得用形式计数直接定义维数。
- **严格宽度界：** 保留 `w≥4`、x 标准与全部次数真实预算、真实有限余长等原有条件。不能借本轮的精确计数删除这些原有前提，也不把一般 lex `w=3` 纳入。
- **结果层次：** 本轮可达到整除极小单项式集合、其实际 span、精确基数、删除任一所列单项式后不再生成以及宽度界。任意多项式生成系最少个数、`I/(x,y,z)I` 的基、Betti/Tor 与整个半群归约不自动跟随；新颖性未检索、未认证。

## F. 最终源码/日志待验收清单

待根线程通知源码冻结后，审查 `GeneratorMinimality.lean`、`BoundaryGenerators.lean`、`GeneratorExact.lean`，并记录各自 SHA-256 与统一成功日志 SHA-256。核对实际定义、三类极小性、成员 iff 极小性、同一集合实际 span 与精确基数、真实维数改写和严格界。只接受最终统一构建证据；WIP 的局部编译不作最终验收。

同时核对禁止项 `sorry`、`admit`、自定义公理、`native_decide` 与声明实际依赖；标准逻辑公理允许并如实记录。当前纸面问题列表为空；最终源码审查和日志核验仍未完成。

## G. GeneratorMinimality 最终源码语义审查

实现者通知源码冻结后，独立实际读取全文件及 R028 报告，读取源码 SHA-256 为 `E48027A6B1D0FB176E8DD9894FFB2A64791994C3A7E8622226FC6B7166F4C61F`，与实现者报送相同。

结论：**接受该源码的定义、命题和证明语义；无阻塞性问题。** 统一构建证据仍待根线程交付。

- `IsMinimalExponent` 正是 A 节实际理想成员性及全部坐标因子的定义，不依赖候选集合。核心引理在一般交换半环、一般真实理想上成立；未加非平凡系数不成问题，因为此阶段不比较不同指数所给多项式的基数。
- `isMinimalExponent_of_standard_predecessors` 对任意在理想内的因子 `f≤e` 分别证明三个坐标相等。若某坐标严格变小，理想对单项式倍数的闭包会迫使对应直接因子属于理想，与标准性矛盾。因此并非仅定义或检查局部极小性后假定全局极小性。
- 纯 x 证明只在 `a>0` 分支取 `a-1`；零坐标分支由不可能的正性消去。`a=0` 无遗漏。
- `column_strictAnti_of_initial` 从 `i'<a` 推 `n_i'>0`，再将标准列顶移动到 `i<i'` 的同次 lex 更小指数 `(i,i'-i+n_i'-1,0)`。其总次数、lex 方向和自然数截断减法均有足够假设；所得严格列减性适用于任意两根正列。
- xy 边界先由精确 `hn` 推真实成员性，再使用列长正性与严格递减验证直接因子；只有 x 坐标正时才请求前一列，z 坐标零分支不引入伪因子。
- z 边界先证 `zThreshold>0`，再得阈值前一层标准。若除 x/y 后在理想，源码使用同次 lex 向上闭包推出前一层在理想；前一层标准给矛盾。`i=0`、`j=0`、`t=1` 均由相应分支和正性正确覆盖。
- 该文件没有使用 Hilbert 预算、宽度下界或单项式 span 性。比最终项目目标更一般的核心极小性结论是有效的假设精简；实际 span 和精确多项式计数仍由后续模块承担。

实现者报告局部编译成功及五项公理打印均为标准逻辑公理，本报告尚不把其口头/任务报告记录替代最终持久统一日志。

## H. BoundaryGenerators 最终源码语义审查

根线程通知源码冻结后，独立实际读取全文件及 R029 报告，读取源码 SHA-256 为 `4D8DF5F5B1ADFE65869A9D997CD370D2936DFFF4C2B54EF4D00A3B8361663570`，与冻结通知相同。

结论：**接受该源码的成员性、覆盖、精确计数和实际 span 语义；无阻塞性问题。**

- `boundaryExponents` 是 A 节所列三部分的同一个显式 `Finset`。`mem_boundaryExponents_iff` 展开该定义，未更换集合或引入额外条件。
- `boundaryExponents_monomial_mem` 用纯 x 成员假设、精确柱判据和阈值成员定理逐类证明真正的系数 1 单项式属于 `I`。
- `exists_boundaryExponent_le` 的三分法覆盖所有实际理想内单项式。它的签名不需要 `hx`/`hn`，这是正确的：即使任意给定 `a,n` 所列的某些候选未必属于理想，仍总能按坐标三分得到一个不大于原指数的候选；成员真实性由另一引理独立提供。最终分类/span 组合两者时没有丢掉该要求。
- `boundary_zThreshold_pos` 明确从 `j<n_i` 与 `hn` 得到底部标准，再排除阈值为零。计数中竖边界的正 z 坐标确有证明来源。
- `card_boundaryExponents` 分别由 x 坐标和 x/y 两坐标证明两像单射；由 z 坐标零/正证明两像不交；由 x 坐标 `a`/`<a` 排除纯 x 项重合；然后真正使用 `card_insert_of_notMem` 和 `card_union_of_disjoint` 得等号。既非像基数上界，也非另选集合的基数。
- `span_boundaryExponents` 的理想是明示 `monomialIdeal S`。反向包含检查原始 `S` 生成单项式，经覆盖和 `mem_of_dvd` 进入候选 span；无需 `S` 向上闭，因为没有把任意成员误当 `S` 成员。一般交换半环上的结论有效。
- `a=0`、空列和 sigma 空集在该定义和证明中无需另加正性假设，均与 D 节退化分析一致。

三个新文件的静态禁止项检索当时无命中；最终版本仍须结合统一日志再次核对。根集成的当前 WIP 已作初读，语义未见问题，但其最终验收须待源码冻结和统一构建。

## I. GeneratorExact 最终源码语义审查

根线程通知单模块编译成功并冻结后，独立重新读取全文件、根 import 和 `DependencyAudit.lean`。集成源码 SHA-256：`2C44A514454C70395F4E5E83C526A683C3B39FFB833A99A537D4BAC397FCF399`，与冻结通知相同。

结论：**接受最终集成源码的数学语义；无阻塞性问题。**

1. `exponentMonomials E` 是系数 1 单项式像的真实 `Finset (MvPolynomial (Fin 3) R)`。`card_exponentMonomials` 以非平凡系数下的单项式指数单射给精确像基数；`monomial_mem_exponentMonomials_iff` 也显式使用该单射。没有把指数数目无条件等同为多项式数目。
2. `monomial_mem_span_exponentMonomials_iff` 从 mathlib 的单项式理想成员准则，证明真实 span 中的系数 1 单项式恰被所列某个单项式整除。`monomial_not_mem_span_erase` 和 `exponentMonomials_irredundant_of_minimal` 据此排除删去所列任一指数后仍能用其余项的任意多项式组合生成它。这里允许多项式系数，但没有把结论扩大为任意另一组多项式生成系的最少基数。
3. `mem_finset_iff_isMinimalExponent` 用成员真实极小性与整除覆盖得到完整分类。反向对实际极小指数 `e` 取得 `f∈E, f≤e`，再用 `f` 的真实理想成员性强迫相等，逻辑没有循环。
4. `boundaryExponents_isMinimal` 正确按三类调用 R028；`mem_boundaryExponents_iff_isMinimal` 再接 R029 的覆盖。两者不依赖非平凡系数，最终源码去除该不必要实例正确。
5. `span_boundary_exponentMonomials` 先证明 Finset 强制转换后等于相同集合像，再复用已审查的 R029 实际 span 等式。它明确限定于 `monomialIdeal S`；没有把泛型 `IsLex I` 错当单项式生成性。
6. `monomialIdeal_exists_exact_minimal_exponents` 从已验收 `standard_iff_lt_columnLength` 获取所有自然数上的精确列判据，保留 `hUp`、lex、`w≥4`、全部次数 Hilbert 预算、初始 `a` 与纯 z 幂。对一个固定 `E=boundaryExponents ...` 同时给出完整分类、实际 span、`E.card=a+1+sectionLength` 和逐项删除不生成；没有在不同结论间切换存在的集合。
7. `finiteColength_exists_exact_minimal_generators` 的域与实际 `Module.Finite` 给纯 z 幂；单项式成员判据给非零理想。已验收 `monomialIdeal_all_widths_dimension_bounds` 同时产生 `a≥2`、真正初始性和严格界，因此这里没有任意挑一个过大的纯 x 禁指数。实际次数维数预算经既有 Hilbert 接口传入，列长计数经 `finrank_xySubspace` 改写。
8. 最终定理的同一个实际集合 `G=exponentMonomials E` 满足 `Ideal.span G=monomialIdeal S`、`G.card=a+1+finrank(xySubspace)`、`G.card<choose(w+1,2)`，并明确完整极小指数分类与逐项删除性质。其假设仍含域、指数上集、lex、x 标准、`w≥4`、全部次数真实维数预算和真实有限余长。未宣称 Betti/Tor、任意多项式最少生成数或全半群结论。

根 import 已含三个新模块；依赖审计新增两条主定理，递归检查其实际声明依赖中不含旧四条有限枚举/小宽度证书声明或 `sorryAx`。该审计是诊断，不被用作数学证明。统一日志仍待最终成功后核验。

## J. 统一构建、哈希与最终验收

根线程在项目 `lean/` 目录运行统一 `lake build`，报告退出码 0。本审查独立读取持久日志 `results/lean_minimal_generators_build.txt`，实际确认最后一行为 `Build completed successfully.`；日志包含三份新模块的全部公理打印与两条新主定理的传递声明依赖审计成功输出，未见错误或警告。

所有新打印命题只依赖 `propext`、`Classical.choice`、`Quot.sound`。再次静态检索三份新源码中的 `sorry|admit|native_decide|^axiom`，无命中。已检查的依赖审计程序会另外排除 `sorryAx`；日志显示两条新主定理没有四条旧有限枚举/小宽度证书的传递依赖。根 import 中仍保留历史模块不等于新命题依赖历史有限证书，此处确实检查实际声明依赖。

同次重新读取文件 SHA-256，如下。三份源码与 G/H/I 节冻结值一致，未发现源码修改后继续引用旧日志的情况。

| 文件 | SHA-256 |
|---|---|
| `lean/WidthBounds/GeneratorMinimality.lean` | `E48027A6B1D0FB176E8DD9894FFB2A64791994C3A7E8622226FC6B7166F4C61F` |
| `lean/WidthBounds/BoundaryGenerators.lean` | `4D8DF5F5B1ADFE65869A9D997CD370D2936DFFF4C2B54EF4D00A3B8361663570` |
| `lean/WidthBounds/GeneratorExact.lean` | `2C44A514454C70395F4E5E83C526A683C3B39FFB833A99A537D4BAC397FCF399` |
| `lean/WidthBounds/DependencyAudit.lean` | `F7F6A6EB4841B124B2522126FEACA3C132806A0BF7D940B2F85E1DCE04D5BF57` |
| `lean/WidthBounds.lean` | `CA3A8DE987C53AFFC9ECC0C0EADE308C74FE81DEF5D38D4E0D55DB5F725E782B` |
| `results/lean_minimal_generators_build.txt` | `588C4D7BCE7843F42C919111E755267B2BA4466211BF4C26F5985F4827B77774` |

**最终接受范围：** 在各定理明示假设下，三类候选的实际整除极小性、全部极小指数的有限集合分类、同一实际单项式集合的 span 等式、精确 `a+1+ell` 计数、每项不可删除、真实 xy 商像维数版本及严格 `choose(w+1,2)` 界，均为 **Lean 已编译且独立内部语义审查接受**。零/边界情形和假设方向均已单独检查。

**未包含：** 任意多项式生成系的最少基数、分次 Nakayama/`I/(x,y,z)I` 基、Betti/Tor 识别、完整半群归约、外部专家认可或新颖性认证。它们仍是独立后续任务；本轮不以精确单项式计数替代它们。

最终问题列表为空，无未完成的本任务验收动作。下一步由根线程更新 queue/claims/STATE/HANDOFF 并建立稳定检查点；本执行者遵守独占范围，仅写本报告。

# R036：实际 I/mI 与极小系数坐标接口的独立审查

状态：最终接受；纸面论证、冻结源码语义、统一 Lean 构建、SHA-256、公理及传递依赖证据均已核对。日期：2026-09-24（Asia/Shanghai）。本报告由 generator_quotient_review 独占；审查者不改源码、根 import 或状态文件，不再派生。

## 已核对的基线与范围

已读 AGENTS.md、STATE.md、HANDOFF.md、queue.json、PROTOCOL.md、R034 初始计划、R031 报告末尾以及 PolynomialGeneratorNumber.lean、GeneratorExact.lean、GeneratorNumberBounds.lean 的相关接口。根已完成本轮初始恢复；本审查另运行根 `.venv\Scripts\python.exe -B scripts/checkpoint.py --check`，得到 queue_valid=true；`--verify-latest` 得到 archive_valid=true，报告的工作区变化仅为本轮正常 WIP 文件/状态更新，不是归档损坏。

本轮目标仅为：在 A=K[x,y,z]（K 为域）的实际单项式理想 I 上，以真实变量理想 m=Ideal.span(range X) 与真实理想乘积 m*I 构造 K 向量空间 I/mI，识别其极小单项式类基，连接已经证明的任意有限多项式生成集合的最少基数与宽度界。没有把 Tor、Betti 或半群归约作为已完成接口。

## 一、独立纸面核对

设 S 为指数上集，I=monomialIdeal S，E 为有限指数集合。所需假设为：

1. 对每个 e∈E，monomial e 1 是 I 的整除极小单项式。
2. `Ideal.span (exponentMonomials E) = I`，即所列系数 1 单项式实际生成原理想。

这两项给出了完整极小生成集；反向核包含不能只保留第一项。定义 F(p) 为 p 在 E 处的系数向量，F_I 为它在 I 上的限制。

### 真实乘积到系数核

m 中每个多项式的常数项为零：各 X_v 常数项为零，常数项映射保加法、乘法，故其核包含由全部 X_v 生成的真实理想。对于 q∈m、p∈I，R031 的系数乘法公式给出 F(qp)=constantCoeff(q)F(p)=0。F 的线性性将此结论提升至理想乘积中所有有限和。另由理想闭合性 mI≤I。因此真实成员关系 `p∈mI` 蕴含 `p∈I ∧ F(p)=0`。

此方向不能只检查单个乘积后省略理想乘积闭合论证；冻结源码应使用 Ideal.mul_le / Ideal.mul_induction 或等价的实际乘积成员接口完成这一步。

### 系数核到真实乘积

设 p∈I 且 F(p)=0。若 f 属于 p 的支持，则系数非零。实际单项式理想支持判据保证 monomial f 1∈I。由实际 hSpan 与 GeneratorExact 中的单项式 span 成员判据，存在 e∈E 满足 e≤f。若 f=e，则 F(p) 在 e 坐标为零与支持非零矛盾。因此 f≠e，d=f−e 非零且 d+e=f。

任意非零自然数指数 d 有一坐标 v 满足 d_v>0；于是单项式 x^d 含变量 X_v 因子，属于 m。因为 monomial e 1∈I，乘积 monomial d c * monomial e 1 = monomial f c 属于 mI。逐支持项取 c=coeff f p，再按有限和重构 p，得到 p∈mI。

该路线不需要有限余长、lex、Hilbert 预算、真理想、E 非空或齐次生成集合等额外假设。这里使用单项式支持判据的对象必须始终是 `monomialIdeal S`；不能对任意多项式理想宣称同样的逐项成员性。

## 二、边界情形与反例核对

- **零理想**：E=∅ 时 hSpan 强制 I=0。F 的目标是空坐标函数空间，只有零向量；但核等式始终同时要求 p∈I，因此只有 p=0。I/mI 是零空间，基为空，维数和最少生成数都是 0。没有 finrank 在无限维时取 0 的替代论证。
- **单位理想**：I=A 时唯一极小指数是 0，完整性给 E={0}。mI=m，F 就是常数项，I/mI 同构于 K，单项式 1 的类给基，维数与最少生成数都是 1。一般核与商接口不应误加 I≠⊤。最终 lex 宽度定理另有 x 标准的假设，因而不涵盖单位理想；这与一般接口兼容。
- **只取部分极小指数**：I=(x,y)，E={x 的指数}，p=y。E 中指数确实极小，F(p)=0，而且 p∈I；但 y∉mI=(x²,xy,xz,y²,yz)。因此只有 hMin 不足，hSpan/完整性不可删除。E=∅、I≠0 也会直接表现同一问题。
- **所列指数非极小**：例如 I=(x)，E={x,x²} 虽实际生成 I，但 F 不在 mI 上消失，因为 x²∈mI 且 x² 坐标为 1。因此 hSpan 也不能代替 hMin。
- **非单项式理想**：一般理想成员关系不保证支持项逐项属于该理想。例如 (x+y) 中的 x+y 不能据此推出 x∈(x+y)。反向证明必须保留真实单项式理想条件。

此外，通用结论不能无条件改称 `Tor₁^A(A/I,K)` 的识别：单位理想 I=A 时，本轮商 I/mI≅K，而 A/I=0 的 Tor₁ 为 0。后续同调接口至少需要适当的 I⊆m 条件及实际正合序列论证；本轮最终有限 lex 定理的 x 标准条件可排除单位理想，但这里尚未构造该 Tor 接口。

这些是纸面数学核对，不声称已新增相应边界特例的 Lean 命题。统一一般定理若保留上述完整量词并编译通过，则已涵盖前两类边界。

## 三、实际子商与维数接口的验收标准

对一般理想 I,J⊆A，I 是 A 中多项式的子类型，作为 K 向量空间使用。将 J 限制标量成为 A 的 K 子模，再沿包含映射 I→ₗ[K]A 作 comap，得到 I 内的实际子模 N。其成员关系是 `p:I` 的底层多项式属于 J。商的类型必须为 I⧸N，而非 A⧸I，也不能把 N 定义成尚未识别的系数核。

实例化 J=mI 时，应先有 mI≤I 或等价成员事实，故上述 comap 确实对应 I 内全部 mI。一般 comap 即使不假设 J≤I 也有意义，表示 I∩J；这不损害本轮实例，因为 mI≤I 已单独证明。

F 在 I 上的满射已经由 R031 显式单项式和给出，无须新增研究假设。R035 可在一般接口中假设满射与核成员等价，但根实例化必须实际提供既有满射和 R034 的真实核等价。由此构造商线性同构 I/mI≃ₗ[K](E→K)。必须检查商映射 mk 的值域是真正商空间、其输入包含 I 内成员证明，以及线性同构在 mk(p) 上确实给 F(p)。

基应由 E→K 的标准坐标基通过逆同构传回；还应证明每个基向量是 `monomial e 1` 的真实商类，而不只是存在一个抽象 E 索引基。这个基既给有限维实例，也给 finrank=E.card，排除仅利用 finrank 的数值等式掩盖无限维的风险。

最后将同一个 E 的实际 hSpan 与 hMin 传给既有 `isLeast_generatorCardinalities_of_minimal_exponents`，得到实际商维数是全部任意有限多项式生成集合基数的真正 IsLeast。不能把最少生成数作为新假设，也不能把上界写成适用于任意加入冗余项后的生成集合。

## 四、冻结验收清单（已完成）

已检查以下最终文件：

- `lean/WidthBounds/GeneratorQuotient.lean`：真实 variableIdeal 与理想乘积、两方向成员等价、假设。
- `lean/WidthBounds/IdealSubquotient.lean`：实际 comap 子模与商类型、满射商同构、mk 公式。
- `lean/WidthBounds/GeneratorQuotientBounds.lean`：真实实例、单项式类基、有限维、精确维数、IsLeast 与 strict/harmonic 界。
- 统一 `lake build` 日志、源码及日志 SHA-256、公理与禁止项/传递依赖审计。

验收纪律：源码及统一日志完成冻结后才将本报告标成最终接受。没有数学或类型语义缺陷需回根修改；无需互联网、枚举或新实验，未发生失败数学路线，也没有需要用户确认的障碍。

## 五、源码语义复核进度

已逐行复核 R034、R035 冻结源码，并独立计算哈希与执行者报告一致：

| 源码 | SHA-256 |
|---|---|
| GeneratorQuotient.lean | `19ddb478058534f0e6a16b1655515138ab5ddc8a6a11c6c43a28b2036fe17fcc` |
| IdealSubquotient.lean | `42c8a7ee63bdce92f61279d656efc936766598cf97b5edab9a648428002bf2e6` |

R034 的正向使用实际 `Submodule.mul_induction_on`；反向通过 `p.as_sum` 对支持项还原，完整 hSpan 提供除因子，`f-e≠0` 保证变量理想成员，最后实际 `Ideal.mul_mem_mul` 完成成员证明。反向单独只需 hSpan，不需要 hMin；正向单独只需 hMin，不需要 hSpan；完整等价保留两者。此拆分比合并命题更精确，没有弱化目标。

R035 的分母是 `Submodule.comap (I.restrictScalars K).subtype (J.restrictScalars K)`，先于且独立于 F 定义。商同构先用真实核等式改写商，再用 `quotKerEquivOfSurjective`；mk 公式的输入具有 I 内成员类型，输出的坐标就是底层多项式的 F 值。无 J≤I 时仅解释为 I/(I∩J)，没有错误声称对任意 J 都是 I/J。一般 finrank 等式不假设有限维，但另有 `finite_idealSubquotient` 传递有限维性，文档明确了这一差别。

已逐读根的 GeneratorQuotientBounds.lean 当前完整版本：`GeneratorQuotient I` 实例化 J=variableIdeal*I；`ker_generatorCoefficientMap` 将实际 R034 等价传给通用核接口；`generatorQuotientEquiv` 的满射来自既有实际单项式和构造；`generatorQuotientBasis_apply` 证明逆同构传回的标准坐标基等于原系数 1 单项式的真实商类。`generatorQuotient_finite` 单独由到有限函数空间的线性同构证明有限维；`finrank_generatorQuotient` 得到 E.card，随后调用既有实际最少基数定理而非预设最少数。

最终 `finiteColength_generatorQuotient_bounds` 保留域、指数上集、lex、真实 A/I 有限维、x 标准、w≥4 及全部次数真实维数预算，输出实际 I/mI 有限维、精确维数 a+1+dim(xySubspace)、同一维数的 IsLeast、严格二项式界及精确有理谐和界。没有把上界量化到含冗余项的任意生成集合，也没有新增 Real.log/Theta 或 Tor/Betti 结论。根版本语义接受；最终哈希与统一构建日志核对如下。

## 六、最终统一证据与结论

根在 `D:\project\ai4math\lean` 运行 `lake build`，退出 0。审查者独立读取已经关闭的日志 `results/lean_generator_quotient_build.txt`，确认三个新模块均在统一构建中验证/重放，DependencyAudit 完成，根库 `WidthBounds` 构建完成，末行是 `Build completed successfully.`。日志中无 error 或 warning；五条一般子商输出、四条真实乘积输出及五条根输出均仅列标准逻辑公理 `propext`、`Classical.choice`、`Quot.sound`。

审查者再次独立计算最终文件 SHA-256；前两新模块与第五节相同，其余如下：

| 文件 | SHA-256 |
|---|---|
| lean/WidthBounds/GeneratorQuotientBounds.lean | `86d82364b1c98f05b4b521a26b06dd2c7df9b56a828cf43e4237a21508d5dee3` |
| lean/WidthBounds/DependencyAudit.lean | `c9b90dde9c24f28650878500f8fb650f60ce4268a932e27b27077502e21acfac` |
| lean/WidthBounds.lean | `9d7a945e09d3356b004e904199d39e8d6f2b8bdd3818b04af9df2457e4571867` |
| results/lean_generator_quotient_build.txt | `2769b48af9a18b118648a98869a86059da0fd4db10b3115f275e5f566c81e8a1` |

根回传的最终根模块与日志哈希均与本审查独立结果一致。三个新源码的 `sorry|admit|native_decide|^axiom` 禁止项扫描无匹配。依赖审计源码已逐读，其从真实声明常量依赖递归遍历，不按 import 名单猜测；新核等式 `ker_generatorCoefficientMap`、商类基公式 `generatorQuotientBasis_apply`、最终界 `finiteColength_generatorQuotient_bounds` 均确认不含列出的旧有限枚举/小宽度证书根声明及 `sorryAx`。

**接受结论：** R034/R035/根集成已经 Lean 编译证明真实变量理想乘积对应极小系数核、实际 I/mI 与有限坐标空间的线性同构、由实际极小系数 1 单项式商类组成的基、有限维及精确维数、该维数等于任意有限多项式生成集合的最少基数，并在原有限 lex 模型假设下继承严格二项式与精确有理谐和界。纸面与源码内部独立审查没有发现未解决缺陷。

仍未建立实际 Tor/Betti 定义接口、完整半群归约、Real.log/Theta 的完整形式化或任何新颖性认证；本审查也不是外部人类审稿。未改冻结 v0.1/v0.2、未对外通信。下一步由根登记 claims/STATE/HANDOFF/queue 并创建稳定检查点；本审查报告此处冻结，不再修改源码或追加研究任务。

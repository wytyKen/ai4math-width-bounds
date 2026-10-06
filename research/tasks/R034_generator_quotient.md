# R034：极小系数映射与 I/(x,y,z)I

状态：R034整体已完成统一Lean构建（2026-09-24，Asia/Shanghai）。代数核由generator_product_kernel执行，R035提供一般实际子商接口，根已完成真实I/mI同构、单项式商类基、有限维性、维数与最少数/宽度界的集成。独立审查证据见R036；以下初始计划与执行者证据保留。

目标：在实际多项式环A=K[x,y,z]中，令m=(x,y,z)。将已构造的极小指数系数映射限制到实际理想I，证明其核正是mI在I中的对应K子空间，由此构造实际商向量空间 `I/mI` 与 `E→K` 的线性同构，得到其维数等于已证明的最少多项式生成元数。这一步仍不直接声称Tor/Betti识别。

建议文件：`lean/WidthBounds/GeneratorQuotient.lean` 与本报告。先读R031、R032、R033报告及PolynomialGeneratorNumber.lean、GeneratorNumberBounds.lean；无需重做系数乘法公式、满射或任意生成集合的最少基数。

候选路线（须执行者实际验证）：

1. 用真实 `Ideal.span (Set.range X)` 定义m，真实理想乘积m*I。证明m*I≤I，并把它经包含映射comap为I中的K子模，避免把商空间仅定义成未知映射的核然后直接叫mI。
2. 限制 `minimalCoefficientMap E` 得 `I →ₗ[K] (E→K)`。已有理想上原像定理给满射；已有乘法常数作用公式与m中多项式的常数系数为零给mI包含于核。
3. 反向：假设E完整地描述极小指数，或更直接使用已证明的实际单项式生成性。若p∈I且E上所有系数零，则每个非零支持指数f都被某e∈E整除，且f≠e。选一个严格增大的坐标v，减去该变量后仍被e整除，故该项是X_v乘以I内单项式，属于mI。按有限支持和提升到p∈mI。
4. 由核等式与实际满射建立商线性同构、标准单项式类的基和finrank=E.card。最后接R031的IsLeast结果，不把最少生成数再次作为假设。

重要条件：零理想/空E、单位理想/E={0}须正确处理；若只选了一部分极小指数，核一般大于mI，因此核等式必须保留穷尽或生成性条件。不要偷偷对任意理想套用单项式支持判据。

验收：定义中确为真实变量理想与真实理想乘积；商/核等同有证明；模块及统一构建通过；准确区分已证明的I/mI线性代数与尚未建立的Tor_1^A(A/I,K)接口、半群归约。禁止sorry/admit/自定义公理/native_decide；两次实质路线无进展应落盘具体障碍交根决策。

## 代数核实现进度（2026-09-24）

独占文件为 `lean/WidthBounds/GeneratorQuotient.lean` 与本报告；未改根import、旧证明、配置、状态、queue或claims，未派生。根已完成启动恢复及检查点核验。本子任务读AGENTS、R031/R032/R033报告、R034计划以及所需既有源码和mathlib实际理想乘积API。

声明位于 `WidthBounds.MonomialInterface`，参数 `{K : Type*} [Field K]`。目标接口：

- `variableIdeal` 定义为真实 `Ideal.span (Set.range (MvPolynomial.X : Fin 3 → MvPolynomial (Fin 3) K))`。
- `variableIdeal_mul_le I`：真实理想乘积 `variableIdeal * I ≤ I`。
- `constantCoeff_eq_zero_of_mem_variableIdeal hp`：p∈变量理想时常数项为0。
- `monomial_mem_variableIdeal_of_ne_zero hd`：非零指数d的系数1单项式属于变量理想。
- `minimalCoefficientMap_eq_zero_of_mem_variableIdeal_mul S hUp E hMin hp`：实际乘积内多项式的所选极小系数全零；正向不需要生成性。
- `mem_variableIdeal_mul_of_minimalCoefficientMap_eq_zero S hUp E hSpan hp hZero`：所列系数全零的理想元素属于实际乘积；反向不需要极小性，但保留完整实际span等式。
- `mem_variableIdeal_mul_monomialIdeal_iff S hUp E hMin hSpan p`：合并为成员等价，供根与R035商接口拼接。

当前证明机制：常数项环同态的核包含三个变量，通过 `Ideal.span_le` 得整个变量理想落入核。非零指数单项式属于变量理想，用mathlib的真实 `mem_ideal_span_X_image` 判据。产品正向由 `Submodule.mul_induction_on`，乘积生成项使用R031系数乘法公式，有限和使用K线性性。

反向对p的每个支持指数f，利用上集单项式理想的真实support判据得x^f∈I；完整hSpan及 `monomial_mem_span_exponentMonomials_iff` 给某e∈E,e≤f。若f=e则hZero与支持系数非零矛盾，因此f−e≠0。系数1的x^(f−e)属于变量理想，系数为coeff_f(p)的x^e属于I，两者之积为p的该单项式项；用p的支持有限和还原p。没有选坐标或截断支持。

首次编译暴露两个局部Lean问题：支持判据返回d=m而目标写m=d；真实产品声明中的两个隐式系数类型同时未定造成Membership卡住。显式指定K并调整等号方向后，第二次编译反向证明已通过；正向归纳tactic的 `extra targets` 改为直接 `refine Submodule.mul_induction_on hp ?_ ?_` 后，第三次编译整体通过。这些是同一路线的局部编译修正，没有失败的数学路线。

边界：未加I≠0、I≠⊤、E非空或有限余长假设。零理想/空E以及单位理想/指数0均保留。只有部分极小指数时只能得到正向，反向必须有hSpan。尚未在本文件构造商空间、商基、finrank或Tor/Betti接口。

### 代数核单模块验收证据

执行目录：`D:\project\ai4math\lean`。命令：`lake env lean WidthBounds/GeneratorQuotient.lean`。最后返回exit code 0；成功编译后源码冻结，SHA-256：`19ddb478058534f0e6a16b1655515138ab5ddc8a6a11c6c43a28b2036fe17fcc`。

```text
'WidthBounds.MonomialInterface.constantCoeff_eq_zero_of_mem_variableIdeal' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'WidthBounds.MonomialInterface.minimalCoefficientMap_eq_zero_of_mem_variableIdeal_mul' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'WidthBounds.MonomialInterface.mem_variableIdeal_mul_of_minimalCoefficientMap_eq_zero' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'WidthBounds.MonomialInterface.mem_variableIdeal_mul_monomialIdeal_iff' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```

源码扫描 `sorry|admit|native_decide|^axiom` 无匹配。仅三个标准逻辑公理，没有额外研究假设或自定义公理。R036执行者已审阅真实变量span、产品归纳、反向支持证明与零/单位边界并回传语义接受；最终独立审查和统一构建证据由R036与根维护。

结果分类：本节七个接口为**Lean已编译**。本执行者交付并停止；下一步由根将成员等价接R035的实际子商线性同构接口，完成商基、finrank和最少生成数识别，统一构建并更新状态、claims及检查点。没有新增Tor/Betti识别、半群归约、原创性声明、外部通讯或稿件覆盖。

## 根集成：实际商、基与维数

根新增 `lean/WidthBounds/GeneratorQuotientBounds.lean`，没有改写旧生成元证明。所有定义在WidthBounds.MonomialInterface命名空间。

1. `GeneratorQuotient I` 直接定义为R035的实际IdealSubquotient I (variableIdeal*I)。分母来自真实Ideal.span(range X)与真实理想乘积，独立于系数映射；已有variableIdeal_mul_le证明mI≤I，因此这正是I/mI，而非一般的I/(I∩J)误称I/J。
2. `minimalCoefficientMap_zero_iff_mem_product` 始终保留p∈I；`ker_generatorCoefficientMap` 把映射**限制在I上**后，证明其核等于真实mI拉回I的K子空间。没有把整个多项式空间上系数映射的核冒称mI。
3. `generatorQuotientEquiv` 使用已证明的实际成员等价与R031实际理想内原像，构造I/mI≃ₗ[K](E→K)。`generatorQuotientEquiv_mk`明确商代表元p的像就是其极小系数坐标。
4. `generatorQuotientBasis` 将标准坐标基沿逆同构传回；`generatorQuotientBasis_apply`证明每个基向量恰为原系数1极小单项式在I/mI中的商类，未停留在一个未识别的抽象基。
5. `generatorQuotient_finite` 单独证明实际I/mI作为K模有限。`finrank_generatorQuotient`给维数E.card，`generatorQuotient_finrank_isLeast`再接R031真正最少生成数。一般接口只需域、指数上集、有限极小单项式生成集合，不需lex、预算或A/I有限维。

最终 `finiteColength_generatorQuotient_bounds` 保留原模型的域、指数上集、lex、真实A/I的Module.Finite、x标准、w≥4及全部次数真实齐次商空间维数预算。它构造初始a≥2，证明

    dim_K(I/mI) = a+1+dim_K(xySubspace(A/I)) = a+1+ell = μ，

其中μ确为任意有限多项式生成系的最少基数，并给同一商维数的严格二项式界与精确有理谐和界：

    μ < binom(w+1,2)，
    μ ≤ 4w−1+(2w−1)H_(2w−1)。

没有把维数上界应用到任意冗余生成集合大小。一般商接口覆盖零理想和单位理想；将来Tor_1接口不能不加条件直接套一般结论，例如I=A时I/mI≅K，而Tor_1(A/I,K)=0。I⊆m条件和标准Tor定义的连接仍是后续工作。

## 最终构建与证据

在lean/运行 `lake build`，退出0；日志 `results/lean_generator_quotient_build.txt`，SHA-256 `2769b48af9a18b118648a98869a86059da0fd4db10b3115f275e5f566c81e8a1`。

根GeneratorQuotientBounds.lean SHA-256 `86d82364b1c98f05b4b521a26b06dd2c7df9b56a828cf43e4237a21508d5dee3`。执行者两个源码hash见本报告前文及R035；R036核对冻结源码和最终日志。

根五条#print axioms仅propext、Classical.choice、Quot.sound。新增ker_generatorCoefficientMap、generatorQuotientBasis_apply、finiteColength_generatorQuotient_bounds的实际传递声明依赖审计通过，不引用旧有限枚举/小宽度证书或sorryAx。源码禁止项扫描无命中。

根集成的编译修正：标准坐标函数的等号方向用eq_comm对齐；乘积成员判据补显式K/R类型参数解决实例推断。未添加研究假设，失败构建产生的占位诊断不属于最终源码或验证证据。目标修正后单文件与统一构建均通过。

下一项R037拟把真实(A/m)⊗[A]I与此商连接。本轮只定向读取已安装mathlib的张量商API和Tor定义文件，未实现新张量/Tor定理，计划不算成果。未改冻结PDF，无新枚举或对外动作，新颖性未认证。

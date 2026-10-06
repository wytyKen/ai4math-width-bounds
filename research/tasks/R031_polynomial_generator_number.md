# R031：任意多项式生成系的基数下界

状态：R031整体完成（2026-09-23）。系数映射、一般生成集合维数界、实际任意多项式生成系的最少基数及严格/谐和界已统一Lean编译通过，独立源码语义审查接受。以下保留初始计划及执行者证据，最终整体范围见末尾根集成验收。

目标：对实际域上单项式理想I及R028给出的全部整除极小指数有限集合E，证明任何有限**多项式**集合P若满足 `Ideal.span P=I`，都有 `E.card≤P.card`。结合已构造的系数1单项式集合，实现最少生成元数 `a+1+ell`，并保留与Betti/Tor定义的区别。

先读R028、R029、R030报告及 `GeneratorExact.lean`；旧的三类极小性、分类、真实span和精确计数无需重做。独占建议新文件 `lean/WidthBounds/PolynomialGeneratorNumber.lean` 与本报告。

候选路线（需要执行者实际证明，不能当作现有前提）：

1. 对属于I的多项式，提取E上各指数的系数，构造K线性映射 `I →ₗ[K] (E → K)`。每个极小单项式映为相应单位坐标，故映射满射。
2. 对任意q与p∈I、e∈E，证明 `coeff e (q*p)=constantCoeff(q)*coeff e p`。在乘积系数卷积中，p的每个非零支持指数f都在I；若f≤e，极小性迫使f=e，其余项为零。这里用真实 `mem_monomialIdeal_iff_support`，不只检查系数1单项式。
3. 若P生成实际理想I，由 `Ideal.span_induction` 或有限线性组合展开，证明P的这些系数向量在K上张成整个 `E → K`。P中元素属于I须从span等式推得。
4. 用有限维空间的张成族基数界得到 `E.card≤P.card`。此时才可与现有大小正好为E.card的生成集合合并，声明任意多项式生成系的最小基数。

可选替代路线：构造并识别 `I/(x,y,z)I` 的基，得到同一基数下界。不要在两条路线间反复重做；两次实质尝试没有新增进展时落盘障碍交根判断。

验收：实际多项式集合与Ideal.span，不能把P预先限制为单项式或齐次元素；单模块与统一构建通过，无禁止项，记录标准逻辑公理及证据hash。一般引理尽量不携带不必要的lex/预算假设，最终宽度推论再接已验收的模型条件。准确声明这仍非完整Tor/Betti和半群归约。

## R031系数子任务验收（2026-09-23）

本轮拆分：本报告与 `PolynomialGeneratorNumber.lean` 由 minimal_coefficients 独占；一般理想生成集合的线性维数论证移至R032，最终最小基数及宽度界由根集成。本子任务只验收系数卷积、常数作用、实际理想内坐标满射。

新文件已落盘，首次单模块编译通过。接口均位于 `WidthBounds.MonomialInterface`：

- `minimalCoefficientMap E : MvPolynomial (Fin 3) K →ₗ[K] (↥E → K)`，域K、有限指数集E；映射定义在全部多项式上。
- `coeff_mul_of_minimalExponent S hUp he hp q`：S为指数上集，e为monomialIdeal S的整除极小指数，p属于该理想；证明e处乘积系数等于q常数项乘p的e处系数。
- `minimalCoefficientMap_mul S hUp E hMin hp q`：逐坐标应用前条。
- `minimalCoefficientMap_exists_preimage_of_mem I E hMem v`：任意理想I，只假设各e∈E的系数1单项式属于I；显式构造p为有限单项式和。
- `minimalCoefficientMap_exists_preimage I E hMin v`：供集成的极小指数版本。

E不要求穷尽全部极小指数，没有非空假设、真理想假设或有限余长假设。满射是构造证明，不作额外研究假设。

### 证明机制与精确边界

系数乘法证明直接展开 `MvPolynomial.coeff_mul` 的指数反对角有限卷积。对于项 `(u,f)`，若p的f处系数为零则该项为零；否则通过实际 `mem_monomialIdeal_iff_support S hUp p` 推出f∈S，再通过 `monomial_mem_monomialIdeal_iff` 得到系数1单项式属于理想。关系u+f=e给出f≤e，e的整除极小性遂推出f=e；自然数指数加法消去给出u=0。因此只有 `(0,e)` 留下，且该项确实属于反对角集。

实际满射构造为 `p = ∑ e : ↥E, monomial e.val (v e)`。各项等于 `C (v e) * monomial e.val 1`，由理想乘法与有限和闭合得到p∈I；系数Kronecker公式与Subtype值单射给出F(p)=v。该证明不需要极小性，只需要所选系数1单项式的实际成员关系。

E为空时目标向量空间为零坐标函数空间，显式和为0且属于I；I为单位理想时，任何被允许选择的极小指数只能为0，卷积论证仍成立。源码没有额外排除这两类边界。

结果分类：上述一般系数命题为**Lean已编译**。尚未在本文件中证明任意多项式集合P的生成基数界；该步骤由R032与根集成。没有新增Tor/Betti识别、半群归约、原创性声明或外部审阅。

### 编译与证据

执行目录：`D:\project\ai4math\lean`。

```text
lake env lean WidthBounds/PolynomialGeneratorNumber.lean
exit code: 0
'WidthBounds.MonomialInterface.coeff_mul_of_minimalExponent' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.minimalCoefficientMap_mul' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.minimalCoefficientMap_exists_preimage_of_mem' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'WidthBounds.MonomialInterface.minimalCoefficientMap_exists_preimage' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```

源码SHA-256：`9d5b7aa03255d6121ee522f009b42c00f40e782e8ae04df74acef97dee777cb1`。这是首次通过时源码；打印公理仅三个标准逻辑公理，无自定义公理。禁止项扫描 `sorry|admit|native_decide|^axiom` 无匹配。编译后源码未修改；根将统一构建并保存集成日志及claims校验值。

本子任务沿单一卷积路线首次编译通过，无失败数学路线或待解技术障碍。R033执行者已逐行阅读并回传语义接受，认为真实support路线、反对角唯一项及显式满射正确；最终审查记录与统一证据由R033/根维护。

## 根集成：任意多项式生成集合的最少基数

新增 `lean/WidthBounds/GeneratorNumberBounds.lean`，未重构R025/R028旧证明。

`minimal_exponents_card_le_generators`：K为域，S为指数上集，E为任意有限整除极小指数集合。对每一个有限多项式集合P，只要其真实Ideal.span等于monomialIdeal S，就有E.card≤P.card。P没有单项式、齐次性或独立性假设；E甚至不必穷尽所有极小指数。这一通用下界无需lex、Hilbert预算或有限余长。

证明将R031实际minimalCoefficientMap代入R032：已有系数公式满足hMul，实际理想内原像构造满足hSurj，有限类型E的函数空间维数是E.card。显式有限维实例来自有限函数空间，没有用无穷维时也定义为零的finrank值冒充维数结论。

`generatorCardinalities I` 定义为所有自然数n，使某个任意有限多项式集合P满足Ideal.span P=I且P.card=n。`isLeast_generatorCardinalities_of_minimal_exponents` 将一般下界和实际单项式生成性组合，证明E.card是这个集合的IsLeast。IsLeast的成员部分给达到性，下界部分比较全部P，故本轮已经超越只删除所列项的不可删性。

`finiteColength_generator_number_bounds` 在域K、指数上集、lex、真实商环Module.Finite、x标准、w≥4及全部次数的真实齐次商空间维数预算条件下，构造真正初始a≥2，令

    μ = a+1+finrank_K(xySubspace I) = a+1+ell。

它证明μ是generatorCardinalities I的IsLeast，且

    μ < binom(w+1,2),
    μ ≤ 4w−1+(2w−1)H_(2w−1)。

第二式为精确有理数不等式，使用既有前缀预算给a≤w−2，既有Growth给ell≤3w+(2w−1)H，再相加。H由Growth.harmonicQ精确定义。未新建Real.log/Big-O/Theta接口。

**这两个上界针对最少生成数μ以及达到该数的构造集合，不声称所有含冗余项的生成集合大小都满足上界。**

## 最终统一验收

工作目录lean/，命令 `lake build`，退出0。日志 `results/lean_polynomial_generator_number_build.txt`，SHA-256 `b6b48e11dd968c672b3a8c6d9a656937e755c7a40421432a9b3431bb13be7ee1`。

GeneratorNumberBounds.lean SHA-256 `dd1be04554f6bac8af10f5bcf2268971a8e87e085658de8830a871218d095b45`。另两源码hash见执行者报告；R033核对全部冻结源码和最终日志。

根三条主定理只依赖propext、Classical.choice、Quot.sound。新一般下界及最终最少生成数定理已加入实际传递声明依赖审计，不含旧有限枚举/小宽度证书或sorryAx。源码禁止项检查无命中。

根辅助定义、谐和组合引理及主集成目标构建均首次通过；R032仅有finrank_top名称定位修正，数学路线没有失败或新增假设。日志首次hash读取遇到仍写入时的文件占用，待构建正常退出和关闭后才计算最终hash；未重复构建。

仍未完成：实际I/(x,y,z)I商空间识别、Tor/Betti定义接口、完整半群归约。下一项R034拟证明极小系数映射核为真实mI并构造商线性同构；计划不计入本轮已证明成果。新颖性未检索或认证，冻结PDF不改。

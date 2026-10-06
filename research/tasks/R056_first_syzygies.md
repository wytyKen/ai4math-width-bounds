# R056 实际第一关系生成与第二微分

日期：2026-09-30。状态：R056主实现及统一Lean构建通过，R073独立最终审查正式接受。本轮仅执行R056及其内部实现/审查，不启动R057或d3。

## 精确结果

令K为任意域，A=K[x,y,z]，I为原真实有限余长lex预算模型中的单项式理想。令a为真实初始纯x禁指数，n_i为全部xy标准列长度，ell为实际xy商子空间维数；t_(i,j)为真实z阈值。选用已证明生成I的完整极小边界集合E：纯x边界一个、xy边界a个、z边界ell个。R055的F1=(E→A)与d1保持原定义。

本轮构造有限关系指标

    J = Fin a ⊕ ((Σ i:Fin a, Fin(n i)) × Fin 2)

以及真实F2=(J→A)和A线性d2:F2→F1。其结论为：

- d1.comp d2=0，并且 **range(d2)=ker(d1)**，不是只有正包含。
- d2限制到R055的实际firstSyzygies=ker(d1)是满射；因此该关系模为有限生成A模。
- F2是实际有限自由/投射A模，`finrank A F2 = #J = a + 2Σ_(i<a)n_i = a+2ell`。
- 原全部次数实际预算及w≥4下，`finrank A F2 ≤ 2*choose(w+1,3)`。
- 同一个E的R055呈示、R056第二短复形均为真实Exact，并保留E的完整极小单项式分类与实际hSpan=I；F1的A秩仍为a+1+ell。

“a+2ell”是**所构造自由源F2的A秩和关系列指标数**。本项没有证明这组关系在模意义下极小，没有证明关系核自由、d2单射、d2经残差张量为零、Tor2维数、d3或完整有限ProjectiveResolution。A不是K，不能把上述A秩写成F2的有限K维数。

## 通用关系生成准则

[R071模块](../../lean/WidthBounds/MonomialRelationSpan.lean)以任意有限指数集合E为输入，不要求lex。对同时被两列u、v整除的共同多重次数d，定义真实向量

    rho(d,u,v) = single u (monomial(d-u,1)) - single v (monomial(d-v,1)).

先证明它在实际ker(d1)中，并证明u,v≤d≤D时

    monomial(D-d,1) • rho(d,u,v) = rho(D,u,v).

关键定理 `ker_differential_le_of_commonRelation`：若一个实际A子模N包含所有上述共同倍数差，则整个ker(d1)包含于N。它覆盖任意多项式系数向量，而非只证明单个次数或试验样本。

证明在实际K向量商F1/(N.restrictScalars K)中，为每个次数选择一个除子列的商类，按多项式单项式基延伸为K线性提升。共同倍数差属于N确保选择独立；单项式/多项式归纳及有限Pi分解证明lift(d1(c))=[c]。故d1(c)=0推出c∈N。这里**只构造K线性提升，不偷称A线性分裂**。

R071另给出了所有有限有序LCM pair关系列span=ker的通用结论，作为独立可复用接口；最终d2使用更小的边界相邻族，不使用该冗余pair数量代替a+2ell。

## 边界相邻关系和终止证明

[R072模块](../../lean/WidthBounds/BoundarySyzygies.lean)显式定义规范边界除子c(d)：先比较d的x坐标与a，再比较y坐标与对应n_i，否则取z阈值。逐项证明它属于E，并在monomial d∈I时整除d。

J的左支在每个xy边界配置一个x步骤；右支在每个z边界配置x、y两个步骤。每步有原列u、公共次数b和目标列v=c(b)，定义实际关系列rho(b,u,v)。源列与目标列都实际整除b；前者由坐标直接证明，后者由真实理想成员及规范除子定理证明。

任一u≤d若还不是c(d)，存在J中的一个可行step，其原列是u且b≤d。该step的目标使x坐标增加1，或保持x而使y增加1。边界都满足e0≤a、e1≤n0，因此自然数高度

    H(e) = (a-e0)*(n0+1) + (n0-e1)

严格下降。该下降、可行step存在性、全部边界分支（包括a=0的退化情形）均由Lean证明，不采用有限枚举截断。

## 全部核生成和真实第二微分

根的 [MonomialFirstSyzygies.lean](../../lean/WidthBounds/MonomialFirstSyzygies.lean)固定共同次数d，对上述自然数高度作强归纳。它对每个高度的全部u量化，step后保持target≤b≤d；由缩放公式把有限关系列抬到d，与后继到c(d)的关系相加，得到rho(d,u,c(d))属于相邻span。

两个列到同一c(d)的关系相减，得到每个rho(d,u,v)都属于相邻span。调用R071的任意多项式准则获得ker(d1)≤span；反向由每条关系实际在核里取得。因此 `boundaryRelationSpan_eq_ker`是实证的核生成定理，没有把待证核作为span或d2的定义。

`secondDifferential`是对J关系列的真实 `Fintype.linearCombination`；有single基向量作用公式。它的像先由一般range=span接口识别，再接上述实证span=ker。`secondPresentation_exact`是这两个真实映射的ModuleCat短复形正合性；`secondToFirstSyzygies_surjective`从同一d2像等式给实际codRestrict满射。有限性由有限自由源满射传递，不是核自由性的断言。

## 真实lex模型的参数提取与计数

`finiteColength_second_presentation_bounds`从实际A/I的Module.Finite得到纯z幂，由非零lex理想与x标准取得真实a及其最小性。n取已有columnLength，但全次数预算证明它刻画全部xy标准列；真实列和定理及finrank_xySubspace给Σn_i=ell。

同一个E由既有边界定理给hSpan与全部极小指数分类，连接R055呈示和本轮d2。J的基数由Fin/Sigma/Sum/Product的有限类型计数得a+2Σn_i，转成实际自由源A秩。旧组合第二界只用于最后的数值上界，完全不参与证明核生成或正合性。

边界一般引理可在I满足相应单项式成员、列和lex条件时使用；若I还有非单项式生成元，仅这些边界数据不会自动说明E生成整个I。因此真正A/I呈示的最终应用明确使用I=monomialIdeal S并证明hSpan；没有将一般边界关系定理扩大为任意非单项式理想的呈示。

最终主定理保留任意Field K、指数上集/lex、真实A/I有限维、x标准、w≥4与全部次数实际维数预算。没有特征零、泛型坐标、额外核自由性或未证明Tor比较假设。

## 源码入口和执行证据

| 文件或声明 | 作用 |
|---|---|
| MonomialRelationSpan.lean | commonRelation、缩放、通用全部核准则、可选LCM pair-span |
| BoundarySyzygies.lean | J及精确计数、规范除子、实际邻步、可行性与严格高度下降 |
| commonRelation_canonical_mem / boundaryRelationSpan_eq_ker | 归一化与真实全核生成 |
| secondDifferential / range_secondDifferential | 实际第二微分和像核等式 |
| secondPresentation_exact / secondToFirstSyzygies_surjective | 真实正合与到关系核的满射 |
| boundary_firstSyzygies_finite / boundary_secondFree_finrank | 关系模有限生成与自由源A秩 |
| finiteColength_second_presentation_bounds | 完整原lex预算模型的真实实例与秩界 |

最终在lean/执行 `lake build`，统一日志为 [lean_first_syzygies_build.txt](../../results/lean_first_syzygies_build.txt)，实际退出0，结尾Build completed successfully，无error/warning。三新模块19项命名公理输出仅propext、Classical.choice、Quot.sound；14个新增真实声明依赖审计根排除旧有限/小宽度证书和sorryAx。源码/日志hash汇总见 [r056_validation.json](../../results/r056_validation.json)。

R071/R072各自报告记录局部构建及实现修复；它们不代替根统一日志。根集成的归一化首次完整局部检查即通过；随后有限关系single公式补足DecidableEq J实例，最终主定理仅将未使用的Exists证明binder改名以消除告警。这些是类型/命名修正，不是放宽数学假设。

本轮保存了一次明确WIP检查点（统一构建/最终证据等待时）；其中旧聚合hash未更新是正常工作中状态，不作为本轮最终验收。最终稳定checkpoint在独立审查、claims和queue收束后创建。v0.3 PDF/TeX/ZIP与验收记录不改；旧证明正文保留，根import与DependencyAudit追加新入口，经过新统一构建才更新其证据。

独立审查为 [R073](R073_first_syzygies_review.md)，前两实现报告为 [R071](R071_monomial_relation_span.md)、[R072](R072_boundary_syzygies.md)。最多两个子智能体同时工作，实现者退出后才启动审查者；无递归派生、外搜、对外联系或发布。

## 停止边界

R056完成后停止。下一R057才处理d2的核、d3、后续正合及最小性/完整有限分解；R058才把这些真实分解接成目标高阶Tor公式。本轮的a+2ell是F2的A秩，不是关系核的自由秩，也不是已经验证的Tor2维数。所有后续任务保持parked，等待用户指令。

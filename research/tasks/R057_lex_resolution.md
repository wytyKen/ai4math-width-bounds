# R057 真实lex商的有限自由分解与残差最小性

日期：2026-09-30。状态：完整实际构造已统一Lean编译通过，R076独立正式接受。仅完成R057，不启动R058的高阶Tor计算或R059版本打包。

## 精确成果与假设

K为任意域，A=K[x,y,z]，m=(x,y,z)。在原实际有限余长lex预算模型中，保留I=monomialIdeal S、S上闭/lex、真实Module.Finite K(A/I)、x标准、w≥4与全部次数实际商维数累计预算。a为真实初始纯x禁指数，ell为实际完整xy商子空间维数。

本轮构造实际mathlib `ProjectiveResolution (ModuleCat.of A (A/I))`，不是一个假设已正合的矩阵列表。其具体形式为

    0 → F3 → F2 → F1 → A → A/I → 0,

其中F1沿用R055单项式列，F2沿用R056相邻关系列；F3以每个z边界一个指标构成有限函数自由模。已证明：

- 实际d3的像等于实际ker(d2)，且d3单射；d2d3=0和F2处Exact均有证明。
- 所有项为真实有限自由/投射A模；0、1、2、3次的A秩分别是1、a+1+ell、a+2ell、ell。
- 从第4次起是标准零对象，给出IsZero而非只写finrank=0。
- 增广的0次分量为原 `idealQuotientMap I`，即实际I.mkQ；增广quasiIso由各处正合与商Epi证明。
- 对任意i,j，实际 `residueTensorFunctor.map(P.complex.d i j)=0`，底环始终A、左因子始终实际A/m。

这里的“最小性”精确指**m残差微分全零**。没有另行注册完整graded shifts/分次最小分解API；不声称已计算标准Tor2/Tor3的K维数，也不将F_i的A秩冒称它本身的有限K维数。原半群到lex的归约及新颖性边界均不变。

## 基础工具与两变量关系

[R074](R074_resolution_degree_tools.md)交付 [PolynomialPairRelation](../../lean/WidthBounds/PolynomialPairRelation.lean) 与 [BoundaryResolutionDegree](../../lean/WidthBounds/BoundaryResolutionDegree.lean)。

对不同变量x_i,x_j，实际证明 x_i f+x_j g=0 时存在t，使f=x_j t、g=−x_i t。证明读取对应系数，先得f可被x_j整除，再以x_j非零和域上多项式的无零因子性消去。**没有错误假定(x_i,x_j)生成单位理想，也没有把IsCoprime当假设。**

坐标总次数coordinateTotal(e)=e0+e1+e2。每个边界相邻step的次数是source次数加1；lex性、真实列严格递减与z阈值移动证明target次数不大于source。由此实际d2各系数属于m，进而实际lTensor和标准残差张量函子的d2像为零。通用有限自由坐标张量工具证明：若一个向量的每个坐标属于m，则任何q∈A/m与它的真实纯张量为零；这也用于d3。

## 第三关系列怎样实际构造

根的 [BoundaryThirdDifferential](../../lean/WidthBounds/BoundaryThirdDifferential.lean)强化了R056归一化。对共同次数δ、次数上界B及B+1<total(δ)、total(u)≤B，构造真实系数向量c∈F2，使

    d2(c)=rho(δ,u,canonical(δ)).

它只使用source高度不超过u的关系，并且每个系数属于m。证明仍对已经验证的严格下降自然数高度归纳。单步系数是monomial(δ−stepDegree,1)；stepDegree≤B+1<total(δ)保证该单项式不是常数，递归步骤的target次数不增使IH可用。这同时证明支撑限制与系数条件，而不是只给抽象span成员。

每个z边界p=(i,j,t)取δ=(i+1,j+1,t)。令r_x、r_y为原来的x/y关系列，v_x、v_y为其规范目标。两目标次数≤原边界次数，故上述强化归一化可给c_x、c_y。它们的source支撑严格低于p，且各坐标在m；并有

    d2(c_y−c_x)=y r_x−x r_y.

因此明确构造

    face(p)=y e_(p,x)−x e_(p,y)−(c_y−c_x).

代码给出的 `exists_lexThirdColumn` 实际证明此向量被d2杀灭、具有正确的三角顶部坐标，且全部坐标属于m。`lexThirdColumn`只从这个已经证明的存在性中选取向量；它不是“随便选择ker(d2)元素并假设足够生成”。最初的条件准则中的hk/hf在最终实际构造中全部消除。

## 全部第二核与单射

[R075](R075_triangular_syzygies.md)的 [TriangularSecondSyzygies](../../lean/WidthBounds/TriangularSecondSyzygies.lean)先直接读取R056真实d2的顶部行。若更高source层的系数为零，xy边界行只剩一个x系数，z边界行只剩x*c_x+y*c_y。

对实际ker(d2)的任意多项式系数向量，按有限高度上界归纳：xy最高层系数被非零x消去；z最高层使用两变量关系给(y*t,−x*t)，同时减去该层所有t*face。三角支撑保证新向量只在更低层出现，且hk保证仍在核。这样获得全部ker，而不局限同次向量或有限实验。

单射则从第三系数向量的最高非零层看其x边坐标；三角结构只留下y乘该系数，y非零给矛盾。root把具体face的已证性质代入，得到 `range_lexThirdDifferential` 与 `lexThirdDifferential_injective`，并证明实际ModuleCat箭头Mono及第三短复形Exact。

这里解决的是ker(d2)。没有把更早的ker(d1)宣称为自由模，也没有通过改名来改变syzygy层数。

## 标准分解与原模型实例

[R077](R077_finite_resolution_packager.md)的 [FiniteThreeResolution](../../lean/WidthBounds/FiniteThreeResolution.lean)是一个明确有条件的通用打包器：输入实际三箭头、复合零、两处正合、顶端单射和商增广正合；自然数链复形的项为A,F1,F2,F3,0,…。正次数1/2由输入Exact，次数3由Mono d3，之后由中项零对象；0次用实际商正合和Epi，得到标准quasiIso。

根的 [LexQuotientResolution](../../lean/WidthBounds/LexQuotientResolution.lean)将所有条件替换为已证明的实际d1/d2/d3命题。最终 `finiteColength_exists_residue_minimal_resolution` 只接受原真实lex模型条件，**没有额外的“存在所需分解”“hk/hf”“未知正合性”等待证假设**。

实际a/n/hZ/hSpan沿用R056从真实理想、有限维和全部次数预算取得的数据。Σn_i=ell由已证明的F1秩等式和边界计数严格消去a+1取得；不是把ell定义成期望F3秩。F3的真实有限指标基数是Σn_i。自由/有限逐项实例对零尾项也建立，零尾项通过IsZero→Subsingleton再取得相应模块性质。

原d1残差零保留I≤m；原模型由x标准推出这个包含。d2/d3的残差零来自实际坐标在m。打包器对任意i,j保零性统一推导，不包括增广π本身，也没有暗用Tor两因子交换。原系数域与A/m标量来自既有真实代数嵌入/商，未从期望答案搬运标量作用。

## 验证与文件边界

最终统一命令：在lean/执行`lake build`。日志 [lean_lex_resolution_build.txt](../../results/lean_lex_resolution_build.txt) 实际退出0，无error/warning。六新模块35项命名公理输出仅propext、Classical.choice、Quot.sound；22个新增真实声明依赖根通过递归审计，排除旧有限/小宽度证书和sorryAx。

冻结文件/日志hash及当前假设范围见 [r057_validation.json](../../results/r057_validation.json)；独立最终审查见 [R076](R076_lex_resolution_review.md)。审查确认实际face、全部具体正合/单射、标准对象、自由/有限、秩、零尾项和残差零全部闭合，没有把条件子模块假装成最终证明。

实现中的修复包括：零对象实例的scoped导入、显式保留section命题参数、`exact_iff_mono`目标顺序、增广具体索引；这些已在通用打包器消除。root的实际face及具体d3首次完整局部编译通过。最终lex求和仅需把omega对定义别名I的处理改成明确的Nat.add_left_cancel(hr.symm.trans hRank1)，未弱化任何数学假设。

长任务期间保存过明确WIP；局部成功与条件打包器没有提前注册为整个R057完成。新增六个源码文件，旧证明正文保持原字节，根import/DependencyAudit追加入口；只有新统一构建成功后才更新相关聚合hash与最新日志。旧成功日志保留，v0.3 PDF/TeX/ZIP及验收原件不改。没有外搜、对外联系、上传、发表或工具链升级。

## 停止边界

R057完成后停止，下一R058才连接标准高阶Tor、真实K维数及宽度界；R059才考虑下一版本交付。当前只交真实有限自由标准分解与m残差微分全零，不声称原半群定理已端到端Lean化、完整graded shifts已注册或原创性已认证。

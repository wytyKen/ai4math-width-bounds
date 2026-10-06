# R076：R057真实lex有限自由分解及最小性独立审查

状态：正式接受，2026-09-30。已完成六个新增模块及最终实际lex实例的源码语义审查，并核对根智能体冻结源码与统一成功日志、公理和依赖审计。审查者仅拥有本报告，不改源码、queue或状态，不派生，不进入R058。下文保留初审过程，最终结论及冻结证据见末节。

## 恢复与审查证据范围

- 已读AGENTS、STATE、HANDOFF、queue、PROTOCOL及R057/R074/R075报告。STATE/HANDOFF仍是R056稳定交付口径；queue已登记本轮R057 running、R074/R075 review、R076 running，R058 parked。前者是待主线收尾更新的稳定入口，未据此否定本轮用户授权。
- `.venv\\Scripts\\python.exe -X utf8 -B scripts/checkpoint.py --check`退出0，queue_valid=true。
- `--verify-latest`退出0，归档`20260930T064756496849Z-befb8c1c`完整。工作区差异为queue及本轮新增源码/报告，属正常后续修改，不是归档损坏。此命令本身不检查Lean编译。
- 不重复全量build；只读源码、现有日志、哈希。新增三件冻结源码与各执行报告记录完全相符，详见下表。

| 文件 | SHA-256 |
|---|---|
| lean/WidthBounds/PolynomialPairRelation.lean | `246621dc7652262db3d3a3dd70db471f2037c517af8ace877c86a61b49a8041f` |
| lean/WidthBounds/BoundaryResolutionDegree.lean | `7ea223bec28ede3b2dd87a9346f3ff34e47a3cd7bacc2ceb1a8b89a87f7d475d` |
| lean/WidthBounds/TriangularSecondSyzygies.lean | `b1d6cdf45272938004df6936b09390ff2aa7c4f0f90998f472ced8f38ebb42f1` |
| tmp/r074_final_build.txt | `68dc8dcb1203304de2e1d927aea8adb47cd68b5d2af57867d6da69413b4f1767` |
| tmp/r075_final.txt | `8eb6776cfb61366b28dd417e517a80e319bab52cc27a533150af23b73852bab2` |

R074日志含Build completed successfully及R074_LAKE_EXIT_CODE=0；8项新增公理输出仅propext、Classical.choice、Quot.sound。R075日志含6项标准公理输出；退出0由执行报告记录，日志自身没有退出码尾记，最终统一日志还须独立涵盖该模块。三份源码均未发现sorry、admit、自定义axiom或native_decide。

## 已核：真实变量对关系

`PolynomialPairRelation.lean:16`的量词是任意Field K、i≠j、实际MvPolynomial(Fin 3)K中的f,g与方程`X i*f+X j*g=0`。结论为存在实际多项式t使`f=X j*t`且`g=-(X i*t)`；`polynomial_xy_relation`仅取i=0、j=1。

证明检查j坐标为0的每个d处`coeff (single i 1+d)`，利用变量不同使第二项系数为0，推出f的所有无j项系数为0。modMonomial逐系数为零给`X j ∣ f`，最后使用`X j≠0`与多项式环无零因子消去。没有使用`IsCoprime X0 X1`，没有声称(x,y)=A，也没有把需要的对关系作为额外假设。这部分语义接受。

## 已核：次数不增和真实d2残差零

`BoundaryResolutionDegree.lean:31`逐一展开真实xy/z边界step，证明stepDegree的总次数恰为source+1。`:50`在xy分支使用正列及严格下降，在z分支由j<n(i)得到z阈值为正，把一单位z移到x或y后仍在lex理想；canonical只依赖xy坐标，故目标总次数不超过source。这里使用hZ/hLex/hn/hInitial，不偷偷要求未知正合性或生成性。

`:102`只从total(e)<total(d)推出截断差d−e非零即可使该单项式落入变量理想，这个辅助引理不必假设e≤d；实际关系列的指数可除性则已经在旧R056成立。`:113`分别证明源项和目标项系数都在变量理想，再利用差封闭；因此不是仅证明某一项在m或依赖两项抵消。`:140`对任意系数向量求有限和，得实际d2每一输出坐标在m。

`:155`至`:216`以真实A/m、平衡张量关系和有限Pi.single展开证明实际lTensor为零，再通过ModuleCat.hom_ext得到既有`residueTensorFunctor.map secondDifferentialMap=0`。没有用维数或抽象同构代替零映射，因子次序为现有残差functor规定的次序，未进行Tor平衡。这部分语义接受。

## 已核：条件三角准则的完整核生成与单射

`TriangularSecondSyzygies.lean:50`精确定义的是坐标形状：若faceHeight p≤relationHeight r，则face p r在faceX p处为y、faceY p处为−x，其余为0。这把修正支撑限制到严格低层；同高度的不同face不会互相污染顶部坐标。它没有把kernel/Exact/自由性藏在定义中。

`:76`和`:97`通过真实源指数的x/y坐标分别证明xy源唯一和z源恰好对应两个指标。`:123`对真实d2逐列计算顶部行：目标如果等于高度H的源，则其关系源必有更高高度，因而系数已由支撑界消失。所得顶部方程是单个xy系数乘x，以及同一z源的x/y系数对。

`:228`的D3单射是对有限高度支撑归纳，从faceX p坐标得到`b p*y=0`，用y非零消去，最后由有限univ.sup提供任意b的初始支撑界；并未使用秩等式或hk。

`:262`的range(D3)=ker(D2)对任意实际多项式向量c归纳；最高层xy系数由x消去，z系数对通过已核的polynomial_xy_relation得到t，同时减去此层所有face以降低支撑。hk保证相减仍在核中；hf保证顶部确实被消去。有限sup给全核而非有界次数实验。准则证明语义接受，但它显式要求`hk : ∀p,D2(face p)=0`及hf；这两个尚需主线实际构造消除。

## 初审时的主线部分及验收风险清单（下列待验项现已关闭）

首次审查时`BoundaryThirdDifferential.lean`仅写到`exists_normalizingCoefficients`。该强化归一化的三项合同是：D2c为共同次数δ下u到canonical δ的真实关系；c只用源高度≤height(u)；每坐标属于m。归纳时目标严格降高且总次数不增，B+1<totalδ保证每步系数`monomial(δ−stepDegree)`为非恒定项。源码证明路线与合同一致，未引入错误单位理想假设。尚无本文件最终冻结/统一成功证据，本条只记语义检查。

首次审查时`LexQuotientResolution.lean`只有四项复形通用打包器，参数显式包含h21/h32、Exact at F1/F2、Mono d3与增广Exact。对象F0=A、F1/F2/F3给定，n≥4为零；增广为真实idealQuotientMap I。该条件helper的存在不能单独验收R057；主线报告也明确如此，当前不把尚未写完的部分列作最终缺陷。

最终冻结时必须逐项关闭以下待验项：

1. z边界u的实际D=u+x+y以及vx/vy的归一化合法性（vx/vy≤D、总次数≤total(u)、严格降高）必须全由真实边界证明。
2. face=`y e_rx−x e_ry−(c_y−c_x)`的符号必须与R056源减目标约定一致；D2face=0必须是实际相消定理。
3. hf必须由两条归一化的严格低支撑证明；face每坐标∈m必须包括顶部项和所有修正项，不能只检查矩阵头部。
4. 最终D3全核生成与单射入口必须代入具体face及已证hk/hf，最终定理不能残留假设的face族、Exact at F2或Mono d3。
5. `ProjectiveResolution (ModuleCat.of A (A ⧸ I))`必须使用上述真实D1/D2/D3、hSpan以及实际quotient增广；positive ExactAt、degree0 quasiIso、n≥4零尾项须全部闭合。
6. 每一项的有限自由/投射及F3秩ell要在真实指标上成立；有限A秩不能表述成有限K维数。
7. 全部实际链微分经现有residueTensorFunctor映射为零，必须覆盖D1、D2、D3及尾项；标准K作用沿用functor，不能依赖未证Tor交换或平衡。
8. 最终lex实例中的a/n/hZ/hSpan须来自原实际lex预算类，而非任意代入计数模型。
9. 统一成功日志、公理依赖与源码哈希对应；旧R056日志不能作新源码验证证据。保持R058未启动，不声称目标Tor2/Tor3维数已计算，不声称完整半群归约、新颖性或外部审阅已完成。

## 初审结论

冻结的R074/R075模块已完成独立源码语义审查，未发现实质缺陷。整个R057仍待主线实际face、有限分解和最小性完成后，以最终哈希和统一成功日志复核。审查者不修改其它文件或自行重建全项目。

## 最终复核：真实face及所有条件闭合

根智能体通知六份新源码停止写入后，重新读取并核对`BoundaryThirdDifferential.lean`、`FiniteThreeResolution.lean`、`LexQuotientResolution.lean`及R077报告。初审九项风险现全部关闭，没有发现需要修改源码的实质问题。

`BoundaryThirdDifferential.lean:150`的`exists_lexThirdColumn`对每个实际z边界p取u=source(faceX p)、δ=(i+1,j+1,zThreshold(i,j))及B=total(u)。δ总次数恰为B+2，故满足强化归一化需要的B+1<total(δ)。两个stepDegree分别≤δ，两个target分别≤stepDegree，且目标总次数≤B；归一化所需所有除性和次数前提都有具体证明。

设vx、vy为两个真实target，canon为δ的共同canonical，记共同次数关系为ρ。源码得到D2(cx)=ρ(vx,canon)、D2(cy)=ρ(vy,canon)，并证明y*r_x=ρ(u,vx)、x*r_y=ρ(u,vy)。因此

`y*r_x − x*r_y = ρ(vy,canon) − ρ(vx,canon) = D2(cy−cx)`，

所以`f=y*e_rx−x*e_ry−(cy−cx)`的负号正确，源码`map_sub`、`commonRelation_smul`及最后的交换群相消证明是真实核恒等式。不存在把某个desired cycle当假设的步骤。

两个target的高度均严格小于faceHeight(p)，归一化修正只支撑在各target高度以下或等高处；当relationHeight(r)≥faceHeight(p)时两修正坐标同时为零。这恰好推出三角条件要求的顶部y/−x及其它同层或更高层零。所有修正坐标由强化归一化落入m，顶部x/y由constantCoeff=0落入m，因此整个face所有坐标在m。`lexThirdColumn`的Classical.choose只从上述已证存在性选出列，其spec保留三个已证明性质；没有新增研究假设。

`:275`、`:286`、`:335`的`range_lexThirdDifferential`、`lexThirdDifferential_injective`和`lexThird_exact`都显式以实际lexThirdColumn及其spec调用R075。它们的外部参数只有I/hZ/a/n/hx/hLex/hn/hInitial，已无任意face族、hk、hf、未知Exact或未知Mono。`:316`的Mono实例来自具体注入定理，`:361`的残差零来自任意输出坐标在m的实际张量工具。`:371`从真实Σ指标和有限函数模求F3的A秩Σn_i，未使用期望Tor秩作为定义。

## 最终复核：标准分解、实际商增广及最小性口径

`FiniteThreeResolution.lean`的条件构造器已独立完成：0/1/2/3次对象分别为A/F1/F2/F3，n≥4是范畴零对象；相邻微分分别为d1/d2/d3/0，非相邻微分也按ChainComplex定义为零。正次数1、2正合来自传入Exact，次数3由零前项和Mono d3，次数≥4由零中项。0次quasiIso由实际商映射的正合及Epi证明，`resolution_π_f_zero`直接识别增广为idealQuotientMap I。每项自由、有限及投射包含真实零尾项，不通过finrank=0替代IsZero。

`LexQuotientResolution.lean:24`把F1=FreeModule K E、F2=(BoundaryRelationIndex→A)、F3=(BoundaryFaceIndex→A)和真实D1/D2/D3直接代入上述标准构造器。范畴顺序的`d2 ≫ d1 = 0`、`d3 ≫ d2 = 0`、两处positive Exact、实际Mono及增广Exact各自来自已证明定理；hSpan仅为有限边界确实生成实际I这一可见前提，最终lex实例会实际提供。结果类型为mathlib标准`ProjectiveResolution (ModuleCat.of A (A ⧸ I))`，并非同名自定义替代对象。

`:85`的`lexQuotientResolution_residue_d_zero`同时覆盖任意i,j：d1由实际I≤m和hSpan，d2由R074，d3由本轮具体face，尾项和非相邻项由函子保零。既有`residueTensorFunctor`确实定义为ModuleCat A中左张量实际A/m的函子，保留原第二因子分解路线和既有系数域作用；这里没有交换Tor因子，也没有把K维数为零代替映射为零。

本轮“最小性”的准确已证明内容是所有实际分解微分模m后为零。这是本项合同需要的残差最小性；源码没有注册完整graded shifts/graded-resolution API，也没有证明另一个全局最小分解唯一性定理，报告与交付不得扩大此口径。

## 最终复核：实际lex预算类及范围

`:98`的最终定理`finiteColength_exists_residue_minimal_resolution`以任意Field K、上集S、IsLexExponentSet S、实际A/monomialIdeal(S)的有限K维性、x标准、w≥4及所有次数实际累计维数预算为前提。它从R056已证明的`finiteColength_second_presentation_bounds`取得同一实际理想的a/n/hZ/hx/hn/hInitial/hSpan及a≥2；`monomialIdeal_isLex`和`monomialIdeal_le_variableIdeal_of_x_standard`提供余下具体前提。没有把次数预算或无限范围替换成枚举样本。

最终P实际由lexQuotientResolution构造。Σn_i=ell的桥从真实F1秩的两种表达式作自然数消去，其中ell就是`Module.finrank K (xySubspace I)`；所有0/1/2/3项秩分别为1、a+1+ell、a+2ell、ell。结论同时给出∀j Module.Free A与Module.Finite A、∀j IsZero(P.X(j+4))及∀i j residueTensorFunctor.map(P.d i j)=0，强于只检查三个矩阵头部。有限秩全部明确是A秩；没有声称这些自由项有限K维。

因此接受“真实lex商的标准有限自由分解、真实第三微分完整正合/单射、零尾项及m残差微分全零”。本轮未调用所选分解到标准高阶Tor的比较来计算Tor2/Tor3，R058仍须单独授权；完整四生成元半群归约、一般特征lex比较、新颖性及外部审阅均未由本项认证。

## 最终统一证据与正式接受

审查者没有重复build。根统一日志`results/lean_lex_resolution_build.txt`已结束，末尾为`Build completed successfully.`和`PROCESS_EXIT_CODE=0`；SHA-256为`6a5565d48176395e01ae0b91fec0653ee8e724213e6cb40056286d6347a58d34`。日志无error/warning。用根`.venv`只读解析，六新模块共35项公理输出全部仅标准三项；22个新增真实声明依赖根全部有成功输出。审查同时读取DependencyAudit的遍历代码，确认它检查声明的传递依赖、排除四个旧有限/小宽度证书根和sorryAx，不是只检查import列表。

此前R074/R075三源码hash保持本报告首表数值。后续冻结项如下：

| 文件 | SHA-256 |
|---|---|
| lean/WidthBounds/BoundaryThirdDifferential.lean | `c54459d2cc3b0646d5584f90d11061b9f800f11b1f0941b71e08942c0b06d025` |
| lean/WidthBounds/FiniteThreeResolution.lean | `f75552a79464e92a94f06c967813790fc218fa1c20a3f66a0b8289457ba47a30` |
| lean/WidthBounds/LexQuotientResolution.lean | `dcb068dc03511467532fe570047bfac9f02f32a241d5f1d9f90bdefb0541e951` |
| lean/WidthBounds.lean | `3d16cb197e8b2c0e9fba9e14284397882aa41d283e5489748f65c127f8fd3725` |
| lean/WidthBounds/DependencyAudit.lean | `cbfe35634a059e9f30da5da4420c414f32d0180f0d70c2419b8fa657bf311178` |
| tmp/r057/lex_resolution_build.log | `9369fd3dcf7e88967741f774f526ca79c9e94228776720ae48bef0138141c22a` |

三个后续源码同样无sorry/admit/自定义axiom/native_decide。局部定向日志仅作辅助；本次正式接受依据上述最终源码语义加统一成功日志。正式结论为R057有限合同接受、没有待修复的实质审查项。根智能体负责最终claims、STATE、HANDOFF、queue与稳定checkpoint；审查者完成本报告后停止。

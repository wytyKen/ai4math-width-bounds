# R068：R054 的 Koszul、有限同调维数与消失接口核查

日期：2026-09-30。执行者：`koszul_api_audit`。状态：审计与有限探针完成；不是高阶 Tor 证明。

## 范围与执行约束

仅固定 Lean/mathlib 4.22.0 本地源码；独占本报告、`research/probes/R054_koszul_api.lean`、`results/r054_koszul_api_probe.txt`。不改根 import、依赖或状态文件，不外搜、不下载缓存、不运行全库构建、不派生。完成可交接路线判断和小探针后停止，不启动 R055。

已读 AGENTS、STATE、HANDOFF、queue、NEXT_STAGE_PLAN、R053。根 `.venv` 的 checkpoint `--check` 返回 queue_valid=true；`--verify-latest` 返回 archive_valid=true，workspace.changed=true（本轮正常新增/修改），不是归档损坏。

## 有界检索计划与早期发现

1. 对 `lean/.lake/packages/mathlib/Mathlib/**/*.lean` 做内容检索，模式 `koszul|regularsequence|regular_sequence|regular sequence|euler.*(char|finrank)|finrank.*homology`，不只依文件名。
2. 对 `Algebra/Homology`、`Algebra/Category/ModuleCat` 和 `LinearAlgebra` 检查真实同调、正合、维数、有限性、零对象 API。
3. 对 `Algebra/MvPolynomial`、`RingTheory` 检查变量正则序列/变量商接口；对 mapping cone 与有限链复形构造比较成本。
4. 单独编译 `research/probes/R054_koszul_api.lean`，只确认现有 API 或完全证明的小实例，日志单独保存。

初搜：全 Mathlib 内容中 Koszul 的命中仅 `Algebra/Homology/LocalCohomology.lean:43` 的待实现说明与 `RingTheory/Regular/RegularSequence.lean:19` 的 TODO；已定位 `RingTheory.Sequence.IsRegular`、`IsWeaklyRegular` 的一般序列理论，但尚未找到三变量实例/复形正合定理。有限同调 Euler 尚未定位；`ShortComplex.moduleCatHomologyIso` 给真实 kernel/range 商，`LinearMap.finrank_range_add_finrank_ker` 提供维数骨架，因此不能把“未搜到 Euler”误报成无法证明有限 Euler。

## 检索边界和结论分级

下表统计以固定本地源码内容为准。命名检索不能逻辑排除所有另名实现，所以负结果始终写“未定位”，不写“全库绝无支持”。

| 范围 | 内容模式与结果 | 结论 |
|---|---|---|
| 全 Mathlib，6726 个 `.lean` | 不分大小写 `koszul`，仅2行命中：RegularSequence:19 TODO；LocalCohomology:43 future characterization | 未定位现成 Koszul 复形、正则序列 Koszul 正合或变量残差分解 |
| `Algebra/MvPolynomial` 与 `RingTheory/MvPolynomial`，35个 `.lean` | `IsWeaklyRegular|Sequence\.IsRegular|isRegular_cons|isWeaklyRegular_cons`，0行 | 未定位变量正则序列实例；另搜 `IsRegular` 定位单变量 `isRegular_X` |
| `Algebra/Homology`，102个 `.lean` | `finrank|euler|eulerCharacteristic`，0行 | 未定位现成同调有限维 Euler 定理 |
| `LinearAlgebra/ExteriorAlgebra`，3个 `.lean` | `koszul|homolog|complex|differential`，0行 | 外代数目录未提供已命名 Koszul differential 替代入口 |
| `Algebra` 和 `LinearAlgebra` | `finrank.*(exact|Exact)|exact.*finrank|shortExact.*finrank|finrank.*shortExact` | 有 `ModuleCat.free_shortExact_finrank_add`；一般搜索的其他多数命中只是证明中的 `exact` |
| `Algebra/Homology` | `isZero.*homology|homology.*isZero|exactAt` 以及 cone/shortExact内容 | 真实零同调、长正合及 cone 基础设施可用；不是自动的正则序列分解 |

四类使用约定：**可用**指语义与目标一致的现有接口；**局部可用**指有支撑构件而目标桥仍需证明；**未定位**指在上述检索范围没有找到；**需要新证**指具体缺少的任务命题，不能用现有名称顶替。

## 实际接口清单

以下 Mathlib 路径均相对 `lean/.lake/packages/mathlib/Mathlib/`；项目路径另明确写出。

| 分类 | 实际符号与路径:行 | 语义、假设与本任务界限 |
|---|---|---|
| 可用（已 #check） | `MvPolynomial.isRegular_X`，`Algebra/MvPolynomial/Basic.lean:804` | 任意 `CommSemiring R` 的单变量 X 是乘法正则元；这不是列表 `[x,y,z]` 在逐次商上的正则性 |
| 局部可用（源码核查） | `RingTheory.Sequence.IsWeaklyRegular` / `IsRegular`，`RingTheory/Regular/RegularSequence.lean:137,148` | 交换环上的模；前者逐个要求在以前元素生成子模的商上 `IsSMulRegular`，后者还要求最终商非零 |
| 局部可用（源码核查） | `RingTheory.Sequence.isRegular_cons_iff` / `isRegular_cons_iff'`，同文件:249,255；`IsRegular.recIterModByRegular` / `recIterModByRegularWithRing`，同文件:419,452 | 逐个取 `QuotSMulTop` 可递归正则性；需要真的构造变量商识别和剩余变量正则，且这里没有自动 Koszul 正合结论 |
| 局部可用（源码核查） | `MvPolynomial.killCompl`，`Algebra/MvPolynomial/Rename.lean:134`；`killCompl_comp_rename`:139 | 注入变量重命名的左逆，可用于去掉变量；该文件此处没有“kernel=被去掉变量的理想”的完整商识别定理 |
| 可用（既有项目） | `variableIdeal_eq_ker_constantCoeff`、`variableResidueEquiv`，`lean/WidthBounds/VariableResidue.lean:39,54` | 三变量全部取零后的实际 A/m≃ₐ[K]K 已有；不能据此跳过中间 A/(x)、A/(x,y) 所需的正则性 |
| 可用（已 #check） | `ChainComplex.of`，`Algebra/Homology/HomologicalComplex.lean:612` | 给对象 `X n`、`X(n+1)⟶X n` 和每个相邻复合为零，就得到实际 ℕ 链复形；需要新写具体微分及零尾项 |
| 可用（已 #check） | `ShortComplex.moduleCatMk`，`Algebra/Homology/ShortComplex/ModuleCat.lean:34` | 从实际线性映射与 `g.comp f=0` 构造 ModuleCat 短复形 |
| 可用（已 #check） | `ShortComplex.moduleCat_exact_iff_range_eq_ker`，同文件:53 | 正合性严格等价于实际线性映射 `range f = ker g`；不会替代证明该等式 |
| 可用（已编译小引理） | `ShortComplex.moduleCatLeftHomologyData` / `moduleCatHomologyIso`，同文件:99,171 | 实际范畴同调同构于 `ker g / range(moduleCatToCycles)`，域K下可用于维数与有限性；没有用自定义数值对象替代同调 |
| 可用（已 #check） | `Submodule.finrank_quotient_add_finrank`，`LinearAlgebra/Dimension/RankNullity.lean:208` | `[HasRankNullity R] [StrongRankCondition R] [Module.Finite R M]` 时 `dim(M/N)+dim N=dim M`；域K满足前两者 |
| 可用（已 #check） | `LinearMap.finrank_range_add_finrank_ker`，`LinearAlgebra/FiniteDimensional/Lemmas.lean:131` | 除环K、源有限维时 `dim(range f)+dim(ker f)=dim(source)`；不可忽略有限性 |
| 可用（源码核查） | `ModuleCat.free_shortExact_finrank_add`，`Algebra/Category/ModuleCat/Free.lean:177` | `S.ShortExact`、两端 `Module.Free`/`Module.Finite`、`StrongRankCondition` 及给定两端 finrank，则中项维数为和；在域上可用。不是任意复形 Euler 的现成定理 |
| 可用（源码核查） | `Module.finrank_pi_fintype`，`LinearAlgebra/Dimension/Constructions.lean:300` | 有限指标、各分量有限自由，有限积维数为和；张量后若已识别为 Q、Q³、Q³、Q，可得到 L、3L、3L、L |
| 可用（已编译小引理） | `ShortComplex.isZero_homology_of_isZero_X₂`，`Algebra/Homology/ShortComplex/Homology.lean:1102` | 中间对象本身为零则实际同调为零，不要求先用 finrank=0 反推 |
| 可用（已 #check） | `HomologicalComplex.ExactAt.isZero_homology`，`Algebra/Homology/ShortComplex/HomologicalComplex.lean:653` | 真实 ExactAt 给实际零同调；`K.homology i` 在同文件:84定义为 `(K.sc i).homology` |
| 局部可用（源码核查） | `HomologicalComplex.homotopyCofiber`，`Algebra/Homology/HomotopyCofiber.lean:219` | 任意适当复形形状可构造同伦余纤维；需要二元双积（`HasHomotopyCofiber`:46）和可判定形状关系。ModuleCat的双积不构成主要问题 |
| 局部可用（源码核查） | `CochainComplex.mappingCone`，`Algebra/Homology/HomotopyCategory/MappingCone.lean:52` | 该更丰富名字的接口用于 ℤ 上链复形；若以其为实现中心，还要处理与 ℕ 下链分解的索引/截断对应 |
| 局部可用（源码核查） | `ShortComplex.ShortExact.homology_exact₁/₂/₃`，`Algebra/Homology/HomologySequence.lean:288,293,308`；`δ`:277 | 阿贝尔范畴内真实复形短正合给同调长正合；递归 cone 还须构造相应短正合、识别连接映射，并使用变量商上的乘法单射 |
| 未定位／需要新证 | 三变量实际 Koszul 残差自由分解 | 具体微分、增广、核像相等、自由项、标准 ProjectiveResolution 打包没有现成全部闭合的入口 |
| 未定位／需要新证 | 有限链复形 Euler 总和 | 有足够线性代数构件；本轮只证明局部真实同调分解，不把整条三变量 Euler 或 Tor₂ 公式计作完成 |

## Euler 的精确拼接合同与编译证据

对 `S : ShortComplex (ModuleCat K)`，K任意域且中项有限维，探针完全证明：

1. `Module.Finite K S.homology`。需显式将 `moduleCatLeftHomologyData.H` 展开成核的商以让有限性实例被找到，再经真实同构运输。
2. `dim H(S) + dim range(S.moduleCatToCycles) + dim range(g) = dim S.X₂`。
3. 若源 `S.X₁` 也有限维，则第二项可换成通常的 `dim range(f)`。证明以 `LinearMap.ker_codRestrict`（`Algebra/Module/Submodule/Ker.lean:114`）和源上的两次 rank-nullity 比较维数。

第3项恰好是 Euler 所需的逐项分解：对有限链 `C₃→C₂→C₁→C₀`，记 `bᵢ=dim im dᵢ`、`hᵢ=dim Hᵢ`、`cᵢ=dim Cᵢ`，令边界 `b₀=b₄=0`，逐项有

```text
c₀ = h₀ + b₁
c₁ = h₁ + b₂ + b₁
c₂ = h₂ + b₃ + b₂
c₃ = h₃ + b₃
```

相加消去边界得到自然数加法版本

```text
h₀ + h₂ + c₁ + c₃ = h₁ + h₃ + c₀ + c₂.
```

这避免自然数截断减法。若链项确实为 Q、Q³、Q³、Q且Q有限维，则得到 `h₀+h₂=h₁+h₃`。再经过**尚未完成**的标准 Tor 比较、H₀=1、已知H₁与H₃=socle维数，才可得到目标H₂。以上四项在 ℕ 链端点的 `sc` 索引识别、零尾项、实际张量链项与Q积的同构仍是未来拼接任务；本轮没有证明其应用到Koszul或标准Tor。

高阶消失探针直接证明：若 `C : ChainComplex (ModuleCat K) ℕ` 且 `IsZero(C.X n)`，则 `IsZero(C.homology n)`。故有限分解完成后，对n≥4只需证明张量后链项为零并经标准比较运输，不必以无有限性保证的finrank=0代替零对象。

探针文件：`research/probes/R054_koszul_api.lean`。执行命令（cwd=`lean/`）：

```text
lake env lean ../research/probes/R054_koszul_api.lean
```

最终UTF-8日志为 `results/r054_koszul_api_probe.txt`，含 `PROCESS_EXIT_CODE=0`。四个命名小引理的 `#print axioms` 均只有 `[propext, Classical.choice, Quot.sound]`。导入仅既有 `WidthBounds.TorOneBounds` 与已缓存 `Mathlib.LinearAlgebra.FiniteDimensional.Lemmas`。未加入主根import，未改变既有数学文件。

探针曾遇两处局部 elaboration 问题：同调表示未展开导致有限性实例搜寻失败；自动 `simp` 未在展开后消去 codRestrict 的核。分别用显式 `change` 与显式核等式修复。最终源码及最终日志无 `sorry`、`admit`、自定义公理、`native_decide` 或 `sorryAx`；早期失败输出不作为证据。

缓存边界：`RegularSequence.olean` 和 `ModuleCat/Free.olean` 在本地预编译输出中未找到，所以这两项严格标“源码核查”，未为其新建缓存或声称编译可导入。本探针实际使用的导入成功；没有运行全 `lake build`、下载安装或外部检索。

## 显式三变量矩阵与递归 cone 的成本比较

两者都先要求真实残差自由分解；两者都不会自动解决当前标准Tor派生第二因子、而残差分解解析第一因子的方向问题。

| 比较项 | 显式长度3矩阵 | 递归 cone |
|---|---|---|
| 对象与符号 | `A,A³,A³,A`及≥4零项，可由 `ChainComplex.of`直接固定 | 逐步对乘x/y/z链映射取 `homotopyCofiber`；对象变成嵌套双积 |
| 微分平方为零 | d₁(a,b,c)=xa+yb+zc；d₂列按xy,xz,yz取(-y,x,0),(-z,0,x),(0,-z,y)；d₃(t)=(zt,-yt,xt)。有限交换环恒等式可直接检查 | 泛型cone自动管理微分符号与平方为零，但链映射、项同构和索引调整需写 |
| 正合性主成本 | 手证两个非平凡syzygy核像相等及顶端单射；变量整除/系数消去仍是实质代数工作 | 手证逐次变量商识别、正则序列和cone同调增量；需要把长正合及连接映射识别接起来 |
| 标准分解打包 | 有限ℕ链与增广接项目既有指定分解入口较直接 | `homotopyCofiber`可避免必用ℤ上链，但现成 `mappingCone`高层API集中于ℤ；有限支持、增广及ℕ分解打包仍需额外整理 |
| 后续socle/Euler | 两端微分和项维数一目了然，较少嵌套同构 | 需把最后的嵌套双积同构成1,3,3,1项再计算端点 |

若未来确实选择三变量Koszul备选，建议固定三变量显式矩阵为可审查的有限实现入口；目前没有足够证据认为开发泛型正则序列/cone理论会节省本项目总成本。该建议不是已经构造/证明上述矩阵分解。

## 对主路线和下一个有限合同的建议

同意根拟选“直接解析第二因子A/I”。本审计发现Euler与零对象基础设施不是主要阻断；Koszul路线真正新增的是实际残差分解以及与当前标准Tor派生方向的比较。既然另一审计已确认给定 `ProjectiveResolution(A/I)` 可计算现有标准Tor全部n，直接路线可先绕开这项额外比较。但直接路线仍须真的构造高阶syzygy及正合性，不能仅凭目标维数猜出自由项。

建议下一项仅在另获授权后接受如下有限合同（不把原R055名称当作已批准更广实现）：

1. 输入：域K、A=`MvPolynomial (Fin 3) K`、真实理想I、有限指数集E，其单项式全在I且 `span(exponentMonomials E)=I`；需要张量消失时明确I≤m。项目 `GeneratorExact.lean:140,155,192` 已给边界/有限余长类相应真实生成证据。
2. 定义F₁为有限自由A模（例如 `E→A`），d₁取单项式列；F₀=A，以既有 `idealQuotientMap I` 增广到A/I。
3. 验收 `range d₁=I=ker(I.mkQ)`，打包实际短复形的正合，记录 `FirstSyzygies := ker d₁`。`IdealExactSequence.lean:27,72,79`和 `ShortComplex.moduleCat_exact_iff_range_eq_ker` 可复用。
4. 证明经实际残差张量函子得到的d₁为零：d₁经I因子分解，再用 `TorOneBridge.lean:93` 的 `residueTensorFunctor_map_inclusion_eq_zero`，保留I≤m。
5. 独立核对有限自由项/投射实例、实际K标量来源、命题公理输出，日志必须验证新源码。
6. **停止点：** 此有限呈示验收后停；不声称 `FirstSyzygies`自由、不假设核秩就是a+2ell、不生成假分解、不宣称高阶Tor或v0.4完成。下一合同才选择实际syzygy生成和关系。

R068到此完成；只保留接口报告、有限编译探针和日志。队列、claims、统一结论与checkpoint由根集成；执行者停止。

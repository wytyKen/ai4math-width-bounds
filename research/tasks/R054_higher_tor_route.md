# R054 高阶 Tor 固定库接口核查与路线选择

日期：2026-09-30。状态：R054接口审计、选路与下一有限合同已验收。用户仅授权按顺序执行第一项，本任务完成后不自动启动R055。

## 已核对的起点

v0.3是固定冻结，当前科学主线仍以results/lean_lex_theta_build.txt和C001–C023为准。R052/R053只有计划及其依赖审查，不是高阶Tor证明。当前固定Lean/mathlib4.22.0；mathlib精确提交79e94a093aff4a60fb1b1f92d9681e407124c2ca。

要补的目标是在真实lex有限余长类中，将标准Tor1/2/3的K维数接成a+1+ell、a+2ell、ell，并有i≥4消失。现有Tor固定第一因子A/m、派生第二因子A/I。I≤m、实际K作用、Module.Finite和预算/lex条件必须按各命题所需保留，不能换定义消除缺口。

## 根的局部编译证据

探针research/probes/R054_root_api.lean已由固定环境中的`lake env lean ../research/probes/R054_root_api.lean`（工作目录lean/）通过。完整输出results/r054_root_api_probe.txt末尾记录PROCESS_EXIT_CODE=0。

1. `Finsupp.linearCombination`与`Fintype.linearCombination`确实是实际线性组合映射；`Finsupp.range_linearCombination`把其像接到真实Submodule.span。
2. 既有`monomialIdeal_exists_exact_minimal_exponents`、`span_boundary_exponentMonomials`和`monomial_mem_span_exponentMonomials_iff`接口可直接调用，分别提供全体极小指数/实际span、边界生成以及实际理想成员的整除描述。
3. 对有限指数集合E，`ModuleCat.of A (E → A)`的Projective实例由现有库自动合成，证明有限自由起点可直接使用。
4. `R054Probe.suppliedResolutionComputesTor`在**给定P:ProjectiveResolution(A/I)**之后，直接使用`P.isoLeftDerivedObj residueTensorFunctor n`，对每个n得到现有标准Tor与左张量P后的同调同构。没有交换因子、没有重新定义Tor，也没有构造P或证明其长度/秩。
5. 该条件同构的公理输出仅propext、Classical.choice、Quot.sound。探针不进入主根import，不当成高阶Betti已形式化。

运行封装先成功将Lean输出和退出码保存为UTF-8日志，随后打印到GBK控制台时出现UnicodeEncodeError。根重新读取已保存日志，确认Lean实际退出0；这是显示封装错误，不能与Lean编译失败混淆，也没有据此虚构一次统一lake build。

## 已定位的直接分解入口

`CategoryTheory.ProjectiveResolution`要求真实自然数链复形、每项投射、到目标单点复形的增广quasiIso。`ChosenResolution.resolution`虽可迭代任意投射核覆盖，未提供有限项、可数基数公式或终止性；不能以它直接推出所需三项维数。

第一有限实现单位可用现有完整极小生成集合E定义F1=(E→A)，g_e=monomial(e,1)，d1(c)=Σ_e c(e)g_e，epsilon:A→A/I为实际商映射。已有span定理与线性组合像定理支持建立range(d1)=I=ker(epsilon)，并定义真实FirstSyzygies=ker(d1)。这只是后续实现合同；R054没有证明该整合命题，更没有证明该核自由。

若未来直接解析A/I，关键尚缺的是显式后续微分、第一/第二syzygy穷尽、正合和最小性，而不是标准leftDerived的通用计算接口。全Mathlib .lean的有界内容检索未找到Eliahou/Kervaire、linear quotient、monomial/Taylor resolution、Scarf或strongly stable的专用现成实现；这是检索结果，不是不存在任何可组合替代方案的全局定理。

## 并行审计

R068独占审计Koszul、正则序列、ModuleCat同调/有限维数/Euler与消失；R069独占审计标准Tor比较、双复形/维数移位和直接分解可用性。具体符号、行号、检索范围、编译探针和最终判断见对应报告。本轮最多两个子智能体同时工作，不派生。两个子项已冻结，并分别复核根的选路和下一合同，无阻断。

## 接口结论表

完整检索和精确行号见R068/R069。本表区分已编译探针和仅源码核查；未定位不等于对整库不可能性的证明。

| 所需接口 | 固定4.22.0结果 | 证据强度与用途 |
|---|---|---|
| 标准Tor与Tor'定义 | CategoryTheory/Monoidal/Tor.lean:40/46分别派生第二/第一因子 | 已读源码；现有Tor正是前者 |
| 用所给分解计算任意次leftDerived | CategoryTheory/Abelian/LeftDerived.lean:106 ProjectiveResolution.isoLeftDerivedObj | 根条件同构探针已编译；要求分解的目标是实际第二因子 |
| 分解间比较/同伦 | CategoryTheory/Abelian/Projective/Resolution.lean中的lift、homotopyEquiv等 | 能比较同一目标的投射分解，不是任意两因子的平衡 |
| 第一Tor核计算 | 本项目DerivedKernel.isoLeftDerivedOne | 已有主线结果，只处理一阶，不给有限高阶分解 |
| 实际有限自由生成映射 | Fintype.linearCombination与range_linearCombination；项目完整极小E及span | 现有接口、投射实例探针可用，适合下一有限呈示任务 |
| Koszul复形及正则序列到正合分解 | 全库内容搜索Koszul仅发现TODO/注释；有一般Sequence.IsRegular和变量单元素isRegular_X | 没定位现成完整Koszul链，不仅是缺少某个缓存文件 |
| 标准Tor与Tor'平衡/交换 | Tor实际使用位置、派生及同调目录搜索未定位所需标准比较 | 普通张量交换、同伦/total flip不够；若坚持Koszul先解析残差域需新补比较 |
| 双复形/total/张量复形 | HomologicalComplex₂.total、totalFlipIso、HomologicalComplex.tensorObj等存在 | 仅构造/对称/同伦相容，不自动给行列正合所需的total准同构坍缩 |
| 正合/平坦性工具 | 链同调长正合、Module.Flat张量保持短复形Exact等存在 | 源码核对；整段ShortExact还需相应Mono/Epi，不等于当前Tor functor的长正合/维数移位已接好 |
| 有限维同调与Euler积木 | ShortComplex.moduleCatHomologyIso、商维数加法、range/ker维数加法 | 可组合为局部维数分解；完整有界复形Euler仍需整合边界和逐项有限性 |
| 高阶消失 | 零链项给实际同调IsZero；Tor在其被派生因子投射时的消失已存在 | 必须对实际分解证明高次项为零，不能把finrank=0当无条件替代 |
| 完整lex有限分解 | 未定位专用EK/线性quotients/单项式分解成品 | 直接路线仍要新证syzygy与正合，不能称现成可一键完成 |

若某模块源码存在但olean未缓存，本次标为“源码核查”，不报成“接口不存在”。没有为审计拉取大量缓存、升级mathlib或运行完整lake build。

## 路线决定

**选择直接解析第二因子A/I，Koszul残差域路线降为备选。** 这是按当前库能力和现有项目积木作出的工程/证明组织决策，不是说另一条数学路线错误，也不承诺整条直接分解容易完成。

理由如下。两条路线都需要新建专用的有限正合分解；Koszul路线还需要把解析第一因子的结果连接到当前派生第二因子的标准Tor。相较之下，对A/I构造真实有限分解后，已经编译确认的ProjectiveResolution.isoLeftDerivedObj可以直接使用，保留现有因子顺序与左残差张量。这让新工作集中在目标lex理想的syzygy，而不先开展一套通用平衡理论。

直接路线后续的候选结构是按完整极小单项式分层构造自由项与关系，利用有序生成集合、真实colon或显式约化来证明关系穷尽。已有边界集合区分纯x、xy、含z三类；目标自由项秩为1、a+1+ell、a+2ell、ell。**这些后两秩和具体微分只是待实现目标，当前没有对应正合分解。** 不预先假定线性quotients公式，也不把列计数作为标准Tor的定义。

在主路线中，完整Koszul、Tor因子交换、socle/Euler不再是v0.4的先行必修。已有相应局部线性代数探针仍可用于后续检查或备选；删去实现依赖不代表这些未完成定理已经自动成立。

## 下一有限任务R055的精确合同

建议将原计划中“完整Koszul残差自由分解”的R055替换为**实际有限自由呈示与第一syzygy入口**，并保留parked，等待用户另行指令。

输入分为两层：一般接口只需任意域K、A=K[x,y,z]、真实理想I、有限指数集`E : Finset (Fin 3 →₀ ℕ)`及实际等式`Ideal.span(exponentMonomials E)=I`（明确I由这组单项式生成）；最小性/最终lex特化使用已有完整极小E。需张量d1为零时保留I≤m，不能随之删去properness。预算与有限余长不强塞进一般呈示引理，而在从既有lex模型提取E时按需使用。

建议独占文件为`lean/WidthBounds/FiniteMonomialPresentation.lean`与`research/tasks/R055_finite_presentation.md`。根负责import和最终统一日志。

必须完成的接口：

1. 定义F1=(E→A)及真实A线性映射d1(c)=Σ_e c(e)*monomial(e,1)，有基向量作用公式；不是任意存在的投射覆盖。
2. 从实际span等式证明range(d1)=I，并接epsilon=I.mkQ的kernel，给真实ShortComplex `F1→A→A/I` 的Exact和epsilon的Epi。记录F1和A投射，**不假定F1→A单射或短正合**。
3. 把d1实际限制到I，证明其满射；定义真实FirstSyzygies=ker(d1)，连接限制映射与标准kernel。这个核一般不必自由；不得宣布自由基或高阶项已得到。
4. 在I≤m下证明残差张量后的d1为零，给标准张量映射及纯张量作用验证，保留原K作用。可复用已有tensorInclusion为零的结果，但需证明d1的真实分解/映射相容。
5. 由完整极小E的旧接口给有限自由项的明确指标数，并在实际lex模型中得到E.card=a+1+ell。这里说自由项秩/残差张量维数，不是把A^E当有限维K空间。

验收：单模块/根统一构建、公理和实际依赖检查通过；报告清楚止于呈示、核对象和首微分张量零。**R055不要求证明ker(d1)自由、构造d2/d3、给完整有限ProjectiveResolution或声称Tor2/3已完成。** 完成后单独检查点并停止该项；两次实质尝试无新接口则落盘具体卡点，禁止以新增公理跳过。

## 后续排程怎样调整

只调整待启动任务的目标，不现在执行：

- R056：构造实际第一syzygy的有限候选生成系和d2，证明range(d2)=ker(d1)及所需计数；若选colon/有序约化，先证明该真实理想/模中的关系。未完成正合不得只交数量公式。
- R057：构造后续关系d3并证明剩余正合/终止，形成实际有限ProjectiveResolution(A/I)；证明各正次数微分经A/m张量为零及必要基/自由性。若这仍过大，先拆出一个可验收具体关系引理，不自动新增无限任务。
- R058：使用标准isoLeftDerivedObj在正确第二因子上计算同调，沿真实algebraMap限制到K，证明有限性、精确Tor维数和高阶零对象，再接旧组合三界。
- R059：独立语义审查、统一构建和v0.4冻结标准不变。

原NEXT_STAGE_PLAN保留其规划时的候选路线记录；本R054审计决定与queue/STATE/HANDOFF是之后实施的依据。完整半群R060–R067仍parked，预算/因子顺序和新颖性边界不变。本次也没有把抽象lex下界倒推为半群下界。

## 最终验收与停止

R068/R069分别完成固定库审计及独立局部探针，均接受根的路线和R055有限合同。R069建议精确区分“Flat保持短复形Exact”和“整段ShortExact”，并明确E是有限指数集合及真实单项式span；根已修正文。R068确认Euler基础不是主要阻断，但有限复形整体拼接/Koszul应用仍未完成。

三份探针最终实际退出码均0，共8项命名声明的公理输出仅标准三项；无error、warning或sorryAx。它们不进入主根import，不是完整v0.4。完整源码/日志hash及范围汇总见 [r054_api_validation.json](../../results/r054_api_validation.json)。两个子报告分别为 [R068](R068_koszul_api_audit.md)、[R069](R069_tor_api_audit.md)。

根核对v0.3的50个lean/项目文件仍逐字节相同，固定mathlib HEAD与锁定提交一致且tracked diff为空；原冻结ZIP hash不变，既有claims所有证据匹配。未运行主线全lake build，未修改原数学证明；只新增独立接口探针。本次没有外部文献检索、联系或发布。

R054、R068、R069标done并停止。R055按新有限呈示合同保持parked；其后任务仅调整待实施路线，不执行。保存新的稳定工作checkpoint后等待用户下一条指令。

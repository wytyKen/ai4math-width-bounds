# R040：标准Tor₁与真实生成元张量纤维的连接

日期：2026-09-29（Asia/Shanghai）。状态：R040完整标准Tor1识别及K线性维数/界已统一Lean构建通过，最终审查证据见R043。R041/R042基础接口与根集成都已完成；本轮任何时刻最多两个子智能体并行。原计划及WIP历史保留以追溯范围，最终结论见文末。

目标：对A=K[x,y,z]、m=(x,y,z)和实际理想I≤m，连接mathlib标准 `CategoryTheory.Tor (ModuleCat A) 1` 的对象与真实 `(A/m) ⊗[A] I`，继而使用已完成的生成元商/最少数界。不可自行定义Tor或Betti为当前维数来替代证明。

建议文件：`lean/WidthBounds/TorOneBridge.lean`、本报告。先读R037/R038/R039报告及GeneratorTensorFiber/GeneratorTensorBounds/VariableResidue三个新模块。它们已经解决底层张量和系数域结构，但没有处理派生函子。

## 已核对的本地API线索（尚非本任务成果）

- `Mathlib/CategoryTheory/Monoidal/Tor.lean` 定义Tor为固定第一因子后，对第二因子张量函子的左派生；因此优先精确固定目标 `((Tor (ModuleCat A) 1).obj (ModuleCat.of A (A/m))).obj (ModuleCat.of A (A/I))`，不暗用未证明的Tor平衡性或两因子交换。
- `Mathlib/CategoryTheory/Abelian/LeftDerived.lean` 的 `ProjectiveResolution.isoLeftDerivedObj` 可用一个实际选定的projective resolution计算标准派生函子。
- `Mathlib/CategoryTheory/Abelian/Projective/Resolution.lean` 提供从projective对象到目标的epi开始的 `ProjectiveResolution.of` 及低次微分公式；`Algebra/Category/ModuleCat/Projective.lean` 提供足够projectives及自由模projective实例。
- 根对当前安装版本的定向源码搜索未定位到可直接调用的低次Tor长正合序列接口；这不是断言库中绝对没有，开始执行时做一次有限、针对性的API审查即可，不要无限搜索。

## 建议可验收拆分

1. 在实际ModuleCat A中构造短正合序列 `0→I→A→A/I→0`，并证明I≤m时残差张量后的包含映射 `(A/m)⊗I→(A/m)⊗A` 为零。R037已提供主模型I≤m及真实张量公式，不应再假设零映射结论。
2. 选已有低次派生正合接口，或使用以A→A/I为首项的实际projective resolution，连接标准Tor对象与该张量映射的核。若走resolution路线，必须用isoLeftDerivedObj完成标准定义连接，不能只算一个无来源复形的同调。
3. 在I≤m下将该核识别为整个生成元张量纤维，核对K线性结构以及A模结构通过常数项因子化。最后再给对应维数界；此时才可标注实际Tor₁定理完成。

边界：I=A的通用张量维数为1，但Tor₁(A/I,K)=0，故I≤m条件不可省略。A/I不是I、张量底环始终A、理想与商的Betti下标差1。非lex的一般同调接口不必携带Hilbert预算，最终宽度推论再加入旧模型条件。

验收：标准mathlib派生对象、真实理想短正合序列、核/张量同构及标量结构均实际证明，模块与统一构建通过；无禁止项。若本轮只能闭合步骤1，作为明确子里程碑报告并保持本任务未完成，记录标准Tor接口的精确缺口；不要把局部有限命题称完整同调归约。两次实质路线无进展时落盘障碍交根，不凭聊天反复重做。半群的全部代数归约和更高Betti数仍另行处理。

## 恢复与阶段进度（WIP）

用户新指示“继续”恢复研究，根检查checkpoint归档完整且初始工作区无差异。中途主动中断后原执行者消失，R041/R042只有计划报告、没有Lean源码，根TorOneBridge草稿已有。根核对文件与进程后按原独占任务重新委派，没有删除原计划或重做已验收证明。

根已单独编译真实 `residueTensorInclusion_eq_zero` 与实际单项式特例，得到I≤m时I.subtype.lTensor(A/m)=0，公理仅标准三项。证明对纯张量应用TensorProduct.rid，再由p∈I⊆m证明其残差类为零。初稿TensorProduct.ext的层级及宽泛map_zero实例推断造成技术错误，改用ext'及显式rid/LinearEquiv.map_zero后通过。此结果本身不识别Tor。

为后续标准对象加入CategoryTheory.Tor的精确别名，固定第一因子A/m、第二因子A/I并在第二因子派生；该声明和新kernel=top推论尚待同调依赖构建后编译。根集中补建固定mathlib4.22.0的Tor/ModuleCat.Projective/Monoidal.Basic依赖缓存，未修改配置或版本。

校正原计划API表述：当前ProjectiveResolution.of的实现固定首项Projective.over X和Projective.π X；不能直接把给定A→A/I传给它。R041按相同syzygy递推另构造给定epi开头的标准ProjectiveResolution，再调用isoLeftDerivedObj。

## 2026-09-29续接节点（WIP）

根核对旧稳定归档完整，既有R041/R042源码均存在但未统一验收，旧执行者与旧进程已不存在；按新用户指示最多同时两个子智能体续接。原R043纸面/API审查保留。先由R041派生核实现和R042真实核实现并行，R042结束后才启动独立审查，未出现第三个同时活动执行者。

R041已编译给定projective epi的标准ProjectiveResolution及泛型isoLeftDerivedOne；R042已编译真实ShortExact、标准kernel q≅I及包含兼容。根补明确ModuleCat.Abelian与Monoidal.Closed import，从标准残差tensor functor的左伴随性推保余极限，证明其映实际包含与标准kernel.ι均为零。

`idealQuotientTorOneIsoTensor` 已在目标lake build退出0：来源严格是mathlib `Tor (ModuleCat A) 1`，固定A/m第一因子，在A/I第二因子派生；经DerivedKernel.isoLeftDerivedOne得到F(kernel q)，再F.mapIso实际kernel≅I得到真实fiber。该同构不是用纤维重定义Tor，也没有假设I投射或暗用Tor平衡性。

K作用在TorOneBounds中使用ModuleCat.restrictScalars(algebraMap K A)，并以恒等映射和IsScalarTower.algebraMap_smul证明与现有TensorFiber的K作用相容。最初显式change的目标因源/目标同型但Module实例不同而失败，改为给该库lemma明确M参数后helper编译通过。当前正在编译完整K-linear同构、Tor基与精确维数/最少数/两个界；未统一验收前整体R040仍running。

## 完整R040结果（2026-09-29）

令A=K[x,y,z]，m为真实变量理想，I为实际理想。对I≤m，已经证明

    Tor₁ᴬ(A/m,A/I) ≅ (A/m)⊗[A]I。

左侧严格是mathlib标准 `CategoryTheory.Tor (ModuleCat A) 1`，固定A/m第一因子、在A/I第二因子派生；没有使用未形式化的平衡性或交换两因子。`IdealQuotientTorOne`只是标准对象的缩写，绝不是以生成数或目标纤维定义Tor。

### 标准定义到实际对象的证明链

1. R042的 `idealQuotientShortExact` 使用实际I.subtype与I.mkQ证明I→A→A/I短正合；A自由秩一而投射。`idealQuotientKernelIso`由真实核泛性质识别标准kernel q为I，并证明包含映射兼容。
2. R041 `ChosenResolution.resolution`从给定projective epi开始构造标准ProjectiveResolution，证明全部项投射及实际增广quasiIso。没有假设I本身投射。
3. R041 `DerivedKernel.isoLeftDerivedOne` 用实际两次syzygy微分呈示kernel q，证明其余核泛性质；additive、保有限余极限的F保留该余核。F(kernel.ι q)=0时，同调数据给H₁=F(kernel q)，再显式接 `ProjectiveResolution.isoLeftDerivedObj` 到标准左派生对象。
4. 根 `residueTensorFunctor` 是实际左张量A/m；ModuleCat的MonoidalClosed左伴随性证明它保余极限，而非将右正合性作为未经证明假设。I≤m使实际张量包含为零，核同构兼容进一步给F(kernel.ι q)=0。
5. `idealQuotientTorOneIsoTensor` 实际代入泛型标准派生接口，再串接F.mapIso(kernel q≅I)，得到真正A模同构到实际GeneratorTensorFiber。
6. `IdealQuotientTorOneK` 沿真实algebraMap K A限制标准Tor对象的标量。`idealQuotientTorOneEquivTensor`把A模iso限制到K，再接底层恒等且由IsScalarTower证明兼容的自然K等价；没有从目标反向搬运任意K作用。

### 基、有限维、最少数与宽度界

对完整有限极小单项式生成集合E，`torOneBasis`是真正标准Tor对象的基，`torOneBasis_toTensor`证明对应的向量为原极小生成单项式的1⊗g。单独证明Module.Finite，再给finrank=E.card以及任意有限多项式生成集合基数的IsLeast。

`finiteColength_torOne_bounds`在既有域、指数上集、lex、真实A/I有限维、x标准、w≥4和所有次数真实齐次商空间维数预算下，从x标准推必需的I≤m，证明标准Tor₁的K维数

    dim_K Tor₁ᴬ(A/m,A/I) = μ = a+1+dim_K(xySubspace(A/I)) = a+1+ell，

并且

    dim_K Tor₁ᴬ(A/m,A/I) < binom(w+1,2)，
    dim_K Tor₁ᴬ(A/m,A/I) ≤ 4w−1+(2w−1)H_(2w−1)。

谐和界仍是精确有理数不等式。上界针对该标准Tor维数/最少数，不针对冗余生成集合大小。

### 验收与范围

统一命令为lean/目录 `lake build`，实际退出0，日志关闭后读取末尾Build completed successfully。日志 `results/lean_tor_one_build.txt`，SHA-256 `7eb47d1cd5e03bcda8111aab5e042bb09748405217834ca04696b02cbbaf434c`。

冻结根源码：TorOneBridge `b10879dc685babd693f24e0cd2b9c807d7e317851898f882cfbc899053173dd3`；TorOneBounds `046329559b46108404a8b5c2d67c556661acf61c2e6fc2354059608cf6b9dfbe`。R041/R042源码hash见各报告，R043独立核对全部五源码和最终日志。

五新增模块共22项公理输出仅propext、Classical.choice、Quot.sound；禁止项无命中。实际传递声明依赖审计新增泛型派生核iso、标准Tor A模iso、K线性iso、Tor基到真实张量公式、最终Tor维数界五个根，全部排除旧有限证书和sorryAx。

本轮修复了原WIP的实际import缺口（ModuleCat.Abelian）、标准分解增广零次化简、映后短复形低次微分显式同构及K限制标量实例推断。固定Lean/mathlib4.22.0未变，只补建项目内所需缓存。旧报告没有丢弃，没有把任何失败编译或WIP哈希当最终证据。

R040至此完整闭合，不再只是“张量包含为零”阶段。仍未形式化：标准Tor两因子交换、更高阶Tor/Betti公式、从四生成元数值半群到此lex模型的完整归约，以及半群匹配下界。本一般iso保留I≤m；单位理想I=A不满足该条件，不能反用旧通用张量等式得到错误Tor结论。无新颖性认证、外部专家审稿或对外动作；冻结v0.1/v0.2未修改。

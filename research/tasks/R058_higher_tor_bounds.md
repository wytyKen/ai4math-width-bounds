# R058 标准高阶Tor与宽度界

2026-10-01。状态：完成；统一Lean构建及R082独立正式验收通过。用户本轮授权本项，R059及以后不启动。已恢复R057稳定证据，归档有效且原工作区无变化。

分工：R080证明实际残差张量有限自由维数桥；R081证明标准Tor到零微分张量项的同构；根集成到原lex模型和全部宽度界、审计及独立复核。不得改写旧成功证据。

## 根实现草稿（开发过程记录）

HigherTorBounds已落盘：通用P的K有限性/finrank桥、无预算的真实boundary数据Tor四维数与零尾、原有限余长模型全部维数与三宽度界、所有正次数不等式。initialExponent_unique已单独局部编译，用于证明宽度定理的a与分解的a一致；当时其余接口尚待R080/R081；最终成功证据见下节。

## 已验收的精确链条与边界

标准对象是 mathlib `CategoryTheory.Tor (ModuleCat A) n` 的第一变量 A/m、第二变量 A/I；K对象仅沿实际 algebraMap K A 限制标量。R081先用P.isoLeftDerivedObj到F(P)的真实同调，再以ShortComplex.HomologyData.ofZeros同构到真实F(P_n)。R080给该真实残差张量的有限坐标等价：选定有限自由A基，以标准张量基变换到A/m系数，经过已证明variableResidueEquiv到K系数；不假定自由项本身K有限。

根的新通用引理只要求给定实际P、全部残差微分零及所讨论项A有限自由。无预算的lexQuotient_tor_dimensions则对R057已经具体构造的P实例化，明确保留I≤m和真实boundary数据/hSpan，给0..3维数1,a+1+Σn_i,a+2Σn_i,Σn_i以及4次起实际IsZero。

原模型入口finiteColength_higherTor_dimensions保留任意Field K、上集/lex、实际Module.Finite K(A/I)、x标准、w≥4、全部次数实际商齐次维数预算。其ell为真实xySubspace的K维数，来自R057的已证明秩，不新定义ell或Tor。全部Tor次数先得到K有限性；0..3为1,a+1+ell,a+2ell,ell；高次给IsZero，另由标准对象零性推K维数0。

finiteColength_higherTor_width_bounds将既有真实维数三界接到标准Tor；分解与组合界各自给出的a通过首个纯x禁指数的唯一性匹配。finiteColength_tor_all_positive_bounds合并i=1,2,3与i≥4，目标为dim Tor_i≤i*choose(w+1,i+1)，i≥1。第一界保留严格小于choose(w+1,2)。一次接口以定义相等回接旧C021对象和K作用，higherTor_one_dimension_compatibility保留旧GeneratorTensorFiber维数公式。

这些陈述都只针对实际三变量lex模型。未新增一般Tor换序、完整graded shifts、四生成元半群比较、局部完备归约或新颖性认证。R059另存v0.4交付与后续半群研究未授权启动。

## 联合编译进度

R080/R081分别局部成功，R082首轮语义复核无阻断。组合首次发现section假设需显式include与K对象零性需经restrictScalars.map_isZero两处接口问题；第二次仅doc comment与include的命令顺序报错，全部新定理公理输出已标准。已改为include在注释之前；此后最终完整lake build及独立验收通过，详见下节。两次失败诊断保留在results/r058_integration_wip.txt，不作为成功证据。

## 最终统一构建（2026-10-01）

在lean目录运行固定 C:/Users/wyty/.elan/bin/lake.exe build，实际子进程退出0，终止标记PROCESS_EXIT_CODE=0。成功日志为results/lean_higher_tor_build.txt，SHA-256 `29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4`。没有error/warning，16项新增命名声明公理检查只含propext、Classical.choice、Quot.sound；17个新增实际声明依赖根排除旧有限/小宽度证书及sorryAx。这是包含缓存依赖回放的统一增量构建，不声称clean rebuild。

results/r058_validation.json记录全部新源码、根import/audit和成功日志SHA-256，验证新源码无sorry/admit/custom axiom/native_decide。对比前稳定文档检查点的61个lean项目文件，原有文件只有根import和DependencyAudit改变；所有旧数学证明正文保持原字节。固定mathlib提交79e94a093aff4a60fb1b1f92d9681e407124c2ca且tracked diff为空；未升级/下载/外搜。

三个新数学文件：

| 文件 | 作用 | SHA-256 |
|---|---|---|
| ResidueFreeDimension.lean | 真实张量坐标、K有限性/维数桥 | 64415e375a16e7253e77a343d96aa0a973ebfd5ca86b494697a4c4f69453d1e9 |
| MinimalResolutionTor.lean | 标准Tor/同调/残差项同构、K相容和IsZero | 5f3f883bcb2a188698aecdaee61164759855c375485e9fc9a82f9cec0b1ce3aa |
| HigherTorBounds.lean | 实际lex同调维数、消失、宽度三界与全部正次数 | 81bd72c661a22e187882c2b00c1beedb269a8cb4f6e828419f185da2dd263d42 |

## 后续恢复接口

MonomialInterface中：ResidueTensorK M、residueTensor_free_finite M、finrank_residueTensor_free M；IdealQuotientTor I n / IdealQuotientTorK I n；idealQuotientTorIsoResidueTensor I P hzero n、idealQuotientTorEquivResidueTensor同参数；idealQuotientTor_isZero_of_resolution_isZero再接hX。一次对象相容两个simp定理均为rfl。

MonomialPresentation中：minimalResolution_tor_finite/finrank I P hzero n；lexQuotient_tor_dimensions接受R057全部实际boundary数据及hI:I≤m，无预算；finiteColength_higherTor_dimensions返回实际a、所有次数K有限、0..3维数与高次零；finiteColength_higherTor_width_bounds给三界；finiteColength_tor_all_positive_bounds给所有i≥1的dim Tor_i≤i*choose(w+1,i+1)。finrank_tor_eq_zero_of_isZero通过实际限制标量保持零对象处理高次维数。

这里严格第一界dim Tor_1<choose(w+1,2)在自然数中等价于至多choose(w+1,2)-1。宽度假设仍w≥4；本轮未证明w=3抽象lex版本。v0.3旧PDF/TeX/ZIP及原验收记录不改，本轮也不生成v0.4。下一项候选R059是独立整链审查与新版本冻结，须等用户继续指令。

## 独立最终验收与停点

R082正式接受且无剩余阻断，见tasks/R082_higher_tor_review.md。审查者核对6个源码/日志hash、16项公理输出、17个实际依赖根、标准对象/因子/标量/有限性/高阶消失与全部原假设，未用一次编译替代语义审查。R080/R081执行者及R082审查者均已停止。根登记C031后保存稳定checkpoint；当前最高候选变为R059，但仍parked。旧C030规划原字节按原hash保存在research/frozen/planning_r058_start/research/NEXT_STAGE_PLAN.md，当前计划更新不冒充历史证据。

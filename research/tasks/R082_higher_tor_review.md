# R082：R058 标准高阶 Tor 的独立复核

日期：2026-10-01。状态：**正式接受 R058**。语义复核与最终统一构建证据对应核验均通过；下文保留首轮 WIP 检查及待办历史，并以末尾最终核验结论覆盖其等待状态。验收不使用局部编译或 WIP 失败日志。

独占本报告。未修改 Lean 源码、根状态、配置或其他文件；未派生、未外搜、未启动大构建。读取 AGENTS、STATE、HANDOFF、queue 后，根 `.venv` 的 checkpoint `--check` 通过；`--verify-latest` 显示归档完整，工作区增量是 R058 正常 WIP，非归档损坏。

## 首轮语义核对

1. **标准对象与因子顺序。** `MinimalResolutionTor.lean` 的 `IdealQuotientTor I n` 直接展开 mathlib `CategoryTheory.Tor`，第一因子为实际 A/m，第二因子为实际 A/I。固定库 `CategoryTheory/Monoidal/Tor.lean:40` 的定义派生第二因子，与既有 `residueTensorFunctor` 完全相合。没有使用 `Tor'`、Tor 换序或一般平衡结论。
2. **真实标量。** `IdealQuotientTorK`、`ResidueTensorK` 都沿实际 `algebraMap K A` 做 `ModuleCat.restrictScalars`。比较同构先是 A 模同构，再经 `restrictScalars.mapIso` 成 K 线性等价；没有从指定维数空间运输 K 作用。`residueTensorKNaturalEquiv` 复用已有恒等底层映射，由 `IsScalarTower.algebraMap_smul` 核对自然 K 作用。
3. **有限性与维数桥。** `ResidueFreeDimension.lean` 从真实 A 自由基出发，用 `TensorProduct.equivFinsuppOfBasisRight` 将 `(A/m) ⊗[A] M` 化为有限基指标上的 A/m 坐标，经 `Finsupp.linearEquivFunOnFinite` 与已证明的 `variableResidueEquiv` 得 K 坐标。其 A 线性坐标等价先限制为 K 线性。`Module.Finite.equiv` 独立证明 K 有限性，之后才由 `finrank_eq` 与基指标数证明 Kdim 等于原 A 秩。没有假设 M 自身 K 有限，也没有把裸 A 秩直接解释成 Kdim。
4. **标准导出对象与零微分同调。** `P.isoLeftDerivedObj` 首先把标准 Tor 同构到实际张量复形同调；`ShortComplex.HomologyData.ofZeros` 的同调数据以原中项、恒等核和余核构造，故从实际同调得到原张量项。全部残差微分为零是明确输入，具体 lex 实例由已验收 R057 的实际分解给出；未以计数或定义替代正合性。
5. **真实高阶消失。** `idealQuotientTor_isZero_of_resolution_isZero` 通过保零函子作用于真实零分解项，再沿同构传回标准 Tor 的 `IsZero`。最终数值零先经限制标量的保零性得到 K 对象零性，再取 Subsingleton；此修正已核对实际最终源码。结论不是依赖无限维 finrank 也可能为零的漏洞。
6. **具体模型与同一 a。** `finiteColength_higherTor_dimensions` 原样保留任意 Field K、指数上集和 lex、真实有限余长、x 标准、w≥4、每次实际齐次商维数预算。复用 R057 的同一实际 P 和秩，并证明所有次数 K 有限。`ell` 仍为真实 `xySubspace` 的 K 维数；四个维数为 1、a+1+ell、a+2ell、ell，4 次起是实际零对象。
7. **宽度界。** 组合界独立取得的 a' 通过 `initialExponent_unique` 与分解的 a 匹配：两者都是第一个纯 x 禁指数，若一方较小即与另一方所有更低指数标准矛盾。随后连接既有 `monomialIdeal_all_widths_dimension_bounds` 的严格第一界及二、三界；全部 i≥1 的统一界按 1、2、3、≥4 分类，由高次 `IsZero` 补齐无界尾段，未遗漏 i>w。
8. **旧一次对象相容。** `idealQuotientTor_one` 与 `idealQuotientTorK_one` 均 rfl，既有 C021 对象和 K 标量保持定义相同；`higherTor_one_dimension_compatibility` 直接复用真实 `GeneratorTensorFiber` 维数比较，没有重新定义一次 Tor。

## 首轮反馈与待核验

在上述数学语义范围内未发现阻断。根通知的两项 Lean 修正（BoundaryData 全部变量显式 include；K 对象零性经 restrictScalars.map_isZero）不改变目标数学含义，但须检查最终实际源码及成功构建证据后才可接受。

首轮仍待：统一日志成功退出、无 error/warning、三新增模块命名公理只含标准逻辑公理、17 个新增实际依赖根均排除旧有限枚举/小宽度证书及 sorryAx、最终源码与日志/validation 中 SHA-256 一致。以上已在下列最终核验完成。R059 交付、完整半群归约、graded shifts、一般 Tor 换序及新颖性不在本审查认证范围。

## 最终源码与构建证据核验

在收到主智能体最终完成通知后，独立读取 `results/r058_validation.json` 与 `results/lean_higher_tor_build.txt`。根 `.venv` 的只读 Python 核对得到：6 个 source_and_log 条目的 SHA-256 全部对应当前文件；16 个命名公理输出逐项匹配真实日志；17 个新增实际依赖根逐项出现成功输出；error/warning 扫描无命中；存在 `Build completed successfully.` 与 `PROCESS_EXIT_CODE=0`；三新增 Lean 文件的 sorry/admit/自定义 axiom/native_decide 禁项扫描无命中。核对脚本报告 `errors: []`，未创建范围外的脚本或日志。

这是完整项目的统一增量 `lake build`，包含缓存成功依赖的 replay，未声称 clean rebuild。实际日志末尾记录 `Built WidthBounds` 与成功退出。`DependencyAudit.lean` 遍历声明真实常量依赖闭包，其代码会拒绝四项旧有限枚举/小宽度证书及 `sorryAx`；17 个新增根的成功输出来自这一遍历，而不是 import 列表检查。16 项新公理输出全部恰为 `propext`、`Classical.choice`、`Quot.sound`。`initialExponent_unique` 和数值零辅助也受终端宽度定理的传递公理检查覆盖。

| 文件 | 最终 SHA-256 |
| --- | --- |
| `lean/WidthBounds/ResidueFreeDimension.lean` | `64415e375a16e7253e77a343d96aa0a973ebfd5ca86b494697a4c4f69453d1e9` |
| `lean/WidthBounds/MinimalResolutionTor.lean` | `5f3f883bcb2a188698aecdaee61164759855c375485e9fc9a82f9cec0b1ce3aa` |
| `lean/WidthBounds/HigherTorBounds.lean` | `81bd72c661a22e187882c2b00c1beedb269a8cb4f6e828419f185da2dd263d42` |
| `results/lean_higher_tor_build.txt` | `29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4` |
| `results/r058_validation.json` | `3417fdc58105394ecd08271467e7580661798d36822bcc0a700190c6c22a2816` |

也核对了根 import、DependencyAudit 的两个记录 hash，无差异。`lean-toolchain` 保持 Lean 4.22.0；mathlib 实际 HEAD 为 `79e94a093aff4a60fb1b1f92d9681e407124c2ca`，tracked diff 为空。R057 validation 中的六个数学源码文件及旧成功日志与原记录 hash 均一致，未被本项覆盖。

最终源码关键入口：`ResidueFreeDimension.lean:38` 的真实坐标等价、`:51` 的 K 有限性、`:58` 的维数桥；`MinimalResolutionTor.lean:35` 的标准对象、`:56` 的实际同调比较、`:80` 的 K 线性等价、`:94` 的 IsZero；`HigherTorBounds.lean:74` 的真实边界数据维数、`:108` 的原模型四维数与零尾、`:137` 的三宽度界、`:170` 的全部正次数界。BoundaryData 的全部必要证明变量已通过 `include` 明确保留在定理参数中，其位置语法也在最终统一构建中通过。

## 最终结论与停止边界

**接受 R058 为 Lean 已编译并经本次独立语义复核的结果，无剩余阻断。** 在原实际有限余长三变量 lex 预算模型及其全部原假设下，标准 `Tor^A_i(A/m,A/I)` 的真实 K 限制标量对象各次有限维；0、1、2、3 次维数分别为 1、a+1+ell、a+2ell、ell，ell 为真实 xy 商子空间维数；4 次起标准 A 模 Tor 对象实际 `IsZero`。相应第一严格宽度界、第二和第三宽度界及所有 i≥1 的统一二项式界成立，并与旧 C021 的一次对象和维数接口兼容。

这里的接受不声称一般 Tor 因子换序、完整 graded shifts API、完整四生成元半群归约或数学新颖性已经证明。本执行者在此停止；只需主智能体集成验收状态、claims 和检查点，不启动 R059 或其他后续研究。

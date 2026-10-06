# R071 通用单项式关系生成准则

状态：已完成局部 Lean 编译，2026-09-30；待根统一集成/独立审查。仅支持已授权 R056；不构造 d3，不扩展到完整分解或高阶 Tor。

独占文件：`lean/WidthBounds/MonomialRelationSpan.lean` 与本报告。根管理状态、queue、claims、根 import 和统一构建。未派生子执行者。

已读 AGENTS、STATE、HANDOFF、queue 与 R055 实际列映射及报告。根 uv `.venv` 的 checkpoint `--check` 通过；`--verify-latest` archive_valid=true，当前 queue/R056 报告是正常后续修改。

目标：在任意域 K 与有限指数集合 E 上，对真实 `differential E : (E→K[x,y,z]) → K[x,y,z]`，证明任何包含所有同多重次数单项式差的 A 子模 N 必含整个核，覆盖任意多项式系数。差定义为 `commonRelation E d u v = single u (monomial (d-u) 1) - single v (monomial (d-v) 1)`，条件 u,v≤d。

计划：按多重次数在 F1/N 中选择任一可除列，构造 K 线性单项式提升；共同倍数差保证选择兼容。证明提升复合 d1 等于商映射，进而核包含。辅助证明每种差在真实核以及共同倍数的缩放公式。所有定义位于 `WidthBounds.MonomialPresentation`，不假称提升 A 线性。

停止条件：通用核生成定理及小辅助声明局部 Lean 编译通过，报告实际命令/退出/校验值；不启动后续研究。

## 最终接口

所有公开接口位于 `WidthBounds.MonomialPresentation`，系数域参数 `K : Type*` 任意宇宙，`E : Finset (Fin 3 →₀ ℕ)` 任意有限指数集。无需极小性、lex、有限余长、宽度预算或理想生成假设。

| 接口 | 结论 |
| --- | --- |
| `commonRelation E d u v` | 两个指定单项式向量的真实差，底层是原 `FreeModule K E` |
| `commonRelation_mem_ker E d u v hu hv` | 若 u,v≤d，该差属于原 `LinearMap.ker (differential E)` |
| `commonRelation_smul E d δ u v hu hv hd` | 若 u,v≤d≤δ，乘以 `monomial (δ-d) 1` 将 d 处关系变成 δ 处关系 |
| `ker_differential_le_of_commonRelation E N hN` | N 含所有以上共同倍数差，则包含整个真实核；hN 的精确形状为 `∀ d u v, u.val≤d → v.val≤d → commonRelation E d u v∈N` |
| `lcmRelation E u v` | 指数 `u.val ⊔ v.val` 处的 pair 关系 |
| `ker_differential_le_of_lcmRelation E N hN` | 只需 N 包含有限有序 pair 家族，即得整个真实核包含于 N |
| `ker_differential_eq_span_lcmRelation E` | 真实核等于 `(fun p : E×E => lcmRelation E p.1 p.2)` 的像之 A-span |

最后两项是可选有限 pair 推论；家族可能冗余，不声称极小、线性无关或具有 R072 特殊计数。公开结论也适用于 E 空集。

## 核生成证明内容

取 Q=`FreeModule K E ⧸ N.restrictScalars K`，这是沿实际系数域标量限制形成的商空间。对每个指数 d：若存在列指数 u≤d，就选择一列，并取 `single u (monomial (d-u) 1)` 的商类；不存在则取零。用 `MvPolynomial.basisMonomials` 的 `constr K` 扩为 K 线性映射 `relationLift : A →ₗ[K] Q`。

包含所有共同倍数差的假设直接给出不同可除列代表相同商类。由单项式基公式和 K 标量作用，得到每个任意系数单项式的提升公式。`MvPolynomial.induction_on'` 把该式推广到任意多项式列系数 p，最后用有限 Pi 单向量分解 `Finset.univ_sum_single` 得到

`relationLift (differential E c) = (N.restrictScalars K).mkQ c`

对任意多项式向量 c 成立。于是原微分值为零必使商类零，恰好说明 c∈N。这里没有假称 `relationLift` 为 A 线性，也没有把逐多重次数或有限实验误充为一般核生成。证明中的 choice 仅用于选定可除列；输出公理限制见下。

LCM 推论使用 `commonRelation_smul` 将任意共同倍数关系还原为相应 LCM pair 的 A 倍数；反向 span 包含直接由 `commonRelation_mem_ker` 获得。

## 编译证据与修复记录

固定 Lean/mathlib 4.22.0，未改依赖、旧源码或根 import。最终命令，工作目录 `D:\project\ai4math\lean`：

`lake build WidthBounds.MonomialRelationSpan`

实际进程退出 **0**，日志 `tmp/r071_final_build.txt` 结尾为 `Built WidthBounds.MonomialRelationSpan` 和 `Build completed successfully.`。最终日志无 error/warning，已生成可供 R072/root import 的 olean。这是指定目标的局部构建，不替代根统一构建。

- 源码 SHA-256：`2d563dfd4cc444b0edef89578417b9cf0041f34b2c37a10188cb0b9f981c8df3`。
- 成功日志 SHA-256：`bd3b0894e8522a8c95494e77f10dec482fad8f36ad6e7b392d52865dc978c053`。
- 四项 `#print axioms`：`commonRelation_mem_ker`、`commonRelation_smul`、`ker_differential_le_of_commonRelation`、`ker_differential_eq_span_lcmRelation`，均仅含 `propext`、`Classical.choice`、`Quot.sound`。
- 禁用词检查无 `sorry`、`admit`、`native_decide` 或自定义 `axiom` 声明。

首次核心 `lake env lean` 即通过，仅有一个 unused simp 提示；已删去该冗余 simp 参数。随后缩放公式第一次 `lake build` 因其声明中 `commonRelation` 的 K 参数尚未固定而触发 HSMul 元变量错误；为两侧显式增加 `(K := K)` 后消除。最终加入 LCM 推论的直接 Lean 编译和目标 build 都退出0、无warning/error。没有更换数学证明路线或弱化任何核命题。

## 交接与停止

R071可验收合同完成，源文件与报告交根集成并停止。R072仅需实例化 N 包含所有 commonRelation（或仅全部 lcmRelation），即可使用通用定理得到真实核生成。R056 的具体 d2、特殊边界指标数、统一构建、依赖审计、claims 与 checkpoint 由根负责。

本任务没有证明关系核自由、没有构造 d3、没有完整有限分解或标准高阶 Tor 识别。结果口径为上述一般单项式关系统一核生成准则“Lean 已编译”；数学新颖性未认证。

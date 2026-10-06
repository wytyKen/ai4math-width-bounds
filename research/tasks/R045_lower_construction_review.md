# R045：显式 lex 下界族独立审查

状态：**最终接受**。2026-09-29，执行者 `lower_review`。纸面推导、冻结源码语义、统一构建日志、公理输出和新增传递依赖审计均已核对，没有发现须修订的实质问题。本任务只改本报告，不改源码、根 import、状态、claims 或队列，不派生子任务，不进行外部检索或枚举实验。

## 审查范围及恢复

独立核对 R024 的真实理想构造、R044 的轮廓与全部次数预算，以及根 `LowerConstructionBounds.lean` 的列计数、实际商维数、有限有理谐和下界和标准 Tor₁ 计数。对照 R020 下界段，从乘积条件重新推导。只按相关接口读取 `MonomialInterface`、`LexCounting`、`MonomialBasis`、`IdealBounds`、`TorOneBounds` 与 `TorOneBridge`，没有重读全部旧论文或研究记录。

已读 AGENTS、STATE、HANDOFF、queue、PROTOCOL。根 `.venv\Scripts\python.exe -B scripts/checkpoint.py --check` 返回 `queue_valid:true`；`--verify-latest` 返回 `archive_valid:true`。当前状态/队列/任务报告修改和三份新 Lean 文件是正常工作区后续修改，未报告归档损坏。检查点字节验证不替代编译。

本轮先审阅的 `LowerConstruction.lean` SHA-256 为 `1f82b90634a5d31aa52afddcbad07d56d773180fc4af0f36060863aa9bcade2e`，与 R024 单文件编译报告一致。初审时另两文件尚处实现/根集成期，因此先只接受数学和候选源码语义；随后完成的统一 Lean 最终验收单独记录于第7节。

## 1. 真实理想及原族同一性

取任意域 K，自然数 s，m=s²。新指数集为

`S_s={e | m < (e₀+1)(e₀+e₁+e₂+1)}`，

实际理想 `lowerIdeal s` 是 `monomialIdeal S_s`，不是由欲证 Hilbert 函数定义的替代空间。两个乘积因子随各坐标增加而不减，因此 S_s 为逐坐标上集。固定次数 d 时，lex 更大单项式的 x 指数不减，第二因子 d+1 不变，因此同次 lex 上闭；x 指数相同时无需限制 y，因为成员性本就与该次数内的 y 指数无关。

利用已验收的实际单项式理想成员接口，实际标准性恰为

`(i+1)(d+1)≤m`，其中 d=i+j+k。

由于 d+1>0，正确的整数除法等价为

`(i+1)(d+1)≤m ↔ i+1≤floor(m/(d+1)) ↔ i<floor(m/(d+1))`。

取反得到理想成员 `i≥floor(m/(d+1))`，取整方向与严格性均正确。若 d<s，则 i+1≤d+1≤s，乘积≤s²，所以成员性不可能成立；因而新增的原式条件 d≥s 是冗余条件。源码 `monomial3_mem_lowerIdeal_iff_piecewise` 确实证明与 R020 原分段族完全等价，并未换成只具有相似增长的另一族。

`x^s` 的乘积为 (s+1)²>s²，而全部更低总次数标准，所以初始次数恰为 s。`z^(s²)` 的乘积为 s²+1>s²；上集和 lex 接入真实标准集有限性，再经真实商的标准单项式基得到 `Module.Finite K (K[x,y,z]/L_s)`。这不是从累计预算错误地推断有限余长。`d≥s²` 时全部单项式在理想中也有独立命题。

## 2. 全部次数计数和预算

R044 的 `lowerStandard` 正好等于上述乘积标准性。`standard3` 的成员 `(i,j)` 满足 i+j≤d，并将 z 指数恢复为 d-i-j；这个限制保证 Lean 中截断减法确实重建总次数 d。

每个次数 d 的标准对单射到 `[0,m)`：

`(i,j) ↦ i(d+1)+j`。

由 j≤d-i<d+1，像小于 (i+1)(d+1)≤m；若两像相等，模宽度 d+1 的区间互不重叠，所以先得 i 相同，再得 j 相同。该证明对所有自然数 s,d 成立，尤其涵盖 d≥m 的空尾部。无需把三维维数精确公式当作预算假设。

当 s≥1 时，零次标准集恰为 {(0,0)}，故 H₀=1。每个正次数 H_d≤m；对任意自然数 d 归纳得

`∑_{t=0}^d H_t≤1+dm`。

源码量词确实是任意 d，无有限截断限制，也没有只在初始次数附近验证预算。二维切片恰为 `range(min(d+1,floor(m/(d+1))))`，于是 d<s 时 h_d=d+1；d≥s 时 h_d=floor(m/(d+1))。第二分支用 `m<(d+1)²`，包括 s=0 时的空切片，边界 d=s 无偏移。

根通过 `standard_lowerIdeal_eq_lowerStandard` 和 `finrank_quotientHomogeneous` 逐项替换，将预算传到 `quotientHomogeneous`。后者是实际齐次多项式子模在真实理想商中的像，其 finrank 不是重新定义的组合计数。因此 `lowerIdeal_finrank_budget hs d` 是全部次数的真实商空间维数预算。

补充核对根新增的 `lowerIdeal_finrank_budget_of_square_le`：对任意自然数 w，只要求 s≥1 和 s²≤w，就由 d 的非负乘法单调性把预算扩展为 `1+dw`，量词仍为所有 d。此命题允许同一实际理想进入更大的预算类，但尚不包含为任意 w 选择 `s=floor(sqrt w)` 及解析下界的证明。

## 3. 列区间、自然数减法和精确截面

固定 x 指数 i，在 z=0 截面有

`(i+1)(i+j+1)≤m ↔ i+j+1≤floor(m/(i+1)) ↔ j<floor(m/(i+1))-i`。

此等价对所有 i,j,s 成立，包括右侧自然数减法截为零的情况：若商≤i，两侧均不成立。没有将 `Nat.sub` 直接当作有符号减法使用。

对于求和范围 i<s，已证明 i+1≤s，于是 `s≤floor(s²/(i+1))`，特别有 i≤该商。因此 `Nat.sub_add_cancel` 合法，得精确恒等式

`ell_s + ∑_{i<s} i = ∑_{i<s} floor(s²/(i+1))`，

其中 `ell_s=∑_{i<s}(floor(s²/(i+1))-i)`。i≥s 时乘积至少 (i+1)²>s²，所以不存在遗漏的非零列。

`lower_columnLength_eq` 经已验收的全列成员判定得到真正列长，而不是从数值相等猜测；`sum_columns_eq_sectionLength` 用 x^s 非标准排除后续列。s≥2 给 w=s²≥4，全部次数预算满足既有截断接口。`xySubspace` 本身定义为实际商中所有 x^i y^j 类的张成，没有人为截断；根经已有 `finrank_xySubspace` 得到 `dim_K xySubspace(L_s)=ell_s`。计数和实际空间的连接完整。

## 4. 有理谐和下界和取整误差

每个正分母 r=i+1 有

`m/r≤floor(m/r)+1`。

源码先由 Nat.div_add_mod 和余数上界得到整数乘法不等式，再用正分母清除有理除法，方向正确。对 i<s 求和给

`m H_s≤∑_{i<s}floor(m/(i+1))+s`。

代入上节的精确恒等式及 `∑_{i<s}i=s(s-1)/2`，得到

`s² H_s≤ell_s+(s²+s)/2`。

这与 R020 的 `ell_s≥s²H_s-s²/2-s/2` 完全等价。源码在有理数中处理后半式，不对负数做自然数截断。`lowerSectionLength_harmonic` 对所有 s（含空和 s=0）成立；实际 xy 维数推论按既有接口取 s≥2。

这只是有限有理谐和不等式；源码中没有 Real.log、Theta、任意非平方预算参数的 sqrt/floor 选择。因此不能将本轮升级为完整 Lean 渐近证明。

## 5. 标准 Tor₁、变量和初始次数唯一性

`IdealQuotientTorOneK I` 是 mathlib `CategoryTheory.Tor (ModuleCat A) 1` 在 `(A/m,A/I)` 上的值，沿实际 `algebraMap K A` 限制标量；A=K[x,y,z]，m 为真实变量理想。它不是将生成元数重命名成 Tor，也没有交换两个参数或改派生因子。

根实际实例化 `finiteColength_torOne_bounds` 所需的所有输入：上集、lex、真实商 Module.Finite、x 标准、w=s²≥4、任意次数的真实预算。x 标准由 s≥2 保证，并经原接口蕴含 L_s≤m，所以没有省略 Tor 比较的实质理想包含条件。

原通用接口给初始纯 x 次数 a 及 `dim Tor₁=a+1+dim xySubspace`。根证明 a=s 的两个方向均有效：

- 若 a<s，则构造族的低次标准性与 x^a 属理想矛盾。
- 若 s<a，则通用接口的低次标准性与 x^s 属理想矛盾。

代回实际 xy 维数即得 `dim_K Tor₁ᴬ(A/m,A/L_s)=s+1+ell_s`。假设 a 唯一性没有通过 `a:=s` 偷换存在见证；源码确实用两个相反情形排除不等。

此处只完成第一 Tor 维数，保留原实际第一参数 A/m 与第二参数 A/L_s。没有更高 Tor、没有半群理想实现，没有比较不等式的反向使用。

随后根新增 `lowerIdeal_admissible` 将已证的 w≥4、实际 IsLex、商有限维、x 标准和全部次数预算合取，未新增未证假设。`lowerIdeal_generator_number` 从同一通用 Tor 接口取 `IsLeast` 并代入精确 Tor 维数，得到 `s+1+ell_s` 是实际理想的任意有限多项式生成集合基数中的最小值；这里 `generatorCardinalities` 量化所有 `Finset (MvPolynomial (Fin 3) K)` 且要求实际 `Ideal.span` 等于该理想，没有限制生成元为单项式或齐次。该结论比只展示一个给定生成集合的基数更强，但由既有已验收接口合法传递。

## 6. 退化值及验收边界

- s=0：乘积总为正，S₀为全部指数、L₀为单位理想，商和标准集均为空/零；初始次数为0，有限性与乘积判定仍成立。H₀=1 的定理明确要求 s≥1。此时实际 Tor₁为0，而 `s+1+ell_s=1`，所以 Tor 公式绝不能删 s≥2（或另行改成恰当的正参数接口）。当前源码没有该错误。
- s=1：L₁为变量理想，只有常数标准，ell₁=1；预算成立，x 不标准，w=1不满足通用 w≥4 接口。本轮 Tor/实际 xy 集成统一保留 s≥2，未声称覆盖 s=1。数学上该退化 Tor 数为3，可与有限公式一致，但不在当前正式定理范围内。
- s=2：w=4，x 标准、x² 首次非标准；所有不等式与列计数的边界均闭合，无需加强到 s>2。审查没有新增枚举实验。

总体结论：没有发现候选证明的实质数学错误或错误量词。新颖性未定；这是先前传统审查通过的抽象 lex 下界族及有限公式的形式化。即使未来证明某 Hilbert 轮廓来自半群，`Betti(半群)≤Betti(lex)` 也不能推出半群匹配下界。本轮不得宣称四生成元数值半群的下界、完整增长阶机器证明或外部专家认可。

## 7. 最终冻结核验（已完成）

以下是独立重算并与根提供的最终值逐字核对的 SHA-256；三份实现文件均与先前冻结值一致，新增根 import 和依赖审计文件也记录在这里。

| 文件 | SHA-256 |
|---|---|
| `lean/WidthBounds/LowerConstruction.lean` | `1f82b90634a5d31aa52afddcbad07d56d773180fc4af0f36060863aa9bcade2e` |
| `lean/WidthBounds/LowerProfile.lean` | `5833f295a3881c9fd19527c23da63709914bf3eed9adf5380b50024712b0dec1` |
| `lean/WidthBounds/LowerConstructionBounds.lean` | `08439e34f7c012fbeb4d4396c6a2198875bee0a474deaa0d067620aba2a82783` |
| `lean/WidthBounds.lean` | `e9396d313e70f545c251de07f06a285241e3d8e01edb585452d8c37e3caa6c72` |
| `lean/WidthBounds/DependencyAudit.lean` | `b1af39cb4e5ce4adb93de3800da906e9475318e3321334965d2a8fbd43d13ed6` |
| `results/lean_lower_construction_build.txt` | `174a29cb3799d24b7110e85d51d1e68d8325728f24d1040c05c02f37304f8dec` |

构建命令为在 `lean/` 运行统一 `lake build`。根确认进程退出0；本审查独立读取已关闭的最终日志，确认三模块全部出现，`WidthBounds.DependencyAudit` 和总根 `WidthBounds` 构建成功，最后一行为 `Build completed successfully.`，无 error/warning/sorryAx/Unexpected 诊断。日志不是前期失败日志或旧轮次日志。

三份新模块共18项 `#print axioms` 输出仅含 `propext`、`Classical.choice`、`Quot.sound`，无自定义公理或研究假设。三新源码扫描 `sorry`、`admit`、`native_decide`、自定义 `axiom` 无匹配（最后 rg 退出1表示没有匹配，不是编译失败）。

新增六个实际依赖根为 `lower_hilbert2_eq`、`lowerIdeal_admissible`、`lowerIdeal_xy_finrank`、`lowerIdeal_xy_harmonic_lower`、`lowerIdeal_torOne_finrank`、`lowerIdeal_generator_number`。已核对审计程序遍历实际声明依赖闭包，并排除旧四个有限/小宽度证书声明及 `sorryAx`；统一日志中六根均成功。这里宣称的是这些明确依赖根的审计结果，未把它扩大成任意未来声明的认证。

最终接受范围：任意域上的显式真实有限余长 lex 族、原纸面族等价、精确二维轮廓、全部次数实际 Hilbert 预算、精确完整 xy 维数和有限有理谐和下界，以及 s≥2 时标准 Tor₁ 维数/真正任意多项式最少生成数 `s+1+ell_s`，均有当前冻结源码的统一 Lean 构建证据。审查层次为独立模型审查，未冒称外部人类审稿。

没有阻断项；R045 本轮审查完成。下一动作由根更新 R024/R044/R045 队列、claims、STATE、HANDOFF 并创建稳定检查点。本轮停止在完整构造与有限公式，不启动 Real.log/Theta、半群归约、高阶 Tor 或对外动作。

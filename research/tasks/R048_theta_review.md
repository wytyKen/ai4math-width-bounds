# R048：实对数极值 Theta 独立审查

更新时间：2026-09-29。执行者 `/root/theta_review`；独占本报告，不修改源码、根 import 或状态文件，不派生执行者。本轮不外搜、不做数值实验、不启动后续收尾。

## 当前审查状态

**最终接受。** 三个新增模块的源码语义、固定版本统一构建、12项新增公理输出、五个新增实际声明依赖审计根及冻结文件/日志哈希已核对通过。接受范围严格限于下述精确命题；任务状态与 claims 由根集成。

启动恢复已读 AGENTS、STATE、HANDOFF、queue、PROTOCOL 及 R046/R047 报告、FINISH_PLAN。根 `.venv/Scripts/python.exe -B scripts/checkpoint.py --check` 返回 queue_valid=true；`--verify-latest` 返回 archive_valid=true，旧快照本体无损坏。工作区新增本轮三个源码及报告、结束计划，STATE/HANDOFF/queue 已有修改，属于快照后的正常 WIP 差异，不是归档损坏。

## 精确对象及命题

固定任意域 K，A=K[x,y,z]。`LexExtremal.Admissible w S` 的五个字段为：指数集合 S 上闭；同次数 lex 上闭（x>y>z）；实际 A/monomialIdeal(S) 为有限 K 模；实际 x 单项式不在理想中；对每个自然数 d，实际齐次商空间的累计维数至多 1+d*w。

`lengthSet K w` 收集这些实际理想的完整 xy 商子空间 K 维数。`xySubspace` 在 `IdealBounds.lean` 中定义为所有 i,j∈ℕ 的 x^i y^j 商类的 K 线性张成，没有把定义截为有限次数。`quotientHomogeneous` 在 `MonomialBasis.lean` 中定义为 mathlib 标准 homogeneousSubmodule 经实际商映射的像。`standard` 是实际理想非成员谓词，`monomialIdeal` 是系数为1的单项式生成的 Ideal.span。

`M_K(w)=maxLexLength K w` 定义为上述自然数集合的 sSup；对 w≥4 证明 IsGreatest，因而确实由类中某个实际理想达到。对每个 w≥64：

    (w : ℝ) * log w / 16 ≤ (M_K(w) : ℝ) ≤ 10 * (w : ℝ) * log w.

最后目标为标准 `Asymptotics.IsTheta Filter.atTop`，定义域是所有自然数宽度，不是平方参数序列。

## 上界及强制转换

1. `Growth.harmonicQ n` 是有理数中的 Σ_(r<n) 1/(r+1)。`LogGrowth.harmonicQ_eq_harmonic` 逐项归一化为 mathlib 的有理 harmonic；没有另定义一个只满足所需不等式的替代对象。
2. 使用固定 mathlib `NumberTheory/Harmonic/Bounds.lean` 的真实积分比较定理 `log_add_one_le_harmonic` 和 `harmonic_le_one_add_log`。n=0 的上界由库按 log 0=0 处理；实际粗增长界仅用 w≥4 时的正参数。
3. 项目原有实际 xy 有理上界经 `exact_mod_cast` 传至实数。整个被估计系数是自然数 2*w-1 的实数转换，非负性来自自然数转换，未把截断减法误当无条件的实数减法。
4. w≥4 给 log w≥1；由 log2≤1 和正数上的对数单调性，有 log(2w-1)≤1+log w，并用 2w-1≤2w，得到至多 7w+2w log w≤9w log w≤10w log w。10 是足够常数，不声称最优。
5. 上界实际接口保留 S 上闭、lex、非零理想、x 标准、w≥4 和所有次数预算。极值类从真实有限余长推出非零：有限标准指数集产生入理想的纯 z 幂，经单项式成员判据及 `monomialIdeal_ne_bot_iff` 得非零。没有把预算错误当作有限余长的充分条件。

## 下界、log64 与平方根方向

1. `lowerSectionLength_log_add_one` 从已验收的有理式 s²H_s≤ell_s+(s²+s)/2 出发。先统一 s*s 与平方，再使用 `Rat.cast_le (K := ℝ)` 传递整个不等式，并展开 cast 的加、乘、幂、除。乘 log(s+1)≤H_s 时因子是非负 s²，不发生方向反转。
2. `three_le_log_of_sixtyFour_le` 用实分析定理 1-1/2≤log2，得 log2≥1/2，再由 log(2^6)=6log2 及 2^6=64 得 log64≥3。w≥64 的转换及 log 单调性给 log w≥3。这是符号证明，无浮点近似或经验阈值。
3. s=Nat.sqrt w。固定库 `Nat.sqrt_le` 给 s²≤w，`Nat.lt_succ_sqrt` 给 w<(s+1)²，方向正确；`Nat.le_sqrt.mpr` 从 4≤w 得 s≥2。因而旧显式理想的 s² 预算可单调放宽为 w 预算。
4. s≥2 给 s≤s²/2 及 w≤(s+1)²≤4s²。由 w>0 和 log 单调性得 log w≤2log(s+1)。因此

       ell_s ≥ s² log w/2 - (s²+s)/2
             ≥ s² log w/2 - 3s²/4
             ≥ s² log w/4
             ≥ w log w/16.

   倒数第二步恰用 log w≥3，最后一步恰用 w≤4s² 和 log w≥0。代码中的 `nlinarith` 与这些等式方向相符。
5. 定理的唯一宽度假设为 64≤w；没有要求 w 是平方。实际 xy 版本以已验收的 `lowerIdeal_xy_finrank` 改写，参数条件 s≥2 未被删去。

## 类非空、上有界与最大值达到

1. `lower_admissible` 逐字段调用真实构造的上闭、lex、有限余长、x 标准及放宽预算定理，未将 Admissible 自身作为未经证实的研究假设。
2. w≥4 时选择 s=2 得非空；不需等到 w≥64 才定义可达到的最大值。
3. `lengthSet_bddAbove` 从既有真实维数严格界 a+1+ell<choose(w+1,2) 推出 ell≤choose(w+1,2)，是所有类成员共有的自然数上界。被使用的 `monomialIdeal_all_widths_dimension_bounds` 数学正文调用 `all_widths_analytic_bounds`，而非旧有限小宽度证书。
4. 固定 mathlib 的 `Nat.sSup_mem` 明确需要 Nonempty 和 BddAbove；两个前提均已提供。`length_le_maxLexLength` 使用同一集合的 `le_csSup`。两者组装出的 IsGreatest 同时包含成员资格和上界性质；不是把任意包络函数命名为 maximum。
5. 对 w<4 仅保留总定义 sSup，未声称这些参数有实际最大值。最终 atTop 结论只使用 w≥64，符合该区别。

## 标准 Theta 及系数域

固定 mathlib 的 `Asymptotics.IsTheta l f g` 定义为 `IsBigO l f g ∧ IsBigO l g f`。目标第一方向由 M≤10w log w 得常数10；第二方向由 w log w/16≤M 得 w log w≤16M，使用常数16。两个 eventually_atTop 见证均取64。

M 的实数转换自然非负，w≥64 时 log w≥0，故 w log w≥0；源码分别显式移去两边范数对应的绝对值。常数10、16为正，既不存在范数方向调换，也不依赖负 log 值。

三个源码的实际代数接口仅要求 `[Field K]`，没有 `[CharZero K]`。ℚ→ℝ 是数值估计的保序转换，`Module.finrank K` 的自然数输出才被转成实数；未向 K 注入有理数或实数。类本身依赖 K，但同一常数和阈值对任意域有效；本轮没有单独声称或证明极值函数跨域逐点相等。

## 结束计划与结果边界

FINISH_PLAN 明确将“当前增长阶 + 一次总审校打包”列为建议的研究交付范围；它把决策写为仍待用户答复，并明确未启动最终打包。未把默认选项当授权，未保证完成日期。端到端半群 Lean 所需高阶 Tor/Betti、真实半群归约与宽度3等仍被列为独立大项。当前文本符合授权和不确定性边界。

本轮最强数学结论只是任意域上的**抽象有限余长 lex 累计预算类的实际 xy 维数最大值**为 Θ(w log w)。已存在的标准 Tor₁/生成数公式可保留原有口径；此次 maxLexLength 不是新定义的半群 Betti 极值。不得从 Betti(半群)≤Betti(lex) 反推出半群匹配下界。没有更高 Tor、数值半群构造、半群下界、新颖性认证或外部审稿结论。未修改冻结 v0.1/v0.2、未生成新 PDF。

## 源码与证据

首次独立读取的 SHA-256：

| 文件 | SHA-256 |
|---|---|
| lean/WidthBounds/LogGrowth.lean | 880f67c5aaaf5caa5408f131890cd67069a09e887f87227c74c2f0840dd8e115 |
| lean/WidthBounds/LogLower.lean | 3ea59be90c9c37301d983337e060cf373f28d76a484864d2ab10ca2b89a8c360 |
| lean/WidthBounds/LexGrowthTheta.lean | 779ecd9db9df3b75aa6ddaf74102f9c591a76b4dcb79876420e72f6ff34bb736 |
| research/FINISH_PLAN.md | ee4b4ff394ae9a4d1cb422df8b946da86cb4a6254fb669387877b53987082e36 |

源码禁止项搜索 `\b(sorry|admit|axiom|native_decide|CharZero)\b` 在三个新增 Lean 文件无匹配；`#print axioms` 语句本身不是自定义公理。固定 `lean-toolchain` 为 leanprover/lean4:v4.22.0，lakefile 中 mathlib rev=v4.22.0。

R046/R047 单模块成功报告与所报源码 hash 相符。根随后完成统一构建，以下最终核验取代先前等待状态。

## 最终冻结验收

根在 `D:\project\ai4math\lean` 执行统一 `lake build`，subprocess 返回 exit=0，并确认日志文件上下文已关闭后才计算 hash。审查者独立读取日志、源码与入口/依赖审计代码，再独立计算 SHA-256；根确认所有值一致且相关文件不再修改。

| 最终证据 | SHA-256 |
|---|---|
| results/lean_lex_theta_build.txt | 0b43de4c75bf3eeedc6af52ca63417c53aae798e6593aefda2255eea40d230b8 |
| lean/WidthBounds.lean | a622ef975ae7e2a1c501539e408b88d6d0a6c512549c9d2c2b81504d9a0c298c |
| lean/WidthBounds/DependencyAudit.lean | 3f4c705be9db95ef049e31f6d1bc5f54c635c47d4196e3ed8a13558eb0aa2387 |

三个新增 Lean 源码最终 hash 与上表首次读取值完全一致，未用旧日志核验修改后源码。根入口含 LogGrowth、LogLower、LexGrowthTheta 三个 import。日志末尾为 `Built WidthBounds` 与 `Build completed successfully.`，完整日志未搜索到 error、warning 或 sorryAx。

日志第232—245行中的12项新增 `#print axioms` 输出（LogGrowth 5项、LogLower 4项、LexExtremal 3项）全部仅为 `[propext, Classical.choice, Quot.sound]`。没有研究自定义公理、占位证明或 native_decide。依赖审计新增根为实际 quotient 上界、实际 lowerIdeal 下界、maxLexLength_isGreatest、maxLexLength_log_bounds、maxLexLength_isTheta；全部通过传递声明依赖检查，排除 finite_envelope_certificate、small_width_combinatorial_bounds、small_width_binomial_bounds、envelope_bounds 和 sorryAx。此审计检查实际声明依赖，不以 import 列表或旧日志重放作为证据。

审查结论：**当前精确范围内无阻断问题；Lean 已编译，独立语义及冻结证据审查接受。** 上下界常数分别为1/16与10，统一下界/Theta阈值为64；最大值达到性从4起成立。结论只属于真实有限余长抽象lex预算类，非半群下界或原半群目标端到端Lean完成。FINISH_PLAN 保留待用户选择与无保证日期状态。

本报告已完成并冻结。下一动作仅由根登记 claims、更新状态/队列与创建本里程碑检查点；审查者停止，不执行研究打包、高阶Tor、半群归约或任何外部动作。

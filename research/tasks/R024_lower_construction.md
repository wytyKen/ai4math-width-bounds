# R024：显式下界族形式化

状态：R024整体完成并统一Lean构建通过（2026-09-29），R045独立审查接受。真实理想、全部次数实际预算、精确计数和有理谐和下界均已集成。证明来源为R018与R020；完整Real.log/Theta仍非本轮结果。

## 本轮分工与准确范围

执行者 `lower_ideal` 只修改本报告与 `lean/WidthBounds/LowerConstruction.lean`。
R044 独立实现组合轮廓和全部预算，主智能体连接实际商维数与计数、统一编译并更新状态。

本轮采用等价的无除法指数集合

`lowerExponentSet s = {e | s*s < (e 0+1)*(e 0+e 1+e 2+1)}`，

实际理想为 `lowerIdeal (K := K) s = monomialIdeal (lowerExponentSet s)`，K 是任意域。
目标为坐标上闭、同次lex上闭、精确标准性乘积判定、纯z的s²次幂成员、实际商的 `Module.Finite`、恰为s的初始次数与s≥2时x标准。
不将此模块单独称为Hilbert预算、谐和下界或完整Theta证明；更不宣称半群匹配下界。

恢复检查：根 `.venv\\Scripts\\python.exe -B scripts/checkpoint.py --check` 返回 queue_valid:true；`--verify-latest` 返回 archive_valid:true，queue修改为正常工作区后续变更，归档未损坏。

## 已编译的精确接口

以下均位于 `WidthBounds.Lower`，K 是任意域，没有特征限制；除明确标出的 `2 ≤ s` 外，构造命题对所有自然数s成立。s=0时理想为单位理想，这不影响辅助命题；实际下界族仍取s≥2。

| 声明 | 已证明内容 |
|---|---|
| `lowerExponentSet_isUpper s` | 乘积阈值给出的真实指数集合对逐坐标顺序上闭。 |
| `lowerExponentSet_isLex s` | 在同次 `x>y>z` lex 顺序下上闭。 |
| `monomial3_mem_lowerIdeal_iff s i j k` | 实际理想成员等价于 `s*s < (i+1)*(i+j+k+1)`。 |
| `standard_lowerIdeal_iff s i j k` | 实际标准单项式等价于 `(i+1)*(i+j+k+1) ≤ s*s`。 |
| `lowerIdeal_isLex s` / `lowerIdeal_standardLex s` | 实际理想的IsLex及实际非成员谓词的StandardLex。 |
| `pure_z_mem_lowerExponentSet s` / `pure_z_mem_lowerIdeal s` | `z^(s*s)` 属于指数集及实际理想。 |
| `lowerExponentSet_standard_finite s` | 实际标准指数集有限。 |
| `lowerIdeal_quotient_finite s` | 真实 `MvPolynomial (Fin 3) K ⧸ lowerIdeal s` 是 `Module.Finite K`。 |
| `pure_x_mem_lowerIdeal s` | `x^s` 在理想中。 |
| `pure_x_standard_of_lt hd` | `d<s` 时 `x^d` 标准。 |
| `standard_lowerIdeal_of_degree_lt hd` | `i+j+k<s` 时所有该次数单项式标准。 |
| `lowerIdeal_initial_degree s` | 初始总次数恰为s：`x^s` 非标准且全部更低次数标准。 |
| `x_standard_lowerIdeal hs` | `2≤s` 时x标准。 |
| `lowerIdeal_ne_bot s` | 理想非零。 |
| `monomial3_mem_lowerIdeal_of_degree_ge hd` | `s*s≤i+j+k` 时单项式在理想中。 |
| `standard_lowerIdeal_iff_lt_div s i j k` | 实际标准性等价于 `i < s*s/(i+j+k+1)`，不需次数分支。 |
| `monomial3_mem_lowerIdeal_iff_piecewise s i j k` | 实际理想成员等价于 `s≤i+j+k ∧ s*s/(i+j+k+1)≤i`，与原纸面族完全一致。 |

## 证明要点及原公式一致性

逐坐标增加时两个乘积因子均不减，故是上集。同次数lex增加只需x指数不减；第二因子次数加一保持不变，所以lex上闭。实际单项式成员使用现有 `monomial_mem_monomialIdeal_iff`，因此不是把目标非成员条件假设为理想实现。

纯z的s²次幂满足 `s²<1*(s²+1)`。现有 `standard_finite_of_pure_z` 结合上集和lex性给标准指数集有限，再用现有实际标准单项式商基的 `quotient_finite_iff_standard_finite` 得真实商有限维。

`x^s` 满足 `s²<(s+1)²`。若总次数d<s，则 `i+1≤s` 且 `d+1≤s`，故乘积不超过s²。于是初始次数恰为s，且s≥2时x标准。

以 `Nat.le_div_iff_mul_le`（分母d+1正）证明 `(i+1)(d+1)≤s² ↔ i<floor(s²/(d+1))`；低于s的次数已全标准，故原理想成员的显式 `d≥s` 条件可从乘积成员条件推出。本模块已经形式化原分段理想的等价，根无需重新论证族的同一性。

## 编译证据与源码校验

最终命令：在 `D:\project\ai4math\lean` 运行 `lake env lean WidthBounds/LowerConstruction.lean`，进程退出码0，无警告或错误。前一版也编译成功；最终版本新增原分段等价后重新完整编译成功。

最终源码 SHA-256：`1f82b90634a5d31aa52afddcbad07d56d773180fc4af0f36060863aa9bcade2e`。

六项 `#print axioms` 输出：上集只用 `propext, Quot.sound`；lex、精确标准性、有限商、初始次数、原分段等价均只用 `propext, Classical.choice, Quot.sound`。没有研究假设、自定义公理或禁用占位符。针对源码的 `rg` 禁用词扫描无匹配（退出码1表示无匹配）。最终统一构建日志及claims由主智能体落盘；本次单文件编译输出记录于此报告，不冒充已完成全项目构建。

## 失败路线、限制与下一步

没有实质失败路线：首版全部构造命题一次编译通过，新增分段等价再次编译通过。没有进行枚举实验或外部检索，没有修改已验收旧模块、根import、配置或状态文件。

本执行者未证明hilbert3计数、Hilbert全部累计预算、列长度和、谐和下界、Real.log或Theta；这些不由“真实理想存在且商有限维”自动推出。原计划中R044负责轮廓和全部预算，根负责把其乘积标准谓词接到实际标准性与真实商空间维数；接着按队列进行独立审查与统一构建。无论完成哪一层，都不能反用 `Betti(半群)≤Betti(lex)` 宣称半群匹配下界。

## 原任务计划（保留）

取整数s>=2、w=s²。可用真实指数集合

`S = { e : Fin 3 →₀ Nat | e.degree >= s ∧ e 0 >= s*s / (e.degree+1) }`

并取已有 `monomialIdeal S`。先证明它是坐标上集及同次lex上闭；指数总次数至少w时均属于S，故标准集有限。利用MonomialBasis/IdealBounds把计数接到真实商环。

计划证明：初始次数s；二维轮廓d<s时d+1、d>=s时floor(s²/(d+1))；全部次数三维计数<=w（零次为1）；实际累计维数预算；列长 `floor(s²/(i+1))-i` 与总截面计数公式。

可以先交付有限参数的统一构造和精确计数，不必同一轮形式化Real.log、Euler常数或Theta接口。下界只针对抽象lex类；不得倒用Betti(半群)<=Betti(lex)来宣称半群匹配下界。

## 根集成：真实预算、精确维数与有限下界

`LowerConstructionBounds.lean` 连接真实lowerIdeal与R044的lowerStandard，先用函数外延证明二者标准性完全相同，而非把可实现性作为假设。

- `lowerIdeal_finrank_budget`：对任意s≥1和所有自然数d，实际商齐次像维数满足Σ_(t≤d)dim≤1+d*s²；`lowerIdeal_finrank_budget_of_square_le`将同一个实际理想用于任意更大预算参数w≥s²。没有有限截断或抽样。
- `lowerIdeal_admissible`：s≥2时，w=s²≥4、真实lex性、真实A/I有限维、x标准与全部次数真实预算同时成立。
- `lower_columnLength_eq`给每列精确长度 `s²/(i+1)-i`（Nat截断减法）；通过旧完整列计数，`lowerIdeal_xy_finrank`证明整个未截断xy商子空间的维数为

    ell_s = lowerSectionLength s = Σ_(i<s)(floor(s²/(i+1))-i)。

- `lowerSectionLength_add_sum_indices`证明ell_s+Σ_(i<s)i=Σ_(i<s)floor(s²/(i+1))，逐项先证明商至少为s≥i，因此没有错误使用自然数截断减法。
- `lowerIdeal_xy_harmonic_lower`在有理数中证明精确有限下界

    s² H_s ≤ ell_s + (s²+s)/2，

  即ell_s≥s²H_s−(s²+s)/2。先由自然数商/余数证明每项rational quotient≤Nat quotient+1，再求和及化简三角形和；不是浮点估计或拟合。
- `lowerIdeal_torOne_finrank`证明s≥2时真实标准Tor₁ᴬ(A/m,A/lowerIdeal s)的K维数恰为s+1+ell_s。R040产生的初始次数a通过双向标准性矛盾证明a=s，并非随意替换存在见证。
- `lowerIdeal_generator_number`进一步将s+1+ell_s识别为所有任意有限多项式生成集合基数中的IsLeast；不是只比较单项式生成集合。

R044精确轮廓 `h_d=min(d+1,floor(s²/(d+1)))` 给原先d<s时d+1、d≥s时floor值。三维H_d≤s²用实际标准指数集合注入range(s²)：(i,j)↦i(d+1)+j，再由H_0=1得到全部累计预算；无新枚举。

## 最终证据及边界

在lean/执行 `lake build`，返回0，日志末尾Build completed successfully。日志 `results/lean_lower_construction_build.txt`，SHA-256 `174a29cb3799d24b7110e85d51d1e68d8325728f24d1040c05c02f37304f8dec`。

三个冻结源码：LowerConstruction `1f82b90634a5d31aa52afddcbad07d56d773180fc4af0f36060863aa9bcade2e`；LowerProfile `5833f295a3881c9fd19527c23da63709914bf3eed9adf5380b50024712b0dec1`；LowerConstructionBounds `08439e34f7c012fbeb4d4396c6a2198875bee0a474deaa0d067620aba2a82783`。

统一日志中18项公理输出仅标准逻辑公理。六新增实际声明依赖根覆盖精确h2、真实admissible、xy精确值/谐和下界、标准Tor₁计数与IsLeast，均排除旧有限/小宽度证书和sorryAx。R045核对冻结源码、日志与数学量词并接受。

根编译修正仅涉及Nat.le_div_iff_mul_le的参数/定向乘法改写、自然数求和到有理数的显式congrArg和cast_sum，以及Module.Finite局部实例的显式monomialIdeal类型。没有新增待证数学假设；失败构建的占位诊断不属最终证据。

范围：本轮实现抽象lex类的显式族、有限公式及精确谐和下界，不声称已经形式化Real.log/完整Theta或非平方参数的明确log增长常数。预算单调扩展w≥s²已证明，但不等于完整sqrt/log分析。没有构造数值半群；不能倒用Betti(半群)≤Betti(lex)推半群下界。新颖性未认证，冻结v0.1/v0.2未改。始终最多两个子智能体同时工作，审查在构造者结束后启动。

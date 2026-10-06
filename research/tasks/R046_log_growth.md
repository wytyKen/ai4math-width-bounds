# R046 实对数增长上界

更新时间：2026-09-29。状态：R046整体完成并统一构建通过，R048最终审查接受。前半记录log_upper的上界模块交付，文末记录根的真实极值/标准Theta完整集成与证据。

## 状态与交付

**Lean 已编译。** `lake build WidthBounds.LogGrowth` 在固定 Lean/mathlib 4.22.0 下退出 0，最后输出 `Build completed successfully.`。没有占位证明、自定义公理或 `native_decide`。最终源码 SHA-256：

`880f67c5aaaf5caa5408f131890cd67069a09e887f87227c74c2f0840dd8e115`

根可直接导入 `WidthBounds.LogGrowth`。命名空间为 `WidthBounds.LogGrowth`。

1. `harmonicQ_eq_harmonic`：项目有理数谐和和恰为 mathlib `harmonic`。
2. `log_add_one_le_harmonicQ`：对每个自然数 n，`Real.log ((n : ℝ) + 1) ≤ (Growth.harmonicQ n : ℝ)`。
3. `harmonicQ_le_one_add_log`：对每个自然数 n，`(Growth.harmonicQ n : ℝ) ≤ 1 + Real.log (n : ℝ)`。n=0 也合法，遵循 mathlib 的 `Real.log 0 = 0`。
4. `one_le_log_of_four_le`：`4 ≤ w` 时 `1 ≤ Real.log (w : ℝ)`，便于下界或 Theta 集成复用。
5. `sectionLength_le_log`、`quotient_xy_le_log`：将已有有理谐和上界转成精确实对数上界

   `ell ≤ 3w + (2w−1) * (1 + log(2w−1))`。

6. `sectionLength_le_ten_mul_width_log`、`quotient_xy_le_ten_mul_width_log`：所有 `w ≥ 4` 的统一上界

   `ell ≤ 10 * (w : ℝ) * Real.log (w : ℝ)`。

`quotient_xy_le_*` 的 ell 是真实的 `Module.finrank K (xySubspace (monomialIdeal (R := K) S))`，并保持任意 `[Field K]`。实数只用于自然数维数的标量转换，未误加 `[CharZero K]`。假设完整保留：指数集合上闭、lex、真实单项式理想非零、x 标准、w≥4、每个次数的真实齐次商空间累计预算。

## 证明路线

`Growth.harmonicQ` 与库 `harmonic` 通过逐项 `one_div` 及自然数转换归一化严格相等。库 `Mathlib.NumberTheory.Harmonic.Bounds` 提供已证明的上下积分比较，得真实自然对数不等式。

已有项目 `Growth.quotient_xy_le_harmonic` 给出实际商空间有理界；`exact_mod_cast` 保序转至实数后乘以非负的 `(2w−1)`，得到精确实对数上界。

粗常数使用 `log 2 ≤ 1`、`1/2 ≤ log 2`、`log 4 = 2 log 2` 与对数单调性。w≥4 时 `log w ≥1`，且 `log(2w−1) ≤1+log w`，所以目标左侧不超过 `7w+2w log w ≤9w log w ≤10w log w`。代码直接以多项式不等式完成最后合并；常数10有意留余量，不声称最优。

## 编译与公理证据

最终命令（工作目录 `D:\project\ai4math\lean`）：

```text
lake build WidthBounds.LogGrowth
ℹ [3109/3109] Built WidthBounds.LogGrowth
Build completed successfully.
```

五个 `#print axioms` 检查的最终输出都恰为 `[propext, Classical.choice, Quot.sound]`：harmonic 相等、上下 log 比较、精确实际 quotient 上界、实际 quotient 的10倍上界。最终构建无新增告警。

开发阶段第一遍 `lake env lean` 只在 `log 2 ≤ 1` 的 `2−1` 归一化处失败；改为 `convert` 后显式 `norm_num`，随后 `lake env lean` 退出0，再修去一个不必要的策略序列告警并以 `lake build` 对最终源码重编译成功。旧失败输出不能当作当前版本审计结论。

## 范围与下一步

本文件已形式化实对数上下谐和比较和一般真实 lex 商空间的实对数上界；没有独立声称已经证明整个研究主线或半群下界。极值函数是否可达到、非平方参数构造和标准 `Asymptotics.IsTheta` 分别由根及 R047 集成。下界族属于抽象 lex 预算类，不能由半群到 lex 的 Betti 上界比较反推半群匹配下界。未作新颖性认证、外部审阅或新 PDF 更新。

## 根集成：真实极值的标准Theta（2026-09-29）

根新增 `lean/WidthBounds/LexGrowthTheta.lean`。Admissible不是任意组合谓词：它要求实际指数上集、lex、实际商A/I的Module.Finite、x标准和全部次数的真实齐次商空间预算。非零理想由有限余长/纯z幂接口推得，不额外当未知假设。

lengthSet K w定义为该类真实理想的完整xy商子空间维数集合；maxLexLength K w取自然数sSup。对w≥4，L_2构造使集合非空，旧全部宽度解析界给显式自然数上界。Nat.sSup_mem证明该数确实由一个实际理想达到；maxLexLength_isGreatest证明它是真正最大值，没有把各次数包络的和误作可实现的极值。

实对数两端已完全连接：

- w≥4时，每个目标理想及最大值M(w)≤10w log w。
- 每个w≥64取s=Nat.sqrt w，R047证明s≥2、s²≤w及具体下界w log w/16≤ell_s。旧构造的预算单调性使同一个实际L_s属于预算参数w的类，故下界不局限于平方子序列。
- 因而所有w≥64有 `w log w/16 ≤ M(w) ≤ 10w log w`。
- `maxLexLength_isTheta`使用mathlib标准Asymptotics.IsTheta Filter.atTop，将两个比较转为带范数的两向IsBigO，明确处理log非负性。不是自定义Theta标签，也不是浮点/曲线拟合。

系数域K始终任意Field，只有自然数维数与有理谐和数cast到Real，没有把K限定为CharZero。这证明抽象有限余长lex预算类的最大xy截面长度增长阶，不证明每个理想都达到该阶，不是数值半群匹配下界。

## 最终统一验收

lean/执行 `lake build`，退出0。日志 `results/lean_lex_theta_build.txt`，SHA-256 `0b43de4c75bf3eeedc6af52ca63417c53aae798e6593aefda2255eea40d230b8`；根源码LexGrowthTheta.lean SHA-256 `779ecd9db9df3b75aa6ddaf74102f9c591a76b4dcb79876420e72f6ff34bb736`。另两冻结源码hash见R046/R047交付记录。

三模块12项公理输出仅propext、Classical.choice、Quot.sound；禁用项无命中。实际声明依赖审计新增真实上界、真实下界、最大值达到性、双侧界、标准Theta五个根，均排除旧有限/小宽度证书和sorryAx。R048最终独立接受，报告SHA-256 `e1441027896a3e4103e6213d330f9d7586d5daf63ebbcbe4768d0dc809fce572`。

根极值与Theta模块首次完整编译通过；只补建固定mathlib4.22.0的谐和Bounds缓存，没有更改版本、旧证明或冻结v0.1/v0.2。更高Tor/Betti与完整半群归约未开展，新颖性未认证。

用户询问何时结束项目；结束标准及建议见research/FINISH_PLAN.md。本里程碑已完成，研究交付建议只剩一次总审校/打包；端到端半群Lean仍有实质大项，不能给出未经证据支持的日期。用户尚未答复两种完成标准选择，不将默认选项当授权。

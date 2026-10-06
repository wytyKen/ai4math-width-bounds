# R047：任意大宽度的实对数构造下界

状态：已完成并统一集成验收，R048最终接受，2026-09-29。执行者仅修改LogLower.lean与本报告；根已将所有w≥64下界接入标准Theta。

## 目标与证明路线

对每个自然数 `w ≥ 64`，取 `s = Nat.sqrt w`，证明

`(w : ℝ) * Real.log w / 16 ≤ (Lower.lowerSectionLength s : ℝ)`。

同时给出 `2 ≤ s`、`s*s ≤ w` 与真实 lex 理想 `Lower.lowerIdeal s` 的全 xy 商子空间 finrank 下界。结论仅涉及抽象累计预算 lex 类，不是数值半群构造或半群下界；新颖性未定。

证明依赖已编译的 `Lower.lowerSectionLength_harmonic`：`s² H_s ≤ ell + (s²+s)/2`，以及 mathlib 的 `log_add_one_le_harmonic`。先把 `Growth.harmonicQ` 与库 `harmonic` 对齐，得到实数版 `s² log(s+1) ≤ ell+(s²+s)/2`。

`Nat.sqrt_le` 和 `Nat.lt_succ_sqrt` 给 `s²≤w<(s+1)²`。由 `s≥2` 得 `w≤4s²`、`s≤s²/2`。对数单调性给 `log w≤2log(s+1)`；`Real.one_sub_inv_le_log_of_pos` 在2处给 `log2≥1/2`，再用 `log64=6log2` 得 `log w≥3`。所以 `ell≥s²log w/4≥wlog w/16`。

## 精确接口

namespace 为 `WidthBounds.LogLower`，共四项公开定理：

1. `sqrt_admissible {w : ℕ} (hw : 64 ≤ w)`：`2 ≤ Nat.sqrt w ∧ Nat.sqrt w * Nat.sqrt w ≤ w`。
2. `lowerSectionLength_log_add_one (s : ℕ)`：`(s : ℝ)^2 * Real.log (s+1 : ℕ) ≤ (Lower.lowerSectionLength s : ℝ) + ((s : ℝ)^2+s)/2`。不要求 `s≥2`。
3. `lowerSectionLength_log_lower {w : ℕ} (hw : 64 ≤ w)`：`(w : ℝ) * Real.log w / 16 ≤ (Lower.lowerSectionLength (Nat.sqrt w) : ℝ)`。
4. `lowerIdeal_xy_log_lower {K : Type*} [Field K] {w : ℕ} (hw : 64 ≤ w)`：相同左端不大于 `Module.finrank K (MonomialInterface.xySubspace (Lower.lowerIdeal (K := K) (Nat.sqrt w)))` 的实数转换。

现成的 `Lower.lowerIdeal_finrank_budget_of_square_le` 与第1项保证该真实理想在预算 `w` 下可容许。有限余长与 lex 性仍由既有 `LowerConstruction` 定理提供；本模块不重新定义理想。

## 编译证据

命令（工作目录 `lean/`）：`lake env lean WidthBounds/LogLower.lean`。

最终命令退出码0，完整本模块输出为：

```text
'WidthBounds.LogLower.sqrt_admissible' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.LogLower.lowerSectionLength_log_add_one' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.LogLower.lowerSectionLength_log_lower' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.LogLower.lowerIdeal_xy_log_lower' depends on axioms: [propext, Classical.choice, Quot.sound]
```

源码 SHA-256：`3ea59be90c9c37301d983337e060cf373f28d76a484864d2ab10ca2b89a8c360`。这是执行者单模块验收证据；根统一构建日志独立登记，不把旧日志当新版本证据。

随后 `lake build WidthBounds.LogLower` 亦退出0，尾部为 `[3254/3254] Built WidthBounds.LogLower`、相同四项标准公理输出及 `Build completed successfully.`；对应 `.olean` 已产生，可供根导入。本次 build 重放了旧依赖模块的打印，重放本身不表示新定理使用旧有限证书；数学正文仅调用上述谐和界、平方根界、对数界与真实xy维数公式。

## 失败路线与修正

首轮编译仅剩有理数到实数转换问题：`exact_mod_cast` 没有把左端的自然数乘积 `s*s` 与目标的 `s^2` 自动识别一致。先把乘积统一成平方后，第二次尝试仍因谐和数乘积上有理数转换没有展开而失败。最终用 `(Rat.cast_le (K := ℝ)).mpr hrat'` 显式传递整个不等式，再仅展开 `Rat.cast_mul`、`Rat.cast_pow`、`Rat.cast_natCast`、`Rat.cast_add`、`Rat.cast_div` 与 `Rat.cast_ofNat`。该修正编译通过。数学路线未变；未尝试其他常数或阈值。

禁止项未使用：`sorry`、`admit`、自定义公理、`native_decide`。首轮失败产生的 `sorryAx` 打印不作为有效证据。

## 结论边界与下一步

本任务结果类型为 **Lean已编译**，范围仅为上述四个有限参数/全部大参数定理，不是整份数学稿件完全形式化，也没有单独声明渐近 `IsTheta`。没有数值实验或外部查新。本模块没有自定义公理；标准 `propext`、`Classical.choice`、`Quot.sound` 已如实记录。

下一步由主智能体把上下界接入抽象实际理想类最大值与 `IsTheta` 接口，做统一构建、独立语义验收及 claims 哈希登记。执行者不修改状态或冻结稿件。

## 根最终验收

本模块已用于真实lex极值下界，和R046上界共同给标准IsTheta。统一 `lake build` 退出0，日志 `results/lean_lex_theta_build.txt`，SHA-256 `0b43de4c75bf3eeedc6af52ca63417c53aae798e6593aefda2255eea40d230b8`。R048独立核对sqrt取整、所有w≥64、正性/取整方向及真实理想应用并接受；冻结源码保持原hash。完整抽象最大截面Theta已在根模块证明，但没有把这条下界转成半群下界。

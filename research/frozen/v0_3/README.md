# ai4math：四生成元宽度界与 lex 极值增长

**研究交付 v0.3，2026-09-29。用户选择在此关闭研究阶段，不再自动追加数学任务。** 原数值半群结论已有传统证明稿及内部审查；真实 lex 模型的组合界、商空间、最少生成数、标准第一 Tor 与极值增长阶已有 Lean 验证。完整半群定理尚未端到端形式化，新颖性与人类同行评审未认证。

## 从这里阅读

- **[全过程与扩展报告](research/PROJECT_REPORT.md)**：原问题、各阶段路线与关键取舍、精确定理和假设、证明依赖、失败教训、源码证据地图、复现办法和可选后续工作包。长期维护入口。
- **[交付与复核指南](research/DELIVERY.md)**：包内容、校验命令、重建环境、版本边界与恢复步骤。
- **[v0.3 英文数学报告](output/pdf/width_bounds_v0_3.pdf)** / [LaTeX 源码](paper/width_bounds_v0_3.tex)：8 页定理、证明主线及验证范围。
- **[冻结交付包](output/ai4math_research_delivery_v0_3.zip)** / [校验收据](output/ai4math_research_delivery_v0_3.receipt.json)：源码、任务记录、日志、三版 PDF、历史审阅包及最终稳定检查点。

## 最终结果与边界

对任意域 K，在 A=K[x,y,z] 的真实有限余长 lex 理想类中，要求 x 标准且每个次数都满足实际齐次商维数累计预算 `Σ H_t ≤ 1+dw`。令 a 为初始纯 x 禁指数，ell 为实际完整 xy 商子空间维数。

- 所有 `w≥4` 有 `a+1+ell ≤ choose(w+1,2)-1`，并有第二、第三组合二项式界。
- 真正的任意有限多项式最少生成数 `μ(I)=a+1+ell`；实际 `I/mI`、`(A/m)⊗_A I` 和标准 `Tor₁ᴬ(A/m,A/I)` 的基与维数已经连接。Tor 同构保留 `I≤m`，固定第一因子并派生第二因子。
- 显式真实 lex 下界族给出精确取整和。该预算类最大 xy 维数 `M_K(w)` 在 `w≥4` 时确实达到；所有 `w≥64` 有 `w log w/16 ≤ M_K(w) ≤ 10w log w`，以及标准 `Asymptotics.IsTheta`。

上述机器验证不包括更高 Tor/Betti 公式、Tor 因子交换或完整半群归约。Theta 是**抽象 lex 预算类的最大值增长阶**，不是每个理想或数值半群的匹配下界。267 组参数、1807 个半群的有限检查仅用于查错；后来的全宽度解析证明不依赖旧有限证书。

## 快速复核

已有本地环境时，在项目根目录执行：

```powershell
.venv/Scripts/python.exe -B scripts/package_delivery.py --verify output/ai4math_research_delivery_v0_3.zip
.venv/Scripts/python.exe -B scripts/checkpoint.py --check
.venv/Scripts/python.exe -B scripts/checkpoint.py --verify-latest
```

这些命令检查字节、证据哈希和状态，不运行证明编译。最新数学构建日志为 [lean_lex_theta_build.txt](results/lean_lex_theta_build.txt)，证据登记见 [claims.json](research/claims.json)。本次收尾未改数学源码；复用了与源码哈希匹配的成功日志。

若要独立重新编译，在 `lean/` 执行 `lake build`。Lean/mathlib 固定 **4.22.0**，依赖提交锁定在 `lake-manifest.json`。首次安装、缓存设置、PDF 重建与校验工具测试详见交付指南。Python 只使用根 uv `.venv`，当前脚本仅依赖标准库。

## 版本与未来恢复

[v0.1](paper/README.md) 和 [v0.2](paper/README_v0_2.md) 及各自 PDF、ZIP 保持原字节；它们描述当时范围，不能作为最新状态。最新汇总以本 README、PROJECT_REPORT、DELIVERY 和 claims 为准。

未来只有在用户另行选择扩展目标时重开研究：先读 [AGENTS](AGENTS.md)、[STATE](research/STATE.md)、[HANDOFF](research/HANDOFF.md)，核验冻结包与检查点，再按 [PROTOCOL](research/PROTOCOL.md) 登记有限任务。当前队列无应自动执行的下一项；R009 外部专家联系仍暂缓，未发信、上传或发表。

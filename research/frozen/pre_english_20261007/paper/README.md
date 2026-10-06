# 研究短稿 v0.1：审阅说明

主稿：`width_bounds.tex`。PDF 位于项目根目录的 `output/pdf/width_bounds.pdf`。

稿件命题是：对任意域和恰有四个最小生成元的数值半群，完备局部半群环相对于最小正则表示的 Betti 数满足 `b_i <= i*binom(w+1,i+1)`，范围为 `i>=1`。

本稿将两层证明分开：

- 新增的标准单项式组合论证和有限算术证书已通过 Lean；主定理是 `WidthBounds.small_width_binomial_bounds`。
- 从实际半群环到有限余长 lex 理想，以及从截面长度回到 Betti 数，使用 CMS 与 Herzog–Stamate 的已发表结果。此代数连接有逐项传统证明和独立模型审查，尚未整体形式化，也尚无领域专家的外部审稿。

原始文献的版本、命题号和出处均列在稿中。现有有限查新未发现重复结果，但不构成原创性或优先权认证。稿件不署作者名；作者及研究责任应在实际对外提交前确定。

建议审查者优先看：

1. Lemma 2.2 的标准单项式列计数与 Lemma 2.4 的逐次数包络，是否正确使用 lex 方向及所有累计约束。
2. Section 3 的归约中，有限余长、无一次项、特征无关性、理想模/商环下标是否完整。
3. 是否已有论文包含相同的小宽度结论或等价的二维截面包络方法。

复现：

```powershell
# 从项目根目录运行，Python 使用本地 uv 虚拟环境
uv --cache-dir .uv-cache run --frozen python scripts/envelope_certificate.py
Set-Location lean
lake build
```

生成 PDF 使用本机 MiKTeX 的 `pdflatex`（AMS、Latin Modern、geometry、booktabs、hyperref 等标准包）：

```powershell
# 从项目根目录运行
.\scripts\build_paper.ps1
```

完整的运行时和预编译依赖不放入审阅包；固定版本的 Lake 配置、依赖清单、Python 锁文件及证明源码均保留。

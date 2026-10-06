# ai4math：宽度界、lex 理想与标准 Tor

[English (primary)](README.md) · 中文说明

英语是项目的默认维护语言，完整主线见[英语文档](docs/README.md)。本中文页面保留阶段成果说明；更早的任务记录按原语言保存。

**进行中的人机协作数学研究项目（work in progress）。** 本仓库记录四生成元数值半群宽度问题的研究过程、相关组合论证，以及三变量 lex 理想模型的 Lean 形式化。提前公开的目的是让阶段成果和证据可供阅读、核查与后续扩展。

**状态更新：2026-10-07。** 数学基线完成于 R058，并冻结为 v0.4；贡献对照与证明叙事已完成到 R092。R112 将项目主入口、核心研究说明与维护文档改为英语优先，数学范围不变。原四生成元半群问题尚未端到端 Lean 形式化，候选贡献的新颖性仍未确定，未获得外部人类同行评审。

> **Research status (English).** This is an ongoing human–AI mathematical research project. The Lean development verifies a finite-colength, three-variable lex-ideal model, including an actual finite free resolution and standard higher Tor dimensions and bounds. The full reduction from four-generated numerical semigroups is not formalized end to end. Novelty remains unresolved; internal AI-assisted reviews are not external human peer review. The latest mathematical baseline is R058 / v0.4; contribution mapping and proof exposition are complete through R092.

## 从哪里开始

| 阅读目的 | 入口 |
|---|---|
| 理解主要证明及全部假设 | [核心证明叙事 N0–N9](research/publication/PROOF_NARRATIVE.md) |
| 从命题追到 Lean 声明 | [GitHub 可浏览声明映射](research/publication/STATEMENT_MAP_GITHUB.md)；[原验收映射](research/publication/STATEMENT_MAP.md)保留本地行链接 |
| 分清文献已知、候选贡献与未排除项 | [贡献对照表](research/publication/CONTRIBUTION_MAP.md) |
| 阅读冻结的英文数学报告 | [v0.4 PDF](output/pdf/width_bounds_v0_4.pdf) / [TeX](paper/width_bounds_v0_4.tex)，10 页阶段报告 |
| 查看全过程、意义与扩展方向 | [全过程报告](research/PROJECT_REPORT.md)、[项目复盘](research/PROJECT_RETROSPECTIVE_v0_4.md) |
| 查看当前工作与后续规划 | [STATE](research/STATE.md)、[HANDOFF](research/HANDOFF.md)、[发表准备计划](research/PUBLICATION_PREPARATION_PLAN.md) |
| 自行上传本项目到 GitHub | [Windows PowerShell 上传指南](research/publication/GITHUB_UPLOAD_GUIDE.md) |

历史文档保留其写作时的状态；例如 v0.4 交付指南中的“下一 R060”是旧停点。当前路线以 STATE 和发表准备计划为准。GitHub 版声明映射仅转换链接并加导读说明，原验收稿与冻结稿未改写。

## 已经做到哪一步

| 层面 | 当前结果与证据 | 仍需区分的边界 |
|---|---|---|
| 组合界与极值 | 谐和 / 对数上界、严格二项式界、真实可行下界族，以及实际 lex 预算类最大值的 Θ(w log w) | 不等于原半群类也有匹配下界；不声称下界族对每个 w 精确最优 |
| 形式化 | 实际有限自由分解、标准所有高阶 Tor、真实 K 有限维数、消失与宽度界；R058 有匹配源码的成功 Lean 构建日志 | 覆盖的是下面列明假设的 lex 模型；完整半群归约仍有缺桥 |
| 传统数学叙事 | 原半群应用通过文献归约与比较论证说明，R092 整理到可读证明和精确映射 | 传统证明、文献引用、纸面直接推论和已编译 Lean 声明分别标注 |
| 新颖性 | R091 对照了相关文献、已有算法和形式化工作 | U1–U5 尚有未排除项；不宣称首次证明、首次形式化或已解决开放问题 |
| 复现与发表 | 固定 Lean / mathlib 版本；保存源码、日志、结论哈希与冻结版本 | 尚未完成 R095 独立干净环境复现；公开源码本身不代表论文发表或同行认可 |

### 形式化主模型的精确范围

设 K 为任意域，A = K[x,y,z]，m = (x,y,z)。I 是实际有限余长 lex 单项式理想，x 不属于 I，整数 w ≥ 4，并对每个 d ≥ 0 满足实际累计 Hilbert 维数预算

```text
Σ_{t=0}^d dim_K Q_t(I) ≤ 1 + d·w
```

其中 Q_t(I) 是 t 次齐次多项式在 A/I 中的像。有限余长是独立假设。令 a 为首个使 xᵃ 属于 I 的指数，ℓ 为完整 xy 商子空间的实际 K 维数。

- A/I 的实际标准有限自由分解在 0、1、2、3 次的 A 秩依次为 **1、a+1+ℓ、a+2ℓ、ℓ**，4 次起为零项；与 A/m 张量后所有微分为零。
- 标准对象 **Torᵢᴬ(A/m, A/I)** 固定第一因子 A/m，派生第二因子 A/I；K 作用沿实际 K→A 限制。所有次数均证明 K 有限性，0–3 次维数为上述四数，i ≥ 4 为真正零对象（`IsZero`）。
- 记 `b_i = dim_K Tor_i^A(A/m, A/I)`。所有 i ≥ 1 均满足 `b_i ≤ i·C(w+1, i+1)`，其中 C(n,k) 表示二项式系数（从 n 个元素中选 k 个，k > n 时为 0）。第一界更严格：`b_1 < C(w+1, 2) = w·(w+1)/2`。
- 令 M_K(w) 为该实际 lex 预算类的最大 xy 维数。最大值在 w ≥ 4 时达到，w ≥ 64 时有 `w·log(w)/16 ≤ M_K(w) ≤ 10w·log(w)`，其中 log 为自然对数；并连接 mathlib 标准 `Asymptotics.IsTheta`。

完整半群归约、一般 Tor 因子交换 / 平衡比较、完整分次位移与 Betti 表接口仍未完成。b₂、b₃ 的显式谐和式在证明叙事中作为既有声明的直接数学推论列出，不冒称新增独立已编译端点。有限实验用于探索和查错，不替代一般证明。

## AI 参与、审核与责任

AI 助手实质参与了推导、Lean 实现、文献核查、文档整理及内部复核；人类提出研究目标、调整范围并作出推进决定。具体人工贡献、独立理解和核验范围仍待 R093 如实记录，不能从已有操作授权推定已经完成。

任务报告中的“独立复核”通常指另一执行智能体的内部检查，**不表示独立人类专家审阅**，也不构成统计独立的可靠性测量。Lean 编译证据只针对实际声明与依赖；传统论证及文献解释仍需按其自身证据判断。项目禁止 `sorry`、`admit`、自定义公理和 `native_decide`；已记录的公理审计使用标准逻辑公理，研究假设显式保留。

本仓库不据此宣称 AI 自主发现新数学，或证明人机协作比其他方式更高效。未来论文署名和责任声明由实际人类贡献者确认。

## 环境与复核

Lean 与 mathlib 固定 **4.22.0**；mathlib 锁定提交 `79e94a093aff4a60fb1b1f92d9681e407124c2ca`，以 [lean-toolchain](lean/lean-toolchain) 和 [lake-manifest.json](lean/lake-manifest.json) 为准。不要通过 `lake update` 改变验收版本。Python 为 3.13 系列，使用根目录 uv `.venv`。

在已安装 elan / Lake 的机器上，从仓库根目录用 PowerShell 构建：

```powershell
$taskRoot = (Get-Location).Path
$env:MATHLIB_CACHE_DIR = Join-Path $taskRoot '.mathlib-cache'
Push-Location lean
try {
    lake exe cache get
    if ($LASTEXITCODE -ne 0) { throw 'mathlib cache download failed' }
    lake build
    if ($LASTEXITCODE -ne 0) { throw 'Lean build failed' }
} finally {
    Pop-Location
}
```

缓存取得可能需要网络。上述是供读者执行的重建命令，**不是本轮已完成干净复现的声明**。历史已验收结果为 [R058 验证清单](results/r058_validation.json)与 [Lean 构建日志](results/lean_higher_tor_build.txt)：一次成功的统一增量构建，含缓存回放。本次公开准备未改 Lean 或重跑构建。

需要运行 Python 检查工具时，在根目录执行：

```powershell
uv --cache-dir .uv-cache sync --frozen
.venv\Scripts\python.exe -B scripts/checkpoint.py --check
```

`--check` 检查队列结构，不运行证明。公开源码仓库不包含 `research/checkpoints/`、旧 ZIP、收据、缓存和下载的文献全文；它与完整本地交付包的载荷不同。因此不要在普通 Git 克隆中把 `--verify-latest` 当成必备成功项，也不要把缺少本地归档证据误报为 Lean 失败。[claims](research/claims.json)保留历史证据索引，其中部分文件仅在冻结交付材料中。

持有原冻结包时，另按 [v0.4 交付指南](research/DELIVERY_v0_4.md)验证 ZIP 和包内检查点。哈希校验只证明字节对应，不代替数学编译。Git 使用 [.gitattributes](.gitattributes)保留现有字节，避免换行自动转换使历史 SHA-256 失配。

## 后续、版本与许可

关于阶段性公开、AI 披露、作者责任与许可，请参阅[英语发布说明](docs/PUBLICATION_STATUS.md)。

下一计划项是 **R093：真实贡献与作者责任记录**；随后再选择主稿路线，并做独立复现 / 分发准备。R060–R067 是完整半群形式化的可选分支，不会因提前公开自动启动。v0.1–v0.4 的 TeX、PDF、归档和旧验收记录保持冻结，新增成果另记版本。

目前尚未选定项目级许可证，也未设置正式论文署名或 DOI。请勿把“公开可读”当作已经授予开源再利用许可；第三方材料仍遵循其原许可。许可选择见 [GitHub 官方说明](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)。如引用阶段成果，请注明仓库地址、具体提交和上述未完成范围。

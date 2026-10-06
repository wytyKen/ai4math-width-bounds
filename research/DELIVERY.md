# v0.3 研究交付与复核指南

交付日期：2026-09-29。阅读全过程与未来扩展，请从 [PROJECT_REPORT](PROJECT_REPORT.md) 开始；本文件负责操作、证据和保存边界。用户选择的是研究交付收尾，不要求把原数值半群定理剩余同调与归约全部补成 Lean 后才结束。

## 1. 交付物及角色

| 入口 | 用途 |
|---|---|
| [PROJECT_REPORT.md](PROJECT_REPORT.md) | 中文全过程、最终数学、路线取舍、证据地图、失败教训、可选后续工作包 |
| [v0.3 PDF](../output/pdf/width_bounds_v0_3.pdf) / [TeX](../paper/width_bounds_v0_3.tex) | 8 页英文数学报告；含传统半群证明、实际代数与 Tor1、真实极值 Theta 和状态表 |
| [交付 ZIP](../output/ai4math_research_delivery_v0_3.zip) | 冻结可移交载荷；不是运行时安装包 |
| [外置收据](../output/ai4math_research_delivery_v0_3.receipt.json) | ZIP 整体 SHA-256、大小、内部 manifest SHA、最终 checkpoint ID、实际核验结果 |
| [claims.json](claims.json) | 数学/实验/传统证明/交付记录分层及相应证据 SHA-256 |
| [queue.json](queue.json) / [STATE](STATE.md) / [HANDOFF](HANDOFF.md) | 已关闭范围、任务验收和未来恢复约定 |
| [最终数学构建日志](../results/lean_lex_theta_build.txt) | 固定 Lean/mathlib 4.22.0 的统一构建和声明审计输出 |
| [交付验证记录](../results/delivery_validation_v0_3.json) / [PDF QA](../results/pdf_qa_v0_3.md) / [独立审查](tasks/R051_delivery_audit.md) | 本次复核做了什么、未做什么；最终 ZIP 创建后的校验数值在外置收据 |

包的具体文件表为包内 `output/DELIVERY_MANIFEST.json`，它为每个载荷条目记录路径、字节数和 SHA-256，不为自己记录哈希。外置收据记录整个 ZIP 和 manifest 的哈希，避免“ZIP 内文件写入该 ZIP 自身哈希”的循环。

包内含根文档、Python/Lean 固定依赖配置、全部项目 Lean 源码、脚本、研究任务报告和文本结果、三版 PDF、原 v0.1/v0.2 审阅 ZIP，以及 `research/checkpoints/LATEST.json` 和它所指最终 checkpoint 的 `manifest.json`、`source.zip`。不会打入 `.venv`、`.lake`、`.uv-cache`、`.mathlib-cache`、Git 对象、临时渲染图或全部旧 checkpoint 历史。当前项目无完整离线工具链交付；首次重建通常需安装已固定版本和下载依赖。

原 v0.1/v0.2 PDF、TeX、审阅 ZIP 和历史报告保持原内容。早期文件的“尚未形式化”描述按其历史日期理解，当前范围以 C021–C023 与新主报告为准。旧日志不作为已修改证明的新验证证据；本次没有修改数学证明源码。

## 2. 先核对完整性

以下命令在当前项目根目录执行，Python 只用根 `.venv`。交付脚本只用标准库。

```powershell
.venv\Scripts\python.exe -B scripts/package_delivery.py --verify output/ai4math_research_delivery_v0_3.zip
```

成功输出 `archive_valid: true`，以及实际文件数、claims 引用数、checkpoint ID 和 ZIP SHA-256。`--verify` **仅读该 ZIP**：拒绝重复/不安全路径、额外或缺少的载荷、文件哈希/长度变化、包内 claims 引用缺失或失配、活动任务及 WIP checkpoint；不依赖当前工作区的证明文件来“补全”坏包，也不解压执行任何内容。它核对内嵌 checkpoint 的整体哈希；内嵌 checkpoint 的详细逐项检查可在解压后用原 checkpoint 工具执行。

也可用系统命令核对外置收据与整包：

```powershell
$taskReceipt = Get-Content output/ai4math_research_delivery_v0_3.receipt.json -Raw | ConvertFrom-Json
$taskHash = (Get-FileHash output/ai4math_research_delivery_v0_3.zip -Algorithm SHA256).Hash.ToLowerInvariant()
$taskHash -eq $taskReceipt.sha256
```

预期 `True`。SHA 证明与保留的收据/清单一致，不是密码签名；一致性不证明作者身份、原创性、文献结论或数学模型正确性。即使所有校验通过，也不能说又运行了一次 Lean。`--verify` 本身只计算 ZIP 摘要，不自动读取外置收据。

解压时选择一个新的空目录，避免覆盖现有项目。在那里创建根 `.venv` 后执行：

```powershell
.venv\Scripts\python.exe -B scripts/checkpoint.py --check
.venv\Scripts\python.exe -B scripts/checkpoint.py --verify-latest
```

`--check` 只查队列结构与所有权；`--verify-latest` 区分“归档损坏”和“工作区自快照之后的正常改变”。干净载荷预期 `archive_valid: true`、`workspace.changed: false`、`is_wip: false`。解压目录名和机器路径可变，正文的历史运行路径无需改写。包本身及外置收据位于交付外层；解压后的内部 README 对交付 ZIP 的相对链接可能需要把收到的 ZIP/收据另存到 `output/`，这不会影响源码 checkpoint。内部清单放在 `output/`，因此不被源码 checkpoint 误报为新增源码。

## 3. 固定环境与证明复现

Python 配置：`pyproject.toml` 要求 3.13 系列，已使用 Python 3.13.2；`uv.lock` 固定依赖，当前无第三方 Python 包。新目录可先运行：

```powershell
uv --cache-dir .uv-cache sync --frozen
.venv\Scripts\python.exe -B scripts/checkpoint.py --check
```

Lean 配置：`lean/lean-toolchain` 固定 `leanprover/lean4:v4.22.0`，mathlib tag v4.22.0，精确提交 `79e94a093aff4a60fb1b1f92d9681e407124c2ca` 及传递依赖见 `lean/lake-manifest.json`。需要可用的 elan/lake；不要为便捷而升级依赖或执行 `lake update` 改锁文件。

```powershell
$taskRoot = (Get-Location).Path
$env:MATHLIB_CACHE_DIR = Join-Path $taskRoot '.mathlib-cache'
Set-Location lean
lake build
Set-Location $taskRoot
```

已有缓存时直接构建；首次需要预编译缓存时可在 `lean/` 执行 `lake exe cache get`，保留上述项目内缓存目录，随后再 `lake build`。输出中成功构建、指定 `#print axioms` 与实际依赖审计要分别读，单纯退出 0 不替代语义审查。

交付沿用的最新统一日志 SHA-256 为：

```text
0b43de4c75bf3eeedc6af52ca63417c53aae798e6593aefda2255eea40d230b8
```

其对应源码已在本次重新核对字节，最后 R048 独立审查已接受。该日志中新增十二项公理输出仅 `propext`、`Classical.choice`、`Quot.sound`；新增声明的传递依赖排除旧有限证书和 `sorryAx`。这不是对未完成半群归约的证明声明。

## 4. 文稿与工具复现

v0.3 TeX 沿用项目数学论文构建方式：本机 MiKTeX `pdflatex` 两遍编译，Poppler 渲染所有页目视检查。最终 PDF 8 页，无 overfull/underfull、未定义引用或缺字警告；检查见 PDF QA。

```powershell
.\scripts\build_paper.ps1 -PaperName width_bounds_v0_3
.venv\Scripts\python.exe -B scripts/test_package_delivery.py
```

PDF 编译需要本机 TeX 字体/宏包；排版工具版本/时间元数据变化可导致新 PDF 字节不同，即使数学文本相同。**在新工作副本里重建**，不覆写保留的冻结原件或据此覆盖旧哈希。测试覆盖载荷篡改、未列文件、重复条目、路径越界、陈旧 claims、活动队列、WIP checkpoint、防覆盖及独立于工作区的验证。

冻结流程顺序是：完成审查和所有报告 → 更新 claims/queue/STATE/HANDOFF → 建立并核验稳定 checkpoint → 创建 ZIP 并核验 → 写外置收据。不在源码文件内回填该最终 ZIP 的哈希，因而没有自引用依赖。脚本默认创建固定 v0.3 ZIP，若 ZIP 或收据已存在会拒绝；以后版本应另立名称和里程碑，不能删除旧包来重复创建。

## 5. 交付完成的准确含义

本阶段完成了用户选定的研究与文档交付。后续不自动运行队列、不新增数学子题、不联系专家、不发表。R009 仍 parked，恢复条件是用户授权具体外部动作；它不阻碍本次研究交付结束。

未完成的端到端部分是高阶 Tor/Betti、必要的 Tor 因子交换、完整实际半群归约及边界连接；新颖性和外部同行认可也没有被认证。这些不会因有一个完整 ZIP 或成功校验而改变状态。未来可能扩展的具体起点、任务拆分与停止条件均见 PROJECT_REPORT，只有用户明确重启后才登记新编号、分配独占文件，并为改动重新建立编译证据。

# v0.4 高阶lex研究冻结与复核指南

日期：2026-10-01。该版本完成真实三变量lex商的标准高阶Tor链，保留原四生成元半群归约尚未端到端形式化的边界。长期过程见[PROJECT_REPORT第12节](PROJECT_REPORT.md#part-12)，原v0.3操作说明仍保留在[DELIVERY](DELIVERY.md)。

## 产物与证据

| 入口 | 内容 |
|---|---|
| [10页PDF](../output/pdf/width_bounds_v0_4.pdf) / [独立TeX](../paper/width_bounds_v0_4.tex) | 传统半群层、旧组合/极值结论、新实际d1/d2/d3分解与标准Tor/K维数证明、准确验证范围 |
| [新ZIP](../output/ai4math_research_delivery_v0_4.zip) / [外置receipt](../output/ai4math_research_delivery_v0_4.receipt.json) | 源码、任务历史、数学/测试日志、所需历史产物、新PDF和稳定checkpoint；receipt记录整体/内清单hash及实际核验结果 |
| [claims](claims.json)、[R058数学验证](../results/r058_validation.json)、[R083整链审查](tasks/R083_lex_chain_release_audit.md) | 实际数学陈述、源码/日志hash与独立语义接受 |
| [交付准备验证](../results/delivery_validation_v0_4.json)、[PDF QA](../results/pdf_qa_v0_4.md)、[R084工具报告](tasks/R084_v04_packager.md) | 文稿/环境/版本对应和归档工具测试；最终ZIP数字只在外置receipt |
| [STATE](STATE.md)、[HANDOFF](HANDOFF.md)、[NEXT_STAGE_PLAN](NEXT_STAGE_PLAN.md) | 本阶段停点；下一R060须用户启动 |

## 数学覆盖范围

任意Field K、A=K[x,y,z]、m=(x,y,z)，实际monomialIdeal S与上集/lex、实际有限余长、x标准、w≥4和全部次数实际累计预算。标准Tor第一A/m、派生第二A/I，其K作用沿实际algebraMap限制。所有次数K有限，0..3维数1,a+1+ell,a+2ell,ell，4次起实际IsZero；i≥1全部二项式界和第一严格界成立。a和ell是实际初始禁指数和xy商子空间维数，不是按目标公式定义。

最新数学日志results/lean_higher_tor_build.txt，SHA-256 `29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4`，实际统一增量lake build退出0，16个R058新命名公理检查只标准三项，17个新实际依赖根通过。R059未改数学源码，重新核对源码/日志对应和整链语义，没有声称又做一次Lean构建。完整半群归约、必要Tor换序/约定比较和完整graded shifts API仍在后续范围；无新颖性或人类同行认可认证。

## 校验交付包

在项目根目录，Python只用根.venv：

```powershell
.venv\Scripts\python.exe -B scripts/package_delivery_v0_4.py --verify output/ai4math_research_delivery_v0_4.zip
```

`archive_valid: true`表示该ZIP独立通过：规范安全路径、无重复成员/未列文件、每个载荷的大小/SHA、包内claims引用、关闭队列、稳定内嵌checkpoint，以及内嵌source.zip每个源码字节与外层源码完全相同。验证不借当前工作区补全缺失文件、不解压执行、不运行Lean。新内清单为`output/DELIVERY_MANIFEST_v0_4.json`，它不列自己的hash；整包hash由外置receipt记录。

另将收到的ZIP与外置收据对应：

```powershell
$taskReceipt = Get-Content output/ai4math_research_delivery_v0_4.receipt.json -Raw | ConvertFrom-Json
$taskDigest = (Get-FileHash output/ai4math_research_delivery_v0_4.zip -Algorithm SHA256).Hash.ToLowerInvariant()
$taskDigest -eq $taskReceipt.sha256
```

包验证本身不读取外置receipt。hash一致仅证明字节与记录对应，不是密码签名或数学正确性的替代。实际最终文件数、证据引用数、源码checkpoint ID、ZIP大小与hash均读receipt，源码文档不回填它们以避免自引用循环。

## 载荷与环境

工具收录checkpoint.source_paths选择的全部项目源码/文档/任务/文本结果、四版PDF、v0.1/v0.2审阅包、claims直接引用的全部证据（含所需冻结二进制）、LATEST及其指向的稳定manifest和source.zip。本次还保留v0.3原ZIP及收据作为旧版本证据。不会打入.venv、.lake、.uv-cache、.mathlib-cache、Git对象、临时渲染图或全部旧checkpoint历史；不是完整离线运行时安装包。

选择新的空目录解压，避免覆盖现有工作区。内嵌checkpoint工具可在新目录复核；当前v0.4的ZIP/receipt在包外，若需要让文档相对链接可用，可将收到的两个文件放入解压目录output/，它们不参与源码checkpoint。新机器可能需安装固定依赖；保留Lean/mathlib4.22.0、mathlib提交79e94a093aff4a60fb1b1f92d9681e407124c2ca与lake-manifest，不运行lake update来消除版本差异。Python3.13系列由pyproject/uv.lock约束，脚本仅用标准库。

```powershell
uv --cache-dir .uv-cache sync --frozen
.venv\Scripts\python.exe -B scripts/checkpoint.py --check
.venv\Scripts\python.exe -B scripts/checkpoint.py --verify-latest
$taskRoot = (Get-Location).Path
$env:MATHLIB_CACHE_DIR = Join-Path $taskRoot '.mathlib-cache'
Push-Location lean
lake build
Pop-Location
```

缓存不足时先辨认缺缓存与证明错误；首次可在lean目录取得固定版mathlib缓存，保持上述项目内缓存位置。不需要为了阅读交付重跑历史枚举。解压载荷相对于内嵌checkpoint应archive_valid=true、workspace.changed=false；检查点校验不等于证明编译。

## PDF复现与工具测试

新TeX已通过open_in_codex提交到Codex内置编辑器（工具返回queued）；该环境的内置编译器报标准目录缺失，未据此声称编译成功。最终PDF使用项目已有MiKTeX pdflatex两遍编译，脚本实际退出0，所有10页已由Poppler渲染逐页检查。没有overfull/underfull、未定义引用或缺字警告。准确最终TeX/PDF hash和可复核编译日志见PDF QA。同一TeX和编辑器打开请求保留，供后续查看；当前交付PDF的成功证据是本地编译与渲染。

在新的工作副本复现，保留原PDF，不覆盖冻结产物：

```powershell
.\scripts\build_paper_v0_4.ps1
.venv\Scripts\python.exe -B scripts/test_package_delivery_v0_4.py
```

若本副本已含冻结v0.4 ZIP，构建脚本拒绝覆写对应PDF；应在另外的工作副本运行。字体/TeX版本与时间元数据可能使重建PDF字节不同。旧build_paper.ps1、package_delivery.py及其v0.3验收记录不变，新脚本仅处理v0.4。归档测试覆盖有效包、篡改/缺失/额外文件、路径与重复、旧证据、活动队列、WIP、内外层源码不一致、循环引用和防覆盖等失败模式，不以测试代替实际整包验证。

## 冻结顺序与恢复最后一步

先完成数学整链复核、文稿/PDF QA、工具测试和全部源码报告，更新claims与关闭本阶段源内任务；再保存稳定且工作区未变的checkpoint；最后运行一次新的打包脚本，工具在发布ZIP前自行验证临时整包，再写外置receipt。

源内的任务关闭记录表示数学、文稿和可移交载荷准备已验收，最终归档事务的实际完成由外置receipt及整包校验确认。若归档或receipt尚不存在，交付最后一步还未完成，恢复时只完成这一归档动作，不能据源内状态声称ZIP已交付或启动R060。不得为重新打包删除已存在版本；有异常先保留现有字节并核对报告。

旧v0.1/v0.2/v0.3 PDF、TeX、ZIP及验收原件保持不变；README和长期报告的v0.3原字节已移交research/frozen/v0_3，历史C024 evidence只换定位路径、hash不变。当前v0.4是新的有限阶段出口。R060以后与外部专家联系仍等待用户明确指令，不自动继续或公开发布。

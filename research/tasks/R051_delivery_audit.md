# R051：研究交付口径与证据独立审查

日期：2026-09-29。执行者 `/root/delivery_audit`。唯一可编辑文件为本报告；不改证明、状态、claims、配置、稿件或打包脚本，不派生、不外联、不重跑未修改数学源码的完整 Lean 构建。

## 状态与审查方法

**最终接受：交付正文、现有证据对应关系与冻结载荷准备。无待修正缺陷。** 初审和修订过程保留于下文，最终结论见末节。本报告冻结在最终 checkpoint 和 ZIP 创建之前；两者必须包含本报告，故其实际成功结果由根在本报告冻结后执行，并记录于包外 receipt。本报告不预先宣称尚未生成的最终 ZIP 已校验成功。

已按恢复协议读取 AGENTS、STATE、HANDOFF、queue、PROTOCOL、claims，并阅读 R043、R045、R046、R047、R048 的最终报告、`LexGrowthTheta.lean` 与 `TorOneBounds.lean` 的实际接口、统一数学构建日志及固定版本配置。依据当前用户授权只做研究交付收尾，不添加研究任务。

本审查分开处理三类证据：源码语义和既有 Lean 构建；传统证明/内部模型审查；文件与归档字节完整性。哈希匹配不意味着本轮重新执行了证明，AI 独立审查不等于人类同行审稿。

## 恢复及证据核验记录

在项目根使用唯一允许的 Python `.venv\Scripts\python.exe -B`：

1. `scripts/checkpoint.py --check` 返回 `queue_valid: true`，无错误。
2. `scripts/checkpoint.py --verify-latest` 返回 `archive_valid: true`，检查点为 `research/checkpoints/20260929T083830833245Z-461c545d`。初核时工作区仅有 FINISH_PLAN、queue 修改和 R050 报告新增；是已登记收尾工作的正常后续差异，不是归档损坏。
3. 直接遍历当时 `claims.json` 的全部 23 条结论及证据，以 `hashlib.sha256(Path.read_bytes())` 重算实际文件；112 个独立路径全部匹配，没有缺失、hash 失配或同路径不同预期 hash。
4. 最新 `results/lean_lex_theta_build.txt` 为成功统一 `lake build` 记录，结尾为 `Build completed successfully.`。未发现 error、warning 或 sorryAx 诊断。新增 log/Theta 的 12 项公理输出仅有 `propext`、`Classical.choice`、`Quot.sound`；五个实际声明依赖审计根通过。审查者未再次运行完整 Lean 构建。
5. 配置固定为 `leanprover/lean4:v4.22.0`、mathlib `v4.22.0`；哈希审查覆盖根入口、依赖配置、数学模块和成功日志，未使用旧日志替代改动后源码的核验证据。
6. 补充核对 `DependencyAudit.lean` 的实际 `getUsedConstantsAsSet` 递归，确认它检验真实声明依赖而非仅 import。全部项目 Lean 源码禁止词搜索唯一命中是 `Arithmetic.lean` 第8行说明“不使用 sorry/custom axioms/native_decide”的注释，未发现禁止构造。
7. 用标准库 `zipfile.ZipFile.testzip()` 读取旧两审阅包：v0.1 共36条目、v0.2 共54条目，CRC 错误均为 null。未重写文件。

### 初核冻结产物

| 路径 | SHA-256 |
|---|---|
| `paper/width_bounds.tex` | `3d67eae1fd88d1947bbb8fede3c06bf81b69b72a9a4bc8579e2a67322744dd2d` |
| `paper/certificate_table.tex` | `2bfd90d9483112f0faf45f0801559c55c06bf3d3b3611f749778d99d902bd26f` |
| `output/pdf/width_bounds.pdf` | `35ef5ede0cfa95a99aac2afe54510e8ee84ad17ac4e26e70e5d6b7cca00ddfac` |
| `output/width_bounds_review_v0_1.zip` | `daf6849293d37ee1ae9bc44d8891ae01fa28a36827a9114ac1840ec7dc169001` |
| `paper/width_bounds_v0_2.tex` | `e0a5c4bbcb10c5671e1fa87664471f2ed088848b0e1aced91a01d0f05b2abba8` |
| `paper/README_v0_2.md` | `8e3ee1226f327630836de28ddc999d3cbb01d49c5b7e9f4160cc5e141d6bc85f` |
| `output/pdf/width_bounds_v0_2.pdf` | `40f4c90a0d8fe9f67d761a14483c57b068ebcf13bae8b9d51f376e9bc4c18445` |
| `output/width_bounds_review_v0_2.zip` | `9ad24bcc1a3eaa0829383b3fd70507f6d4ea99936682cbb6efc9fd35ddca89fc` |
| `results/lean_lex_theta_build.txt` | `0b43de4c75bf3eeedc6af52ca63417c53aae798e6593aefda2255eea40d230b8` |
| `research/tasks/R048_theta_review.md` | `e1441027896a3e4103e6213d330f9d7586d5daf63ebbcbe4768d0dc809fce572` |

上述冻结证据的现有哈希均相符；两个既有 PDF/审阅包是历史快照，不能作为新增标准 Tor₁ 和 Θ 结果的最新版交付物。

## 精确数学口径检查表

| 检查项 | 已核对的正确范围 |
|---|---|
| 系数域 | 任意 `[Field K]`，无 CharZero 限制；实数只用于维数数值的 log 比较。 |
| 实际对象 | A=K[x,y,z]；实际指数上集生成单项式理想，lex 次序 x>y>z；xy 空间为完整所有 x^i y^j 商类的张成。 |
| 极值类假设 | lex、指数上闭、真实 A/I 有限 K 维、x 标准；对每个自然数 d，实际齐次商空间累计维数 ≤1+dw。有限余长是独立条件。 |
| 最大值 | `lengthSet` 是上述实际理想达到的自然数维数；`maxLexLength` 为 sSup；w≥4 时 Nonempty、BddAbove、成员和 IsGreatest 都已有证明。 |
| 对数增长 | 每个 w≥64 有 w log w/16≤M_K(w)≤10w log w；上界单独从 w≥4 成立；标准 `Asymptotics.IsTheta Filter.atTop` 已编译。 |
| 下界族 | s≥2，标准单项式条件 (i+1)(i+j+k+1)≤s²；实际 lex/有限余长/全部次数预算与精确 xy 维数已证明；s=Nat.sqrt w 覆盖所有 w≥64。 |
| 生成数 | μ 比较任意有限多项式生成集合，不限单项式或齐次；完整极小单项式集合实现该最小值。 |
| 标准 Tor₁ | mathlib `CategoryTheory.Tor` 固定第一因子 A/m、派生第二因子 A/I；I≤m 是必要条件，张量底环仍为 A；K 作用经实际系数嵌入限制标量。 |
| 第一阶公式 | 在已陈述有限余长 lex 预算类中，dim_K Tor₁ᴬ(A/m,A/I)=μ=a+1+dim_K xySubspace；严格二项式与有理谐和界成立。 |
| 传统半群结论 | 原四最小生成元数值半群 Betti 归约仍是传统证明及内部审查；w=3 有单独分支；v0.2 的严格第一界纸面应用不冒充 Lean 半群定理。 |
| 仍未完成 | 更高 Tor/Betti、标准 Tor 两因子交换、完整数值半群归约及端到端半群目标尚未形式化；抽象 lex 下界不是半群下界。 |
| 可信层次 | 有限1807例仅查错；无新颖性认证、无人类外部同行审稿；内部模型审查和编译不扩大此范围。 |

## 初审待根处理的文字一致性事项

已回传根，属于正在整合的状态文字，不要求改动冻结数学证据：

- C015/C017 的历史 scope 仍总称 Betti/Tor 未完成；C018 仍总称 Tor/Real.log/Theta 完整接口未完成；C019/C020 仍总称完整渐近形式化未完成。可保留各条历史定理的窄范围，但应以“本条不涵盖，后续见 C021/C023”区分已经完成的第一 Tor 与抽象 lex Θ，继续列出更高阶/半群缺口。
- C023 scope、`last_handoff_check`、旧 STATE/HANDOFF 中“待用户选择”的描述是上次里程碑状态；本轮用户已明确选择研究交付。最终活动状态必须更新，R048 等已冻结历史报告则无需回写。

## v0.3 TeX 初审

根通知初稿形成后已完整阅读 `paper/width_bounds_v0_3.tex`。新增实际理想、任意多项式最少数、真实 fiber、标准 Tor₁、显式下界族和极值 Θ 的数学语义与上述源码一致，未发现数学阻断项。标准 Tor 的实质理想包含条件和两个参数顺序均明说；保留任意域、有限余长独立条件、全部次数预算、w≥4 的达到性与 w≥64 双侧界。

传统 semigroup 段沿用冻结 v0.2 的归约和下标；新稿明确把高阶 Betti、w=3 归约、最终高阶消失与完整半群转移归入传统层。下界族不被误称半群实现，最大值也不被误称逐次数包络。

唯一文字精化建议已回传：极值类首句 `For each integer $w$` 改成 `For each natural number $w$`，和 Lean 自然数总定义以及后文 natural widths 一致。本节点尚不评价根正在修复的排版或未来完整包。

## 打包实现初审

已阅读初稿 `scripts/package_delivery.py` 和其调用的 `checkpoint.safe_path`、`contained_file`、`source_paths`、`check_queue`、`require_project_venv`。创建要求当前检查点完整、工作区无后续差异、检查点非 WIP、任务无 ready/running/review；已有发布 ZIP 或 receipt 时拒绝覆盖。所选源码、三 PDF、旧两 ZIP、LATEST 与最终 checkpoint 均以实际字节捕获，创建 ZIP 后再执行相同验证。

`--verify` 仅读 ZIP；规范相对路径、重复条目、manifest 格式、每 payload 的大小/SHA-256、包内 claims 的证据引用、静止队列、LATEST 与 checkpoint 整体摘要、非 WIP 状态均有检查。manifest 排除自身，不存在自哈希循环。代码和 SCOPE 明确只验证字节证据，不认证作者或数学。

已向根指出需在说明中精确表达的区别：初稿 `--verify` 返回所算 ZIP SHA，但不读取/比对外置 receipt。外置 receipt 的整包哈希需要另行比对，或增加明确的可选校验接口；不能把一次包内自洽检查说成已对可信外部摘要进行认证。包内 checkpoint 的 source.zip 是按整体摘要核对；若要复核其内部 manifest/entries，应另运行 checkpoint 验证，而不扩大当前命令的声明。

## 长期项目报告初审

已完整阅读 `research/PROJECT_REPORT.md` 的11节主稿。其问题定义、任意域与实际对象、全宽度组合界、精确谐和/log、生成数、fiber/标准 Tor₁、显式族、真正可达到极值及标准 Θ 均与已接受接口一致；传统半群结果和 C009 的低重数补充分开标出，没有把独立 AI 审查冒充外部人类审稿。正文明确反例、有限查错边界、历史报告的早期状态与最新追加验收之区别，并保留 frozen v0.1/v0.2。

报告把原目标的传统 `Tor_i^P(R,k)` 与本项目标准 `Tor_1^A(A/m,A/I)` 准确放在不同证明层，不宣称形式化了交换参数或完成高阶/半群归约。未来六个工作包都是需要新授权的可选范围，未伪装成本次已完成成果，也未自动加入队列。

已回传作者三个文字精化建议：第3.6节类定义使用任意自然预算 w，w≥4仅为非空/最大值达到的定理阈值；第11节将本轮用户限制明确为最多两个子智能体（包括审查），避免解释为两执行者另加一审查；第9.3节明确外置 receipt 的 SHA 需另行比对。暂无数学阻断项，等待作者修订和最终文件冻结。

## 最终续审清单

1. 逐项对照 `PROJECT_REPORT.md`、`DELIVERY.md`、README、新 v0.3 TeX 的精确公式、变量约定、假设、阈值与上表；明确关闭的是研究阶段。
2. 核对 PDF 生成/视觉 QA 记录及最终源文件哈希；只据真正运行结果写已编译/已视觉检查。
3. 核对打包脚本的范围、排除项、文件路径和完整性验证；包验证仅确认字节/清单，不声称重新运行 Lean、证明正确性或新颖性。
4. 核对最终状态与 claims、历史冻结文件、最新数学日志继续匹配；活动任务已由根验收后再创建稳定检查点，不把 WIP 叫稳定交付。
5. 最后给出明确接受或逐项缺陷；若接受，列出独立审查的最终文件哈希供根冻结归档。

## 最终续审与冻结验收

### 结论

**接受；当前审查范围内没有未解决的数学口径、证据对应或交付说明缺陷。** 已完整审阅最终 `PROJECT_REPORT.md`、README、DELIVERY、v0.3 TeX、STATE/HANDOFF，以及打包工具和九项故障测试。所有初审反馈已落实：

- C015/C017/C018/C019/C020 的旧 scope 已明确转接后续 C021 标准 Tor₁ 与 C023 真实极值 Θ，保留历史定理自身范围；C023 已记录用户选定研究交付。旧 R043/R045/R048 的历史过程文字保持冻结，不回写成错误的新历史。
- 极值定义明确对任意自然数预算 w，总定义和 w≥4 的达到性阈值分开；w≥64 的所有参数下界与标准 Θ 保持完整。
- AGENTS、PROTOCOL、PROJECT_REPORT、STATE/HANDOFF 均明确阶段结束后不自动扩展；最多两个子智能体包含审查者。
- `--verify` 仅核对包内字节并返回整包摘要，不读取外置 receipt；DELIVERY 给出独立 SHA 比对命令，并明确无签名、作者认证、数学或新颖性保证。
- 曾发现根目录 manifest 会导致干净解压后 checkpoint 报新增源码。最终工具已改为 `MANIFEST = "output/DELIVERY_MANIFEST.json"`，该目录被源码选择器排除；DELIVERY 写明此安排。故其干净载荷 `workspace.changed: false` 预期与实际选择规则一致。

### 复核证据与没有重复执行的工作

本审查再次以根 `.venv` 对 C001–C023 的全部112个独立证据路径重算 SHA-256，全部匹配。又直接对上次稳定 checkpoint 的 `manifest.json` 中全部50个 `lean/` 文件逐项比较，零差异；这涵盖数学源码、根入口及固定依赖配置。旧 v0.1/v0.2 稿件/PDF/ZIP 继续保持本报告前表中的字节。没有必要或依据将本轮整理描述成一次新 Lean 构建，本审查亦没有重跑它。

PDF QA 中所记录的 TeX/PDF 摘要与本审查独立计算相符。独立读取最终 `pdf_v0_3_build.txt`，确认输出8页，未匹配 Overfull/Underfull、undefined、Missing character 或 LaTeX 错误；根报告两遍退出0。全部页的视觉检查由根完成并写在 QA 中，本审查没有冒称再次独立渲染或目视全部页。

九项打包测试源码覆盖：有效包不依赖工作区载荷、内容篡改、未列文件、重复成员、不安全路径、陈旧 claims、活动队列、WIP checkpoint 及已有发布防覆盖。根在最终 manifest 路径修改后重新执行，`results/delivery_tests_v0_3.txt` 明确为 `Ran 9 tests ... OK`，SHA 与 validation 记录一致；本审查阅读最终输出而没有重复运行已通过且未改的测试。测试 fixture 的内嵌 source.zip 仅作为整体字节对象，与说明中“这里不再逐项解析内嵌 checkpoint”的边界一致。

`results/delivery_validation_v0_3.json` 已明确标作 Pre-freeze payload validation，记录数学源码未改、Lean 未重建、50个项目文件/112个原证据路径一致、九测试成功和PDF8页。它不含尚未生成的ZIP成功声明；无自引用冻结问题。

### 最终审阅文件 SHA-256

| 文件 | SHA-256 |
|---|---|
| `README.md` | `ac19262e3f274cc82d592f7c3ae6b0501f79ffd39592ccfc6ded7d79b5a32a95` |
| `research/PROJECT_REPORT.md` | `8304e526b941d22780457c008c8a73a29832dac472f1c8ca921067fcfc4da3fc` |
| `research/DELIVERY.md` | `84908ed66c665fa3351fd1189023b92256bcd4babc2313b944019a7a4f775837` |
| `research/STATE.md` | `2115efe0510dd8f0b7361bc0f7a2474d772067d38048a4428359f873bde4a73a` |
| `research/HANDOFF.md` | `5147766680ce35ae61b1ae7368508407f144c70c51302a0f4cf889d04e36f696` |
| `AGENTS.md` | `c29baa7909f69082576afcef3ee4359c88121ac1d7c0ab60ba5ccf8c03ec5c20` |
| `research/PROTOCOL.md` | `f64ef7d49d644b829bfe0012ce493e9654cb77110e72f543e65849d1b198c622` |
| `paper/width_bounds_v0_3.tex` | `5f6fe88d19fcbc0f086e5fb8242bef1a84613177bc0f522c0271aed89609bb27` |
| `output/pdf/width_bounds_v0_3.pdf` | `5d1e9f8a925a7fc9d7c6368056a060ff4ef634306801da4fe6e810b010208887` |
| `results/pdf_qa_v0_3.md` | `965120aa1eeaea6a5586958eeb8df629ab87669dc3021242ef8f56ea9e42bc91` |
| `results/pdf_v0_3_build.txt` | `22cd7e98b4781fb62bf5846d99f97b165610caeeab4bbd72028160341a489333` |
| `scripts/package_delivery.py` | `bae26d0df594b4266e41eff21b91c1265b67cd5516a22e79254af9cee2213329` |
| `scripts/test_package_delivery.py` | `4115d3b686cffac3e4d0cd492eeed7fbe1101a0350b21c760a3129c859e1db2c` |
| `results/delivery_tests_v0_3.txt` | `438706c9aa0abce38839bb9e70df3b8f71747be54540a8632fb98f5c0d3d9ba8` |
| `results/delivery_validation_v0_3.json` | `79ea705f6ab43d93ce2f508bd05ed3421682d779bbdfbdd4350af94be3c82b6a` |

### 根的最后集成责任与本任务停止条件

R051 已完成并停止修改本报告。根在收齐报告后登记 C024/R049/R050/R051、关闭活动队列，创建并核验稳定 checkpoint，再创建不可覆盖的交付 ZIP，执行仅读验证并核对外置 receipt 的整包摘要。实际 ZIP 文件数、checkpoint ID、整包 SHA 与 `archive_valid` 只能来自这个后续真实执行；本报告不代填，也不要求打包后重写自身造成哈希循环。若该最后执行失败，必须如实保留失败状态而不能仅凭本报告宣布整个交付完成。

接受层级为独立 AI 文稿/源码语义及证据一致性审查；既不是外部人类同行审稿，也不增加任何新定理、Lean 证明、Tor 换序、高阶 Betti、完整半群归约或新颖性认证。所有此类边界继续有效。

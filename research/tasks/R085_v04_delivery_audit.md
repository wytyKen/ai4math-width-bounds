# R085：v0.4 交付内容与归档合同独立复核

日期：2026-10-01。执行者：`/root/v04_delivery_audit`。独占本报告；未派生，未改其他文件，Python 仅使用根 `.venv`。

**结论：准备验收接受。** 当前新稿、交付文档、已有验证记录及归档工具在本任务范围内无剩余阻断。此结论允许根完成 claims/状态集成及稳定源码冻结，**不认证尚未创建的 v0.4 ZIP，也不将构造测试代替真实包核验**。最终归档完成仍须由实际 ZIP 的独立核验和外置 receipt 确认。

## 恢复、范围与方法

按要求读取 STATE、HANDOFF、queue 和 PROTOCOL。启动时根 `.venv` 执行 `checkpoint.py --check` 返回 `queue_valid: true`；`--verify-latest` 确认 `20261001T094840960955Z-21042d34` 的 `archive_valid: true`、`workspace.changed: false`。该检查点明确为 WIP，原因是 running/review 任务尚在；本审查不将它当作最终稳定交付。其后根继续补全准备记录，是正常工作区增量。

直接阅读当前 README、PROJECT_REPORT 新前言与第12节、DELIVERY_v0_4、最终 TeX 的摘要／新增分解和高阶 Tor 节／验证边界、PDF QA、R083、R084、新打包器与测试、构建脚本及最终测试日志；同时核对 checkpoint 的源码选择和路径规则。独立计算当前产物、准备验证和旧冻结证据的 SHA-256，并将旧产物与 v0.3 原 ZIP 中成员逐字节比较。

没有重新构造数学证明、运行 Lean、重编 PDF、重复逐页视觉 QA 或重跑38项构造测试。数学整链的直接源码审查由 R083 完成；本任务验证该接受结果、最终稿、QA 和工具日志对应同一版本。

## 数学语义与版本口径

当前 README、PROJECT_REPORT 第12节、交付指南和最终新稿一致保留：任意域 K、实际 A=K[x,y,z]、m=(x,y,z)、真实单项式上集／lex、实际有限余长、x 标准、w≥4 及所有次数真实累计商维数预算。a 是首个纯 x 禁指数，ell 是完整 xySubspace 的真实 K 维数。

文稿从具体 d1/d2/d3 的全核正合和 d3 单射，连接标准有限自由 ProjectiveResolution、原商增广与零尾；再通过标准第二因子派生比较、残差微分零和实际有限自由残差坐标取得真实 K 有限性。0..3 次维数为 1、a+1+ell、a+2ell、ell；i≥4 为真实标准 Tor 零对象，随后得到所有正次数宽度界与第一严格界。没有以自由项 A 秩直接定义 Tor 的 K 维数。

标准 Tor 固定第一 A/m、派生第二 A/I；与旧 C021 的一次对象和标量作用相容。预算外公式仍保留真实 boundary/span 数据和 I≤m。原四生成元数值半群归约、必要 Tor 因子比较与完整 graded shifts API 未完成；Theta 只指抽象 lex 预算类最大值的增长。没有新颖性或人类同行认可认证。

PROJECT_REPORT 明确将第1–11节标为 v0.3 历史正文，新前言和第12节覆盖后续进展；历史“高阶未完成”句子未被误作为当前结论。R060 及以后保持等待用户授权。R059 只复核已有科学源码／日志对应，不声称进行了新的 Lean 构建。

## 最终稿、QA、日志与链接

独立计算下列摘要，全部与 R083、PDF QA、R084 和新准备验证记录一致：

| 文件 | SHA-256 |
|---|---|
| `paper/width_bounds_v0_4.tex` | `26c1ebdcf796969ca3f829b93393d291e04c5c9f23b3bbf652f76641f37a54d5` |
| `output/pdf/width_bounds_v0_4.pdf` | `ead6e0ede749632d5ebd704a0a2b9ab2e5312361fe94a322c916df23877ef64f` |
| `results/paper_compile_v0_4.txt` | `1939d12652d0185fe9782f01fcab4af57b927b9ef5c1d3384f6e073c3eb1f98d` |
| `scripts/package_delivery_v0_4.py` | `30646d67a4d5dbf67256ce43cae9a329eb1d56b7cd12e5030b367c2b74385ad4` |
| `scripts/test_package_delivery_v0_4.py` | `ce143c10f6c4b4ce8593dde3c735f46918fa479ae70dc8f4623ba859f62395e6` |
| `results/package_delivery_v0_4_tests.txt` | `1edfefbcdc68ab2d3ed7f6e05713538b4be892ab1491731fe8b33cef26e3d9ca` |
| `results/delivery_validation_v0_4.json` | `cd4a2a1bcc900dd2759bc2231c9e0a6aa8a1c537bced7fcebb9cbbf5c9c6e939` |

准备验证明确标为 `source_manuscript_and_payload_preparation_before_final_archive`，`lean_rebuilt: false`，并明确当前 ZIP 尚未创建。其 `artifacts` 和 `preserved_previous_artifacts` 共31条摘要全部与当前文件匹配，零失配。64个 Lean 文件未变、687条既有 evidence 匹配和10页视觉 QA 是根记录的准备验证范围；本审查未把这些数字冒称为自己重跑数学／渲染所得。

QA 和指南精确记录 `open_in_codex` 返回 queued、内置编译器环境目录错误，以及本地已有 MiKTeX 两遍编译成功的不同证据。最终本地日志确有10页、435122字节的输出记录；逐页目视检查来自根的 QA，非本审查重新执行。没有用内置编译失败冒称成功，也没有将打开请求写成已确认可见的编辑器状态。

独立扫描 README、PROJECT_REPORT、DELIVERY_v0_4 共185个本地文件链接。仅4处引用缺失，分别是 README 和指南各自链接的当前 v0.4 ZIP 与 receipt；实际只有这两个尚未创建的目标。准备验证 JSON 已存在，其余链接目标存在。指南明确这两个文件是最后生成的包外产物及恢复最后一步，因此属于当前准备阶段的预期状态，不是文档误指路径。

## 旧版保存

独立核对 C024 的21条 evidence，全部哈希匹配。原 README 与 PROJECT_REPORT 移到 `research/frozen/v0_3` 后仍保持原字节和原 hash，只变定位路径。

将14个文件与 v0.3 原 ZIP 的对应成员逐字节比较，全部相同：原 README、PROJECT_REPORT、DELIVERY，旧 build/package/test 脚本，v0.1/v0.2/v0.3 的三份 TeX 和三份 PDF，以及 v0.1/v0.2 两个审阅 ZIP。原 README／报告比较使用其新冻结位置。其余旧验收记录亦在上述31条准备验证摘要核查内。

v0.3 原 ZIP 的当前 SHA-256 为 `84f9508927c73b96c5313b8e60a32ac7a9b2d7d308447c1226128f81ae9c201d`；原 receipt 为 `d459058f5675612f279ee269bbf755e99241fd82eb51d661e4e8d2f51aaf1df1`。本次未改或替换它们。

## 归档实现与测试复核

| 合同 | 直接代码核对 |
|---|---|
| 新版本与防覆盖 | TARGET、RECEIPT、MANIFEST 固定 v0.4；CLI 不提供覆盖或换版本入口。创建前和发布前拒绝已有目标／收据；ZIP 用排他硬链接、收据用 `xb` 发布。旧 v0.3 脚本未变。 |
| 先稳定源码后打包 | `stable_workspace` 要求最新 checkpoint 有效、非 WIP 且工作区未变；`closed_queue` 另拒绝 ready/running/review，避免只依赖 WIP 标志漏过 ready。捕获后再次检查稳定性、LATEST 和全部载荷当前字节。 |
| 完整载荷选择 | 采用 checkpoint 源码选择、四版 PDF、两个早期审阅 ZIP、全部 claims evidence、LATEST 和当前 checkpoint 两文件的并集；`archive_required:false` 的 evidence 仍收入交付并校验。不会默认纳入整个旧 checkpoint 历史或运行时缓存。 |
| 证据及循环 | 所有状态的 claims evidence 都检查真实字节，accepted claim 必须有证据；明确拒绝将当前 ZIP／receipt／当前内清单作为 evidence。内清单不包含自己的 hash。 |
| 安全与完整成员 | 外层和嵌套 ZIP 均检查原始／规范路径、重复和大小写碰撞、文件目录冲突、非普通文件／加密条目、成员精确集合、长度及 SHA-256；JSON 重复 key 被拒绝。 |
| 稳定 checkpoint | 校验 pointer 的 ID／路径和摘要、manifest／source.zip 的整体摘要与大小、稳定状态、关闭队列快照及 claims assessment。 |
| 嵌套源码 | `check_checkpoint` 逐项核验嵌套 source.zip 的清单和实际数据，要求嵌套源码集合等于外层按源码规则筛选的集合，并逐文件要求内外层字节相等。accepted 且要求归档的证据必须实际出现在嵌套源码中。不是只比 source.zip 的整体 hash。 |
| 独立 ZIP 核验 | `verify` 从同一个已打开 ZIP 流读取成员和计算整包摘要，不读取工作区载荷，不解压或执行；不依靠当前源码补足包内缺项，不读取外置 receipt。临时 ZIP 在正式发布前先经过同一完整核验。 |

测试 fixture 真实调用 checkpoint 创建、交付创建和核验；正常路径没有用 mock 伪造通过。故障测试的局部 patch 用于制造捕获竞争／变化，符合其目的。最终日志载明根 `.venv`、工具和测试源码 hash、退出0、38项 `ok` 和 `OK`；其覆盖路径、成员、证据、队列、伪稳定、嵌套篡改、内外源码差异、循环引用及防覆盖等实际失败模式。没有发现日志与当前实现不对应的问题，已有证据足够，不重复测试。

R084 已如实记载边界：逐文件捕获和前后复核不是工作区锁；ZIP／receipt 是两个文件，不能保证跨两文件事务，已发布 ZIP 后的故障可能留下不完整收据步骤；没有针对任意恶意超大 ZIP 的资源配额。指南要求保留异常现场，不能删已存在版本重跑。该边界不构成本次本地静止工作区研究交付的准备阻断。

## 接受范围与根的最后动作

当前没有发现需返工的版本、数学语义、链接或归档设计阻断，R085 在准备验收层面接受并停止。C032 尚待根登记，状态／规划／queue 尚待根统一关闭；本审查不把这些预计的最终集成写成已完成。

根须将本报告、准备验证、必要 evidence（含新 PDF、旧 v0.3 ZIP 和 receipt）及最终状态全部集成后，停止源内写入，创建并核验稳定且 unchanged 的 checkpoint，再执行一次 v0.4 打包和独立 `--verify`，保留外置 receipt。当前最终 ZIP 数值不得回填源内记录造成自引用循环。若最后一步失败，源内 done 仅表示数学／文稿／载荷准备验收，不授权宣称 ZIP 已交付或启动 R060。

本报告不认证最终 ZIP 字节、数学原创性或人类审阅认可；没有启动后续研究、外联、上传或发表。

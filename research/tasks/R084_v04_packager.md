# R084：v0.4 独立交付打包与只读核验

日期：2026-10-01。执行者：v04_packager。状态：实现完成，38 项构造性测试通过，等待根集成验收。只修改本任务四个独占文件；未派生智能体、未修改状态/claims/队列、未创建真实 v0.4 ZIP 或收据。

## 目标与恢复核对

新增 `scripts/package_delivery_v0_4.py` 和对应测试，保留 v0.3 打包器及冻结产物。已读 AGENTS、STATE/HANDOFF/queue、DELIVERY、R059 计划与原打包/检查点工具。启动 `checkpoint.py --check` 通过；`--verify-latest` 确认检查点 `20261001T090243180713Z-07071c19` 归档有效，工作区变化是 R059 的正常文档/队列/新稿写入，不是归档损坏。

## 精确调用合同

在项目根目录，用根 uv `.venv`，仅依赖 Python 标准库：

```powershell
.venv\Scripts\python.exe -B scripts/test_package_delivery_v0_4.py
.venv\Scripts\python.exe -B scripts/package_delivery_v0_4.py
.venv\Scripts\python.exe -B scripts/package_delivery_v0_4.py --verify output/ai4math_research_delivery_v0_4.zip
```

第二条由根在所有报告/claims/queue/STATE/HANDOFF 完成并建立稳定 checkpoint 后执行；本任务没有执行它来创建真实项目包。

- 默认唯一创建目标：`output/ai4math_research_delivery_v0_4.zip`。
- 外置收据：`output/ai4math_research_delivery_v0_4.receipt.json`。
- 包内清单：`output/DELIVERY_MANIFEST_v0_4.json`；schema 1、version `0.4`，不列自身摘要。
- `--verify ZIP` 可以读取任意位置的 v0.4 ZIP，只读、不解压、不执行包内脚本、不读取工作区载荷，也不读取外置收据。返回实际 ZIP SHA-256/大小、manifest SHA-256、载荷文件数、claims 引用数、checkpoint ID 和嵌套源码数。用保留的外置收据比较返回摘要仍是另一项操作。
- CLI 不提供覆盖、改版本或替换目标选项。Python `create(root=...)` 的 root 参数仅用于临时 fixture；CLI 创建始终使用脚本所在项目根目录。成功退出 0，验证/创建失败退出 1 并输出 JSON 错误。

## 创建和载荷合同

创建先拒绝任何已经存在的目标 ZIP 或收据，然后调用既有 `checkpoint.verify_latest`，要求归档有效、工作区未改变、`is_wip` 为 false；另外独立验证队列结构，拒绝 ready/running/review 任一活动任务。所有 claims 的 evidence 均校验，不限于 accepted 状态。accepted claim 必须有证据。

载荷为以下并集，自动去重：

1. `checkpoint.source_paths(root)` 的全部源码/文本；
2. 四版 PDF：`width_bounds.pdf`、`width_bounds_v0_2.pdf`、`width_bounds_v0_3.pdf`、`width_bounds_v0_4.pdf`；
3. 原 v0.1/v0.2 审阅 ZIP；
4. 所有 claims evidence 引用，包括 `archive_required: false` 的旧二进制证据；
5. LATEST 与其对应 checkpoint 的 manifest 和 source.zip。

不递归加入所有旧 checkpoint 历史。若 claims 显式引用旧 checkpoint 或旧交付 ZIP 的某个文件，则该文件按 evidence 纳入；不把这些旧 ZIP 作为当前科学检查点解析。claims 若引用当前 v0.4 目标 ZIP、当前收据或当前包内清单，明确报 circular current-delivery evidence，防止循环。

`archive_required` 沿用 checkpoint 的语义：accepted claim 的必备证据必须已经在源码 checkpoint；PDF/旧 ZIP 等二进制证据应明确 `archive_required: false`，但 v0.4 交付仍将其打包并核验。

捕获后重新校验 claims、稳定 checkpoint、LATEST 指针以及全部已捕获文件的当前字节（包含源码选择以外的二进制产物），随后对临时 ZIP 执行完整独立核验。最终发布前再检查 ZIP/收据是否出现，ZIP 用同目录临时文件的排他硬链接发布，收据用 `xb` 排他创建，均不覆盖已有文件。

## 独立核验与伪稳定防护

外层和嵌套 source.zip 均拒绝重复或大小写碰撞路径、文件/目录冲突、绝对/越界/Windows 非安全路径、非规范分隔符、symlink/非普通文件和加密条目。清单逐项核对路径、非负整数长度、64 位小写 SHA-256、完整成员集合和实际字节。也检查 ZIP 原始 `orig_filename`，避免 Windows 的 ZipInfo 规范化提前隐藏反斜杠或 NUL 拼写。JSON 对象重复 key 被拒绝。

检查点核验并非只比较 source.zip 的整体 hash：还验证 pointer/schema/ID/path、manifest 整体 hash、source.zip hash/大小、稳定状态字段、closed queue 与 checkpoint queue snapshot 的一致性，以及稳定 claims assessment。随后逐个验证嵌套源码清单/条目，并要求：

- 外层按 checkpoint 源码规则选出的成员集合与嵌套源码集合完全相同；
- 每个当前源码文件与嵌套 checkpoint 对应文件字节完全相同；
- accepted claim 中要求归档的 evidence 确实在嵌套源码内；
- 外层载荷正好符合源码、固定产物、claims evidence 和当前 checkpoint 的并集。

因此即使攻击者重算外层清单，陈旧 claims、缺少必备产物、源码与 stable checkpoint 不同、嵌套 ZIP 条目篡改等仍会被拒绝。哈希一致性当然不能排除连同可信外置收据一起被替换的全套伪造，不是签名或数学语义认证。

## 构造测试与证据

测试使用真实 `checkpoint.create_checkpoint` 在 TemporaryDirectory 建立稳定 fixture，再真实创建 ZIP/收据并核验，不以 mock 伪造成功路径。每项测试清理自己的临时目录。38 项测试最终退出 0，完整输出：`results/package_delivery_v0_4_tests.txt`。

覆盖：有效构造/收据、无工作区独立只读核验、错版本、外层 payload 篡改/缺失/额外项、已列但不应存在的 artifact、缺 v0.4 PDF、重复和大小写路径、越界/反斜杠/设备名等路径、symlink、错误 manifest 类型/hash、所有状态 claims 的陈旧或缺失证据、三类活动队列、无效队列、WIP/伪稳定状态、checkpoint queue 不一致、pointer ID/hash、嵌套 ZIP 的篡改/重复/不安全/缺失条目、源码集合/字节不一致、current target 自引用、初始已有 ZIP/收据、捕获期间新出现的 ZIP/收据、源码改动、二进制证据改动、捕获末尾 PDF 改动。

首次运行发现 Windows `ZipInfo` 在读写阶段会规范化反斜杠，使仅检查 `namelist()` 不足。已增加原始路径检查，并用保留恶意原始拼写的构造 ZIP 回归通过。该初次失败不是最终成功证据；保留日志为修复后的最终 38 项运行。

| 文件 | SHA-256 |
|---|---|
| scripts/package_delivery_v0_4.py | `30646d67a4d5dbf67256ce43cae9a329eb1d56b7cd12e5030b367c2b74385ad4` |
| scripts/test_package_delivery_v0_4.py | `ce143c10f6c4b4ce8593dde3c735f46918fa479ae70dc8f4623ba859f62395e6` |
| results/package_delivery_v0_4_tests.txt | `1edfefbcdc68ab2d3ed7f6e05713538b4be892ab1491731fe8b33cef26e3d9ca` |

旧 `package_delivery.py` 和 `test_package_delivery.py` 均与最新原检查点的对应字节一致。旧 v0.3 ZIP SHA-256 仍为 `84f9508927c73b96c5313b8e60a32ac7a9b2d7d308447c1226128f81ae9c201d`。本任务结束前实查真实 v0.4 ZIP 和 receipt 均不存在。

## 限制与交接停止点

这只是字节完整性与记录一致性工具，不重新运行 Lean、不判断数学模型/原创性/作者身份。嵌套 source.zip 在内存读取；未实现针对恶意超大压缩包的资源配额防护。创建需要支持同卷硬链接的文件系统，本机 Windows 临时目录真实测试已通过；不支持时失败而不降级为覆盖写入。

源码捕获按文件读取且有前后校验，不是工作区锁；正式创建时必须保持执行者已停、文件不再改写。ZIP 与收据是两个文件，不能保证跨两文件事务：若 ZIP 成功发布后发生断电、I/O 失败或极窄并发收据竞争，可能留下有效 ZIP 但没有本次完成的收据；程序不会覆盖或自动删除已有最终文件。此时应保留现场由根检查，不能删除旧版本重跑。

根下一步：验收本工具/日志，把 R084 结束信息及必要 claims 纳入最终文档；所有 R059 工作完成后更新状态/队列、创建并核验新的 stable unchanged checkpoint，最后才执行 v0.4 创建命令及只读核验并保留外置收据。不把最终 ZIP/hash 回填进已冻结源码。当前执行者停止，不推进 R060 或其他研究。

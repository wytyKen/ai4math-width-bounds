# R005 — 不可覆盖检查点工具

状态：实现与临时目录测试完成，待主智能体真实检查点验收。

实现文件：`scripts/checkpoint.py`、`scripts/test_checkpoint.py`。

工具使用 Python 标准库，CLI 要求使用脚本所属项目根目录 `.venv` 的解释器。创建检查点时把逐文件读取的相同字节用于 SHA-256 和 ZIP 写入，并在归档及 manifest 完成后原子更新 `research/checkpoints/LATEST.json`。失败保留已有 LATEST；不覆盖旧检查点，不自动恢复或上传。

运行方式：

```powershell
.venv/Scripts/python.exe scripts/checkpoint.py --check
.venv/Scripts/python.exe scripts/checkpoint.py --reason "交接原因"
.venv/Scripts/python.exe scripts/checkpoint.py --verify-latest
.venv/Scripts/python.exe -m unittest discover -s scripts -p test_checkpoint.py -v
```

设计约束：

- `--root` 可指定待归档项目根目录；解释器仍须来自工具所属项目的 `.venv`。
- `running/review` 任务、无效队列、不能匹配的 accepted claims 证据或未被归档的必须归档证据会明确标记 WIP。
- evidence 可选 `archive_required: false`（默认 `true`），用于有意不放入源码快照的冻结 PDF/ZIP 等产物。仍核对当前文件哈希；缺失或不匹配仍 WIP。匹配时记录 `unarchived_references`，但不单因该文件未归档而 WIP。`all_evidence_archived` 和 `all_required_evidence_archived` 分开报告，快照明确标记为 source-only，不能视为全产物备份。
- accepted statuses 为 `formal_verified`、`traditional_reviewed`、`artifact_checked`。只比较所记录的证据哈希，绝不声称重新编译或证明了源文件。
- 校验 LATEST 指针中的 manifest 哈希、ZIP 整体哈希、CRC、归档条目集合和每个条目的大小/SHA-256。归档通过后单独比较当前工作区；正常后续修改不影响 `archive_valid`。
- 默认包含源码、脚本、Lean/项目配置、Markdown/JSON/TXT 及常见文本研究数据；排除缓存、Git、Lean `.lake`、`tmp`、`output`、既有检查点、符号链接和未列入类型清单的二进制文件。
- 快照按文件捕获，未冻结整个工作区。哈希确保各归档文件字节完整，不能替代跨文件一致性或证明验证。

验收记录（2026-09-23，北京时间）：

- 根目录 `.venv` 运行 15 项 unittest 全部通过：归档往返/逐项哈希、归档后工作区增删改、缓存及历史快照排除、有效 ZIP 被追加/压缩数据被破坏/manifest 被篡改、重复任务 ID、绝对及穿越路径、Windows 大小写路径冲突、任务自依赖/缺失依赖/依赖环、running/review WIP、证据匹配与不匹配、缺失或未知元数据、失败写入不替换 LATEST、指针路径不能越界；另验证 optional 外部产物未归档但哈希匹配时允许 SNAPSHOT，缺失/不匹配仍 WIP，且未显式设 false 的外部证据仍要求归档。
- 实际项目 `--check` 返回 `queue_valid: true`；检查 ready/running/review 与 root 的文件所有权，其余任务仍检查路径安全但不占用文件。
- `py_compile` 已通过。所有运行均使用根目录 `.venv/Scripts/python.exe`。
- CLI 创建成功返回 0（WIP 也可保存）；`--check` 校验失败和 `--verify-latest` 归档校验失败返回 1；操作错误或非项目 `.venv` 解释器返回 2。有效归档即使工作区已改变仍返回 0，并在 `workspace` 单独报告差异。
- 主智能体负责最终状态、claims 与队列收束后创建真实检查点、复核并演练只读恢复；本任务未执行自动恢复，未删除旧检查点。

剩余限制：LATEST 与 manifest 的哈希用于本地意外损坏检测，没有外部签名，不能抵抗同时重写归档/manifest/指针的恶意修改。二进制 PDF 等不在源码快照内；除显式设置 `archive_required: false` 的引用外，accepted claim 的证据不在归档会明确标记 WIP。optional 产物只保存检查时的路径、哈希和结果，无法从源码归档恢复其字节。完整项目仍须按固定版本重建依赖并重新编译 Lean 后才能声称当前源已通过构建。

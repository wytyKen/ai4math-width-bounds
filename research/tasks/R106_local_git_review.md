# R106 本地 Git 首次提交载荷只读复核

2026-10-07。执行者：local_git_review。支持 R105；只写本报告，不改 Git 索引、配置、远端或其他项目文件，不派生子任务。

## 结论及对象

**接受本次核验的首次本地提交载荷。** 最初检查的索引含 269 个普通文件；主执行者随后将同一索引提交为 `18c79a36fc232f6de781131d09000628ecf65163`。本报告独立核对该提交只有零个父提交、包含 269 个文件，且与所查索引没有差异。提交 tree 为 `b0067b6e65ba9a7ccadee2d7eaa05061bc1a1135`。

这是本地载荷、字节完整性和 Git 状态复核，不是新数学验收、Lean 重建、全面安全审计或 GitHub 上传成功证明。最终 STATE/HANDOFF/queue/claims、本报告及 R105 结果记录由主执行者另行集成；这些后续文件或修改不在本次 269 文件的初始快照中，不能拿本报告的初始计数代替最终提交检查。

## 恢复与授权依据

已读 AGENTS、STATE、HANDOFF、queue 中 R105/R106、`.gitignore`、`.gitattributes`、R103 上传指南，并只读使用 `tmp/r105_baseline.json`。R105/R106 已登记本次授权：助手备份 Lean Git 元数据、初始化根 main 仓库、暂存核验并首次本地提交；GitHub 建仓、remote add 和 push 仍由用户执行。

根 `.venv` 执行 `scripts/checkpoint.py --check` 返回 `queue_valid: true`、无 errors。随后 `--verify-latest` 对 `research/checkpoints/20261006T183505558880Z-bc7ec893` 返回 `archive_valid: true`、无 errors；检查时工作区只有 `research/queue.json` 被列为后续修改，无缺失、增加或不可用记录。这是已登记任务造成的工作区差异，不是历史归档损坏。基线标记的 source checkpoint 与此一致。

检查时旧 STATE/HANDOFF 和 R103 指南所述“未初始化/未移动/未提交”属于 R103 历史边界，现已被最新本地操作授权及实际执行超越。主执行者负责更新当前 STATE/HANDOFF；保留旧指南和旧验收记录的字节不代表当前操作仍未发生，也不把历史授权范围倒改为新授权。

## 实际检查结果

| 检查 | 结果 |
|---|---|
| 根分支 | `main` |
| 根 remote | 名称数 0；两次核对均为空 |
| 根本地换行配置 | `core.autocrlf=false` |
| 根本地身份覆盖 | 只读查询 local `user.name` / `user.email` 键，无本地覆盖；未打印身份值 |
| 索引模式与 stage | 269 个文件均为 `100644`、stage 0；无 `160000` gitlink、无冲突 stage |
| 索引总载荷 | 5,166,638 字节 |
| 索引与工作区 | 用 `git cat-file --batch` 取出全部 269 个实际 blob，与对应工作区文件逐字节比较，差异 0 |
| 换行属性 | 对全部 269 个索引路径执行 `git check-attr --cached`；`text` 均为 `unset` |
| Lean 文件完整性 | 基线 64 个项目文件全部以实际普通文件入索引，无缺失、多出；工作区与索引各自 SHA-256 均与基线一致 |
| 四版 PDF | 仅 `width_bounds.pdf`、`width_bounds_v0_2.pdf`、`width_bounds_v0_3.pdf`、`width_bounds_v0_4.pdf` 在 output 范围入索引；四者 blob SHA-256 均与基线一致 |
| 本地旧产物 | 基线记录的 12 个 output 原件均仍存在，SHA-256 不变；包含不进入 Git 的旧产物 |
| 排除范围 | 实际索引无 tmp、references、research/checkpoints、运行时/缓存目录、`.git` 元数据、ZIP、Python 字节码或 output 非白名单文件 |
| 忽略规则抽查 | 9 个目标路径探针全部被忽略，含备份元数据、三类缓存、历史归档、旧 ZIP 与最终 ignored receipt 路径 |
| 原 Lean Git 备份 | `tmp/lean_git_before_root_import` 存在；18 个文件与基线逐项同 SHA-256，无缺失和多出；`lean/.git` 已不存在 |
| 备份仓库历史 | 只读 `for-each-ref` 得到零 refs；`rev-parse --verify HEAD` 返回 128，未解析到提交；remote 名称数 0 |
| 新根及备份属性 | `Get-Item -Force` 确认两者为各自预期绝对路径的 `Hidden, Directory` |

索引顶层数量：`lean` 64、`output` 4、`paper` 7、`research` 126、`results` 48、`scripts` 14，根单文件 6（`.gitattributes`、`.gitignore`、AGENTS、README、pyproject、uv.lock），合计 269。

本次 `git ls-files --stage -z` 原始字节 SHA-256 为 `bbdb9cd1f1b2554827cb9ca0878f1a09498b8fa9ba12d190c548736675318ac0`。主执行者首次提交后再次读取，该值保持不变；`git diff --cached --name-only HEAD` 为空。该哈希标识本次检查的索引清单，最终状态记录提交后自然会变化。

科学日志 `results/lean_higher_tor_build.txt` 在首次提交中 blob SHA-256 为 `29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4`，与工作区逐字节一致并符合现有科学基线。未运行 Lean、重编论文或进行数学实验；没有把旧日志当作修改后新源码的构建证据。

## 方法、限制与后续集成

检查使用根 `.venv` 的 Python 调用只读 Git 命令，设置 `GIT_OPTIONAL_LOCKS=0`，避免 status 等读取命令的可选索引刷新。主要证据来自 `ls-files --stage -z`、`cat-file --batch`、`check-attr --cached -z`、`check-ignore --no-index`、`diff --cached`、`rev-parse`、`ls-tree`、`remote` 和只读配置查询；没有运行 `git add`、`commit`、`config` 写操作、`remote add` 或 `push`。

本报告不包含基线敏感内容或身份值；只记录计数、必要项目路径和验证哈希。本次没有重新扫描所有正文中的潜在凭据，也不提供全面无秘密保证。源码可公开范围依 R103 的有限核查及本次实际路径排除验收，不扩大为旧 ZIP 或下载全文的再分发许可。

最终主集成应重新核对最终索引/HEAD 与工作区、无 remote 及本轮结果文件完整性，再由 ignored 的 `output/r105_local_git_commit.receipt.json` 记录实际提交结果，避免在被提交文件内要求记录自身最终 commit hash 的自引用。当前验收不认证未来的 remote、push、GitHub 网页状态、R093 作者责任或 R095 干净复现；这些范围没有在本轮完成。

独占报告已落盘；执行者到此停止。状态、结论索引、最终检查点和本地提交收尾归主执行者集成。

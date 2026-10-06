# R103 提前 GitHub 公开入口与用户上传指南

日期：2026-10-07。状态：完成。R104 最终复核接受，根集成验收通过。用户希望提前上传并声明进度，随后明确全部终端 / GitHub 上传操作由本人完成；本任务不启动 R093，不修改数学，也不实际上传。

## 决定与范围

建议公开为进行中的研究快照。现有 R058 数学基线 / v0.4 已足以支持同行阅读，R091/R092 进一步给出贡献对照与证明叙事，但不能写成完整半群 Lean 证明、认证首创、人类同行认可或正式发表。README 在醒目位置提供中英文状态，列已完成 / 未完成层次、AI 实质参与、作者理解与责任仍待 R093，以及 R095 干净复现尚未完成。

当前入口替换旧 README 中已经过时的“下一 R060”；新入口指向 R093 和发表准备计划，原 R060–R067 保持可选暂停。旧历史文件各自保留当时停点，并在 README 提醒读者按日期区分。

## 文件与保存

- `README.md`：当前公众入口、主模型精确假设、标准 Tor 顺序 / K 作用 / 有限性 / IsZero、全部正次数界、实际 lex 极值 Θ 与相应限制、阅读地图和复核边界。
- `research/publication/GITHUB_UPLOAD_GUIDE.md`：GitHub 新建空仓库、Windows PowerShell 首次导入、嵌套 Git 备份、暂存检查、commit / remote / push、后续更新；所有操作留给用户。
- `.gitignore`：明确排除运行时 / 缓存、tmp、检查点、下载全文和旧交付 ZIP / 收据；仅保留现有四份项目 PDF。
- `.gitattributes`：`* -text` 保持历史证据字节；指南同时要求项目级 core.autocrlf false，不禁用文本 diff。
- `research/publication/STATEMENT_MAP_GITHUB.md`：由原映射机械转换 142 个文件链接，改相对路径 / #L 行号并加导读，数学原文不改；正式引用应固定 commit。
- `research/frozen/v0_4/README.md`：原 README 原字节，SHA-256 `0251ee5d716346e39385b0e8f624e460241d5e69d8000376ee7296d627b8ea92`；C032 只更换 evidence 定位，hash 不变。旧 ZIP、原交付验收 JSON、PROJECT_REPORT、原叙事 / 映射均未改。
- `results/r103_github_readiness.json`：本轮有限核验范围与结果。状态 / 队列 / claims 由根集成。

## 关键发现与操作边界

根没有 Git 仓库且不在父仓库内；Git 已安装、gh 未安装。`lean/.git` 是独立 Git 目录，`git -C lean rev-parse --verify HEAD` 退出 128、无 HEAD；`git -C lean remote` 无输出，`status --short` 显示源码均未跟踪。因此指南先由用户把元数据备份到 `tmp/lean_git_before_root_import`，保持 Lean 源文件不动。路径精确核验、目标存在即停止、原生 PowerShell Move-Item -LiteralPath，未执行该移动。

公开载荷与本地交付不同：旧 ZIP 含历史载荷与下载材料，不能直接当作已经审核的公共分发附件。当前保留源码 / 文档 / 文本结果和四份自有 PDF，历史索引引用的本地归档在 Git 克隆缺失是预期。没有给缺失 ZIP 或 checkpoint 声称验证成功。

`lean/.github/workflows/lean_action_ci.yml` 只是子目录模板，当前没有根 CI 配置或 CI 成功证据。没有选择许可证、虚构作者身份或 DOI。指南采用真实用户名 / 邮箱 / URL 占位，用户替换后执行；认证不写 token 到文件或 URL。

## 核验与证据

启动时 --check 与 --verify-latest 通过，原最新快照 archive_valid=true、workspace.changed=false；原快照为 `20261004T161336673725Z-6fd54382`。本轮未改 Lean，不需要新构建来验证文档更改。

根核验旧 724 条 evidence 引用全部匹配；64 个 Lean 项目文件、12 个冻结 output 文件、原证明叙事 / 声明映射 / PROJECT_REPORT 均与启动基线逐字节一致。新版三个公开入口的 163 个本地文件链接均存在、属于拟公开载荷，Lean 行号有效。

仅借现有未提交的 lean/.git 配合显式 --git-dir / --work-tree 执行只读 `check-ignore --no-index --stdin` 与 `check-attr`，确认输出规则和 `text: unset`，没有初始化、暂存、提交、移动元数据或操作远端。PowerShell Parser 对 README / 指南的 6 段代码做语法解析，没有执行代码。常见凭据文件名及若干 token / 私钥模式检查无命中；这是有限核查，不是全面安全审计，也未检查 PDF 内部敏感内容。

不执行 GitHub 实际流程就不能声称 push 成功或网页渲染验收完成；命令检查以当前无提交、空远端假设及官方说明为限。用户自行上传后网页核对仍在指南中列明。

官方依据（2026-10-07 读取）：[GitHub 本地项目上传](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)、[许可](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)、[换行](https://docs.github.com/en/get-started/git-basics/configuring-git-to-handle-line-endings)。不作新的数学查新。

## 审查与停点

R104 只写 `research/tasks/R104_github_readiness_review.md`，未派生或操作 Git。R104 最终接受，无阻断项，另独立核对科学基线的全部 64 个 Lean 文件与 C031 的 21 条证据。本轮只交付 README 和可由用户执行的指南；R093/R095、完整半群分支和外部联系仍未启动。

过程中一次 queue --check 发现 README 同时登记在 root_owned_paths 和 R103 owned_paths；已按根集成所有权改为 root_integration_paths，并把 Git 配置规则列入根所有权，复查 queue_valid=true。没有实际并发文件写入冲突。

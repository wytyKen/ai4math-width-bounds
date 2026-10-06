# R105 本地 Git 初始化与首次提交

2026-10-07。状态：本地初始化及首次提交完成，R106 接受；本轮验收记录准备完成，最终记录提交由根事务收尾。

## 授权与执行范围

用户在确认本机 Git / name / email 后明确授权“你做完后我执行那两条命令”。本轮据此完成本地备份、根初始化、暂存检查和提交；GitHub 建仓、remote add 和 push 仍由用户操作。推荐仓库名 ai4math-width-bounds。没有改许可证、姓名、邮箱或推进 R093/R095 / 数学分支。

## 已执行的本地准备

原根不在 Git 仓库内；lean/.git 无 HEAD、无 remote。首先保存根基线，并验证精确源 / 目标绝对路径、拒绝覆盖既有备份，以 PowerShell Move-Item -LiteralPath 将 lean/.git 移至 tmp/lean_git_before_root_import。18 个元数据文件 SHA 全部保持，旧 64 个 Lean 项目文件未改。

读取隐藏 .git 属性时第一次 Get-Item 未加 -Force，出现非终止找不到项提示；补用 -Force 检查备份确认是普通目录、非 reparse point。路径核验和迁移后的完整元数据哈希均通过，未遗漏或删除原元数据。

执行 git init -b main、git config --local core.autocrlf false，沿用已配置身份，无本地 user.name / user.email 覆盖。现有 .gitattributes 的 * -text 生效。没有 custom hooksPath、活动默认钩子或配置的提交签名需求。

按 R103 白名单显式 git add：根配置与入口、lean / paper / research / results / scripts、四版自有 PDF。首轮 269 个索引文件均为普通 100644 / stage 0，无 160000 gitlink；所有索引 blob 与工作区字节相同，64 个 Lean 文件全部入索引且与基线一致。没有缓存 / tmp / checkpoints / references / 旧 ZIP 或收据入索引。常见凭据模式无命中，但不是全面安全审计。

732 条此前 evidence、12 个冻结 output 文件均保持 hash。整个任务不修改证明、不运行新 Lean 构建；Git 提交不是数学验证。

## 验收与提交结果

R106 独占 research/tasks/R106_local_git_review.md，根负责最终状态、claims、checkpoint 与 Git 提交。初始导入提交 `18c79a36fc232f6de781131d09000628ecf65163` 已实际成功，269 个文件入库，提交身份与既有配置一致。R106 独立确认首提交及其 tree / 全部 blob / 普通文件模式 / 字节属性 / 备份范围，接受无阻断项。随后只集成状态与本轮验证记录；最终 HEAD 以 Git 历史和本地 output/r105_local_git_commit.receipt.json 为准，外置收据不进入 Git，避免把最终提交号写入其自身树。

所有旧 R103 文档的“用户操作全部 Git 命令”是上一授权边界的历史记录，保留原件；当前以本任务及 STATE/HANDOFF 为准。上传指南首次初始化部分执行后不应重做，用户只需在根目录设置自己的新空仓库 origin 并 push main。

本轮先提交实际研究载荷，再提交验收记录，避免在首次提交的自身树中回填其哈希。最终工作区及根对象库还要在记录提交后检查，实际结果由被忽略的 output/r105_local_git_commit.receipt.json 记录；不增加云端操作。

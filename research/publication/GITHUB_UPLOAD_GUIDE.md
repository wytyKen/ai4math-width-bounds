# 提前上传 GitHub：用户自行操作指南

2026-10-07，R103。对应当前 Windows 工作区 `D:\project\ai4math`。助手只准备本地文件和以下步骤，**没有执行 Git 初始化、移动 Git 元数据、提交、创建远端仓库或上传**。

建议现在公开为 **work in progress / research snapshot**：供读者检查真实进度和证据，不等待所有数学分支完成。README 已标注数学 R058 / v0.4、文档 R092、未完成的半群归约、新颖性未定、AI 实质参与及人类审阅边界。提前公开不等于完成 R093 作者责任、R095 独立复现或论文投稿。

## 1. 本次上传的范围

| 放入 Git 的内容 | 只保留在本地的内容 |
|---|---|
| README、Git 配置规则、AGENTS、Python 锁文件 | `.venv/`、`.uv-cache/`、`.mathlib-cache/`、`lean/.lake/` |
| `lean/` 自有源码与固定依赖配置 | `research/checkpoints/` 历史检查点 |
| `research/` 研究说明、任务记录、结论索引与冻结文本 | `tmp/` 临时渲染、解压目录及下面的 Git 元数据备份 |
| `paper/` 自有文稿、`scripts/` 工具、`results/` 文本结果 | `references/` 下载的第三方文献全文 |
| `output/pdf/` 中现有四版项目 PDF | `output/` 中 ZIP、收据和其他非白名单产物 |

`.gitignore` 已落实这个范围。旧 ZIP 内含历史载荷及下载材料，不因名字是“交付包”就自动适合再分发；以后如要提供 GitHub Release 附件，应另做公开载荷。当前不覆盖、重打包或删除旧版本。

原研究记录包含本地路径、历史执行日期及内部任务编号，它们作为过程记录保留。便携声明映射 `STATEMENT_MAP_GITHUB.md` 使用相对源码链接和 `#L` 行号；旧映射保留原字节。首次提交前仍请按下面清单浏览将公开的研究记录；本轮只做有限的文件名和常见凭据模式核查，不是全面安全审计。

普通 Git 克隆没有完整本地检查点和旧 ZIP，故不能直接复现所有历史 `--verify-latest` / 交付包验证。源码构建不依赖这些归档，方法见根 README。`lean/.github/workflows/` 是原 Lean 子目录中的模板；它不是仓库根 `.github/workflows/`，本次不声称已配置或通过 GitHub Actions。

## 2. 在 GitHub 网页创建空仓库

1. 登录你的 GitHub，选择 **New repository**，仓库名可用 `ai4math`。
2. Description 可填：`Human–AI research on width bounds, lex ideals, and Lean formalization (work in progress).`
3. 要直接公开则选 **Public**；若想先预览，选 Private，核对后再决定公开。
4. **不要在网页预生成 README、.gitignore 或 LICENSE**，创建空仓库即可，避免与本地首次提交产生不同历史。
5. 复制 HTTPS 地址，形如 `https://github.com/你的用户名/ai4math.git`。

目前没有替你选择许可证。可以先按 README 中的“许可未定”声明公开研究快照；若希望明确允许他人复用代码，应另行选定项目许可。公开可读和开源许可是两件事，参见 [GitHub 许可说明](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)。不要虚构作者或套用未经选择的版权声明。

## 3. 在 PowerShell 处理已有的 Lean 嵌套仓库

本轮只读检查发现：项目根没有 `.git`；`lean/.git` 是独立 Git 目录，**没有提交、没有 remote**。若直接在项目根 `git add .`，它会妨碍将 Lean 源码作为普通文件提交。先把这份元数据备份到已经被忽略的 `tmp/`，源码留在原处。

下面按路径核验后移动，不删除、不覆盖已有备份。**只适用于本次首次上传**；已经完成此步骤就跳过。

```powershell
Set-Location 'D:\project\ai4math'
$taskRoot = (Resolve-Path '.').Path
$taskLeanGit = Join-Path $taskRoot 'lean\.git'
$taskBackup = Join-Path $taskRoot 'tmp\lean_git_before_root_import'
if (Test-Path -LiteralPath $taskLeanGit) {
    if ((Resolve-Path -LiteralPath $taskLeanGit).Path -ne 'D:\project\ai4math\lean\.git') {
        throw 'Unexpected source path; stop and inspect.'
    }
    if ([System.IO.Path]::GetFullPath($taskBackup) -ne 'D:\project\ai4math\tmp\lean_git_before_root_import') {
        throw 'Unexpected backup path; stop and inspect.'
    }
    if (Test-Path -LiteralPath $taskBackup) {
        throw 'Backup already exists; do not overwrite it.'
    }
    New-Item -ItemType Directory -Path (Join-Path $taskRoot 'tmp') -Force | Out-Null
    Move-Item -LiteralPath $taskLeanGit -Destination $taskBackup -ErrorAction Stop
}
```

本轮没有执行这段移动。如果准备过程中你已给 `lean/` 添加提交、远端或 worktree 配置，请先停在这里核对新的状态，不再直接套用“无提交”的前提。备份以后不要复制回已按普通目录提交的 `lean/`，否则重新变成嵌套仓库。

## 4. 初始化根仓库并检查首次提交

继续在同一个 PowerShell 中，逐段执行；某条命令失败时先处理错误，不继续执行下一段。把身份占位内容换成你自己的 Git 提交名和邮箱；也可以使用 GitHub 账户设置中的 noreply 邮箱。身份只配置在本项目，不改变全局设置。

```powershell
Set-Location 'D:\project\ai4math'
git init -b main
git config --local core.autocrlf false
git config --local user.name '替换成你的提交名'
git config --local user.email '替换成你的提交邮箱'
```

已有 `.gitattributes` 的 `* -text` 会阻止 add/checkout 自动转换换行，保护历史字节哈希；这不禁用正常文本 diff。不要对旧证据执行全仓库换行格式化。

```powershell
git add -- .gitattributes .gitignore README.md AGENTS.md pyproject.toml uv.lock lean paper research results scripts output/pdf/width_bounds.pdf output/pdf/width_bounds_v0_2.pdf output/pdf/width_bounds_v0_3.pdf output/pdf/width_bounds_v0_4.pdf
git status --short
git diff --cached --stat
git diff --cached --name-only
git ls-files --stage -- lean | Select-String '^160000 '
git check-attr text -- README.md lean/WidthBounds.lean
```

核对最后两项：`160000` 筛选应**无输出**，表示 Lean 源码没有被作为 gitlink 暂存；两个文件的 `text` 属性应为 `unset`。清单应含 `lean/WidthBounds/*.lean` 的实际文件，不应含缓存、临时目录、检查点、下载全文、ZIP 或凭据。`.env.example` 如果将来存在，也应只含占位值。

若看到不应提交的路径，先停止，不使用 `git add -f` 绕过忽略规则。提交前可用 `git diff --cached -- README.md .gitignore .gitattributes` 查看入口和排除规则的实际内容。

## 5. 提交并推送

将 URL 中的占位内容改成第 2 节复制的真实仓库地址，再执行：

```powershell
git commit -m "Publish research snapshot: R058 mathematics and R092 exposition"
git remote add origin 'https://github.com/你的用户名/ai4math.git'
git remote -v
git push -u origin main
```

根据本机 Git 的提示完成 GitHub 登录；不要把 token 写入上面的 URL、README 或脚本。若 `origin already exists`，先用 `git remote get-url origin` 核对；如果远端已有内容而推送被拒绝，先核对仓库与历史，**不要直接 force push**。本指南的前提是新建空远端。

上传后在网页确认 README 可读、Lean 源码可打开、声明映射的文件 / 行号链接可用、v0.4 PDF 可下载。保存当前 `git rev-parse HEAD` 的完整提交值，分享或引用时用具体提交。第一次根提交日期只是公开导入时间；此前研究过程的日期与证据保存在任务记录和冻结材料中。

以上首次导入 / 推送步骤参照 [GitHub 官方操作说明](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)；换行设置参照 [GitHub 行尾说明](https://docs.github.com/en/get-started/git-basics/configuring-git-to-handle-line-endings)。这是供你执行的命令，不是已执行的上传记录。

## 6. 以后更新

每次只暂存本轮确实需要公开的文件，检查差异，再 commit / push。研究验收仍遵循 AGENTS：更新状态 / 结论、保留匹配源码的验证证据并建本地检查点。Git 提交不能替代 Lean 构建或研究验收；修改许可、署名或投稿需要相应真实决定。

根 README 保持“最新阶段”；旧 TeX、PDF、ZIP 和旧验收证据保持冻结。R093 与 R095 仍按原计划等待执行，本次没有将它们标为完成。

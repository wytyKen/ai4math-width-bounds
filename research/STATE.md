# 当前状态 R107 README 公式显示修复

2026-10-07。用户已完成首次 GitHub 推送，仓库为 https://github.com/wytyKen/ai4math-width-bounds 。用户随后报告 README 的 operatorname 宏被拒绝、组合数 / 对数界显示异常；R107 已改为不依赖数学渲染的普通文本公式，根核验与 R108 语义复核均通过，本轮本地修复验收完成。只做本地修复与提交，更新远端仍由用户执行 git push。R093 仍 parked。

## 当前阶段与公开内容

数学基线仍 R058 / C031，研究冻结为 v0.4；R091 贡献对照与 R092 证明叙事 / 映射已完成。README 将这些层次与 AI 参与、新颖性未定、缺少外部人类审阅、尚未完成 R095 干净复现分别说明。旧“下一 R060”仅是历史交付停点，当前下一研究准备项仍 R093。

新增 [GitHub 浏览版声明映射](publication/STATEMENT_MAP_GITHUB.md)转换 142 个链接，原 [叙事](publication/PROOF_NARRATIVE.md)和[验收映射](publication/STATEMENT_MAP.md)不改。原 v0.4 README 保存在 frozen/v0_4/README.md，C032 只改定位不改 hash；旧稿、PDF、ZIP、验收记录及 PROJECT_REPORT 保持原件。

公开规则排除缓存、tmp、checkpoints、下载全文与历史 ZIP/收据；仅四份项目 PDF 放入 output 白名单。普通 Git 克隆不具全部历史归档，不能把缺少 --verify-latest 所需归档当成数学错误。原无提交的 lean/.git 已完整备份到 tmp/lean_git_before_root_import，18 个元数据文件保持字节；根 .git / main 已就绪。64 个 Lean 项目文件按普通文件入 Git，无 gitlink，core.autocrlf=false 仅本地设置，现有姓名和邮箱未覆盖。许可证 / 署名未替用户选择。

## 科学范围不变

任意域、真实三变量有限余长 lex 商、x 标准、w≥4、所有次数累计预算。实际有限自由分解、标准 Tor 第一 A/m 派生第二 A/I、沿 K→A 的真实 K 作用；各次真实 K 有限，四维数 1,a+1+ell,a+2ell,ell，高次 IsZero，全部正次数宽度界及第一严格界。lex 实际类最大值达到且 w≥64 的 Θ(w log w) 已证，不迁移为半群匹配下界。

R092 N0–N9 的具体假设 / 符号 / 截断 / 下界 / 标准 Tor / 传统半群引用层级保留。b2/b3 谐和式是直接数学复合，不伪称新增独立已编译端点；完整半群桥仍未端到端 Lean。R091 U1–U5 未排除，C003 新颖性 unresolved；文档公开不认证首创或人类责任。

科学日志 results/lean_higher_tor_build.txt hash `29b05fbcfa9054df43f5b171a511eb51e28e5745188c4a3a4ce9320fcee787e4`；旧 64 个 Lean 文件不变，未编译或新实验。v0.4 ZIP hash `ed74ee6c46ed160fd4b00f074de9c1e8c833f9a0b91a5bd96f29b36f1ede2285`；原包源码 checkpoint 20261001T095721013368Z-b002439c，科学基线 20261001T090243180713Z-07071c19。

## 下一项与恢复

origin 已由用户设置且首次推送成功，不再执行 remote add。当前显示修复本地提交后，用户仅需 `git push`。旧 R103 / R105 文档记录当时授权和执行范围，保持原件；当前以本 STATE/HANDOFF 和 R107 报告为准。原 R103 README 保存在 frozen/github_r103/README.md，C037 只换历史定位、hash 不变；“下一项”仍指 R093 真实贡献 / 作者责任事实记录，区分日志可证、本人确认、未知，不从授权推定理解或补造贡献。R094/R095/R096、旧 R060–R067 及外部联系 R009 保持 parked。

本地恢复按 AGENTS 读 STATE/HANDOFF/queue，用根 .venv 核 checkpoint --check；有本地检查点时再 --verify-latest。Git 克隆缺少历史归档是预期，见上传指南。固定 Lean/mathlib 4.22.0，最多两子智能体且不派生；本轮结束时全部停止。LATEST 为本次公式显示修复文档快照；工作区新增 .git 与 tmp 备份不进入检查点，Git 提交不改变 R058 科学证据。

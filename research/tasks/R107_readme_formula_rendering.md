# R107 README 公式显示兼容性修复

2026-10-07。状态：完成。R108 语义复核接受，根已核旧证据和字节一致性。本轮只修 README 数学写法，不修改 Lean、证明假设或研究路线。

## 用户报告与修复

用户贴出的显示结果将 `operatorname` 拒绝为不允许的宏，同时二项式系数及对数界出现难以辨认的显示。本地 README 原文中的公式完整，没有把乱码写入源码；因此针对渲染依赖修改：

1. 累计预算用 text 代码块显示 `Σ_{t=0}^d dim_K Q_t(I) ≤ 1 + d·w`。
2. 明确定义 `b_i = dim_K Tor_i^A(A/m, A/I)`，所有 i≥1 的统一界写成 `b_i ≤ i·C(w+1, i+1)`，并说明 C(n,k) 是二项式系数，k>n 时为 0。
3. 第一严格界展开为 `b_1 < C(w+1, 2) = w·(w+1)/2`，避免上下堆叠的组合数被显示成 `(w+12)`。
4. 极值式写为 `w·log(w)/16 ≤ M_K(w) ≤ 10w·log(w)`，注明自然对数，保留 w≥64；最大值达到仍为 w≥4。

Tor 因子顺序、K 作用、真实有限性、IsZero、任意域 / 有限余长 / lex / x 标准 / 全次数预算等上下文原样保留。没有为显示问题改数学。

## 保存、核验与边界

R103 原 README 逐字节另存 `research/frozen/github_r103/README.md`，SHA-256 `1bca49d931837785c224fef090a072e073f82a0ae594bb154be85d718bf01740`。C037 只换 evidence 路径并保留 original_delivery_path；原 R103 验收 JSON / R104 报告和既有 Git 历史仍对应旧版本。

旧 735 条 evidence 全部相符；64 个 Lean 项目文件和本轮开始时 13 个 output 文件逐字节保持。README 中原三个公式位置不再含 LaTeX 数学分隔符 / 宏，关键不等式与条件经源码核对。核验本地链接全部存在，没有新 Lean 构建。本轮验证普通 Markdown 表示和数学等价，不声称已经做线上 GitHub 渲染验收。

用户已提供首次成功推送输出，仓库为 https://github.com/wytyKen/ai4math-width-bounds 。本轮只读核对 origin 与该地址一致，main 的本地 origin/main 记录和启动 HEAD 均为 `01450016b1c7fc7e669a1155f8d717f9a00fa5e0`；未为此执行网络 fetch / push。首上传成功据用户输出与本地跟踪状态记录，不推断仓库可见性设置。

修复和本轮验收记录由助手本地提交，用户执行 `git push` 更新远端。没有重做 remote add、初始化或改变身份 / 许可。R093 和后续数学任务保持 parked。

R108 报告见 tasks/R108_readme_formula_review.md：三处公式的条件、因子、索引、常数及严格性一致，无阻断问题。当前 19 个 README 本地链接均存在；待本轮稳定检查点后生成本地修复提交，最终 HEAD 以 Git 记录为准，用户另行 push。

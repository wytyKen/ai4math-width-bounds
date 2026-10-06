# R100 自然语言命题到源码与传统引用映射

2026-10-04 起草，2026-10-05 完成。状态：映射已交付，待根集成；支持 R092。独占文件为本报告及 research/publication/STATEMENT_MAP.md；未修改 Lean、冻结稿件或状态文件，未派生执行者。

## 计划与验收

1. 已读 AGENTS、STATE、HANDOFF、queue、PROTOCOL、R092 报告、CONTRIBUTION_MAP 与 R058 验收记录。
2. 按 N0–N9 核对当前源码的精确声明、完整假设、命名空间与真实行号；将组合层弱假设和实际有限余长 lex 模型分开。
3. 在声明映射中标注传统来源、尚缺 Lean 桥、R091 候选增量/直接推论/文献已知及 U1–U5。
4. 根完成主文后核对 N0–N9 对应；只交回文档结果，集成、状态与检查点由根执行。

## 启动检查

- 根 .venv\Scripts\python.exe -B scripts/checkpoint.py --check：queue_valid=true，无错误。
- 同一解释器 --verify-latest：checkpoint 20261003T152231119936Z-162ef6cc archive_valid=true；STATE/HANDOFF/queue 的修改及 R092 报告新增是当前授权工作，与归档损坏不同。
- 本任务只读源码和既有证据，不运行 Lean 构建、实验或新文献搜索。R058 是含成功缓存回放的增量统一构建，不是本轮或干净重建。

## 结果与精确范围

已完成 [STATEMENT_MAP](D:/project/ai4math/research/publication/STATEMENT_MAP.md)，并阅读全文 [PROOF_NARRATIVE](D:/project/ai4math/research/publication/PROOF_NARRATIVE.md) 核对一级 N0–N9。表内使用 N1.1 等数字细分，避免与主文 N1a/N1b 等字母小节混淆；每行均列自然语言结论、假设、命名空间内精确声明、真实行链接及证明/传统层边界。

- G/Q/C/D 分别明确组合合同、无整个商有限余长假设的实际截面合同、实际有限余长主模型、无宽度预算的具体边界数据。任意域、所有次数预算、x 标准、w≥4、w≥64 和 s≥2 等范围保留；个别下界闭包对全部 s、预算只需 s≥1。
- N0–N4 对应真实标准单项式基/齐次维数/完整 xy 维数、首禁次数、前缀、sharp 截断 d≥2w−2、点态乘积和谐和、常数10、终端三角注入、带符号 Cauchy 及第一项严格的三界。不是三项都声称严格。
- N5–N6 对应实际 I_s、全部次数预算、精确 ell、非平方 w 的整数平方根参数、最大值达到及标准 IsTheta。主文式(5.2)的 H_d 精确等式单列为该族的直接计数解释；已有独立 Lean 端点为 h_d 精确式、H_d≤s² 和所有次数预算，未冒称新增 H_d 等式声明。
- N7 对应 d1/d2/d3 的完整核/像、顶端单射、原商投射分解、残差零、实际张量坐标、K 有限与四维数、高次 IsZero。补上 R102 建议的严格列下降和完整极小生成族入口；Classical.choose 不称可执行算法。标准 Tor 第一因子 A/m、派生第二因子 A/I，标量沿原 algebraMap 限制，理想/商指标右移均明确。
- N8 第一条谐和界有既有 TorOne 端点；b2/b3 是既有成分的直接复合，不冒称本轮独立编译。实际二项式 Tor 端点位于 HigherTorBounds，主文 N8 通过 N7 链解释。
- N9 明列 CMS 的 w≤m−2 预算分支、w≥m−1 的总长度预算推论、Herzog–Stamate v3 Prop2.7 的 w=3 分支与局部化/完备化；这些及一般 Tor 换序仍是传统桥。不能从 lex 下界反推半群下界。
- R091 M1–M3/F1 与 U1–U5 全部保留。固定 w 的算法路径不等于已执行算法或已发表解析增长；已知公式、传统计数、标准库接口不作为首创。

## 实际检查与证据

只读了当前任务所需源码/报告与主文；没有重读全部论文、扫描无关缓存、搜索文献、跑新实验或编译 Lean。相关模块包括 Growth/Cutoff/Prefix/ColumnBounds/AllWidths/AnalyticArithmetic/LogGrowth/LowerConstruction/LowerProfile/LowerConstructionBounds/LogLower/LexGrowthTheta，以及实际基、分解和 Tor 的必要依赖入口。

所有 Python 命令均使用根 .venv\Scripts\python.exe -B。最后一个内存脚本读取 Markdown 链接、核文件存在与行号，并核每个 Lean 链接指向 theorem/def/abbrev/structure/instance 声明开始：

- 本地文件/行链接共 142 个不同目标；其中 136 个不同 Lean 声明行链接；无缺失文件、越界行号或非声明开头。
- 无意外控制字符。
- 映射 SHA-256：698cfa7bbf56592f3f74580e1eee4d5655f52746daa2f54db85fc63d69ba21cf。
- 最终核对主文 SHA-256：bcb09a18172c1a751092420fda56a40188624bbe1a2da6cbc8fdae8e71e0f484。
- 本地绝对路径仅对应当前工作区；未来公开版本需要固定源码版本、重定位可分发链接并核行号。

初次文档工具调用出现 PowerShell 花括号路径不展开、长字符串转义和标准输出编码问题；均为读/写文档接口失败，已通过显式路径、原始字符串及 UTF-8 输出修正。失败调用未修改数学源码或形成新的科学证据。

## 尚缺内容与停止点

未发现阻碍 R092 的实质声明缺口；R102 对 N7/N9 的建议是编号与极小生成族定位补足，已采纳。新增形式化、完整半群桥、一般 Tor 平衡、分次位移、经典 EK 矩阵同一性、新颖性认证均不在本次交付范围。根负责最终集成、claims/STATE/HANDOFF/queue 与检查点；本执行者交回后停止写入，不自动启动后续工作。

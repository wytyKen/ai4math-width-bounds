# R102 证明叙事与声明映射的最终范围复核

日期：2026-10-05（Asia/Shanghai，跨日续接 R092）。独占本报告，不派生，不修改主文、源码、状态或他人产物。

当前状态：**接受主文与最终声明映射作为已有证明的内部整理；本次限定范围无剩余阻断。** 主文 N7、N9、整体证据层级与 N0–N9 映射均完成有限复核；N0–N6/N8 核心重推仍明确沿用 R101 的独立通过范围。本结论不是新增数学结果、独立 Lean 重构建、原创性认证或人类认可。

## 恢复与范围

已读 AGENTS、STATE、HANDOFF、queue 和 R092 执行记录。根 `.venv` 执行 `scripts/checkpoint.py --check` 得 `queue_valid: true`；`--verify-latest` 确认 `20261004T155551360030Z-e9506cf3` 归档有效、标签 WIP。其后仅 queue 工作区修改，是正常任务登记增量，不是归档损坏。检查点工具没有运行 Lean 或证明数学。

已完整读取 `publication/PROOF_NARRATIVE.md`，重点从当前源码核对 N7 实际边界、第二全核、第三列和单射、标准 P、Tor 因子与 K 作用；N9 只回读已指定 CMS/HS 原文准确段落，没有扩展查新。R101 对 N0–N6/N8 的独立重推报告作为这部分已完成审查的记录；本报告只再核其集成假设与层级，不冒称重新独立验证全部计数。

辅助定位为 R056、R057、R058 报告及 R083 整链审查；接受结论不只依赖旧审查文字，而回读了下列当前实际定义和定理。未运行 Lean、实验、打包或对外动作。

## N7：边界、正合性与残差维数

### 极小生成元的叙述正确

`GeneratorMinimality.lean` 的 `column_strictAnti_of_initial` 以真实、未截断列为参数。对 i<i'<a，标准的 x^(i')y^(n_(i')−1) 经 lex 向下移动得到 x^i y^(i'−i+n_(i')−1) 标准，因此 n_i>n_(i')；n_a=0 的相邻端点另由 n_(a−1)>0 给出。N7 使用这个严格下降推出全部 xy 边界极小，方向和端点正确。

对 z 阈值生成元，t_ij≥1 是 xy 标准性与阈值成员性给出的。若合法的 x 或 y 直接前驱落在 I，则用 lex 把一个 z 移回该变量，使同 xy 位置的 t_ij−1 层落在 I；这与阈值最小性冲突。z 前驱直接由阈值最小性排除。这正是 `isMinimalExponent_zThreshold` 的证明，不是只靠不同生成元的数量猜极小性。纯 x、xy、z 三类在正阈值下不重叠；`BoundaryGenerators` 的成员、除子与 span 定理提供完整生成性。故 a+1+ell 的计数有实际理想语义。

### d2 全核与 d3 条件都已落实

`MonomialFirstSyzygies.lean:89` 的 `commonRelation_canonical_mem` 对已证明递降的自然数高度强归纳；`:133` 的 `boundaryRelationSpan_eq_ker` 调用任意多项式系数的共倍关系核准则；`:186` 给实际 `range(secondDifferential)=ker(differential)`。主文按共同多重次数分组再归一化，是此完整论证的有限概要，未把单项式测试或复合为零误写成全核。

`BoundaryThirdDifferential.lean:150` 的 `exists_lexThirdColumn` 同时证明核关系、三角顶部/低支撑与各坐标在 m。`:238` 的 choose 只从此已证存在性取列，`:246` 的 spec 供应全部性质。`:275`、`:286` 将这些具体性质传给通用 `range_thirdDifferential` 与 `thirdDifferential_injective`，因此旧条件工具中的 hk/hf 不是最终未证假设。主文的 f_p=y e_rx−x e_ry−(c_y−c_x) 和消元符号一致。

任意系数对 xf+yg=0 的两变量关系在当前域上多项式环中成立；主文令 x=0、得 x|g，再作整环消去的解释与源码系数法具有同一数学内容。最高层消元针对任意多项式向量，有限高度给终止；单射由最高非零第三系数对应顶部 y 倍数非零证明。无需也没有假定 (x,y)=A。

`BoundaryResolutionDegree` 证明相邻目标总次数不增；强化归一化同时控制修正列的次数和支撑。N7 未从低支撑单独推断系数在 m，而明确保留次数控制，故 d2/d3 的残差零没有遗漏。

### P → 标准 Tor → K 有限性没有跳步

`LexQuotientResolution.lean:24` 的实际 P 将 d1–商增广、d2–d1、d3–d2 的已证正合与顶端单射供给标准分解打包器；`:48` 保留原商映射，`:52` 给第 4 次起真实零项，`:85` 给全部残差微分零。原模型端点 `finiteColength_exists_residue_minimal_resolution` 没有额外存在分解或未知正合性输入。

`MinimalResolutionTor.lean:35` 固定第一因子 A/m、派生第二因子 A/I；`:44` 只沿实际 algebraMap K A 限制标量。`:56`、`:68` 依次用标准派生比较及零微分同调同构到实际残差项，`:80` 再给实际 K 线性等价。一次对象和 K 作用与旧定义均以 rfl 相容；没有新增一般因子换序。

`ResidueFreeDimension.lean:38` 用真实自由 A 基、张量 Finsupp 坐标及 `variableResidueEquiv` 得到 K 有限坐标空间；`:51` 先由等价取得 `Module.Finite K`，`:58` 才比较维数与原项 A 秩。N7 的逻辑顺序吻合，未称自由 A 项本身 K 有限。`HigherTorBounds.lean:108` 返回所有次数的 K 有限性、四维数以及高次 IsZero；后者来源于实际零项，不能被无限维 finrank 的数值约定替代。

三变量 lex 公式归为已知数学是准确的：[CMS Lemma 4.2 证明的式 (7)](https://arxiv.org/html/2307.05770v2#S4.E7) 有有限余长前提，写的是理想的 Betti 数；换成商的正次 Betti 必须右移一阶。N7 数学实现证据使用具体 P 路径，未把引用公式当定义或新发明。

## N9：传统半群层的有限核对

回读 [CMS 第 2 节、Theorem 2.1 和 Definition 3.1 后的式 (1)](https://arxiv.org/html/2307.05770v2) 可确认主文对象及下标：任意域、恰四个最小生成元、最小四维正则表示；参数约化保持 Betti，关联分次及初始/lex 步骤仅给上界。商长度为 m_Γ，无一次项随同 Hilbert 函数传递。比较链本身不需要宽度分支条件。目标是正则表示上的 Betti，非 Tor^R(K,K)。

预算必须如主文分成两支：[CMS Theorem 3.3](https://arxiv.org/html/2307.05770v2#S3.Thmthm3) 明确要求 w≤m_Γ−2；另一支直接用长度 m_Γ≤w+1，并分别处理 d=0 与 d≥1。该论证让 w≥4 的所有情形进入 N0，没有把有限余长反过来从预算推出。

w=3 时的四个最小生成元确为连续整数。[Herzog–Stamate v3 Proposition 2.7，印刷页 9](https://arxiv.org/pdf/1308.4644v3#page=9) 的范围为最小等差生成元族及 1≤i≤r−1；r=4 给所需三项。主文明确另用最小加权分次分解的局部化、完备化平坦性及极大理想内矩阵条目，解释仿射到完备局部的 Betti 保持。四维正则表示和一维 Cohen–Macaulay 性给 pd=3，处理高次消失。此处是经典理论拼接，不是 HS 命题逐字覆盖完备化，也不是本地 Lean 已验证。没有把只对 w≥4 成立的抽象 lex 严格界用于 w=3。

因此 N9 可作为已审查传统归约；它既没有重新证明全部引用定理，也没有将某次 Lean 构建扩张到半群、局部化、完备化、Gröbner/lex 比较全链。

## 整体证据层级

- N0 的任意域、真实有限余长、lex、x 标准、w≥4 与全部次数实际累计预算均保留。无特征零或泛型坐标条件被暗加，也没有将三变量模型扩张到任意嵌入维数。
- N1–N6 的核心输入及范围与 R101 通过版本一致；N1c 已采纳“比较两端所得必要界”的精化。三个实际 h 尾项与 floor 上界尾项的区别、阈值 64、真实下界可行性与极大值达到均保留。
- N8 已编译二项式端点和三条谐和直接复合推论分开；当前标准 Theta 仅针对实际 lex 截面最大值。未反推半群匹配下界，未称每个理想达到 Theta。
- M1–M3/F1 的候选/已知/推论口径未改变；U1–U5 和原创性未知明确保留。标准库包装、经典公式、最大值存在性不作首创。主文没有声称人类作者已核验。

## 声明映射的有限对照

已读 R100 完整映射。G/Q/C/D 四层的区别准确：G 无真实环或有限余长；Q 给实际维数预算但允许整个商不有限；C 明列真实有限余长且由此导出非零；D 的具体边界工具保留 hn、hInitial、hSpan/hI 的适用位置。`LexExtremal.Admissible` 本身不含 w≥4，映射另加主结论范围，未把结构定义偷换成定理。

N0–N6 对应主文的对象、截断、谐和、严格界、实际下界及 Theta 范围。实读 `IdealBounds.finrank_xySubspace`、`monomialIdeal_exists_initial_degree`、`LexExtremal.Admissible` 及最大值端点与合同吻合；主文 (5.2) 的三变量精确等式为该特殊族的直接计数推论，应与现有独立编译声明 h_d 精确式和 H_d≤s² 区分。

N7 关键声明从实际核/像到 P、零残差、标准 Tor、K 有限性和 IsZero 逐项对应，上文所查精确入口均在表内。无宽度边界版没有省去 hSpan/hI。N8 第一谐和式实读 `TorOneBounds.lean:123` 确认为既有直接有理数端点；第二、第三谐和式分别只列为既有维数公式和上界的直接复合。N9 各传统分支及尚缺 Lean 桥与主文一致，明确 w=3 不额外主张第一项严格或同一谐和常数。

提出两项非数学修订供 R100 集成：其一，表内原字母子项与主文同名字母小节并非逐一对应，改用独立数字细分并明示对应的是一级 N0–N9；其二，为 N7 的严格列下降与极小生成元补直达 `GeneratorMinimality` 和 `GeneratorExact` 的准确入口。两者均为已有内容的定位精化，不需要修改数学或补证明。

R100 终检完成后，已回读确认数字子项说明、四个极小边界准确入口和式 (5.2) 的声明层级提示均已纳入。关键源码链接在本次回读中准确；全体本地目标/声明起始行机械检查由 R100 执行并记录，不冒称为本审查另行运行的测试。

## 最终读取版本与停止

已只读复算并核对以下 SHA-256：

| 文件 | SHA-256 |
|---|---|
| `research/publication/PROOF_NARRATIVE.md` | `bcb09a18172c1a751092420fda56a40188624bbe1a2da6cbc8fdae8e71e0f484` |
| `research/publication/STATEMENT_MAP.md` | `698cfa7bbf56592f3f74580e1eee4d5655f52746daa2f54db85fc63d69ba21cf` |

这些哈希定位文档审查版本，不创造数学构建证据。未发现需要改证明、追加实验或扩张研究的问题；两项非数学定位建议已闭合。R102 只写本报告，现已停止。队列、claims、STATE/HANDOFF、最终检查点和本轮总体结论由根集成；R093 及以后仍须用户另行授权。

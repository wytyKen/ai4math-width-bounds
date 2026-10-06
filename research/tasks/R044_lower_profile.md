# R044：显式下界族的标准轮廓与全部次数预算

状态：已完成并统一集成验收，R045独立审查接受。执行者lower_profile，2026-09-29。组合计数已由根连接真实理想/商维数，而非仅假设轮廓可实现。

独占文件：`lean/WidthBounds/LowerProfile.lean`、本报告。未修改根 import、旧模块或状态文件。

## 当前实现

命名空间 `WidthBounds.Lower`，`lowerStandard s i j k := (i+1)*(i+j+k+1) ≤ s*s`。

- `lowerStandard_standardLex`：坐标下闭和同次 lex 下闭。
- `lower_hilbert3_le (s d)`：所有自然数参数/次数都有 `hilbert3 (lowerStandard s) d ≤ s*s`；编码 `(i,j) ↦ i*(d+1)+j` 给到 `range(s*s)` 的单射。
- `lower_hilbert3_zero {s} (hs : 1 ≤ s)`：零次计数为 1。
- `lower_hilbert3_budget {s} (hs : 1 ≤ s) (d)`：全次数累计预算 `sum_{t=0}^d H_t ≤ 1+d*s*s`。
- `lower_standard2_eq` 和 `lower_hilbert2_eq`：二维标准集为 `range(min(d+1,s*s/(d+1)))`，计数等于此最小值。
- `lower_hilbert2_of_lt {s d} (hd : d < s)`、`lower_hilbert2_of_le {s d} (hd : s ≤ d)`：原纸面分段轮廓。

以上接口均已通过目标编译，无数学障碍或未完成目标。

## 恢复与验证

已读取 AGENTS、STATE、HANDOFF、queue、R024、R020 预算段和 LexCounting。根 `.venv` 的 `checkpoint.py --check` 得到 `queue_valid: true`；`--verify-latest` 得到 `archive_valid: true`。queue 和根正在写的新集成文件是正常工作区后续修改，不是归档损坏。

目标命令：在 `lean/` 运行 `lake env lean WidthBounds/LowerProfile.lean`。最终调用退出码 0，无警告；六个公理输出仅含 `propext`、`Classical.choice`、`Quot.sound`。`lowerStandard_standardLex` 本身只需 `propext`、`Quot.sound`。预算根覆盖零次定理，二维计数根覆盖二维标准集合等式。

首次编译仅零次 singleton filter 化简未收束；改为显式证明 `standard3 ... 0 = {(0,0)}` 后最终编译通过。首次失败日志的 `sorryAx` 是编译器对未闭合证明生成的临时诊断，不是源码中的证明占位；最终输出已消除。源码未使用 `sorry`、`admit`、`native_decide` 或自定义公理。

最终工具会话 `99709` 的编译输出：

```text
'WidthBounds.Lower.lowerStandard_standardLex' depends on axioms: [propext, Quot.sound]
'WidthBounds.Lower.lower_hilbert3_le' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.Lower.lower_hilbert3_budget' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.Lower.lower_hilbert2_eq' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.Lower.lower_hilbert2_of_lt' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.Lower.lower_hilbert2_of_le' depends on axioms: [propext, Classical.choice, Quot.sound]
```

本轮已编译源码 SHA-256：`5833f295a3881c9fd19527c23da63709914bf3eed9adf5380b50024712b0dec1`。详细编译日志与 claims 校验值由主智能体统一构建后登记；本执行者未写独占范围外的结果文件。

## 口径与边界

本模块只证明指定标准谓词的组合轮廓与预算；真实单项式理想、有限余长、标准谓词匹配由 R024 和根集成另行验收。没有将轮廓直接假定为可实现，没有证明实对数或 Theta 渐近，更没有半群匹配下界或新颖性声明。没有外查、实验或 Python 数学计算。

## 根最终验收

统一 `lake build` 退出0，日志 `results/lean_lower_construction_build.txt`，SHA-256 `174a29cb3799d24b7110e85d51d1e68d8325728f24d1040c05c02f37304f8dec`。本模块冻结hash保持不变。根已证明actual standard=lowerStandard，传全部次数预算到实际商维数，并给完整xy精确列和、有理下界与第一Tor/真正最少数公式；R045已独立核验。完整Real.log/Theta及半群下界不在本轮范围。

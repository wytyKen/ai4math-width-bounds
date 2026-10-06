# R038：真实变量理想的残差域

状态：已完成并统一集成验收，2026-09-25。原执行者residue_field完成源码，根统一构建成功，R039独立最终核验接受；本轮不启动后续任务。

## 精确目标与范围

令 K 为域，A = MvPolynomial (Fin 3) K。沿用 GeneratorQuotient.lean 中
variableIdeal = Ideal.span (Set.range X)，不改变它的定义。

1. 证明 p ∈ variableIdeal ↔ constantCoeff p = 0。
2. 证明 variableIdeal = RingHom.ker constantCoeff。
3. 构造 variableResidueEquiv : (A ⧸ variableIdeal) ≃ₐ[K] K，给正向商代表公式与逆向常数公式。

只拥有 lean/WidthBounds/VariableResidue.lean 与本报告。不改旧证明、root imports、状态文件。
不建立张量模实例，不替换张量积底环，不声称 Tor/Betti 识别或新颖性。

## 路线与恢复记录

- 已读 AGENTS、STATE、HANDOFF、queue、PROTOCOL 及 GeneratorQuotient.lean。
- `.venv\Scripts\python.exe -B scripts/checkpoint.py --check`：queue_valid=true。
- `--verify-latest`：archive_valid=true；工作区仅根当前正常更新的 STATE/HANDOFF/queue 有差异。
- 反向成员证明用 p.as_sum：支持中的零指数由 constantCoeff=0 排除；非零指数用既有 coefficient-one monomial 成员引理，再乘 C(coeff)。
- 代数同构经 Ideal.quotientEquivAlgOfEq 与 Ideal.quotientKerAlgEquivOfRightInverse 构造；常数项 AlgHom 由已有 RingHom 包装，右逆为 C。

## 验证与失败记录

在 `D:\project\ai4math\lean` 运行 `lake env lean WidthBounds/VariableResidue.lean`，退出码 0，首次数学实现编译即成功，无警告。
命令由本任务工具会话 85747 执行；最终输出如下（统一构建日志由根另行记录）：

```text
'WidthBounds.MonomialInterface.mem_variableIdeal_iff_constantCoeff_eq_zero' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'WidthBounds.MonomialInterface.variableIdeal_eq_ker_constantCoeff' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'WidthBounds.MonomialInterface.variableResidueEquiv' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.variableResidueEquiv_mk' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.variableResidueEquiv_symm_apply' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```

未引入 sorry、admit、自定义公理或 native_decide；唯一类型假设为 `[Field K]`。标准逻辑公理如上。
初次 rg 使用 Windows 不支持的未展开 Quotient* 路径；改为对确定目录搜索，属工具路径修正，与数学路线无关。

## 完成交付接口

所有定义/定理位于 `WidthBounds.MonomialInterface`：

- `mem_variableIdeal_iff_constantCoeff_eq_zero (p)`：`p ∈ variableIdeal ↔ constantCoeff p = 0`。
- `variableIdeal_eq_ker_constantCoeff`：实际 span 定义的变量理想等于常数项 RingHom 的核。
- `constantCoeffAlgHom`：常数项的 `K` 代数同态包装；`constantCoeffAlgHom_apply` 为 rfl。
- `variableResidueEquiv`：`(MvPolynomial (Fin 3) K ⧸ variableIdeal) ≃ₐ[K] K`。
- `[simp] variableResidueEquiv_mk (p)`：`variableResidueEquiv (mk p) = constantCoeff p`，证明 rfl。
- `[simp] variableResidueEquiv_symm_apply (c)`：`variableResidueEquiv.symm c = mk (C c)`，证明 rfl。

因此正向映射、逆向映射及 `K` 线性兼容均由同一个实际 `AlgEquiv` 保证；可通过 `.toLinearEquiv` 使用已有线性结构。

## 边界与下一步

本文件只识别实际余环与系数域。没有定义新的 `A`-module structure on K，未把实际 `(A/m) ⊗[A] I` 改成替代向量空间；R037 的张量实例与底环仍由该任务独立处理。未作 Tor/Betti、完整半群归约、新颖性断言。

根加入 import 后统一构建并登记 SHA-256 证据；R039 审查实际理想定义和代表元公式。执行者停止写源码，等待根验收。

## 根最终集成与证据

R038与R037真实张量接口均已进入统一主线。根GeneratorTensorCoordinates_tmul在任意残差类上使用variableResidueEquiv给坐标公式，同时张量底环仍为A。统一 `lake build` 退出0，日志 `results/lean_generator_tensor_build.txt`，SHA-256 `703b698074e1619e83902c88d681f61538e6f7504d51d2e6bfc63162e5224f7b`。本模块源码自首次编译冻结后没有修改，SHA-256仍为 `9ba7cf9356ab12b7f70d91f57af7da67890e58216e71e790ca838a2a90ba6e12`。

2026-09-25根按用户要求只完成本步骤的最终核验、证据和稳定检查点，不继续执行后续任务。R039核对实际商K代数结构、公式和最终日志；本结果仍不是Tor/Betti识别。

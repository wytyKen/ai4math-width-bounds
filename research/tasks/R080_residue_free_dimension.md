# R080：有限自由模的真实剩余张量维数桥

状态：已完成局部 Lean 编译与公理检查，交主智能体统一集成。仅支持当前授权的 R058；不计算 Tor，不推进后续任务。

## 目标与所有权

独占 `lean/WidthBounds/ResidueFreeDimension.lean` 与本报告。设任意域 K，A = MvPolynomial (Fin 3) K，m 为既有 span 定义的 variableIdeal。对任意实际 M : ModuleCat A，假设 Module.Free A M 和 Module.Finite A M，证明真实 (A/m) ⊗[A] M 沿 K → A 限制标量后的 K 有限性及维数等于 finrank A M。

## 有限实施计划

1. 用实际自由基及 Basis.baseChange 构造剩余张量到有限坐标空间的等价。
2. 通过 variableResidueEquiv 将实际 A/m 坐标变成 K 坐标，并用 restrictScalarsNaturalEquiv 核对范畴限制标量与原有 K 作用。
3. 由等价证明 Module.Finite 和 finrank 等式；在分配的 Lean 文件内编译并检查关键声明公理。
4. 完成桥后停止，向主智能体提供精确接口与核验结果，由其维护根 import、状态、claims、日志和检查点。

## 恢复检查

已读 AGENTS、STATE、HANDOFF、queue；queue 中 R080 为 running 且路径已分配。checkpoint --check 通过；--verify-latest 表示最新归档完整，工作区只有主任务正常增量（queue 与 R058 报告），不是归档损坏。原状态文档尚待主智能体同步本轮 R058 授权。

## 最终源码接口

命名空间均为 `WidthBounds.MonomialInterface`，`M` 均为显式参数。

- `ResidueTensorK (M : ModuleCat A) : ModuleCat K`：实际 `residueTensorFunctor.obj M` 沿实际 `algebraMap K A` 的范畴限制标量。
- `residueTensorKNaturalEquiv M : ResidueTensorK M ≃ₗ[K] ((A/m) ⊗[A] M)`：将上述范畴对象与张量积原有自然 K 作用比较，底层是恒等映射，由既有 `restrictScalarsNaturalEquiv` 的标量塔证明保障兼容。
- `residueTensorFreeCoordinates M [Module.Free A M] [Module.Finite A M] : ResidueTensorK M ≃ₗ[K] (Module.Free.ChooseBasisIndex A M → K)`：真实 K 线性坐标等价。
- `residueTensor_free_finite M [Module.Free A M] [Module.Finite A M] : Module.Finite K (ResidueTensorK M)`。
- `finrank_residueTensor_free M [Module.Free A M] [Module.Finite A M] : Module.finrank K (ResidueTensorK M) = Module.finrank A M`。

## 验收记录

固定项目 `lean/` 工作目录，运行

```text
C:/Users/wyty/.elan/bin/lake.exe env lean WidthBounds/ResidueFreeDimension.lean
```

最后一次运行实际退出码为 0，无 error/warning。四项 `#print axioms` 分别检查 `residueTensorKNaturalEquiv`、`residueTensorFreeCoordinates`、`residueTensor_free_finite`、`finrank_residueTensor_free`，均恰为 `[propext, Classical.choice, Quot.sound]`，没有 sorryAx 或自定义公理。源码禁项文字扫描无匹配。未运行或声称统一构建；主智能体负责依赖生成、统一日志及审计。

局部编译对应的最终 `lean/WidthBounds/ResidueFreeDimension.lean` SHA-256：

```text
64415e375a16e7253e77a343d96aa0a973ebfd5ca86b494697a4c4f69453d1e9
```

源码已冻结供主智能体构建，没有修改既有证明、根 import、依赖配置、状态或 claims；没有另存未分配的日志。

## 实现进展

已定义 `ResidueTensorK`（真实 residueTensorFunctor 对象沿 algebraMap K A 的 restrictScalars），`residueTensorKNaturalEquiv` 给自然 K 作用的恒等兼容等价。主接口显式接受 M，供 `P.complex.X n` 使用。

初稿经 `Basis.baseChange` 构造坐标时，具体商环自作用触发实例搜索 heartbeat 超限；显式 leftModule 未消除。最终改用 mathlib 标准 `TensorProduct.equivFinsuppOfBasisRight (Module.Free.chooseBasis A M)`，先取得实际 A 线性张量坐标，再限制为 K 线性，经 `Finsupp.linearEquivFunOnFinite` 及逐坐标 `variableResidueEquiv` 到 K。这是同一个自由基剩余化论证，避免新增商环作用实例。最终修订局部编译通过。

维数等式由真实线性等价的 `finrank_eq`、`Module.finrank_fintype_fun_eq_card` 与 `Module.finrank_eq_card_chooseBasisIndex` 组合；有限性独立由 `Module.Finite.equiv` 给出，不从裸 finrank 数值推出有限性。

## 范围及停止点

结论属于 Lean 已编译的通用有限自由模剩余张量桥。没有假设 M 本身是有限维 K 模，也没有交换张量因子，仍为第一因子 A/m、第二因子 M。K 作用来自实际 K → A 和张量积自然作用，没有按目标维数运输标量。

本任务不构造或计算 Tor，不证明宽度界、graded shifts 或任何半群归约。下一步仅由主智能体将该桥用于已实际构造的分解项并做 R058 统一核验；本执行者在此停止。

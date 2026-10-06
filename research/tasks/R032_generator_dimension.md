# R032：理想生成系经常数作用映射的维数下界

状态：已完成并由根集成验收。实际极小系数映射应用、具体最少生成数与两个上界均已统一构建通过，R033独立审查接受；最终证据见本报告末尾。

独占文件：`lean/WidthBounds/GeneratingFamilyDimension.lean` 与本报告。根负责状态、集成、统一构建及检查点；本执行者不派生子任务。

## 精确目标与计划

设 `K` 为域，`V` 为 `K` 向量空间，`A = MvPolynomial (Fin 3) K`，`I : Ideal A`，`F : A →ₗ[K] V`。假设：

- `hMul : ∀ q p, p ∈ I → F (q*p) = MvPolynomial.constantCoeff q • F p`。
- `hSurj : ∀ v, ∃ p, p ∈ I ∧ F p = v`。
- 任意 `P : Finset A` 满足 `hSpan : Ideal.span (P : Set A) = I`。

证明 `Submodule.span K (F '' (P : Set A)) = ⊤`，再证明 `Module.finrank K V ≤ P.card`（允许有限维假设）。P不要求单项式、齐次或线性独立；F也不要求在P上单射。

最终路线：将`p ∈ I`通过hSpan转为真实理想span成员，对其使用`Submodule.span_induction`（mathlib中`Ideal.span`定义即环作为自身模块时的`Submodule.span`）。依赖归纳原理保留每个中间项属于该span的证据；乘法步骤先由此与hSpan还原`p ∈ I`，再使用hMul，因此没有把乘法公式错误地应用于理想外元素。生成元的像直接属于线性span，零与加法由F的线性性处理；hSurj推出整个V被张成。最后用有限像集合的张成维数上界与`Finset.card_image_le`。

公开名：`WidthBounds.MonomialInterface.span_image_eq_top_of_ideal_generators`，`WidthBounds.MonomialInterface.finrank_le_card_of_ideal_generators`。

精确共同参数顺序为`I F hMul hSurj P hSpan`。公共类型类为`{K V : Type*} [Field K] [AddCommGroup V] [Module K V]`；第二条维数定理额外显式要求`[Module.Finite K V]`。本模块只导入三个mathlib模块，不依赖R031源码或旧生成数证明。

## 恢复与验证

已读AGENTS、STATE、HANDOFF、queue、PROTOCOL及R031任务报告。根虚拟环境运行`checkpoint.py --check`返回queue_valid；`--verify-latest`返回archive_valid，报告的差异是当前本轮状态与新集成文件，非归档损坏。

验收命令：在`lean/`执行`lake env lean WidthBounds/GeneratingFamilyDimension.lean`，最终返回exit 0。

最后编译的全部输出：

```text
'WidthBounds.MonomialInterface.span_image_eq_top_of_ideal_generators' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
'WidthBounds.MonomialInterface.finrank_le_card_of_ideal_generators' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```

已编译源码SHA-256：`f019dbe54192905c2b684e9b16c961ab4786d6c70191c0f0335cc53c99853601`。源码禁止项搜索无命中；没有`sorry`、`admit`、自定义公理或`native_decide`。以上仅有Lean/mathlib常用标准逻辑公理；hMul、hSurj及有限维性是定理的显式研究假设，并未声明为全局公理。根的统一日志与claims应在实际集成之后重新记录。

实现中的失败只涉及库定理的名字定位：第一次误写`Module.finrank_top`，第二次误写`Submodule.finrank_top`；读定义后改为全局`finrank_top`，第三次完整编译通过。核心张成证明自首版即通过，不存在数学路线失败。失败编译中的自动占位公理诊断不属于最终源码或成功证据。

独立审查者R033已逐行核对当前张成、乘法及碰撞基数步骤，回报语义接受；最终综合验收仍由根完成。

## 边界

本模块只证明满足显式映射假设时的一般代数接口；不构造具体极小系数映射，不识别Tor或Betti数，不证明半群归约，也不宣称新颖性。根和R031将验证实际映射满足hMul、hSurj。

下一步：根将R031的`minimalCoefficientMap`代入两个一般定理，对`V = ↥E → K`换算finrank为E.card，再与已验收的精确生成集合合并；在统一构建和claims更新后建检查点。此执行者已完成所分配目标并停止改写源码。

## 根最终验收

实际F由R031提供，根GeneratorNumberBounds.lean已完成任意生成集合的基数下界、真实IsLeast以及最少生成数的严格/有理谐和界。统一 `lake build` 退出0，日志 `results/lean_polynomial_generator_number_build.txt`，SHA-256 `b6b48e11dd968c672b3a8c6d9a656937e755c7a40421432a9b3431bb13be7ee1`。本模块冻结源码hash未变，R033独立语义审查接受。本模块的hMul/hSurj在完整应用中均有实际证明，没有留作未验证桥梁。

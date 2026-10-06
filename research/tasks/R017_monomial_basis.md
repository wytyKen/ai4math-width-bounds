# R017：单项式商环标准基

状态：完成并经主智能体集成验收；2026-09-23。独占 `lean/WidthBounds/MonomialBasis.lean` 和本报告。最终统一日志见 `results/lean_quotient_growth_build.txt`；下文保留执行者原始验证过程。

目标：对域 K 与指数上集 S，证明真实商环 MvPolynomial (Fin 3) K / monomialIdeal S 与补集指数到 K 的 Finsupp 线性同构；进一步给出标准单项式基及有限子集维数接口。不得把基/维数等同作为假设。

路线：查本地 mathlib 的 Finsupp 限制线性映射、核及 quotientKerEquivOfSurjective；由 R007 的支撑判据证明核就是真实理想的 K 子空间，再得到商空间基。所有证明只放目标模块；根 import 交主智能体集成。

恢复已读：AGENTS、STATE、HANDOFF、queue、PROTOCOL、R007_interface 和 MonomialInterface。checkpoint --check 通过；--verify-latest 确认旧归档完整，当前 queue 与新增任务报告属于正常后续修改。最终新增源码已通过下面列出的目标编译与 Lake 构建。

## 已通过的中间里程碑

`lake env lean WidthBounds/MonomialBasis.lean` 于 2026-09-23 返回退出码0。
已证明 `ker_standardCoeffs`：限制到 S 补集的系数映射之核恰好为真实理想的 `restrictScalars K`；构造 `quotientStandardEquiv`；`standardMonomialBasis_apply` 证明基向量就是商环中的系数1单项式；`standardMonomials_linearIndependent` 与 `finrank_standardMonomialSpan` 证明任意有限标准指数切片的独立性和 finrank=card。三项公理审计入口均只包含 `propext, Classical.choice, Quot.sound`。

构造使用 `Finsupp.lsubtypeDomain`、`Finsupp.subtypeDomain_extendDomain`、`Submodule.quotEquivOfEq`、`LinearMap.quotKerEquivOfSurjective`、`Basis.ofRepr`；没有把商环基或维数作为假设。

## 最终命题与实际语义

全部定义/定理位于 `WidthBounds.MonomialInterface`，系数对象为任意 `[Field K]`，指数集合为 `S : Set (Fin 3 →₀ ℕ)`。主结论唯一的集合条件是 `hUp : IsUpperSet S`，不需要 lex 条件、不需要有限余长、不需要非零理想或标准集有限。

1. `standardCoeffs`：从真实多项式到补集指数的 Finsupp 线性映射；在标准指数处读取实际 `MvPolynomial.coeff`。
2. `standardCoeffs_surjective`：用 Finsupp 延零证明满射。
3. `ker_standardCoeffs`：借 R007 支撑成员判据证明核等于 `(monomialIdeal S).restrictScalars K`。
4. `quotientStandardEquiv`：真实理想商环 `(MvPolynomial (Fin 3) K ⧸ monomialIdeal S)` 与 `↥(Sᶜ) →₀ K` 的 K 线性同构；`quotientStandardEquiv_mk` 精确证明其商投影上的取值。
5. `standardMonomialBasis` 与 `standardMonomialBasis_apply`：由线性同构构造基，并证明每个基向量是实际商映射下的系数1标准单项式。
6. `standardMonomials_linearIndependent`、`finrank_standardMonomialSpan`：任意有限标准指数集合 T 的商环单项式线性独立，其张成子空间的 finrank 恰等于 T.card。没有假设整个商环有限维。
7. `quotientDegreeMonomial_linearIndependent`、`finrank_quotientDegreeMonomialSpan`：直接使用已有 `LexCounting.standard3` 索引，证明该次数单项式商像张成空间的维数就是已有 `LexCounting.hilbert3`。
8. `quotientHomogeneous S d` 定义为 mathlib 的真实子模 `MvPolynomial.homogeneousSubmodule (Fin 3) K d` 经实际商环代数映射 `Ideal.Quotient.mkₐ` 的线性像。
9. `quotientHomogeneous_eq_span` 不是定义重命名：证明上述像与标准次数单项式的张成空间相等。正向把任意齐次多项式按支撑展开；支撑指数均为次数d；在S中的单项式由于理想成员性在商中消失；其余项对应 `standard3`。反向证明每个标准次数单项式来自真实齐次多项式。
10. `finrank_quotientHomogeneous` 因而证明：

```lean
theorem finrank_quotientHomogeneous (S : Set (Fin 3 →₀ ℕ))
    (hUp : IsUpperSet S) (d : ℕ) :
    Module.finrank K (quotientHomogeneous (K := K) S d) =
      LexCounting.hilbert3 (standard (monomialIdeal (R := K) S)) d
```

## 最终验证与源码证据

运行目录：`D:\project\ai4math\lean`；固定 Lean/mathlib 4.22.0，未改变依赖版本或根 import。

- `lake build Mathlib.RingTheory.MvPolynomial.Homogeneous`：退出码0，补建本地缺失的9个现有 mathlib 依赖，1359/1359成功。
- 最终 `lake env lean WidthBounds/MonomialBasis.lean`：退出码0。
- 最终 `lake build WidthBounds.MonomialBasis`：退出码0，`[3064/3064] Built WidthBounds.MonomialBasis`，`Build completed successfully.`。
- 最终源码 SHA-256：`8a9be1d75a7a4d2eca5c34df8cbd6f3530d942393fe169792400e23b93f9181c`。
- 四个审计入口：`quotientStandardEquiv`、`standardMonomialBasis_apply`、`finrank_standardMonomialSpan`、`finrank_quotientHomogeneous`；全部精确输出 `[propext, Classical.choice, Quot.sound]`。
- 源码搜索未发现 `sorry`、`admit`、`native_decide` 或新增公理声明；`axiom` 字符仅出现在 `#print axioms` 审计命令。
- 未修改根 import、状态、queue、claims、依赖配置或任何其他证明文件。构建缓存是 Lake 正常输出；正式统一日志由主智能体集成时保存。

## 实现中排除的障碍

- `Sᶜ` 在函数空间及类型参数位置需要明确写 `↥(Sᶜ)`，避免 Lean 先把 S 强制转成 Type 再寻求补集实例。
- 采用 Finsupp 限制域和第一同构定理，无需从头构造补空间或假设基。
- 引入齐次多项式依赖后，商同构定义的匿名类型参数使类型推断耗尽默认 heartbeat；将两个商子模和 K 明确写出解决，未提高限制。
- omega 对未标注的 subtype 投影表达式区分了两种化简形式；明确给出 `ij.1.1 + ij.1.2 ≤ d` 的类型解决。最终没有遗留编译错误。

## 准确边界与下一步

已证明的次数空间是“真实齐次次数d多项式子模在实际理想商环中的像”。没有构造整个商环的 graded algebra / direct-sum 实例；没有依靠一个尚未构造的抽象分次商环组件来声称完成全部 graded API。单项式商环标准基及该真实次数空间与现有 hilbert3 的数值等同，均已机器核验。

本模块没有形式化 `hilbert2` 与二维截面商环的等同、有限余长等价、Hilbert–Samuel/数值半群预算传递、Macaulay lex 伴随理想存在、Gröbner/lex Betti 比较、CMS Betti 公式或半群环的同调归约。整体宽度 Betti 结论仍不能称为端到端 Lean 形式化。

下一具体动作：主智能体语义复核后添加根 import，运行统一构建，更新 claims/STATE/queue 并创建检查点；后续代数任务可使用 `finrank_quotientHomogeneous` 精确替换 hilbert3 计数，或补 hilbert2 的真实二维截面接口。

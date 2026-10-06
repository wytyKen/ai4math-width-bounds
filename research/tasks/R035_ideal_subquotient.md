# R035：实际理想子商的通用线性接口

日期：2026-09-24（Asia/Shanghai）。状态：已完成并统一集成通过；真实mI的核等式由R034提供，根已构造实际商基及维数，最终审查见R036。

独占文件：`lean/WidthBounds/IdealSubquotient.lean` 与本文。未改旧源码、根 import、配置或状态文件。

目标与边界：`idealSubmodule I J` 使用 `Submodule.comap` 把实际理想 `J` 拉回实际理想 `I` 的 `K` 向量空间。`IdealSubquotient I J` 因而为 `I/(I∩J)`；另有 `J≤I` 时才解释为 `I/J`。定义不依赖任何待证线性映射的核。

## 已验证接口

命名空间 `WidthBounds.MonomialInterface`；隐参数为 `K : Type*`、`[Field K]`、`V : Type*`、`[AddCommGroup V]`、`[Module K V]`。

```lean
def idealSubmodule (I J : Ideal (MvPolynomial (Fin 3) K)) :
    Submodule K (I.restrictScalars K) :=
  Submodule.comap (I.restrictScalars K).subtype (J.restrictScalars K)

abbrev IdealSubquotient (I J : Ideal (MvPolynomial (Fin 3) K)) : Type _ :=
  ↥(I.restrictScalars K) ⧸ idealSubmodule I J

def idealSubquotientEquiv (I J : Ideal (MvPolynomial (Fin 3) K))
    (F : MvPolynomial (Fin 3) K →ₗ[K] V)
    (hKer : ∀ p, p ∈ I → (F p = 0 ↔ p ∈ J))
    (hSurj : ∀ v, ∃ p, p ∈ I ∧ F p = v) :
    IdealSubquotient I J ≃ₗ[K] V
```

- `mem_idealSubmodule`：对 `p : I.restrictScalars K`，成员条件等价于 `p.1 ∈ J`。
- `restrictedIdealMap I F`：`F.comp (I.restrictScalars K).subtype`，附 `[simp]` 作用公式。
- `ker_restrictedIdealMap I J F hKer`：限制映射的核等于上述实际子模。
- `restrictedIdealMap_surjective I F hSurj`：由实际理想内的前像给出限制映射满射。
- `idealSubquotientEquiv_mk I J F hKer hSurj p`：同构在 `Submodule.Quotient.mk p` 上的值为 `F p.1`；证明为 `rfl`。
- `finrank_idealSubquotient I J F hKer hSurj`：`Module.finrank K (IdealSubquotient I J) = Module.finrank K V`，不要求有限维；无限维时不能把 `finrank` 本身解释为正整数维数。
- `finite_idealSubquotient I J F hKer hSurj`：假设 `[Module.Finite K V]`，得到 `Module.Finite K (IdealSubquotient I J)`。这是显式定理而非全局 instance，调用者可用 `letI` 安装。

所有数学内容为标准第一同构定理的实际理想接口，不声称新颖性，不声称已经证明任何特殊系数映射的核判据。具体实例 `I/mI` 仍需 R034 对 `J=m*I` 提供上述 `hKer`、`hSurj`；解释为 `I/J` 时另需实际包含 `J≤I`。

## 编译证据与公理

在 `D:\project\ai4math\lean` 执行：

```text
lake env lean WidthBounds/IdealSubquotient.lean
exit_code = 0
'WidthBounds.MonomialInterface.ker_restrictedIdealMap' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.idealSubquotientEquiv' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.idealSubquotientEquiv_mk' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.finrank_idealSubquotient' depends on axioms: [propext, Classical.choice, Quot.sound]
'WidthBounds.MonomialInterface.finite_idealSubquotient' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Lean/mathlib 固定版本：4.22.0。源码 SHA256：`42c8a7ee63bdce92f61279d656efc936766598cf97b5edab9a648428002bf2e6`。检查源码中 `sorry|admit|native_decide|^axiom` 无匹配；公理输出仅标准逻辑公理。此处嵌入命令证据，未另建超出文件所有权的日志文件；统一构建日志与 claims 登记由主智能体负责。

实现时发现 `Mathlib.RingTheory.MvPolynomial.Basic` 单独不导入多项式 `CommRing` 实例；显式导入 `Mathlib.Algebra.MvPolynomial.CommRing` 后所有原定证明一次通过。无修改数学路线或削弱假设。

下一步：主智能体导入本模块，以 `J=variableIdeal*I`、`F=minimalCoefficientMap E` 实例化同构，并用 `Pi.basisFun` 经同构拉回得到实际商的基。

## 根最终集成

根GeneratorQuotientBounds.lean以实际J=variableIdeal*I实例化本模块；R034核成员判据和既有R031实际原像分别满足hKer/hSurj。完整应用没有把两个桥梁性质留作未经证明的模型假设。实际商的单项式类基、有限维性、finrank=E.card、真正最少生成数和原模型宽度界均已统一编译。

统一 `lake build` 退出0；日志 `results/lean_generator_quotient_build.txt`，SHA-256 `2769b48af9a18b118648a98869a86059da0fd4db10b3115f275e5f566c81e8a1`。本模块冻结源码hash保持不变，R036独立审查核对最终证据。本轮没有完成Tor/Betti或半群归约。

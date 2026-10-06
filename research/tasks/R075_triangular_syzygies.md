# R075 三角第三关系准则

状态：R075实现完成并冻结，待主智能体集成与统一验收。只写 `TriangularSecondSyzygies.lean` 和本报告，不派生、不进入 Tor。

恢复：已读 STATE/HANDOFF/queue/AGENTS/PROTOCOL，checkpoint --check 通过；--verify-latest 归档有效，工作区仅本轮正常增量。

计划：固定 BoundaryFaceIndex、faceX/faceY、relationHeight/faceHeight；从真实 d2 的源坐标和目标严格降高证明最高层方程；对给定已闭合且三角的 face 族，以自然高度归纳证明像等于全核、映射单射。根负责 face 的独立构造及所有条件的实际证明，准则不是最终完整分解。

条件：每个 face p 在 d2 核内；对于 faceHeight p ≤ relationHeight r，face p r 等于在 faceX p 的 X 1、在 faceY p 的 -X 0、其余 0。所有参数沿用真实边界 I hZ a n hLex hn hInitial。生成性另用已证明变量对关系引理，非假设。

## 已编译接口

命名空间 `WidthBounds.MonomialPresentation`，任意 `K : Type*`、`Field K`，`Ring K = MvPolynomial (Fin 3) K`。

- `BoundaryFaceIndex a n := Σ i : Fin a, Fin (n i)`。
- `faceX p := Sum.inr (p,0)`、`faceY p := Sum.inr (p,1)`。
- `relationHeight I hZ a n r := boundaryHeight a n (boundaryRelationSource I hZ a n r).val`。
- `faceHeight I hZ a n p := relationHeight I hZ a n (faceX p)`；faceX、faceY的relationHeight有simp引理。
- `thirdDifferential face := Fintype.linearCombination (Ring K) face`，有 `thirdDifferential_single`。
- `TriangularFaces I hZ a n face` 是上述全部坐标三角条件的精确定义，没有把核或正合性藏进定义。

核心声明：

```lean
range_thirdDifferential I hZ a n hLex hn hInitial face hk hf :
  LinearMap.range (thirdDifferential face) =
    LinearMap.ker (secondDifferential I hZ a n)

thirdDifferential_injective I hZ a n face hf :
  Function.Injective (thirdDifferential face)

secondDifferential_thirdDifferential I hZ a n face hk b :
  secondDifferential I hZ a n (thirdDifferential face b) = 0
```

其中 `hk : ∀ p, secondDifferential I hZ a n (face p) = 0`，`hf : TriangularFaces I hZ a n face`。前一定理仅另用R056已有 `hLex/hn/hInitial`；不需要新增 `hx` 假设，也不假设任何生成性。R074 `polynomial_xy_relation` 已直接import并使用。

## 真实顶部行证据

`boundary_source_monomial`直接计算每列源项系数为x或y；`boundary_source_eq_inl`证明xy源仅对应自身指标；`boundary_source_eq_face`证明z源恰对应faceX/faceY两个指标。这些结论使用具体指数的0、1坐标和 `j<n i`，不是引入源不相交的假设。

`secondDifferential_top_coordinate`对真实R056 `secondDifferential` 逐列计算：若所有高度>H的系数为零，则高度H的任意源坐标只保留以此为源的列。目标项若落在此坐标，则其列源高度严格大于H，因此系数已零。其特化为：

- `secondDifferential_top_inl` 给 `D2 c (source(inl i)) = c(inl i)*X0`；
- `secondDifferential_top_face` 给 `D2 c (source(faceX p)) = c(faceX p)*X0+c(faceY p)*X1`。

## 全核生成和单射证明

生成性对严格支撑界H归纳（所有高度≥H系数为零）。在H+1层，xy最高系数由x非零及无零因子消去；每个z最高系数对由已编译两变量关系引理选出t。构造b仅支撑在本层，所有同高度面同时相减。三角性保证不引入更高项，并完全消去本层；剩余仍在D2核中，适用归纳。有限指标的 `univ.sup height + 1` 给任意向量所需初始界。

单射同样对有限高度界归纳。如果D3 b=0，对每个最高层p查看faceX p坐标得到 `b p * X1=0`，由无零因子和X1非零消去。三角性使其它同层及低层face不贡献此坐标，高层系数已零。该证明不需要hk，也不借助秩等式。

## 核验

最终命令（工作目录 `D:/project/ai4math/lean`）：

```powershell
lake env lean -o .lake/build/lib/lean/WidthBounds/TriangularSecondSyzygies.olean WidthBounds/TriangularSecondSyzygies.lean
```

退出0，无error/warning；olean已生成。临时完整输出 `tmp/r075_final.txt`。六项关键声明的 `#print axioms` 均且仅 `propext, Classical.choice, Quot.sound`；源码无 `sorry`、`admit`、自定义 `axiom` 或 `native_decide`。

- 源码 SHA-256：`b1d6cdf45272938004df6936b09390ff2aa7c4f0f90998f472ced8f38ebb42f1`。
- 本地日志 SHA-256：`8eb6776cfb61366b28dd417e517a80e319bab52cc27a533150af23b73852bab2`。

早期只遇到Lean层面的指标类型推断、有限和拆分和多余simp参数问题，均已修复；不存在被弃置的数学假设或实验替代路线。

## 边界与下一步

本文件是条件三角准则加实际D2顶部行，不声称已经独立构造faces或完成标准ProjectiveResolution。主智能体必须给实际face族并证明全部hk/hf后才可得到无遗留条件的完整分解。坐标属于变量理想、最小性、实际类别分解打包由主线另行处理。本项未进行Tor识别。等待根统一构建/审查/状态与检查点集成；文件冻结不再写入。

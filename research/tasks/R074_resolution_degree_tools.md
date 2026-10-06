# R074：变量对关系及边界度数/残差工具

状态：已完成并冻结，2026-09-30。仅支持已授权R057；不启动R058。

独占文件：PolynomialPairRelation.lean、BoundaryResolutionDegree.lean及本报告。根智能体管理队列、import和检查点；不派生。

计划：
1. 任意Field K的三变量多项式环，严格证明 x*f+y*g=0 的Koszul对分解，局部编译后立即冻结接口。
2. 定义 coordinateTotal e=e0+e1+e2，证明边界step次数为source+1、target总次数不增；供根的带次数控制归一化使用。
3. 证明第二微分各坐标属于variableIdeal；时间允许实现有限自由坐标在该理想时真实残差tensor为零的通用工具。

验收：Lean/mathlib固定4.22.0，所有新增目标局部编译，记录源码/日志hash与公理；不使用sorry/admit/custom axiom/native_decide，不把目标性质当假设。

恢复检查：checkpoint --check通过；--verify-latest归档完整，workspace的queue/R057报告变化为正常授权后续修改。

## 已完成的严格接口

命名空间均为 `WidthBounds.MonomialPresentation`，K为任意宇宙上的Field；A=`Ring K`。

### PolynomialPairRelation

- `polynomial_pair_relation {i j : Fin 3} (hij : i ≠ j) (f g : Ring K) (h : X i*f+X j*g=0)` 给出 `∃t,f=X j*t ∧ g=-(X i*t)`。
- `polynomial_xy_relation f g h` 专门取i=0,j=1，供R075使用。
- 证明在j坐标为0的d处查看原等式的`coeff (single i 1+d)`，得到`coeff d f=0`。通过`modMonomial`系数完全消失获得`X j∣f`，再以非零变量消去得到g公式。不使用IsCoprime(x,y)，不把非unit变量理想误作unit理想。
- 源码已冻结。第一次通过后去掉一个unused simp参数，最终局部编译无warning；olean已提供给R075。

### BoundaryResolutionDegree

- `coordinateTotal e := e 0+e 1+e 2`；`coordinateTotal_exponent`、`coordinateTotal_mono`、`coordinateTotal_add`。
- `boundaryRelationDegree_total I hZ a n s`：step的总次数等于source总次数+1。
- `boundaryRelationTarget_total_le I hZ a n hLex hn hInitial s`：target总次数不超过source总次数；无需hx假设。xy分支用真实正列与严格下降；z分支用阈值严格为正、lex将一单位z移到x或y，构造同总次数的理想单项式，再利用canonical仅依赖xy坐标及canonical≤该新次数。
- `monomial_sub_mem_variableIdeal_of_total_lt`：total(e)<total(d)即保证monomial(d−e,1)在变量理想，不需要额外e≤d。
- `boundaryRelation_apply_mem_variableIdeal`：R056真实关系列每个坐标属于变量理想；使用已证degree严格大于source、target，两个Pi.single的系数均属理想，再取差。
- `secondDifferential_apply_mem_variableIdeal`：任意多项式系数向量经真实d2后每个坐标都在变量理想。
- `residue_smul_eq_zero_of_mem_variableIdeal`、`residue_tmul_eq_zero_of_coordinates_mem_variableIdeal`：对任意实际残差q及有限自由向量v，所有v坐标在变量理想则q⊗v=0。通过有限Pi.single分解与平衡张量关系证明，不用维数为零替代实际零映射。
- `lTensor_eq_zero_of_coordinates_mem_variableIdeal`：任意源A模到有限自由模的线性映射，只要所有输出坐标在变量理想，其实际左残差张量为零。
- `residueTensorFunctor_map_eq_zero_of_coordinates_mem_variableIdeal`：上述map的标准residueTensorFunctor像为零。这个类别包装的M与K同宇宙、有限指标ι:Type；前两个线性/张量通用引理允许任意Type*。此约束匹配项目中的实际有限自由指标。
- `secondDifferential_lTensor_eq_zero`和`residueTensorFunctor_map_secondDifferential_eq_zero`：直接对R056的真实d2给出两种零微分表述。仅需hZ、hLex、hn、hInitial，不需要假设未知核或后续正合性。

## 语义边界

以上是局部Lean已编译的代数与度数/最小性工具，不声称单独完成R057分解或R058 Tor计算。没有构造d3，没有断言d2单射。真实d3的核生成、单射、标准分解与全部实际假设由根和R075集成。本任务不改旧源码、根import、依赖、状态、queue；这些由根统一处理。

## 局部证据

- `tmp/r074_pair_final.txt`：最终pair局部编译无error/warning；两个公理输出仅`propext, Classical.choice, Quot.sound`。
- `tmp/r074_degree_local3.txt`：完整degree与tensor工具局部编译无error/warning；6项公理输出仅标准三项，olean已生成。
- 最终两个目标的`lake build`日志与hash在下节登记。


## 最终验收与冻结

命令：lake build WidthBounds.PolynomialPairRelation WidthBounds.BoundaryResolutionDegree。实际退出码0，Build completed successfully，无error/warning；8项新增公理输出仅标准三项。以下hash对应最终冻结源码和成功日志。

- lean/WidthBounds/PolynomialPairRelation.lean: SHA-256 `246621dc7652262db3d3a3dd70db471f2037c517af8ace877c86a61b49a8041f`。
- lean/WidthBounds/BoundaryResolutionDegree.lean: SHA-256 `7ea223bec28ede3b2dd87a9346f3ff34e47a3cd7bacc2ceb1a8b89a87f7d475d`。
- tmp/r074_final_build.txt: SHA-256 `68dc8dcb1203304de2e1d927aea8adb47cd68b5d2af57867d6da69413b4f1767`。

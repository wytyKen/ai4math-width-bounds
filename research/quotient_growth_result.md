# 本轮结果：真实商环接口与对数增长

2026-09-23。统一构建日志：`results/lean_quotient_growth_build.txt`。

## 一、已完成的真实商环形式化

对任意域K、指数上集S，令I是实际多项式环 `MvPolynomial (Fin 3) K` 中由这些单项式生成的理想。

`MonomialBasis.lean` 证明了商环与标准指数系数Finsupp空间的线性同构，并把基向量识别为真实单项式的商像。随后证明：次数d齐次多项式子模经实际商映射所得像的维数，恰好等于已有的 `hilbert3` 计数。

`IdealBounds.lean` 定义未截断的全部xy单项式商像的张成空间 `xySubspace`，证明它等于一个有限标准族的张成空间，其维数等于 `sectionLength`。由此，`monomialIdeal_all_widths_dimension_bounds` 可以直接输入实际商环次数空间的维数预算，输出用实际xy子空间维数表达的全宽度三界。

这些等同由线性同构、基、独立性和显式张成证明得到，没有直接作为假设。尚未形式化完整graded quotient实例、CMS Betti公式、lex/Gröbner Betti比较及数值半群的全部归约；尤其没有把显示的维数表达式直接定义成Betti数。

## 二、已机器验证的谐和上界

在同一StandardLex和累计预算条件下，写初始次数为a、截面长度为ell。`Growth.lean` 已证明

\[
(d-a+1)h_d<2w\quad(d\ge a),
\]

及精确Nat整除和上界，再转换为有理数不等式

\[
\ell\le3w+(2w-1)H_{2w-1},\qquad H_N=\sum_{r=1}^{N}\frac1r.
\]

主定理为 `sectionLength_le_harmonic`；`quotient_xy_le_harmonic` 给出实际商环xy子空间维数的同一界。输入的预算亦是真实次数空间的维数。两者都已通过编译，只有标准逻辑公理；传递声明依赖检查确认没有使用旧有限枚举证书。

使用经典估计 `H_N<=1+log N` 即得到O(w log w)。本轮Lean证明停在精确有理谐和界，未声称已经形式化Real.log或Big-O接口。

## 三、抽象lex类中的匹配下界（纸面证明）

令M(w)表示有限余长三变量lex理想 `L⊂(x,y,z)^2`、满足全部次数 `HS(S/L,d)<=1+dw` 时二维截面长度的最大值。R018构造、R020独立审查给出

\[
M(w)=\Theta(w\log w).
\]

具体下界在w=s²时采用轮廓 `h_d=d+1`（d<s），`h_d=floor(s²/(d+1))`（d>=s）。它确实给出有限余长lex理想；全部次数预算成立。列长为

\[
n_i=\left\lfloor\frac{s^2}{i+1}\right\rfloor-i,\quad 0\le i<s.
\]

对任意w>=25，使用s=floor(sqrt(w))的同族得到 `M(w)>=(w/16)log w`。下界族、对数比较和Theta表述目前是经独立内部审查的传统证明，尚未Lean形式化。

**这不是半群Betti数的匹配下界。** 尚未建立相应半群族；即使同一Hilbert轮廓能由半群实现，Betti(半群)<=Betti(lex)的上比较也不能倒过来传递下界。这里证明的是仅用该累计预算和lex结构时，抽象类的最优增长阶。

## 四、查新与经典部分

三轮定向查新未定位到上述模型的同一Theta结论，见R023；这不认证原创性。CMS Problem 4.1已提出同一累计预算问题，lex归约和除数计数各自有明确先例。

下界计数满足 `ell=(D(s²)+s)/2`，D是经典除数和。因而其平方参数渐近 `ell=(1/2)w log w+(gamma-1/2)w+O(sqrt(w))` 属于经典除数估计的推论，不能单独包装为新数论结果。尚待进一步查新的是这个计数到artinian lex模型的提升及匹配增长阶结论。

详细依据：`research/tasks/R018_growth.md`、`R020_growth_review.md`、`R023_growth_literature.md`。原冻结v0.1/v0.2稿件未重排或覆盖。

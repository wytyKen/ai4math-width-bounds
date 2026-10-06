# R021：整数谐和上界形式化

状态：完成，统一构建及依赖审计通过。证明(d-a+1)*h_d<2w，并将其求和为精确Nat整除和。原始输入仍为StandardLex、初始次数、累计预算；不把点态界直接当最终假设。

## 已有结论

`degree_product_bound`、`degree_divisor_bound`：严格乘积界及Nat除法上界。

`sectionLength_le_divisor_sum`：

`ell <= choose2(a+1) + sum_{r=0}^{2w-a} (2w-1)/(r+1)`，右侧除法为Nat向下取整。

`sectionLength_le_harmonic`：

`(ell : Q) <= 3*w + (2*w-1)*harmonicQ(2*w-1)`，这里 `harmonicQ(n)=sum_{r=0}^{n-1}1/(r+1)` 是精确有理数。

证明包含从前缀预算推出choose2(a+1)<=3w、Nat整除到有理除法的比较及有限谐和和单调性，没有把总长度界作为假设。

`lake env lean WidthBounds/Growth.lean` 退出0；两个主入口公理仅为propext、Classical.choice、Quot.sound。未形式化实对数估计、Big-O/Theta记法或下界理想族；它们由R018/R020纸面推导处理。

在R017/R022接口完成后，增加 `quotient_xy_le_harmonic`：输入真实齐次像finrank预算，输出真实xy子空间维数的有理谐和界。初始次数由非零lex单项式理想及x标准构造；维数与组合计数等同均由已有新模块证明。

最终统一日志 `results/lean_quotient_growth_build.txt`。DependencyAudit对两个谐和主入口均确认旧有限证书不在实际传递声明依赖中。

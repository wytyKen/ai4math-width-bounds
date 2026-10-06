# R012：全宽度解析定理集成

状态：完成，统一主线构建与依赖审计通过。主线程将真实StandardLex列长度、终端计数和R011向量算术连接。最终定理仅假设w>=4、初始次数与累计Hilbert预算，不假设列预算/Cauchy结论，不调用267组有限证书。

## 精确结果

`WidthBounds.all_widths_analytic_bounds`：任意StandardLex A、任意整数w>=4、初始次数a>=2，若所有次数的三维累计计数<=1+d*w，则

- `a+1+sectionLength A w < (w+1).choose 2`；
- `a+2*sectionLength A w <= 2*(w+1).choose 3`；
- `sectionLength A w <= 3*(w+1).choose 4`。

`all_widths_strict_improvement` 将第一条转换为减一的非严格Nat界。初始性、预算与闭包是最终输入；列长正性、前缀值、列预算和列长总和均由已有新引理推导。

## 验证

- `lake env lean WidthBounds/AllWidths.lean`：退出0，两个主定理公理仅为propext、Classical.choice、Quot.sound。
- `lake build WidthBounds.AllWidths`：退出0，日志 `results/lean_all_widths_target_build.txt`。
- 最终 `lake build`：退出0，日志 `results/lean_all_widths_build.txt`，根入口包含AllWidths及DependencyAudit。
- `DependencyAudit.lean` 遍历主定理的实际传递声明依赖（不是import清单），确认无 `finite_envelope_certificate`、小宽度主定理或 `envelope_bounds`，也无sorryAx。诊断命令不作为数学证明使用。
- R011执行者因额度限制中断后，根据磁盘源与编译产物接手，不把未落盘消息直接当最终验收。

## 主线程语义核对

列长以真实标准谓词定义；截断来自通用Cutoff，适用于所有w>=4。末列位置n0-1的三角形注入逐项控制次数，没有把模型关系作为假设。Cauchy在整数向量上使用，允许第一分量为负。最终范围没有w<=39条件；旧有限证书虽因历史模块导入进入环境，实际新证明不使用它。

未覆盖：商环Hilbert维数/长度识别、Betti公式、半群Artinian与lex归约。前期独立紙面审查已通过；本轮新集成由主线程做语义核对和Lean核验，未再次安排外部或额外模型审稿。

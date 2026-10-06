# 全宽度解析证明：当前形式化范围

2026-09-23。新增解析路线已完成统一 Lean 构建，不再只是纸面候选。

## 已机器验证的精确结论

在已有 `StandardLex A` 模型下，假设整数 `w>=4`、初始次数 `a>=2`、`x^d` 在 `d<a` 时标准而 `x^a` 不标准，以及每个次数的三维累计计数 `<=1+d*w`。则

\[
a+1+\ell<\binom{w+1}{2},\quad
a+2\ell\le2\binom{w+1}{3},\quad
\ell\le3\binom{w+1}{4},
\]

其中 `ell=sectionLength A w`；已证明它包含全部二维标准单项式。第一界也已转写为 `a+1+ell <= binom(w+1,2)-1`。

主定理：`WidthBounds.all_widths_analytic_bounds` 与 `WidthBounds.all_widths_strict_improvement`，源码 `lean/WidthBounds/AllWidths.lean`。

## 新证明链

1. `ColumnBounds.lean` 从标准谓词构造实际有限列，证明列是初始区间、列长和等于截面长度、末端 `i+n_i<=n_0`。
2. 显式把每列 `j+k<n_i` 的三角形单项式注入次数小于n0的三维标准集合，得到 `sum n_i(n_i+1) <=2*(1+(n0-1)*w)`。
3. `AnalyticArithmetic.lean` 从原始前缀和终端预算推出 `a<=w-2`；在整数向量上完成平方、应用Cauchy、严格比较多项式。首项向量可以为负。
4. `AllWidths.lean` 连接所有接口，最终定理没有假设列预算、平方界或长度结论，没有w上限。
5. `DependencyAudit.lean` 遍历实际传递声明依赖，确认最终定理不依赖267组证书、小宽度定理或`envelope_bounds`。旧模块仍可导入环境，不代表新证明使用旧证书。

统一日志：`results/lean_all_widths_build.txt`。主定理仅使用标准逻辑公理 `propext`、`Classical.choice`、`Quot.sound`。没有sorry、自定义公理或native_decide。

## 仍有边界

单项式理想成员到StandardLex已有真实MvPolynomial接口；商环Hilbert维数及长度的识别、Betti公式、Artinian/Gröbner/lex半群归约仍为传统代数层，未形成端到端Lean证明。

v0.2稿件补充一个简单的低重数分支：若 `w>=m-1`，Artinian商总长度为m，因此d>=1时HS<=m<=w+1<=1+dw，d=0时HS=1。于是新严格组合界可用于这一分支，不再只借旧弱界。该段属于传统数学证明，不在当前Lean语义范围内；本轮由主线程核对，未额外安排独立审稿。

最新定向查新记录在 `research/tasks/R015_novelty.md`。未找到直接覆盖结果，但有限检索不认证原创性。v0.1稿件及证书保留为冻结的独立旧路线。

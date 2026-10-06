# v0.2解析证明审阅说明

主稿：`width_bounds_v0_2.tex`；PDF：`output/pdf/width_bounds_v0_2.pdf`。

变化：全部w>=4使用列长度平方和、Cauchy与严格多项式比较；不调用v0.1的267组枚举或CMS的大宽度末段。第一组合界强化为减一。稿中相应严格半群结论仍使用明确列出的传统代数归约。

Lean入口：`WidthBounds.all_widths_analytic_bounds`、`WidthBounds.all_widths_strict_improvement`。运行 `lake build` 同时编译新证明和依赖诊断。日志：`results/lean_all_widths_build.txt`。

构建PDF（项目根目录）：

```powershell
.\scripts\build_paper.ps1 -PaperName width_bounds_v0_2
```

精确形式化范围见 `research/analytic_formalization.md`。商环维数、Betti公式及半群归约没有整体形式化；平方根形式的渐近O(w^(5/4))备注也不是最终Lean定理的陈述。

本轮查新未发现同条件结果，但不确认原创性。稿件不署作者名；外部人类审稿仍由用户决定何时恢复。v0.1产物保持冻结。

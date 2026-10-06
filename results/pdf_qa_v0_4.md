# v0.4 PDF QA

2026-10-01。状态：通过。最终新稿paper/width_bounds_v0_4.tex与output/pdf/width_bounds_v0_4.pdf，10页A4，未更改旧版文件。使用PDF技能，首次authoring前marker成功执行且只执行一次。

## 编译与工具边界

已通过open_in_codex请求在Codex内置LaTeX编辑器打开相同TeX（工具返回queued），首次及最终编辑后compile_latex_document均返回环境错误`Unable to find standard directories for platform`，不是源文档错误诊断。未安装新TeX；未关闭编辑器打开请求，内置预览编译不能认证成功。采用项目已有MiKTeX pdflatex两遍流程，scripts/build_paper_v0_4.ps1实际退出0；每次pdflatex返回码由脚本检查，最终完整输出见results/paper_compile_v0_4.txt。输出PDF已独立成功生成，当前交付的编译证据来自该本地流程。

最终TeX日志没有overfull/underfull、未定义引用、缺字或LaTeX Warning；两遍后交叉引用已解析。Poppler pdfinfo核对10页、A4、未加密；pdftotext提取用于检查标题、定理和证据文字，文本检查不替代视觉QA。

## 逐页视觉检查

通过pdftoppm将全部10页渲染为1250像素高PNG并逐页目视检查。最后摘要加x∉I和第二微分多变量记号澄清后重新编译/渲染全部页；仅第1和6页PNG hash改变，这两页重新目视检查，其余8页最终渲染与已检查版本逐字节一致。

| 页 | 核查内容与结果 |
|---|---|
| 1 | 标题、日期、摘要明确x∉I与未完成半群边界，主传统定理和二项式公式清晰，边距正常。 |
| 2 | 列长定义、预算、端点/三角形计数与a界，无公式截断。 |
| 3 | Cauchy恒等式、严格第一界和二三界，长公式未越界。 |
| 4 | 传统半群转移的两个预算分支、一般特征比较与实际代数入口，状态表述一致。 |
| 5 | 实际商/最少生成数/第一Tor、I≤m反例、新分解节引入，无孤立标题。 |
| 6 | 实际有限自由序列、真实d1/d2/d3和低高度修正、标准Tor定理开端，矩阵/指数可辨，无重叠。 |
| 7 | 全部正次数界、真实K有限性与维数证明、预算无关接口和谐调界，连续阅读顺畅。 |
| 8 | 下界族取整和、实际极值类与Theta定理，符号和列表清晰。 |
| 9 | 当前形式化边界表、新模块地图和数学日志摘要，两栏表不裁切、长路径正常换行。 |
| 10 | 公理/依赖与证据边界、冻结说明和两项历史参考文献，页码连续、无空白页或未解析引用。 |

数学文稿审查另见R083；本QA只确认最终排版/导出和稿件版本对应，不认证新颖性或取代Lean证据。

## 最终字节

- TeX SHA-256 `26c1ebdcf796969ca3f829b93393d291e04c5c9f23b3bbf652f76641f37a54d5`
- PDF SHA-256 `ead6e0ede749632d5ebd704a0a2b9ab2e5312361fe94a322c916df23877ef64f`
- 本地编译日志 SHA-256 `1939d12652d0185fe9782f01fcab4af57b927b9ef5c1d3384f6e073c3eb1f98d`

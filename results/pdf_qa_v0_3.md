# v0.3 PDF 核验

2026-09-29，R049。新文件 output/pdf/width_bounds_v0_3.pdf；v0.1/v0.2 原文件未修改。

- 源码：paper/width_bounds_v0_3.tex，SHA-256 `5f6fe88d19fcbc0f086e5fb8242bef1a84613177bc0f522c0271aed89609bb27`。
- PDF：8页 A4，SHA-256 `5d1e9f8a925a7fc9d7c6368056a060ff4ef634306801da4fe6e810b010208887`。
- 最终编译：`scripts/build_paper.ps1 -PaperName width_bounds_v0_3`，pdflatex 两遍退出0；本机 MiKTeX pdfTeX 1.40.28。完整日志 results/pdf_v0_3_build.txt。
- 最终日志无 Overfull/Underfull、未定义引用或缺字警告。
- Poppler pdfinfo确认8页；pdftoppm 90 dpi渲染后实际查看全部8页。最后微调仅第7–8页，重渲染并再次目视检查；前6页文本与布局保持一致。
- 每页均核对公式可读、页码、无重叠/裁切、表格换行与参考文献完整。第8页同时容纳两条参考文献，无单条参考文献孤立成页。
- 数学口径由R051另审：原半群传统证明与Lean范围分开，Tor保留I<=m/因子顺序，Theta只指真实lex预算类最大xy维数。
- 未重新编译Lean；这是文稿/排版核验，不增加数学验证范围。

中间渲染位于tmp/pdfs/width_bounds_v0_3，仅供本地排版复核，不入冻结载荷。正式TeX/PDF/本记录及编译日志入交付。

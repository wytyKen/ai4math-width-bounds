# ai4math：宽度界、lex 理想与标准 Tor

[English (primary)](README.md) · 中文说明

这是一个进行中的人机协作数学研究项目，研究四生成元数值半群的宽度界，并用 Lean 形式化相关的三变量 lex 理想模型。项目以英语为默认维护语言；本页对应英语首页，原中文研究记录作为历史档案保留。

**研究状态：**数学基线为 **R058 / v0.4**，贡献对照和证明叙事已完成到 R091–R092。完整半群归约尚未端到端 Lean 形式化，新颖性仍未确定，也未获得外部人类同行评审。后续文档和仓库工作以[当前状态](research/STATE.md)为准。

## 阅读入口

| 目的 | 文档 |
|---|---|
| 理解成果及研究过程 | [项目总览](docs/PROJECT_OVERVIEW.md) |
| 阅读完整论证并追到源码 | [证明叙事](docs/PROOF_NARRATIVE.md) → [声明映射](docs/STATEMENT_MAP.md) |
| 判断候选贡献与文献关系 | [贡献分析](docs/CONTRIBUTIONS.md) |
| 构建、复现与检查产物 | [复现指南](docs/REPRODUCIBILITY.md) |
| 了解公开状态与责任 | [发布说明](docs/PUBLICATION_STATUS.md) |

以上为英语主线；[文档导览](docs/README.md)说明各文档分工，[研究档案入口](research/README.md)列出中文原件。[v0.4 英文报告](output/pdf/width_bounds_v0_4.pdf)为冻结的 10 页研究稿，另有[TeX](paper/width_bounds_v0_4.tex)和[版本索引](paper/README.md)。

## 主要形式化结论

设 K 为任意域，A = K[x,y,z]，m = (x,y,z)。I 为有限余长 lex 单项式理想，x ∉ I；整数 w ≥ 4，并对每个整数 d ≥ 0 满足

```text
Σ_{t=0}^d dim_K Q_t(I) ≤ 1 + d·w,
```

其中 Q_t(I) 为 t 次齐次多项式在 A/I 中的像。有限余长是独立假设。令 a 为首个满足 xᵃ ∈ I 的指数，ℓ 为完整 xy 商子空间的实际 K 维数。

- 实际有限自由分解的四个秩为 **1、a+1+ℓ、a+2ℓ、ℓ**，4 次起为零项；左侧与 A/m 张量后，所有微分为零。
- 标准对象 `Tor_i^A(A/m, A/I)` 派生第二因子，K 作用沿实际 K→A 限制。所有次数均证明 K 有限性；0–3 次维数为上述四数，i ≥ 4 为实际零对象（`IsZero`）。
- 记 `b_i = dim_K Tor_i^A(A/m, A/I)`。每个 i ≥ 1 均有 `b_i ≤ i·C(w+1, i+1)`，且 `b_1 < w·(w+1)/2`。C(n,k) 是二项式系数，k > n 时为零。
- 实际 lex 预算类的最大 xy 维数 M_K(w) 在 w ≥ 4 时达到；w ≥ 64 时，`w·log(w)/16 ≤ M_K(w) ≤ 10w·log(w)`，log 为自然对数，并有 mathlib 标准 `Asymptotics.IsTheta` 结论。

完整假设和证明见[证明叙事](docs/PROOF_NARRATIVE.md)。极值下界属于 lex 类，不是半群类的匹配下界；一般 Tor 因子平衡和完整分次 Betti 表接口尚未完成。

## 证据、使用与后续

Lean/mathlib 固定为 **4.22.0**；Python 工具使用根 uv 环境和 Python 3.13。具体命令、既有增量构建证据、尚未完成的干净环境复现，以及公开源码与完整本地归档的区别，统一见[复现指南](docs/REPRODUCIBILITY.md)。

AI 实质参与探索、实现、写作和内部复核；AI 内部复核不等于人类同行评审。R093 人类贡献与责任记录、R095 独立复现仍待完成，具体有限步骤见[后续工作](docs/FUTURE_WORK.md)。

修改与纠错按[贡献指南](CONTRIBUTING.md)进行。历史中文报告及冻结证据保留原字节和当时的结论范围。

目前没有选定项目级许可证、正式论文作者名单或 DOI。公开可读不自动授予开源再利用许可。引用时请注明具体仓库版本及“研究快照”状态；权利、署名与责任见[发布说明](docs/PUBLICATION_STATUS.md)。

# ai4math：宽度界、实际lex分解与标准高阶Tor

**研究冻结 v0.4，2026-10-01。** 任意域上的真实三变量有限余长lex模型，现已连接实际有限自由分解、标准所有高阶Tor、真实K有限维数、消失和全部正次数宽度界。原四生成元数值半群的完整归约仍未端到端Lean形式化，新颖性与人类同行认可未认证。旧v0.3及更早版本保留。

## 阅读与复核

- [全过程与扩展报告](research/PROJECT_REPORT.md)：v0.3历史正文与第12节R054–R059续编、精确假设、逐边证明地图和未来接口。
- [v0.4交付指南](research/DELIVERY_v0_4.md)：固定环境、包校验、PDF和版本边界。
- [v0.4英文数学报告](output/pdf/width_bounds_v0_4.pdf) / [TeX](paper/width_bounds_v0_4.tex)：10页，新增实际分解和标准高阶Tor链。
- [v0.4交付包](output/ai4math_research_delivery_v0_4.zip) / [外置收据](output/ai4math_research_delivery_v0_4.receipt.json)：最终整体哈希与载荷核验；源码文档不回填ZIP自身hash。
- [当前状态](research/STATE.md)、[交接](research/HANDOFF.md)、[下一阶段计划](research/NEXT_STAGE_PLAN.md)：下一候选R060，须用户启动，当前不自动推进。

## 数学范围

任意域K，A=K[x,y,z]，m=(x,y,z)，I为真实有限余长lex单项式理想；要求x标准、w≥4及所有次数实际累计维数预算Σ H_t≤1+dw。a为初始纯x禁指数，ell为完整xySubspace的实际K维数。标准Tor固定第一因子A/m，派生第二因子A/I，K标量沿实际K→A限制。

- 真实标准有限自由分解的A秩为1、a+1+ell、a+2ell、ell，4次起为零项，所有残差微分为零。
- 标准Tor所有次数K有限；0..3维数为上述四数，i≥4为真正零对象。通过标准同调比较和实际自由基张量坐标证明，不直接把A秩重命名为K维数。
- 所有i≥1有dim Tor_i≤i choose(w+1,i+1)；第一界严格小于choose(w+1,2)。一次对象与旧C021一致。
- 旧最少多项式生成数、真实I/mI与张量基、显式下界族、达到最大值及Theta(w log w)结论保留。Theta只指抽象lex预算类的最大值，不是每个理想或半群匹配下界。

完整半群归约、必要的Tor因子比较和完整graded shifts API仍未完成。有限实验只用于查错，不是后续全宽度证明的依赖。

## 固定环境与字节检查

```powershell
.venv/Scripts/python.exe -B scripts/package_delivery_v0_4.py --verify output/ai4math_research_delivery_v0_4.zip
.venv/Scripts/python.exe -B scripts/checkpoint.py --check
.venv/Scripts/python.exe -B scripts/checkpoint.py --verify-latest
```

这些命令不运行数学证明。最新已验收统一Lean日志为[lean_higher_tor_build.txt](results/lean_higher_tor_build.txt)，原源码与日志hash见[claims](research/claims.json)、[R058验证](results/r058_validation.json)。R059只做交付审查和字节对应复核，没有修改证明或声称新Lean构建。独立整链审查见[R083](research/tasks/R083_lex_chain_release_audit.md)。

需要独立重建时在lean目录运行lake build，固定Lean/mathlib **4.22.0**与锁文件；Python只用根uv .venv，缓存保持项目内。新机器工具安装与包校验边界见交付指南。

## 冻结与后续

[v0.3指南](research/DELIVERY.md)和[原报告](research/frozen/v0_3/research/PROJECT_REPORT.md)描述当时边界；v0.1/v0.2/v0.3 PDF、TeX、ZIP和验收记录保持原件。v0.4另存，没有覆盖旧成果。

当前有限阶段在R059结束。用户若继续，下一项R060仅制定真实半群对象与归约接口合同；后续不是自动待办。恢复先读AGENTS/STATE/HANDOFF/queue并核验checkpoint。R009外部审阅仍暂缓，不发信、上传或发表。

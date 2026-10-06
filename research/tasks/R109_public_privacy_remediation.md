# R109 公开仓库内容隐私审计与忽略规则补强

2026-10-07。状态：完成。R110 / R111 专项报告已接受，未发现需移除的凭据或私人材料；已补强忽略规则。

## 用户范围

用户明确指仓库内可能有未被 gitignore 排除的隐私；上传本身不需要隐藏姓名和邮箱。因此正常 Git 作者 / 提交者身份保留，不修改 name/email，不把普通本机路径、文献作者或公开 GitHub 账号自动当成秘密。本轮只检查内容和遗漏规则；未重写 Git 历史、改变 remote 或 push。

## 主线检查

启动 checkpoint --check 通过，--verify-latest 对上一稳定快照归档有效且工作区未变。启动 HEAD 为 5165182b944382797ec1bc7c3b7cf13da993ab93，本地跟踪 origin/main 为 01450016b1c7fc7e669a1155f8d717f9a00fa5e0。用户已报告首次推送成功；本轮不主动 fetch，不推断实时远端可见性 / 缓存状态。

实际已跟踪 275 个文件，其中 4 个 PDF，其余为源码、锁文件、研究文档、报告与结果；按敏感文件名规则检查，未发现 .env、密钥、凭据 JSON、浏览器登录状态、密码库等候选文件。另按非运行时项目目录检查未跟踪文件，没有相应候选。缓存 / tmp / checkpoints 等已忽略目录不扫描其全部私有内容；它们不属于当前拟上传载荷。文本历史和 PDF 的正文 / 元数据由两个专项报告给出实际检查范围。

## 已实施防护

.gitignore 原已有环境文件 / pem / p12 / pfx / 缓存 / tmp / 检查点 / 下载全文 / 旧 ZIP 排除。本轮补充：其他私钥 / keystore / jks / kdbx、默认 SSH 私钥名、Git / netrc / npm / Python 凭据配置、SSH / GPG / AWS / Azure / Kubernetes 本地目录、常见 credentials / client_secret / service-account / secrets 配置文件、cookies / storage-state / Playwright 登录状态，以及根 private / .local 私用目录。

保留 .env.example 作为示例文件例外；示例内容仍必须是占位值，名字本身不保证无秘密。没有一概屏蔽研究 JSON / 日志或数学 PDF。

只读使用 git check-ignore --no-index --stdin，对 47 个应忽略路径和 7 个应保留路径做探针，全部符合预期；未创建任何假凭据文件。当前 275 个 tracked 路径没有被新增规则意外排除。gitignore 只控制未跟踪文件的默认纳入，不会抹除已跟踪文件或历史；因此本轮也检查实际载荷与可达历史，没有把补规则当作已经清除泄漏。

C037 已验收的原 .gitignore 字节保存在 research/frozen/github_r103/gitignore.original.txt，只更换旧 evidence 路径、保留旧 SHA 和原验收。没有改动冻结科学源码或交付原件。

## 专项结论与限制

R110（tasks/R110_privacy_text_audit.md）：检查 3 个可达提交、275 个 tree 路径、283 个去重 blob，其中 279 个 UTF-8 文本及 4 个 PDF；文本与提交消息中的凭据 / 私钥 / 带密码 URL / 秘密赋值等扫描无确认敏感项。6 处关键词候选属于说明文字。正常 Git 身份、本机路径和公开 URL 保留，不需要历史重写。

R111（tasks/R111_privacy_pdf_audit.md）：四份 PDF 共 29 页，两套抽取器、960 个对象、112 个非图片 / 非字体程序流及元数据 / 批注 / 附件检查未发现需脱敏内容；作者字段为空，无附件 / 表单 / JavaScript / 图片。16 个外链为公开 DOI / arXiv 来源，路径候选是正则误报；所有原件 hash 不变。没有逐页视觉或隐写取证。

本轮基于实际文件清单、已知敏感模式、人工判别和 PDF 结构 / 内容检查。没有声称能识别任意名称下的所有秘密或所有个人语义；正常提交身份不属于用户要求隐藏的范围。发现真实秘密才需要考虑清理已提交内容 / 历史或撤销凭据；本轮不预先实施这些破坏性或外部操作。

官方行为依据：[GitHub 敏感数据清理说明](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)。提交身份按用户明确要求保留，未套用隐藏邮箱或历史身份重写。

## 停点

根集成两项报告、旧证据字节核验、状态与检查点后，提交本轮规则与安全摘要；用户仍自行 git push。本轮不改变 R093 及后续研究任务状态，不新增数学构建。

验收时旧 738 条 evidence、64 个 Lean 项目文件与既有 13 个 output 文件全部匹配；未重新编译数学。隐私专项精确中间数据仅放 tmp/r109_private、tmp/r110_private、tmp/r111_private，均被忽略；公开摘要不复述真实秘密值。原 .gitignore 旧 hash 已通过保存副本继续满足 C037。

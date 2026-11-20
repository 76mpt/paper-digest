# 論文筆記

日報裡我覺得值得單獨記下的論文。每篇一個檔案，比日報讀得更深（讀全文，不只摘要）。

- 檔名：`<arXiv ID>-<短名>.md`
- 格式：照 [`_template.md`](_template.md)
- 數字一律標明是作者自報；HTML 版的數學式或表格看不清楚的地方，寫「待查 PDF」，不要猜。
- 和我方向的關係分成「可以直接借用」「威脅或差異點」「待驗證的想法」三類，最後一類是假說，不是結論。

## 研究脈絡摘要
每日的「今日重點」與趨勢收在 [`trends.md`](trends.md)，由日報 routine 自動追加。

## 論文筆記索引
<!-- NOTES-INDEX -->
| 日期 | 論文 | 一句話 | 標籤 |
|---|---|---|---|
| 2026-11-20 | [RWM 稽核（ANYmal D）](2611.23118-rwm-audit.md) | 逐位元重建 + 預先登記：one-step 會把設計排反、ensemble 1σ 只覆蓋 4.6%、18 個更準的 simulator 有 13 個訓出失敗 policy；稽核流程可照搬成先導論文方法論，缺口是沒量步態頻率 | 評估方法論、先重現、RL 模擬器、locomotion |
| 2026-11-20 | [Every Camera Grows Up（EyeHeight）](2611.21782-camera-height.md) | 6 個開源互動世界模型都把相機高度拉回人眼；「已知真值起點 + 隨長度畫曲線 + 追到資料先驗」可移植成「rollout 頻率往常見頻率回歸」 | benchmark 設計、往先驗回歸、CFG、量尺驗證 |
| 2026-11-20 | [AgentWorld（NeurIPS 2026）](2611.22880-agentworld.md) | VLA 內部承載規劃的是 grounded agent token（L2 0.27 vs global latent 0.49 vs text 0.58）；沒有拿掉語言的消融、只做一步預測、RL reward 有自我參照風險 | 結構化 world state、P2、合體版動機、reward hacking |
| 2026-11-20 | [AR-WAM](2611.21851-ar-wam.md) | 無語言自駕 WAM，快取 KV + single-pass，NAVSIM 94.0 PDMS、146 ms；只對應 WEWA 的車端那一半（RL 不在世界模型裡）；Dr. GRPO 理由可套用到計數器 reward | WEWA、延遲、NAVSIM、RL reward |
| 2026-11-20 | [Body Schema Policy](2611.22713-body-schema-policy.md) | 運動學樹 token + screw 傳遞，35M 參數打平 2.63B 的 Ψ₀；作者承認換成 latent 動作座標會變差，支持 P2 把 z_pose 錨在關節角度；延遲比較條件不對等 | 關節結構先驗、P2、Track B、B 版即時 |
| 2026-11-20 | [Rhythm of Generated Video](2611.22996-rhythm-bitstream.md) ⏰ | 不經編碼器的 frame-difference energy 裡就有 VAE stride 週期；**橋接實驗前要先做 tokenizer 往返對照**（步驟在筆記裡） | 週期假象、motion energy、對照實驗、待辦 |
| 2026-11-20 | [JointGV（只紀錄）](2611.22543-jointgv.md) | 用外部標註的 scene graph 修正 rollout 漂移；user 判斷和 A 版有差距，降為 related work | related work、結構修正 |
| 2026-11-20 | [待讀清單：DiWALI（未來重點）、StrideWorld、Does the Action Matter?、WACO；⏰ 提醒看 PRISM](2026-11-20-reading-list.md) | 只讀過摘要；DiWALI 是合體版主幹的直接競爭（少了動作先驗、exemplar、計數器），深讀問題已列好 | latent action、世界模型內 RL、世界模型評估、外參校正、週期量測 |
| 2026-11-18 | [待讀清單：Flip Test、Sense、VAE Rhythm（+4 篇輔助）](2026-11-18-reading-list.md) | 只讀過摘要；VAE Rhythm 附給 sparse session 的交接（相位掃描當混疊診斷） | 世界模型評估、latent 距離、週期假象、sparse |
| 2026-11-18 | [BAL：pose 序列的雙向 latent 自回歸](2611.18559-bal.md) | 用行為順序當監督，global/local 分解防 collapse；local 表徵是否天然重複，可當「重複動作對應重複碼」先驗的對照 | pose、latent 預測、P2、Track B |
| 2026-11-18 | [LASR：latent action 的動作支持指標](2611.17775-lasr.md) | 預測增益不等於編碼了動作，要扣掉狀態與進度捷徑；和我們 ESC exemplar「有效但不是 content-specific」是同一個評估判斷 | 評估方法論、latent action、對照組、swap probe |
| 2026-11-16 | [CGEM：Critic-Gated Event Memory](2611.16386-cgem.md) | 只記「讓成功機率跳一下」的事件；玩具環境本身就是要數重複造訪的計數任務 | 記憶、進度、計數器當 reward、decision aliasing |

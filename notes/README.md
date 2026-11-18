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
| 2026-11-18 | [待讀清單：Flip Test、Sense、VAE Rhythm（+4 篇輔助）](2026-11-18-reading-list.md) | 只讀過摘要；VAE Rhythm 附給 sparse session 的交接（相位掃描當混疊診斷） | 世界模型評估、latent 距離、週期假象、sparse |
| 2026-11-18 | [BAL：pose 序列的雙向 latent 自回歸](2611.18559-bal.md) | 用行為順序當監督，global/local 分解防 collapse；local 表徵是否天然重複，可當「重複動作對應重複碼」先驗的對照 | pose、latent 預測、P2、Track B |
| 2026-11-18 | [LASR：latent action 的動作支持指標](2611.17775-lasr.md) | 預測增益不等於編碼了動作，要扣掉狀態與進度捷徑；和我們 ESC exemplar「有效但不是 content-specific」是同一個評估判斷 | 評估方法論、latent action、對照組、swap probe |
| 2026-11-16 | [CGEM：Critic-Gated Event Memory](2611.16386-cgem.md) | 只記「讓成功機率跳一下」的事件；玩具環境本身就是要數重複造訪的計數任務 | 記憶、進度、計數器當 reward、decision aliasing |

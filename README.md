# Paper Digest

每日論文日報（世界模型 / Vision-Action 為主，Pose、RAC、Event 為輔），由 Claude Code 雲端 routine 於東京時間週一～五 11:00 產生。

- `digests/YYYY/YYYY-MM-DD.md`：每日日報
- `context/`：研究方向備忘錄與 memory 快照（從主力電腦用 `sync_context.sh` 同步，請勿在別處手動修改）
- `notes/`：值得單獨記下的論文筆記（讀全文，含和我方向的關係與待驗證假說），索引在 `notes/README.md`
- `seen_ids.txt`：已列過的 arXiv ID
- `SETUP.md`：設定說明（另一台電腦怎麼用、同步方式、待處理事項）

## 最近的日報
<!-- DIGEST-INDEX -->
- [2026-11-18](digests/2026/2026-11-18.md)：Flip Test 顯示 11 個影片世界模型在「差幾毫米未來就翻轉」的反事實對上低於亂猜；RRM 綜述 + RRM-Bench-1K 發現 reward model 的 dense credit 追時間而非任務狀態。
- [2026-11-17](digests/2026/2026-11-17.md)：LASR 檢查 latent action 是否真的編碼動作而非狀態/進度捷徑（含正負對照）；WATO 讓 joint WAM 部署比 CEM 快 11.5 倍。
- [2026-11-14](digests/2026/2026-11-14.md)：同一批（Fri 13 Nov）的第二梯隊：CGEM 用 critic 記「改變成功機率的事件」解 decision aliasing（週期任務的進度問題）；Bind-WAM 只在不確定時才讓 WAM 想像未來。
- [2026-11-13](digests/2026/2026-11-13.md)：V-JEPA 2 的 predictor 幾乎不比「複製現在」好（persistence 對照）；RSSM 想像 rollout 隨步數丟失任務訊號而 ensemble 察覺不到。
- [2026-11-12](digests/2026/2026-11-12.md)：OnlyAct 從 V-JEPA 2 抽 latent action；記憶型 VLA 在計數任務上把時間當進度（phantom progress）。

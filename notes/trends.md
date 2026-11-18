# 研究脈絡摘要（每日重點與趨勢）

每份日報「今日重點」的研究摘要都收在這裡：當天最值得讀的論文，以及看得出來的趨勢。最新的放最上面。
這裡是**當天的判斷**，不是驗證過的結論；被後續論文推翻或修正時，在該條目下補一行「後續：」。
個別論文的深入筆記在同資料夾的 `<arXiv ID>-<短名>.md`。

<!-- TRENDS-INDEX -->

## 2026-11-18（[日報](../digests/2026/2026-11-18.md)）
- **最值得讀**：[The Flip Test](https://arxiv.org/abs/2611.19822)（三層反事實測試：最小對比、matched control、dense sweep；11 個影片世界模型都低於亂猜，方法可直接移植成週期任務的「第 N 下 vs 第 N+1 下」診斷）；[Robotic Reward Models 綜述 + RRM-Bench-1K](https://arxiv.org/abs/2611.20741)（27 個 reward 評估器的 dense credit 追執行時間而非任務狀態，直接支持事件驅動的計數器 reward）。
- **趨勢**：延續 11-13／11-17「世界模型評估要有對照組」，今天轉成**成對反事實**設計（Flip Test、ReactBench-AD、SciWorldBench、localized VOE）；延續 11-12 phantom progress 與 11-17 LASR 的「進度捷徑」，今天延伸到 reward model。新出現：WAM 只監督「變化量」而非完整未來（ResWAM、DiffWAM、PointWM 的 persistence 洩漏），和 11-13 的 persistence 對照是同一個現象的訓練端版本。延續 11-14 的 WAM 延遲主題（Cache or Denoise Less：少做幾步就夠，cache 意義不大）。另需注意 VAE Rhythm：生成影片有 VAE 分組造成的週期性假象，量 rollout 週期前要先排除。

## 2026-11-17（[日報](../digests/2026/2026-11-17.md)）
- **最值得讀**：[LASR](https://arxiv.org/abs/2611.17775)（latent action 讓預測變好不代表編碼了動作，可能只是狀態、進度或任務身分的捷徑；提出有正負對照的離線指標，直接關係到 A 版「latent action 線性探針」的評估寫法）；[WATO](https://arxiv.org/abs/2611.17626)（trajectory optimization 只在訓練時用，部署時 joint WAM 生成加排序，作者自報比 CEM 快 11.5 倍）。
- **趨勢**：延續 11-13「世界模型評估要有對照組」，評估對象從 rollout 擴展到 latent action 本身；LASR 把「進度」列為要排除的捷徑，呼應 11-12 的 phantom progress（但對週期任務，進度和「第幾下」本來就綁在一起，要小心）。延續 11-14 的降低 WAM 推論成本（WATO、Latent Goal Costs 都是把成本移到訓練或小 adapter）。另一條小線：從軌跡順序學進度/目標成本（Latent Goal Costs、BAL 的時間順序自監督）。
- **後續（11-18）**：LASR 的評估判斷（條件變數讓表現變好 ≠ 用到了它該有的內容，要扣掉其他來源）和我們 ESC exemplar 的 swap probe / |S|=0 / self-clip 結論同型，記在 [2611.17775-lasr.md](2611.17775-lasr.md)。

## 2026-11-14（[日報](../digests/2026/2026-11-14.md)，arXiv 標示日 11-13 的第二梯隊）
- **最值得讀**：[CGEM](https://arxiv.org/abs/2611.16386)（同一個觀測下要做不同動作，取決於任務進度：這正是週期任務「現在第幾下」的問題，計數器可以當這種 event memory；筆記見 [2611.16386-cgem.md](2611.16386-cgem.md)）；[Bind-WAM](https://arxiv.org/abs/2611.15368)（World Action Model 不必每步都想像未來，只在不確定時才呼叫，直接關係到即時性）。
- **趨勢**：「什麼時候才需要世界模型想像」與「用便宜的 verifier 或局部模型取代昂貴 rollout」開始出現，都是降低 WAM 延遲的路線（Bind-WAM、A²WM、HDH）。

## 2026-11-13（[日報](../digests/2026/2026-11-13.md)）
- **最值得讀**：[Prediction or Persistence?](https://arxiv.org/abs/2611.15082)（V-JEPA 2 的 predictor 在未來檢索上幾乎沒有貢獻，分數主要來自「未來長得像現在」；提出一次前向就能做的 persistence 對照）；[The Posterior-Prior Epistemic Gap](https://arxiv.org/abs/2611.14955)（RSSM 的想像 rollout 隨步數逐漸丟失障礙物資訊，ensemble 不確定性完全沒察覺）。
- **趨勢**：兩篇都在說「世界模型評估要有對照組、要量 rollout 隨長度的退化」，正是先導論文的論點；世界模型評估方法論本身開始成為獨立題目（另有 Driving WM 的 scene response、WM 的 action sensitivity）。

## 2026-11-12（[日報](../digests/2026/2026-11-12.md)）
- **最值得讀**：**OnlyAct**（從 V-JEPA 2 抽出不用標籤的 latent action，正面對上「latent action 從零學」的路線，也牽涉動作先驗設計）；**Is Your Robot's Memory Just a Clock?**（記憶型 VLA 在「數次數」任務上把經過的時間當成進度；直接支持「計數器當完成判斷」要用事件而非時間）。
- **趨勢**：World-Action Model 的推論延遲（MetaWAM、Elastic-WAM）成了獨立的研究主題；BEHAVIOR Challenge 第 2 名也是用 Cosmos 3 做的 WAM。

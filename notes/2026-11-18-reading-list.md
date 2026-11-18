# 2026-11-18 待讀清單（依 user 指示記下）

- 來源日報：[digests/2026/2026-11-18.md](../digests/2026/2026-11-18.md)（arXiv 標示日 2026-11-17）
- 這份是**只讀過摘要**的整理，還不是單篇深讀筆記；數字都是作者自報。要深讀時再照 [`_template.md`](_template.md) 各開一份 `<arXiv ID>-<短名>.md`。
- **Venue 規則（user 2026-11-18，已寫進每日日報的排程 prompt）**：venue 只讓論文比較容易被列入，不加星；星數仍然只代表相關度。排序加分：一線會議／期刊、它們的正式 workshop，以及二線會議／期刊本身 +0.75；二線會議的 workshop +0.5。已接受的一線論文（含其 workshop）經過審查，引用它們的數字時可以少加保留。

## 會議／期刊查核（2026-11-18）
| 論文 | 查到的 venue | 依據 | venue 加分 |
|---|---|---|---|
| The Flip Test (2611.19822) | 沒寫 | arXiv comments 只寫 project page；專案頁 flip-test.github.io 這次連不到，**待查** | 無（待查） |
| The Sense Paradigm (2611.19796) | 沒寫 | arXiv comments 只寫「11 pages, 4 figures, 4 tables」，也沒有 code 連結 | 無 |
| VAE Rhythm (2611.21114) | 沒寫 | arXiv comments 只寫頁數；專案頁 showlab.github.io/vae-rhythm 連不到，**待查** | 無（待查） |
| Robotic Reward Models (2611.20741) | 沒寫 | 專案頁連不到，**待查** | 無（待查） |
| PointWM (2611.20090) | 沒寫 | GitHub README 沒寫 venue | 無 |
| Cache or Denoise Less? (2611.19709) | CoRL 2026 **Workshop**（EEAI，honorable mention） | arXiv comments 和 GitHub README | 有（一線會議的 workshop，+0.75）；分級維持 user 指定的輔助 |
| MoViC (2611.19998) | 沒寫 | arXiv comments 只寫頁數；專案頁連不到，**待查** | 無（待查） |

結論：只有 Cache or Denoise Less?（CoRL workshop）有 venue 加分。venue 只影響論文能不能被列入，不改變 user 指定的分級，所以它仍在輔助（放在第一位，標 🏛️）。其餘 6 篇沒有查到 venue。github.io 專案頁這次都連不到，四篇的 venue 之後要再補查。
同一份日報裡**有寫正式 venue** 的只有三篇，都沒在下面的清單裡：[RETR](https://arxiv.org/abs/2611.19358)（event 相機 3D 車道偵測，NeurIPS 2026）、[SGIP](https://arxiv.org/abs/2611.20076)（場景感知人體動作預測，NeurIPS 2026）、[Measuring Coherence in Predictive Models](https://arxiv.org/abs/2611.20325)（NeurIPS 2026）。它們有 venue 加分（+0.75），但加分只影響能不能被列入；要不要加進清單由 user 決定（相關度：RETR、SGIP 屬 event／pose 支線，Measuring Coherence 和世界模型只是間接相關）。

---

## 主讀

### 1. [The Flip Test: Video World Models Fail to Learn the World State](https://arxiv.org/abs/2611.19822)
- 一句話：三層反事實測試（視覺最小對比 → matched control → dense sweep），11 個影片世界模型最好的 pair accuracy 18.3%，低於亂猜的 25%。
- 為什麼讀：先導論文「開源世界模型診斷」的方法論範本。可以移植成週期任務的版本，例如在「第 N 下 vs 第 N+1 下」「再擦一下 vs 停下」的邊界上測。
- 差異點：它測的是單一離散事件的狀態，沒有測週期或次數。
- 深讀時要查：VLM 和 coding agent 對照組是怎麼設計的？sweep 曲線怎麼量化？用了哪些開源模型（可能和先導論文的診斷對象重疊）？

### 2. [The Sense Paradigm for World Models](https://arxiv.org/abs/2611.19796)
- 一句話：在有向距離 d(x→y)=Σ ReLU(y_i − x_i) 上用一個 cross-entropy loss 取代所有防 collapse 機制。偵測不可逆轉移的 AUC 是 0.95–1.00，LeWorldModel 是 0.39–0.59；TwoRoom 規劃成功率 100%，LeWorldModel 是 91%。
- 為什麼讀：給 latent 一個有意義的距離。週期動作會回到同一個狀態，可以用「每個週期在 latent 裡是否閉環」量週期一致性，不用解碼像素。另外，它是 JEPA / LeWorldModel 線的新 baseline。
- 待驗證的想法（假說）：週期 rollout 的 d(x_t → x_{t+T}) 是否接近 0？漂移是否表現為每個週期的殘差累積？
- 單一作者、沒有 code、沒有 venue，要讀全文確認實驗規模。

### 3. [VAE Rhythm: Temporal Decoding Traces for AI-Generated Video Detection](https://arxiv.org/abs/2611.21114) ⟶ **請 sparse session 有空時看一次**
- 一句話：3D causal VAE 把連續幀分組解碼，生成幀的保真度會隨組內位置週期性起伏。作者提出不用訓練的 phase scan：從不同的起始偏移重建，再量重建誤差隨偏移變化的週期性。
- 對世界模型線：量生成 rollout 的週期之前，先排除 VAE 分組造成的假週期（research_rules §4）。

#### 給 sparse（rep-DETR）session 的交接
以下都是**假說**，還沒驗證，只根據摘要提出：
1. **相位/偏移掃描當混疊（aliasing）診斷**：phase scan 的核心是「同一段影片換起始偏移，看輸出是否週期性變動」。sparse 模型可以做同樣的檢查：取樣的起始偏移每次移一格 token，看預測次數和 rep 邊界是否隨偏移起伏。起伏大就表示取樣步長接近動作週期，可能發生混疊。這是零訓練、最便宜的對照，也接上碩論備忘裡「頻率自適應稀疏取樣（Nyquist-aware budget）」的想法（`context/memory/project_thesis.md`）。
2. **編碼器的時間分組假象**：VAE Rhythm 的現象來自「把連續幀分組編碼」。如果我們的 video token 也是按 tubelet 或固定時間塊切的（ESC 用的編碼器的 tubelet 設定要回原始碼查，**待查**），sparse query 可能鎖定在分組邊界上。檢查方法：rep-DETR 預測的邊界位置對 tubelet 長度取餘數，看分布是否不均勻。
3. **反向用法**：如果 1 的掃描能穩定反映週期，它也可以當不用訓練的週期先驗，替 sparse query 的初始化或 budget 分配提供依據。這要先在 RepCount val 上確認，不能直接用在 test。
- 開始前要確認：sparse 的數字是在修正後的新 tokens 上（見 `context/memory/project_revisiting_esc.md` 2026-11-10 條）。

---

## 輔助（需要時再讀）

| 論文 | 用途 |
|---|---|
| [Cache or Denoise Less?](https://arxiv.org/abs/2611.19709) 🏛️ CoRL 2026 EEAI workshop | B 版即時性：在 Fast-WAM 上，2 步 denoise 的成功率和 10 步差不到 2 個百分點，延遲從 202 ms 降到 92 ms；cache 最多只省 11–14%。附延遲實驗 checklist。Code：https://github.com/gabhinav001/cache-or-denoise-less |
| [Robotic Reward Models in the Foundation-Model Era](https://arxiv.org/abs/2611.20741) | 計數器當 reward 的佐證：27 個 reward 評估器的 dense credit 追的是時間，不是任務狀態。RRM-Bench-1K 的對照組設計和 RRM-Hub 可以拿來評估計數 reward。五類分法可以當第 8 節「RL 用什麼 reward」的比較框架。 |
| [Latent World Modeling for Point-Cloud Video Pretraining (PointWM)](https://arxiv.org/abs/2611.20090) | 兩個用處：(1) persistence 洩漏與「複製最後一幀」baseline；(2) 點雲上的無標註 latent action，可以當 event-ESC 點雲原生路線的參考。Code：https://github.com/InitalZ/PointWM |
| [MoViC](https://arxiv.org/abs/2611.19998) | 單目影片 → humanoid 控制。用頻域動作表示提供時間上下文，用外插把 10 Hz 感知接到 50 Hz 控制、非同步執行。對應 P2（pose 與 proprioception）和 B 版即時性。 |

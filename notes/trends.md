# 研究脈絡摘要（每日重點與趨勢）

每份日報「今日重點」的研究摘要都收在這裡：當天最值得讀的論文，以及看得出來的趨勢。最新的放最上面。
這裡是**當天的判斷**，不是驗證過的結論；被後續論文推翻或修正時，在該條目下補一行「後續：」。
個別論文的深入筆記在同資料夾的 `<arXiv ID>-<短名>.md`。

<!-- TRENDS-INDEX -->

## 2026-11-27（[日報](../digests/2026/2026-11-27.md)）
- **最值得讀**：[Was the Model Given the Right Action?](https://arxiv.org/abs/2611.34739)（NWM 的訓練和 rollout 程式碼有三處動作編碼差異，只修輸入預測誤差就降 42%、checkpoint 排名改變；先導論文量開源世界模型前必須先做動作介面檢查，和 fps bug 同一個教訓）；[WorldReforge](https://arxiv.org/abs/2611.33925)（5 個 action-conditioned 機器人世界模型的物體運動誤差最多只比「複製第一幀」低 10.4%，兩個更差；週期量測要放靜止與重播 baseline）。
- **趨勢**：延續 11-19 RWM 稽核與 11-20／11-25「世界模型有沒有用到動作」，今天轉到**評估管線本身的正確性**（NWM 動作介面稽核），以及延續 11-13／11-25 的 persistence 對照（WorldReforge 的複製第一幀 baseline）。延續 11-21／11-24／11-25 planner 失敗歸因：Graph Anchors 用排序測試分出「遠距離失去方向」和「距離偏向手臂」兩種失敗。新出現：LeWM 成為標準 baseline（Graph Anchors、CARE-WM、NFWM、JEPA vs RSSM 不確定性同日出現），JEPA vs RSSM 研究指出 recurrent update 會平均掉短暫變化，可當「RSSM rollout 掉次數」的結構性假說。延續 11-26 Agent-State LAM「latent action 要去掉外觀」：FreshVLA 用 high-pass 與頻域正則把 latent action 拆成任務進度和執行動態，並報告連續碼勝過階層離散碼（和 HoloBrain-0.5 的 FSQ 較好相反，VQ 路線證據分歧）。延續 11-25 Entangle／11-26 Any2Act 的示範指定任務：CoWM 是一週內第三篇，只估 phase 不估次數，計數器的空位還在。修正 11-24 FlowScope「3D 比 2D 好」：PhysReader 顯示 3D 提升的 tracklet 模擬最準、真實最差，關鍵在兩個領域量得一致；感測深度的缺值比雜訊更傷 policy。RAC：CoDiCount 從 codec 運動向量讀幀間的重複次數，直接碰到碩論的頻率牆問題。延續 11-14 延遲主題（ShowNow 620→208 ms）與 11-25 SWEEP-Bench 示範速度（RePace）。

## 2026-11-26（[日報](../digests/2026/2026-11-26.md)）
- **最值得讀**：[Agent-State LAM](https://arxiv.org/abs/2611.32017)（latent action 會被背景與固定外觀污染，先學只留代理人物理狀態的表徵再推 latent action；和 P2 `z = [z_pose | z_res]` 同動機，差在它自監督學狀態、我用關節角度，有 code 可當 baseline）；[Any2Act](https://arxiv.org/abs/2611.32353)（單一示範含人體影片指定沒看過的任務，加不需訓練的示範進度 tracker；「exemplar 指定做什麼」加「進度判斷」被做了一部分，只差次數，週期任務會讓 tracker 遇到 aliasing，🚩）。
- **趨勢**：延續 11-24／11-25「動作表徵要錨在代理人狀態或結構上」，今天是學出來的結構（Agent-State LAM 的 agent state、RELACT 的關係表徵、FactorWorld 的代理人／外部動態分離），P2 的差異要落在「外部可驗證的關節狀態」和週期先驗。延續 11-20／11-21／11-25「世界模型是否真的用到條件」：SimPWM 凍結模擬物體（LTX-2.3 從手臂動作推斷結果，另一種捷徑）、ReCast 指出 occupancy 世界模型每場景只有一條軌跡所以學到場景與軌跡的相關性、CIA 用對比辨識動作取代 inverse 回歸。延續 11-25 Entangle 的示範指定任務：Any2Act、G0.7 影片條件化 ICL，空位持續縮小。延續 11-14 WAM 延遲主題且數字明顯下降：FoveaWAM 15 ms、LeanWAM 25 ms、G0.7 60 ms，FoveaWAM 的 OnTimeBench 和 Roboclock 都改成「推論時場景照走」的評估，延續 11-24 RoboDyna。延續 11-13 persistence 對照：SPAR 用重複自身幀的靜態片段當內容匹配參考。延續 11-21／11-24 planner 失敗歸因：CriticJEPA 指出世界模型適合挑選而非梯度最佳化。pose 端：影片模型的動作已被用 3D 骨架評估（Video Models are Excellent Motion Models），但沒有週期與次數，P1 空位還在。

## 2026-11-25（[日報](../digests/2026/2026-11-25.md)）
- **最值得讀**：[DexLatentWorld](https://arxiv.org/abs/2611.30907)（從重定向人手示範的點雲學跨 embodiment 的 3D latent action，並直接拿 latent action 空間做 MPC；P2 在 3D 側最直接的對手，差異在影片估計的身體關節與週期先驗，🚩）；[Entangle](https://arxiv.org/abs/2611.28732)（一段人體影片當 context 指定任務的 WAM，摘要中沒有語言，用 intra-task 對比目標防止任務身分捷徑；「exemplar 指定做什麼」的空位被占一部分，剩下「計數器判斷做完沒」，🚩）。
- **趨勢**：延續 11-24 的「動作表徵錨在幾何或身體運動」（DexLatentWorld 3D 點雲、ζ₀ 預測實測關節軌跡、MotionPort 依運動相似度組織身體運動 latent）。延續 11-12 OnlyAct／11-21 O²LaF：Native LAM 是第三篇「預訓練影片模型本身就是 latent action 模型」，A 版從零訓的理由要寫清楚。延續 11-19 RWM 稽核與 Rhythm 的 VAE 對照：DriveOddsBench 預先登記，真實未來也先過 autoencoder 再量。延續 11-20／11-21「世界模型有沒有用到動作」：Fork-JEPA 證明行為資料下動作響應不可辨識。延續 11-21／11-24 planner 失敗歸因：同狀態排序才是關鍵（Detecting Is Not Choosing、DAS、MotionPort）。新出現：policy 回歸示範平均速度（SWEEP-Bench），和 11-19 相機高度回歸同型，對週期任務即「頻率被拉回訓練平均」，可直接當先導假說。persistence 有一個反向例子：4D occupancy 世界模型輸在「記不住不變的部分」（PersistWorld），和 11-13 的 persistence 虛高要分開看。延續 11-14 的 WAM 延遲主題（SANA-Robot 30 Hz、VITA-WAM、DelayOPSD、JEPA-Tuner）。

## 2026-11-24（[日報](../digests/2026/2026-11-24.md)）
- **最值得讀**：[EgoLAM](https://arxiv.org/abs/2611.27290)（用實測手腕運動監督 latent action 碼、相機運動另給 forward model；等於先驗 (1)「碼回歸身體運動」的手部版，差異只剩影片估計 pose 和週期先驗，🚩）；[FlowScope](https://arxiv.org/abs/2611.26865)（無標籤立體影片預測公制 3D scene flow 預訓練 ACT，受控比較中 kinematics、2D tracks、scale-free 3D 都較弱，回答「動作預訓練該在 2D 還是 3D」）。
- **趨勢**：新出現且一次三篇：**動作表徵錨定在幾何或身體運動上**（EgoLAM 手腕、Ego4Gen 4D 點雲與 scene flow 並宣稱 OOD 勝過 latent action、FlowScope 公制 3D flow；另有 Mind World Models 用 EEG），延續並強化 11-19 JointGV／BSP 的結構先驗線，我的先驗 (1) 空位在縮小，差異要落在「影片估計的全身關節」和「重複動作對應重複碼」。延續 11-21 planner 失敗歸因：Round-Trip Check 顯示 CEM 越優化越像在找世界模型的對抗樣本；延續 11-19 RWM 稽核的「learned simulator 的訊號要驗證」，今天是 RL 梯度可信度（Trust What Repeats：梯度越大越不在模擬器兌現）。延續 11-14／11-18 的 WAM 延遲主題（ReActWAM、Trailblazer-F），RoboDyna 補上「延遲翻轉個別 episode 但平均幾乎不變」。另有 categorical 世界模型 rollout validity 較好的受控證據，支持 VQ 路線。

## 2026-11-21（[日報](../digests/2026/2026-11-21.md)）
- **最值得讀**：[O²LaF](https://arxiv.org/abs/2611.26617)（inverse 和 forward dynamics 都從同一個預訓練 video DiT 初始化，從無標籤影片學 latent action，也能換 V-JEPA 2 當先驗；和 11-12 OnlyAct 同向，挑戰 A 版「從零訓練 latent action」的路線）；[Physical Laws without Physics Loss?](https://arxiv.org/abs/2611.25626)（用週期激振的受迫響應測影片世界模型是否學到共振與非線性 softening，和先導論文的週期量尺很接近，🚩）。
- **趨勢**：延續 11-13～11-20「世界模型評估要有對照組」，今天轉到 planner 失敗歸因：Search or Scoring（同一 cost 在真實結果 AUROC 0.94、在預測上 0.54）、Stuck in Place（JEPA planner ≥96% 失敗是物體不動但模型預測有進展，延續 11-12 phantom progress 到 planning 端）。延續 11-20 的「世界模型是否真的用到動作」，今天出現訓練端解法（AFFECT 對齊動作擾動的反應分布，世界模型內外成功率相關 0.47→0.79）。延續 11-13 persistence 主題：Kernel Physics-IQ 指出單一參考比較會獎勵「生成結果變化變少、甚至停住」。延續 11-20 的「預訓練影片模型當 latent action 先驗」（O²LaF；11-20 DiWALI 則是從零學）。空間端兩篇都支持「動態放在 3D／結構空間預測」（Point Dynamics proxy、MoRE）。無語言即時 VA 在自駕出現一例（BADAS-3.0，1B、<50 ms），但不是世界模型。

## 2026-11-20（[日報](../digests/2026/2026-11-20.md)）
- **最值得讀**：[DiWALI](https://arxiv.org/abs/2611.24836)（inverse dynamics 從人和機器人 play 推 latent action、訓世界模型、在想像中 RL 改進 diffusion policy；是合體版少了動作先驗、exemplar 和計數器的版本，主力論文要正面區分）；[StrideWorld](https://arxiv.org/abs/2611.24408)（用模型自己前幾步量出的 stride 當評估前就固定的參考，檢查後續步驟；和「用前幾下週期檢查後續 rollout」同型，🚩）。
- **趨勢**：延續 11-13～11-19「世界模型評估要有對照組」，今天新增兩種做法：action intervention 加無動作輸入的對照（Does the Action Matter，呼應 11-17 LASR），以及用 siblings 校正結果頻率（SibPO）。延續 11-19 RWM 稽核的「one-step 好不代表 rollout 好」（Reconstruction vs. Prediction：AE 的 one-step 較好，V-JEPA 的 rollout 誤差較小）。新出現：凍結 DINO／V-JEPA 特徵距離幾乎不追蹤任務進度（DOCK，rank corr ≤ 0.11），用特徵差當週期量尺前要先驗證。延續 11-14／11-19 的延遲與語言分層主題（SWIFT 慢世界快動作的非同步架構；DRIFT 拿掉 LM 不掉分）。pose 端：手工 keypoint 統計打贏自監督行為 encoder，支持 Track B 關節角度 baseline。

## 2026-11-19（[日報](../digests/2026/2026-11-19.md)）
- **最值得讀**：[Auditing RWM on ANYmal D](https://arxiv.org/abs/2611.23118)（逐位元重建 learned simulator 後預先登記測試：one-step 準確度誤判設計、ensemble 1σ 只覆蓋 4.6%、預測更準的 simulator 有 13/18 訓出失敗 policy；這是先導論文方法論的範本，也是競爭）；[Every Camera Grows Up](https://arxiv.org/abs/2611.21782)（6 個互動影片世界模型 rollout 時相機高度被以人為中心的資料先驗拉回人眼高度，「rollout 往常見先驗回歸」的設計可以移植到週期頻率）。
- **趨勢**：延續 11-13／11-17／11-18「世界模型評估要對準 rollout 與決策、要有對照組」，今天再補兩篇：RWM 稽核、CURE（畫質無法分辨好決策）。新出現：用關節或結構狀態修正 rollout 漂移（JointGV，測在 Cheetah 和 Walker 的週期步態上），以及運動學樹當 VA 介面（BSP），兩者都逼近我的「動作結構先驗」論點，要盯。延續 11-18 的 VAE 週期假象（Rhythm of Generated Video：bitstream 的 4／8 幀脈衝），量 rollout 週期前必須先排除。延續 11-14 的 WAM 延遲主題（APM 少步蒸餾、AR-WAM single-pass）。pose 當 WAM 動作介面又一個弱結果（EgoHandWAM），支持 pose 當先驗或量尺的定位。
- **後續（11-20，user 判斷）**：JointGV 和 A 版有差距（結構來自外部標註的 scene graph，是外掛修正器，不是 latent action 先驗），降為 related work，紀錄在 [2611.22543-jointgv.md](2611.22543-jointgv.md)。Rhythm of Generated Video 全文顯示週期在**不經編碼器的 frame-difference energy 裡就有**（等同 motion energy），橋接實驗前必須先做 VAE／tokenizer 往返對照，步驟在 [2611.22996-rhythm-bitstream.md](2611.22996-rhythm-bitstream.md)。

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

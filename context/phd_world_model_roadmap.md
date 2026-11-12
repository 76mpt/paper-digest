# 博士方向路線：世界模型 / Vision-Action（2026-10-13 session 整理）

背景：碩士論文 = Repetitive Action Counting（ESC 基底，Track A 外觀高頻改良 + Track B motion-exemplar）。
博士目標 = 世界模型或多模態 vision-action 模型，**不做 VLA**（語言拖累）。博士要求兩篇論文，目標 CVPR，兩篇可一先導一主力。

---

## 1. 領域地圖（2026 年 10 月）

世界模型分三條線，加一座橋：

| 陣營 | 代表 | 在做什麼 | 學生能不能碰 |
|---|---|---|---|
| 像素生成派 | Sora、Veo、Cosmos 3（omnimodal）、Genie 3（Waymo 2026-02 拿去做自駕模擬） | 直接生成未來畫面；可互動但物理不穩、規劃太貴 | 正面打不過，要懂 |
| 潛在表徵預測派 | JEPA 系列：V-JEPA 2、LeWorldModel（2026-03，像素端到端穩定訓練） | 不生成像素只預測表徵；算力需求低 | 學術空間最大 |
| 空間智慧派 | World Labs **Atlas**（2026-09-01）、Marble | 幾張照片重建可走動 3D 場景、相機軌跡控制影片 | 3D 資料+算力，不碰 |
| **橋：World-Action Model / latent action** | Genie（2024）→ LAPA（ICLR 2025）→ **arXiv 2509.18428**（DreamerV3 架構、**50M 參數**無標籤預訓練贏有標籤）→ 2026 爆量：Mixture of Latent Actions、Motus（CVPR 2026）、DreamDojo、LeapBot-WA | 從影片相鄰幀學離散動作碼，**不需動作標籤也不需語言** | **我的主戰場**：剛好繞過語言、接影片時序背景、50M 等級做得動 |

**Atlas 的誠實評估**：「少數圖片生成完整場景」是真突破（重建+生成+相機控制一個模型統一）；「物理還原突破」證據撐不起：公司自報、早期存取無外部重現、剛體/關節/可變形物體在自家路線圖列 Phase 2 未做、匯出碰撞網格官方說是粗略用、機器人跑一小時 demo 是幾何夠真不撞牆而非物理互動夠真。2026-08 survey（arXiv 2608.23070）：現在的世界模型提供「看起來合理」不是「物理正確」。人類偏好 75–94% 量的是看起來對。→ **動態物理與時序一致性仍是宣稱大於驗證 = 我的切入缺口**。

**閱讀順序**：Ha & Schmidhuber 2018 → DreamerV3（2301.04104）→ Genie 2024 → V-JEPA 2 → LAPA → 2509.18428 → WAM tutorial（2607.00836）→ World Models and World-Action Models survey（2026）。追新用 GitHub awesome-vla-wam。

**算力參考**：DreamerV3 Procgen 一組 ≈16 GPU-day、Minecraft ≈9 GPU-day。開源可用：MineWorld（即時 Minecraft 世界模型，含 action-following 指標）、OpenDreamer（2026-07 Dreamer 4 JAX 重現）、LoopNav（空間一致性 benchmark）。

---

## 2. 從 RAC 接到世界模型的角度

RAC 本質是學「影片時序結構」：週期性、temporal self-similarity、長時間一致性。世界模型最弱的正是這裡（LoopNav 測繞一圈回來是否一致、MineWorld 另設 action-following 指標 = 「時序一致性怎麼量怎麼學」是開放問題）。

**博士切入點：世界模型與 latent action 的時序結構**。latent action 碼在週期性動作上是否穩定重複、長序列 rollout 動態是否漂移、週期性先驗能否當 latent action 預訓練的自監督訊號。

**可轉移的資產**（計畫書第一段要講的差異點）：
- 評估方法論：同 checkpoint on/off 歸因、paired bootstrap + Wilcoxon、抓出 warm-start generic 效應汙染子集顯著性、val 選超參不偷看 test、事前註冊決策樹。世界模型領域評估最弱，統計紀律是賣點。
- 時序/頻率分析：Nyquist 分析、motion energy 頻譜、C1 局部頻率頭 r=0.80、「辨識 vs 表達」診斷 → 對口「rollout 動態漂移」。
- 工程：FiLM/cross-attn 注入、DETR 式 set prediction、WiSE-FT 合併、from-scratch 200ep 兩張 4090 管線、VideoMAE token 快取。
- 概念橋：**exemplar 當動作先驗條件化計數 ≈ latent action 當動作先驗條件化預測**，同一想法兩面。Track B 關節角度軌跡 = 現成「真實動作空間」，可當 latent action 對照組。

---

## 3. 先導論文 vs CVPR 論文要做到什麼程度

### 先導論文
標準 = 拿一個現成開源模型，用嚴謹量測找出別人沒說清楚的失敗模式，再給小修正。**不需要贏 SOTA**，要三樣：可量化的現象、第二篇能沿用的工具、一句能引用的結論。Venue：workshop / WACV / arXiv 都可。

用 ESC 改良對照「什麼算、什麼不算」：
- **算**：C1 證明 token 有高頻資訊但 density map 表達不出、Nyquist 分析、warm-start 混淆發現（現象+結論）。
- **不算主體**：caON hf20 的 31% 改善，單獨只是 specialist，審稿人會問 overall。
- → ESC 改良能當先導是**因為帶著診斷**；只有改良數字連先導都撐不住。

世界模型版先導：拿 MineWorld / V-JEPA 2，證明「rollout 超過某長度週期性動作週期漂移、FVD 類指標看不出」，給指標+小修正。

### CVPR 論文
四項同時成立：問題有新框架（不是舊問題加模組）、≥2 benchmark 一致提升或新 benchmark+洞見、消融答「為什麼有效」、一張超出小圈子的圖。

**A+B 混合能不能上 CVPR：分界線不在有沒有混，在混合後有沒有產生 A、B 單獨都沒有的能力，且能證明為什麼。**

MoCount + exemplar 兩種寫法命運不同：
- 「MoCount 骨幹加 ESC exemplar 模組，RepCount 0.174→0.16」= A+B，拒。貢獻可拆、無新能力、不答問題。
- 「exemplar 在 motion 空間比外觀空間更不變 → 類別無關計數第一次逼近用 GT 類別的 SOTA，且跨資料集 zero-shot 贏」= 假設檢驗，A+B 只是手段。新能力 = 不用類別標籤達到有類別標籤水準；證據 = few-shot 樣本效率曲線 + UCFRep zero-shot。**貢獻不可拆**（拿掉 motion 空間不變性消失、拿掉 exemplar 類別無關性消失）→ 可拚。

世界模型領域更嚴（大廠每月出組合模型，Cosmos 3 已全模態混）。學生 A+B 唯一活路：組合是為了回答一個大廠不會做的小問題。

**模板對照**：

| | RAC 版本 | 世界模型版本 |
|---|---|---|
| 先導 | ESC 診斷：token 有高頻，density 表達不出 | 開源世界模型診斷：rollout 週期漂移，現有指標看不出 |
| 先導工具 | 分位分析、on/off 歸因、頻譜估計 | 同一套 + 計數器當量尺 |
| CVPR 假設 | exemplar 在 motion 空間更不變 | motion 結構先驗讓 latent action 更省資料、rollout 更穩 |
| CVPR 新能力 | 類別無關逼近有類別 SOTA | 長程一致性，小模型達大模型穩定度 |
| A+B 陷阱 | 「MoCount 加 exemplar 數字變好」 | 「JEPA 加 latent action 數字變好」 |

---

## 3.5 主力論文預想（2026-10-23，user 更正後）

**兩條都保留，尚未定**：(A) 世界模型為主、VA 當下游評估；(B) 端到端 VA（不含語言），平台 = 機械手臂或移動機器人（非人形），模擬器或實機靠合作。**目標 = 頂會/頂刊，不限 CVPR**（CVPR/ICCV/CoRL/RSS/T-RO/TPAMI 皆可）。
**user 判斷（採用）**：VA 不窄。現在多數是 VLA，但趨勢在減少 L，因為語言骨幹拖慢推論、即時控制受限。佐證：即時性是目前核心工程瓶頸（10 億參數模型在 RTX 5090 上一次前向 50–135 ms，超過 30 Hz 的 33 ms 控制週期）；video-action / world-action 模型興起（LingBot-VA，RSS 2026；Native Video-Action Pretraining，arXiv 2607.08639；FLUX 3 Action）。⚠️ 一次搜尋沒找到明確「完全無語言」的代表作，LingBot-VA 2.0 仍用凍結語言模型 cross-attn → 「無語言、即時」本身可能就是空位。

**共同核心（A、B 都用）**：LAPA/Genie 式 latent action（inverse dynamics → VQ 動作碼 → forward dynamics）+ 兩個訓練時先驗：(1) 碼回歸關節角度變化量（MediaPipe，Track B 現成）；(2) 重複動作對應重複碼（碼序列 self-similarity，RAC 週期知識）。

**版本 A（世界模型為主）**：問題 = 長 rollout 週期性動態漂移、FVD 看不出。評估：先導的週期一致性指標、latent action 線性探針（Procgen/Minecraft 真動作）、少標註 BC 樣本效率曲線、FVD。50M～300M、兩張 4090 可做。不需合作。

**版本 B（端到端 VA，無語言）**：人體影片 + 機器人影片做 latent action 預訓練 → 少量機器人示範微調成 policy（action chunking / 非同步推論做即時）。賣點 = **不靠語言也能泛化 + 即時**：動作結構先驗取代語言提供的任務語意，推論只跑視覺與動作。評估：任務成功率（模擬器如 LIBERO/ManiSkill 類的手臂任務，或移動導航）、控制頻率與延遲、少示範樣本效率、對外觀變化（光照/背景/物體外觀）的穩健性（延續 Track B「motion 空間更不變」命題）。需要合作方提供模擬器或手臂/移動平台。
⚠️ 要先確認：無語言時「做哪個任務」怎麼指定（goal image、示範影片當 exemplar、或單任務 policy）。**示範影片當 exemplar 指定任務 = Track B 的 exemplar 概念直接延伸**，是很自然的設計。

**不可拆性**：拿掉動作先驗 → 漂移/泛化退化；拿掉 latent action → 無法用人體影片預訓練；B 版再加：拿掉 exemplar 任務指定 → 回到需要語言。
**RAC 資產接點**：計數器當量尺、MediaPipe 關節角度管線、exemplar 條件化經驗、on/off 歸因與統計檢定、頻譜分析。

### 產業佐證：自駕去 VLA（2026-10-23）
- user 轉述中國自駕公司資深 RD：實務幾乎不用 VLA（內部訊息，不可引用）。
- 公開來源：華為靳玉志「不走 VLA 路線，WA 才是自動駕駛終極方案」；ADS 4 的 **WEWA** = 雲端 World Engine + 車端 World Action（36Kr）。小鵬 VLA 2.0（2025-11）走「視覺→隱式表徵→動作」，去掉顯式語言轉譯但文字仍 token 化；2026-04 X-World 報告用生成式世界模型做閉環仿真、線上 RL、模型評估。理想仍走 VLA。
- **含義**：WEWA 就是「世界模型當訓練與評估引擎 + VA 當部署 policy」，等於 A、B 兩版合體。動機段可寫「學術以 VLA 為主，產業已轉向無顯式語言的 world-action 架構」。自駕可列為 B 版平台候選（NAVSIM、Bench2Drive、CARLA 類 benchmark），需合作。
- 來源：https://www.36kr.com/p/3441062507550088 ；https://m.huxiu.com/article/4823626.html ；https://www.ofweek.com/auto/2026-08/ART-70109-11000-30699280.html ；https://blog.csdn.net/CV_Autobot/article/details/155106902

### 自有資料庫 / 實體實驗的策略（2026-10-23）
- **會容易一些，原因是評審重點改變**：從「有沒有贏 SOTA」轉到「有沒有別人做不到的東西」。大廠能用算力碾模型，碾不過他們沒有的資料 = 學生最有效的護城河。
- **自有資料庫**：有專門會場（NeurIPS Datasets & Benchmarks、CVPR benchmark 論文），長期被引用、降低方法新穎度要求。門檻：填補真實缺口、附 baseline 與洞見、能公開釋出並維護。只有資料沒洞見，CVPR 主會一樣拒。
- **實體實驗**：CoRL/RSS/T-RO 幾乎必要（只做模擬會被質疑）= 入場券非加分；CVPR 的世界模型論文不強制，有就是差異化。
- **最划算 = 做評估集，不做訓練集**：訓練世界模型的資料量學生收不起，評估 benchmark 幾千段就夠。缺口天然存在（週期性/重複動作長程一致性沒有專門的世界模型 benchmark）；標註能力現成（RepCount 式 rep 邊界、MediaPipe 關節角度、計數器當量尺）；可接實體（合作方手臂錄週期性操作：擦拭、攪拌、鎖螺絲、鋸 + 對應人體示範影片 → 同時服務 A 版評估與 B 版「示範影片當 exemplar 指定任務」）。
- **建議結構**：先導 = benchmark + 指標（週期動態資料集 + 計數器一致性指標 + 開源世界模型系統性診斷），投 NeurIPS D&B 或 CVPR，比單做診斷更紮實。主力 = 方法 + 自家 benchmark 驗證 + 合作方真機或高擬真模擬，依 A/B 版投 CVPR 或 CoRL。
- **三個要提早處理的風險**：(1) 錄真人需 IRB 與受試者同意，否則不能公開，提早幾個月啟動；(2) 硬體取決於合作方，先確認平台與可用時間，別讓主力論文卡在別人排程；(3) 錄影+標註+清理要好幾個月 → 碩士收尾後就開始，與 50M 重現實驗並行。

### WA 往 RL 走的趨勢（2026-10-23）
- **配方收斂**：模仿學習預訓練 policy → 在世界模型裡做 RL 後訓練。世界模型 = 學出來的模擬器，VA = policy，RL = 把兩者接起來。
- **機器人端**：World4RL（arXiv 2509.19080，凍結 diffusion 世界模型當高擬真模擬器精修操作 policy）、WMPO（arXiv 2511.09515，主張像素空間 rollout 有優勢）、WoVR（arXiv 2602.13977，世界模型當可靠模擬器做 VLA 的 RL 後訓練）、WISE（arXiv 2609.03681，排程想像 rollout 提效率）、RehearseVLA / World-Env（世界模型提供 reward 與終止判斷）。Survey：arXiv 2606.00113、2609.16074（World-Action Models）。追新：OpenMOSS/Awesome-WAM。⚠️ 部分 arXiv 編號在不同來源不一致，引用前查原頁。
- **自駕端**：報導稱 2026 年「世界模型 + 強化學習」已是頭部智駕標準配置。地平線 HSD V2.0 世界模型 + 端到端 RL（自稱無接管里程 +56%）；蔚來 1 月推世界模型 + 閉環 RL、6 月加 SFT 成三段式；WorldEngine（港大 OpenDriveLab + 華為 + NVIDIA）從實車日誌找長尾、重建成可互動神經環境、生成對抗場景、RL 後訓練；小鵬 X-World 閉環仿真 + 線上 RL；Tesla 神經世界模擬器；Waymo World Model。
- **學生可切的開放問題**：(1) 世界模型當模擬器的可靠度：RL 會鑽世界模型的錯誤（hallucination exploitation）；(2) 世界模型給 reward 與終止訊號；(3) 長程一致性：世界模型在重複動態上漂移，RL 做週期性任務（擦拭、鎖螺絲）就會鑽這個漂移。
- **RAC 接點（新）**：**計數器 = 週期性任務的 reward / 終止模型**（「擦 5 下」= 數到 5 就完成）；exemplar 示範影片指定任務、計數器判斷完成，兩者合起來不需要語言。先導 benchmark 的一致性指標同時量「世界模型夠不夠格當 RL 模擬器」。
- **技能缺口更新**：RL 從「讀得懂 Dreamer 就好」升級為核心技能（policy gradient、PPO/GRPO 類後訓練、model-based RL）。

---

## 4. RAC 現況（2026-10-13）與收尾建議（詳見 memory submission-strategy / aux-bpm-milestone）

RepCount test MAE 標尺：MoCount（GT 類別 embedding）0.174 / ESC 論文（0-shot, TTA K=4）0.213 / MoCount 拿掉類別 0.280 / control 0.2389（統一 gt 0.2404）/ bdls 0.2273 / caON 0.2398 / route12 0.2130。**全部 overall 不顯著**；caON hf20 0.215→0.148 顯著但 Q1 最差；mrate 的 overall 增益是 3–5 部 gt≤2 慢影片的校準假象。dense-T 六組全滅、FFT gating 全 no-op、路由估計器到頂。rep-DETR run 1 val 0.524（caON ≈0.28）兩倍差，run 2 加 count loss 是唯一判決實驗。Track B 零結果（Phase 0 通過，Phase 1 抽取 3.8h CPU 未做）。

**建議（單一路線）**：
1. 本月：三個探針（rest-mass / temporal mixer / cattn_relpos，判準 = caON Q1 救回 control 而 hf20 不掉）跑完鎖 Track A，不開新變體。補 **ESC time-shift TTA |K|=4**、**UCFRep zero-shot**、**gt≤2 排除穩健性表**，寫先導論文（WACV/ACCV 等級，CVPR workshop 穩）。rep-DETR run 2 看一眼封存（<0.3 才談）。
2. 11 月起 Track B：Phase 1 抽 1041 部 MediaPipe；模型復用 ESC exemplar cross-attn + density head，輸入換關節角度；from-scratch 200ep ≈33h/組；先出 0-shot RepCount + UCFRep zero-shot。CVPR 版四件事：類別無關明顯贏 0.280 並逼近 0.174、UCFRep zero-shot 贏 ESC 與 MoCount 0.1697、few-shot 曲線（`--test_shots` 已加）、pose 失效（bench_pressing）graceful degradation。碩論「0.19–0.21 近 SOTA」夠碩論不夠 CVPR。
3. 兩篇串起的故事：外觀 token 有頻率上限且 density 輸出裝不下 → motion 空間 headroom 高、exemplar 更不變。Track A 證前半，Track B 證後半。

---

## 5. 博士申請包：三層

**第一層：碩論收乾淨，不需要 CVPR**。Track A + Track B 合成一篇，WACV/ACCV 夠，ICCV 更好。Track B 一定要有數字（它是和 latent action 的唯一概念橋）。

**第二層：橋接實驗（申請時真正的差異點）**：用計數器（control/caON）+ motion energy 頻譜當量尺，測 MineWorld / OpenDreamer / Cosmos-Predict2.5 小版 / V-JEPA 2 rollout 週期性動作：週期漂移、次數掉落、漂移 vs rollout 長度、Q1–Q4 誰先崩。零訓練、工具現成、兩張 4090 推論。產出 workshop/arXiv + 計畫書一張圖。證明：碰過世界模型、有別人沒有的量尺、題目有具體起點。

**第三層：補三塊 RAC 沒覆蓋的**（memory: phd-world-model-prep）：
1. 訓練生成模型（從沒訓過 diffusion/flow matching/AR video）→ 重現 2509.18428 的 50M latent action 世界模型，Procgen 或小 Minecraft 跑通。
2. latent action 離散化（VQ 動作碼本）→ Track B 關節角度當對照組。
3. RL 基礎升級為核心技能：model-based RL（Dreamer V3/V4）+ 世界模型內的 RL 後訓練（PPO/GRPO 類、World4RL/WMPO 式）。

---

## 6. 時程

| 時間 | 交出的東西 |
|---|---|
| 2026-11 前 | Track A 收尾、先導論文初稿 |
| 2027-02 前 | Track B 第一組 0-shot + UCFRep zero-shot，決定合併/分開投 |
| 2027-03 | RAC 論文投 ICCV 2027（CVPR 2027 截止 2026-11 來不及） |
| 2027-04～06 | 橋接實驗 → workshop/arXiv；啟動 IRB、確認合作平台、開始錄週期性 benchmark |
| 申請前 | 50M latent action 世界模型重現跑通；計畫書題目「世界模型的時序結構」 |
| 2027-11 | 主力論文投 CVPR 2028 |

申請包 = 一篇已發表/已投的完整論文 + 一個有圖有數字的世界模型先導實驗 + 一份有具體研究問題的計畫書。差異點不是模型大小，是用統計紀律量別人只用人眼看的東西。

---

## 7. Sources
- World Models and World-Action Models survey (2026): https://cdn.prod.website-files.com/64b77d8a4c7f046a3e2e5feb/6a7d12b07356b751a6bcdd08_world_model_survey_0812_2026.pdf
- WAM tutorial for robotics (arXiv 2607.00836): https://arxiv.org/pdf/2607.00836
- Latent Action Pretraining Through World Modeling (arXiv 2509.18428): https://arxiv.org/html/2509.18428v2
- NVIDIA: Pretrained to Imagine, Fine-Tuned to Act: https://developer.nvidia.com/blog/pretrained-to-imagine-fine-tuned-to-act-the-rise-of-world-action-models/
- Mixture of Latent Actions (arXiv 2605.12167): https://arxiv.org/pdf/2605.12167
- LeapBot-WA (arXiv 2607.23969): https://arxiv.org/pdf/2607.23969
- DreamGen (arXiv 2505.12705): https://arxiv.org/pdf/2505.12705
- awesome-vla-wam: https://github.com/DravenALG/awesome-vla-wam
- DreamerV3 (arXiv 2301.04104): https://arxiv.org/pdf/2301.04104
- LoopNav (arXiv 2505.22976): https://arxiv.org/pdf/2505.22976
- MineWorld: https://sotaverified.org/papers/mineworld-a-real-time-and-open-source
- OpenDreamer: https://noqta.tn/en/blog/opendreamer-open-source-world-model-jax-agent-training-2026
- From Generation to Simulation survey (arXiv 2608.23070): https://arxiv.org/pdf/2608.23070
- Atlas 報導：SiliconANGLE https://siliconangle.com/2026/09/01/fei-fei-lis-world-labs-debuts-atlas-a-world-model-showcase-for-advanced-spatial-intelligence/ ；Kingy AI 深評 https://kingy.ai/blog/world-labs-atlas-world-model-deep-dive/ ；XenoSpectrum https://xenospectrum.com/en/world-labs-atlas-spatial-intelligence/
- Every Shot Counts (arXiv 2403.18074): https://arxiv.org/pdf/2403.18074
- MoCount (ACM MM 2025): https://dl.acm.org/doi/10.1145/3746027.3755857
- OVR dataset (arXiv 2407.17085): https://arxiv.org/pdf/2407.17085

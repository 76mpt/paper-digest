---
name: phd-world-model-prep
description: "博士方向=世界模型/Vision-Action(不做VLA;VA端到端保留,可合作做手臂/移動);領域地圖、先導vs CVPR標準(A+B何時可拚)、RAC→世界模型的橋接、申請包三層、時程、要補的三塊技能。完整版在 D:/Research/phd_world_model_roadmap.md"
metadata:
  type: project
  modified: 2026-10-13
---

# 博士方向：世界模型 / Vision-Action（2026-10-13 session 整理）

**完整寫法（含 sources）在 `D:/Research/phd_world_model_roadmap.md`**，本檔是濃縮。**開工前要重讀的備忘錄 = `D:/Research/phd_direction_memo.md`**（user 2026-10-23 要求，開始該方向時先提醒 user 讀它）。

## 方向與領域地圖
- 目標：世界模型或多模態 vision-action，**不做 VLA**（語言拖累）。博士要求兩篇論文、目標 CVPR、一先導一主力串成一線。
- 三陣營+一橋：像素生成（Sora/Veo/Cosmos 3/Genie 3，物理不穩、學生打不過）、潛在表徵預測（V-JEPA 2、LeWorldModel 2026-03，學術空間最大）、空間智慧（World Labs **Atlas** 2026-09-01，3D 重建，不碰）。**橋 = World-Action Model / latent action**（Genie→LAPA→**arXiv 2509.18428** 50M DreamerV3 版無標籤預訓練贏有標籤→2026 Motus/DreamDojo/LeapBot-WA）= **主戰場**：不需動作標籤不需語言、接影片時序、50M 做得動。
- **Atlas 評估**：少數圖片生成完整場景是真突破；物理還原證據撐不起（自報、無重現、剛體/可變形在自家路線圖 Phase 2、碰撞網格粗略、機器人 demo 是幾何不撞牆非物理互動）。arXiv 2608.23070：現有世界模型是「看起來合理」非「物理正確」→ **動態物理與時序一致性 = 我的缺口**。
- 閱讀順序：Ha&Schmidhuber 2018→DreamerV3→Genie→V-JEPA 2→LAPA→2509.18428→WAM tutorial 2607.00836→2026 WAM survey；追新 awesome-vla-wam。開源可用：MineWorld、OpenDreamer（Dreamer 4 重現）、LoopNav。算力：DreamerV3 Procgen ≈16 GPU-day。

## 博士切入點
**世界模型與 latent action 的時序結構**：latent action 碼在週期性動作上是否穩定、長序列 rollout 是否漂移、週期性先驗能否當自監督訊號。
可轉移資產：評估方法論（on/off 歸因、bootstrap/Wilcoxon、warm-start 混淆、val 紀律，世界模型評估最弱→賣點）、時序/頻率分析（Nyquist、motion energy、C1 r=0.80、辨識 vs 表達）、工程（FiLM/C-attn、DETR、WiSE-FT、200ep 管線）。概念橋：**exemplar 當動作先驗 ≈ latent action 當動作先驗**；Track B 關節角度 = 現成真實動作空間可當對照組。

## 先導 vs CVPR 的標準
- **先導**：拿現成開源模型，嚴謹量測找別人沒說清的失敗模式+小修正；不需贏 SOTA；要「可量化現象+可沿用工具+可引用結論」。venue workshop/WACV/arXiv。**ESC 改良能算先導是因為帶診斷**（C1、Nyquist、warm-start 混淆）；只有 caON hf20 改善數字撐不住。
- **CVPR**：新框架+≥2 benchmark 或新 benchmark+洞見+消融答為什麼+超出小圈子的圖。**A+B 可不可拚 CVPR：看混合後有沒有 A、B 單獨都沒有的能力且能證明為什麼。** MoCount+exemplar 寫成「加模組數字變好」=拒；寫成「exemplar 在 motion 空間更不變→類別無關第一次逼近有類別 SOTA+zero-shot 贏」=假設檢驗、貢獻不可拆=可拚。世界模型更嚴（大廠月產組合模型），學生 A+B 唯一活路=回答大廠不做的小問題。
- 模板：先導=開源世界模型 rollout 週期漂移診斷+指標；CVPR=motion 結構先驗讓 latent action 更省資料、rollout 更穩，用先導指標量；陷阱=「JEPA 加 latent action 數字變好」。

## 主力論文預想（2026-10-23，user 更正後）
**A（世界模型為主、VA 當下游評估）與 B（端到端 VA、無語言、手臂或移動非人形，模擬器/機器人靠合作）都保留，未定。目標 = 頂會/頂刊，不限 CVPR。**
**user 判斷（勿再反駁）**：VA 不窄；多數雖是 VLA，趨勢在減 L，因語言拖慢推論、即時受限。佐證：即時是核心瓶頸、video-action 模型興起（LingBot-VA RSS 2026、arXiv 2607.08639、FLUX 3 Action）；但未找到明確完全無語言代表作 → 可能是空位。
共同核心：latent action（VQ）+ 先驗（碼回歸關節角度變化量；重複動作對應重複碼）。B 版賣點 = 無語言泛化 + 即時；任務指定用**示範影片當 exemplar**（Track B 概念延伸）；評估 = 成功率、控制頻率/延遲、少示範效率、外觀變化穩健性。完整版見 roadmap §3.5。

## 產業實務佐證：自駕去 VLA（2026-10-23）
user 轉述某中國自駕公司資深 RD（台大校友、曾在合眾新能源開發已上市產品；第一線量產觀點，也是 B 版潛在諮詢對象）：中國自駕實務幾乎不用 VLA 了（不可引用，只當方向判斷）。**公開可引用的佐證**：華為靳玉志「不走 VLA 路線，WA 才是終極方案」，ADS 4 用 **WEWA = 雲端 World Engine（重建/生成場景）+ 車端 World Action（視覺直接控車）**（36Kr 2025）；小鵬 VLA 2.0（2025-11）改為「視覺→隱式表徵→動作」、去掉顯式語言轉譯（文字仍 token 化），2026-04 X-World 技術報告用生成式世界模型做閉環仿真與 RL；理想仍用 VLA 品牌。業界評論：名稱差異大於實質，關鍵在時空認知。
**對論文的含義**：WEWA 本身就是「世界模型當訓練/評估引擎 + VA 當部署 policy」= A、B 兩版合體的產業版本 → 可當動機段引用（論文偏 VLA、產業已轉 WA）。自駕也可列為 B 版平台候選（學生可用 NAVSIM / Bench2Drive / CARLA 類 benchmark），但資料與算力門檻高，需合作。

## 自有資料庫 / 實體實驗策略（2026-10-23）
加資料或實體會容易些：評審從「贏 SOTA」轉到「別人做不到」，資料是學生對大廠的護城河。**做評估 benchmark 不做訓練集**（幾千段夠；週期/長程一致性無專門 WM benchmark；rep 邊界+MediaPipe+計數器現成；合作方手臂錄擦拭/攪拌/鎖螺絲/鋸 + 人體示範 → 兼顧 A 版評估與 B 版 exemplar 指定任務）。**先導升級 = benchmark+指標+開源 WM 診斷**（NeurIPS D&B 或 CVPR）；主力 = 方法+自家 benchmark+合作方真機/模擬（CVPR 或 CoRL）。CoRL/RSS 真機是入場券。風險：IRB 提早數月、硬體看合作方排程、收集標註要數月 → 碩士收尾後即開始，與 50M 重現並行。完整版見 roadmap §3.5。

## WA 往 RL 走（2026-10-23）
配方收斂 = IL 預訓練 policy → 世界模型內 RL 後訓練（機器人：World4RL、WMPO、WoVR、WISE、RehearseVLA/World-Env；自駕：「世界模型+RL」已是頭部標配，地平線 HSD V2.0、蔚來三段式、WorldEngine 港大+華為+NVIDIA、小鵬 X-World、Tesla、Waymo）。學生切點：RL 鑽世界模型錯誤、世界模型給 reward/終止、重複動態漂移被 RL 利用。**新 RAC 接點：計數器 = 週期性任務的 reward/終止模型**（擦 5 下=數到 5），exemplar 指定任務 + 計數器判完成 = 無語言閉環。**RL 升級為核心技能**（model-based RL + 世界模型內 PPO/GRPO 後訓練）。詳見 roadmap §3.5。

## RAC 收尾建議（數字見 [[submission-strategy]] [[aux-bpm-milestone]]）
全部 overall 不顯著；caON hf20 顯著但 Q1 最差；mrate overall 是 gt≤2 校準假象；rep-DETR run1 兩倍差（run2 count loss 是唯一判決，<0.3 才談）；Track B 零結果。
路線：本月三探針跑完鎖 Track A，補 **TTA |K|=4、UCFRep zero-shot、gt≤2 穩健性表** → 先導論文（WACV/ACCV）。11 月起 Track B（Phase 1 抽取 3.8h→ESC 架構換關節角度→0-shot+UCFRep zero-shot）；CVPR 版要：類別無關贏 0.280 逼近 0.174、zero-shot 贏 ESC/MoCount 0.1697、few-shot 曲線、pose 失效 graceful degradation。兩篇故事：外觀頻率上限+density 裝不下 → motion headroom+exemplar 更不變。

## 申請包三層
1. 碩論收乾淨（WACV/ACCV 夠，不需 CVPR），Track B 必須有數字。
2. **橋接實驗**：用計數器+motion energy 頻譜量 MineWorld/OpenDreamer/Cosmos-Predict2.5 小版/V-JEPA 2 rollout 的週期漂移、次數掉落、漂移 vs 長度、Q1–Q4 誰先崩；零訓練，workshop/arXiv+計畫書一張圖。
3. **補三塊**：(a) 訓練生成模型（從沒訓過 diffusion/flow/AR video）→重現 2509.18428 50M 在 Procgen/小 Minecraft；(b) latent action VQ 離散化→Track B 關節角度當對照；(c) RL 升級為核心技能（model-based RL + 世界模型內 RL 後訓練）。

## 時程
2026-11 前 Track A 收尾+先導初稿 → 2027-02 前 Track B 首批數字 → 2027-03 投 ICCV 2027 → 2027-04~06 橋接實驗 → 申請前 50M 重現跑通+計畫書「世界模型的時序結構」→ 2027-11 主力投 CVPR 2028。

**Why:** user 2026-10-13 要求整個 session 進此記憶並另出 MD。
**How to apply:** 討論博士申請、計畫書、RAC 收尾後下一步、或任何「先導/CVPR 要到什麼程度」時引用。

## 2026-10-23 拓展：pose-in-WM 與 純 event ESC（user 提，尚未定）
- **pose in WM 文獻現況**：pose 當動作介面已擁擠（Skel-WAM 2609.21514、SkelWAM 2609.21983、ω-0 2608.06375、Being-H0.7）；DreamDojo 2602.06949 明確棄 pose 改 latent action（理由：只有手、遮擋/相機動、太低階；但其消融只比 AVP 擷取標籤，**沒測影片估計 pose**）；HumanScore 2604.20157 用 pose 評生成影片 6 指標（多肢/骨長/關節範圍/自碰撞/運動極值/平滑）**無週期/長程漂移/次數**→ 我們的缺口。建議定位：pose 當**結構先驗與量尺**，非動作介面（pose-anchored latent action：z=[z_pose|z_res]，信心門控＝bench_pressing 教訓）。
- **event-RAC**：搜尋未見 event 相機 RAC；event 週期文獻（Frequency Cam、EEPPR、EE3P）只做剛體穩定週期的頻率估計。⚠️ v2e 從 30fps 模擬的 event 不含超過源幀率的資訊→「突破 Nyquist」必須用實拍。需自建 RGB+event 同步資料集（HVRL 有硬體）。
- **HVRL（Saito Lab, Keio）相關學長姐**：Hori（EventPointMesh TVCG24、GRIP CVPR26）、Nakabayashi/Yamane（event 球追蹤/動作分類）、Ozawa/Sekikawa（EventNet、遞迴對比最大化高頻運動）、Fujii（in-context 軌跡預測 NeurIPS25）、Hatano（手部預測）；lab 也有機器人抓取/舀取→ B 版平台候選。
- **2026-10-23 補（user 更正後）**：event-ESC 是**教授建議**的方向。「Hori 凍住 RGB」是 user 記錯，**不存在**；EventPointMesh 的做法 = 把 RGB 的 pose estimation 流程改寫成 event point cloud 版（固定時間窗切點雲→Base→Keypoints 模組估 2D 關節→Anchor Points 以關節為錨分組 event 取局部特徵→mesh）。event-ESC 照同一模式移植：保留 ESC 任務結構（exemplar cross-attn+density+count），輸入端換 event 原生表示；時間窗可遠短於 RGB 幀間隔→在 token 層拆 Nyquist 牆。三條路：點雲原生 / 以關節為錨的局部 token / event→pose→Track B。碩論框架「exemplar 在不同表示空間」可加第三個空間 = event。
- **整理版備忘錄**：`D:/Research/phd_event_pose_memo.md`（event-ESC 三路線、pose-in-WM 的 P1/P2/P3、論文串法、要問 Hori/教授的問題、開工清單）。主線備忘錄 `D:/Research/phd_direction_memo.md`（世界模型×無語言 VA，另一 session 寫）。
- **學長研究分析備忘錄（2026-10-23）**：`D:/Research/hori_research_memo.md`。內容：Hori 完整論文、GRIP（CVPR 2026）選題考古（2022 CCC 足壓種子 → AIST 鞋子硬體 → CMU Kitani lab 的 PHC → CVPR）、選題套路（冷門感測器 + 一句話應用理由 + 自建資料集；國內 MIRU/CVIM/CCC 孵化再升級；頂會 = 累積最久的線 × host lab 招牌方法）、對 event-ESC 和 Track B 的借鏡、要問學長的選題問題。`phd_event_pose_memo.md` 的開頭、§2.7、§7、§9 已加上指向它的連結。**開始 event-ESC 方向時，提醒 user 三份一起讀。**

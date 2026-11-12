# 博士方向備忘錄：世界模型 × Vision-Action（無語言）

> 寫於 2026-10-23。開始這個方向前先從頭讀一遍。
> 細節與完整來源在 `phd_world_model_roadmap.md`，這份只放梳理思緒需要的東西。
> ⚠️ 裡面的產業動態、論文編號都會過時。開工時先做第 9 節的重新確認。
> 延伸方向（純 event 的 ESC、pose 進世界模型）另見 `phd_event_pose_memo.md`，摘要在第 12 節。

---

## 0. 一句話

**用世界模型當學出來的模擬器，訓練一個不經語言的 vision-action policy，並用我在 RAC 練出來的「數重複動作」能力，當作任務指定、完成判斷和一致性量測的工具。**

---

## 1. 方向定位：為什麼是「世界模型 + VA」，不是 VLA

- **不做 VLA**：語言骨幹拖慢推論，即時控制受限。十億參數等級的模型一次前向要 50～135 ms，超過 30 Hz 控制週期的 33 ms。
- **VA 不窄**：論文裡 VLA 多，但趨勢在減少 L。實務上，中國自駕幾乎已經不用 VLA。
  - 第一線說法：一位資深 RD（台大校友、曾在合眾新能源開發已上市產品）。**不可引用，只當方向判斷。**
  - 可引用的公開說法：華為「不走 VLA 路線，WA 才是終極方案」，ADS 4 用 **WEWA** 架構（雲端 World Engine 加上車端 World Action）。小鵬 VLA 2.0 改為「視覺、隱式表徵、動作」，去掉顯式語言轉譯，但文字仍然 token 化。理想仍走 VLA。
  - 公開資料裡沒找到明確「完全無語言」的代表作，所以**「無語言加即時」可能本身就是空位**。
- **WA 正在往 RL 走**：配方收斂成「先用模仿學習預訓練 policy，再在世界模型裡做 RL 後訓練」。
  - 機器人端的例子：World4RL、WMPO、WoVR、WISE、RehearseVLA、World-Env。
  - 自駕端：報導稱「世界模型加 RL」已是頭部標配，例如地平線、蔚來、WorldEngine（港大、華為、NVIDIA 合作）、小鵬 X-World、Tesla、Waymo。
- **目標會場**：頂會或頂刊，不限 CVPR。CVPR、ICCV、NeurIPS、CoRL、RSS、T-RO、TPAMI 都可以。

---

## 2. 研究地圖（只記要用的）

| 線 | 代表 | 我的立場 |
|---|---|---|
| 像素生成世界模型 | Sora、Veo、Cosmos、Genie 3 | 要懂，不正面競爭 |
| 潛在表徵預測 | V-JEPA 2、LeWorldModel | 算力友善，可借用 |
| 空間 3D 世界模型 | World Labs Atlas、Marble | 強在靜態幾何，**動態物理只有宣稱、沒有驗證**，不碰 |
| **latent action / World-Action Model** | Genie、LAPA、arXiv 2509.18428（50M 參數）、Motus、DreamDojo | **主戰場**：不需動作標籤，不需語言，50M 等級做得動 |
| 世界模型內的 RL 後訓練 | World4RL、WMPO、WoVR | **主力論文的後半段** |

---

## 3. 主力論文：A、B 兩版與合體

### 共同核心
- latent action 模型：inverse dynamics 產生 VQ 動作碼，forward dynamics 預測未來。
- 加兩個只在訓練時用的動作結構先驗：
  1. 動作碼回歸關節角度變化量，用 MediaPipe 管線。
  2. 重複的動作對應重複的碼，也就是在碼序列上做 self-similarity。

### A 版：世界模型為主
- **問題**：長 rollout 時週期性動態會漂移，FVD 類指標看不出來。
- **評估**：週期一致性指標、latent action 對真動作的線性探針、少標註的 behavior cloning 曲線、FVD。
- 不需要合作方，兩張 4090 做得到。

### B 版：端到端 VA，不含語言
- **平台**：機械手臂、移動機器人或自駕，不做人形。模擬器或實機靠合作。
- **流程**：用人體影片加機器人影片做 latent action 預訓練，再用少量示範微調成 policy，用 action chunking 和非同步推論做到即時。
- **賣點**：不靠語言也能泛化，而且即時。
- **評估**：成功率、控制頻率與延遲、少示範時的樣本效率、對外觀變化的穩健性。

### 合體版：產業的 WEWA 型（目前最看好）
**世界模型當訓練與評估引擎，VA 當部署 policy，RL 把兩者接起來。** A 版產出世界模型，B 版產出 policy，RL 後訓練是第三段。這樣兩版不必二選一。

### 不可拆性檢查（頂會門檻）
- 拿掉動作先驗，漂移和泛化就退化。
- 拿掉 latent action，就沒辦法用人體影片預訓練。
- 拿掉 exemplar 任務指定，就得回去用語言。
- **A+B 能不能上頂會，看的是混合後有沒有出現單獨都沒有的能力，而且能證明為什麼。只是「加模組、數字變好」會被拒。**

---

## 4. 我的獨特切入點：RAC 資產怎麼接過去

| RAC 資產 | 在新方向的角色 |
|---|---|
| 計數器（control、caON）加 motion energy 頻譜 | **量尺**：量世界模型 rollout 的週期和次數漂移 |
| 計數器 | **reward 與終止模型**：「擦 5 下」等於數到 5 就完成 |
| ESC 的 exemplar 條件化 | **任務指定**：用示範影片告訴 policy 做什麼，取代語言 |
| MediaPipe 關節角度管線（Track B） | **動作結構先驗**，以及 latent action 的對照組 |
| on/off 歸因、bootstrap、Wilcoxon、val 紀律 | **評估方法論**：世界模型領域評估最弱，這是賣點 |
| Nyquist、頻譜、C1「辨識 vs 表達」 | **時序分析**：對應「rollout 動態漂移」 |

> **最關鍵的一句**：exemplar 指定「做什麼」，計數器判斷「做完沒」，兩者合起來就不需要語言。這正好補上 B 版最大的缺口。

---

## 5. 兩篇論文的結構

### 先導論文：benchmark 加指標加診斷
- 週期動態資料集、用計數器做的一致性指標、對開源世界模型的系統性診斷，例如 MineWorld、OpenDreamer、Cosmos-Predict 小版、V-JEPA 2。
- 附帶回答一個問題：這些世界模型夠不夠格當 RL 模擬器。
- 投 NeurIPS Datasets & Benchmarks 或 CVPR。
- **先導的標準**：可量化的現象、第二篇能沿用的工具、一句能引用的結論。不需要贏 SOTA。

### 主力論文：方法加自家 benchmark 加真機或模擬
- 第 3 節的合體版，在自家 benchmark 上驗證，再加合作方平台的實驗。
- 依最後偏 A 或偏 B，投 CVPR 或 CoRL。CoRL 和 RSS 的真機實驗是入場券。

---

## 6. 資料與實體策略

- **加自有資料或實體實驗會容易一些**，因為評審重點從「有沒有贏 SOTA」轉到「有沒有別人做不到的東西」。資料是學生對大廠最有效的護城河。
- **做評估集，不做訓練集**。訓練世界模型的資料量收不起，評估 benchmark 幾千段就夠。
- **可錄的週期性操作**：擦拭、攪拌、鎖螺絲、鋸東西，配上對應的人體示範。同一份資料同時服務 A 版評估、B 版的 exemplar，以及 RL 的計數 reward。
- **三個風險要提早處理**：
  1. 錄真人要 IRB 和受試者同意，提早幾個月啟動。
  2. 硬體看合作方，先確認平台和可用時間。
  3. 錄影、標註、清理要好幾個月，碩士收尾後就開始。

---

## 7. 技能缺口（開工前要補）

1. **訓練生成模型**：我從沒訓過 diffusion、flow matching 或 autoregressive video model。補法是重現 arXiv 2509.18428 的 50M 版本，在 Procgen 或小型 Minecraft 上跑通。
2. **latent action 離散化**：VQ 動作碼本。
3. **RL 已升級成核心技能**：model-based RL（Dreamer V3、V4），以及世界模型內的 PPO、GRPO 類後訓練，例如 World4RL 和 WMPO 的做法。

---

## 8. 還沒決定的事

- [ ] A 版、B 版還是合體版？目前偏向合體版。
- [ ] 平台：手臂、移動機器人還是自駕？取決於合作方。自駕的資料和算力門檻最高，可用 NAVSIM、Bench2Drive、CARLA 類 benchmark。
- [ ] 無語言時怎麼指定任務：示範影片當 exemplar、目標影像，還是單任務 policy？目前偏向 exemplar。
- [ ] 合作方是誰，能給什麼平台、多少時間？
- [ ] RL 用什麼 reward：計數器、世界模型自帶判斷，還是成功偵測器？
- [ ] 算力夠不夠：兩張 4090 能撐到哪個規模的世界模型加 RL？
- [ ] 博士第一篇走 event-ESC（教授建議、留 HVRL 時優先）還是世界模型診斷先導？見第 12 節。

### 要問那位 RD 的問題
1. 他們實際部署的是哪種架構：端到端 VA、WA，還是世界模型加 policy？
2. 不用語言時，導航目標和任務怎麼給？
3. 世界模型加 RL 在量產端最大的坑是什麼？例如 RL 鑽世界模型的錯。
4. 學術界能接觸到哪些實車或仿真資源？有沒有可引用的公開演講或技術報告？

---

## 9. 開工第一週：重新確認清單

- [ ] 重新查「無語言 VA」的最新代表作。空位可能已經被填了。
- [ ] 重新查世界模型內 RL 後訓練的最新論文，從 Awesome-WAM 和兩篇 2026 survey 開始。
- [ ] 核對引用的 arXiv 編號。部分論文在不同來源的編號對不上。
- [ ] 確認開源世界模型的現況：MineWorld、OpenDreamer、Cosmos-Predict、V-JEPA 2 還能不能用、有沒有新版本。
- [ ] 確認合作方與平台。
- [ ] 啟動 IRB。
- [ ] 開始重現 arXiv 2509.18428 的 50M 版本。

---

## 10. 時程（2026-10 版）

| 時間 | 交出的東西 |
|---|---|
| 2026-11 前 | RAC Track A 收尾，先導論文初稿 |
| 2027-02 前 | Track B 第一組數字 |
| 2027-03 | RAC 論文投 ICCV 2027 |
| 2027-04～06 | 橋接實驗，用計數器量開源世界模型；啟動 IRB；確認合作平台；開始錄週期性 benchmark |
| 申請前 | 50M latent action 世界模型重現跑通；計畫書以「世界模型與無語言 VA 的時序結構」為題 |
| 2027-11 起 | 主力論文 |

---

## 11. 關鍵來源

- 華為不走 VLA、WEWA：https://www.36kr.com/p/3441062507550088
- 智駕路線分化（小鵬、理想、華為）：https://m.huxiu.com/article/4823626.html
- 自駕世界模型為何都用 RL：https://www.ofweek.com/auto/2026-08/ART-70109-11000-30699587.html
- 2026 自駕開源工作盤點：https://developer.horizon.auto/blog/14014
- Latent Action Pretraining Through World Modeling（arXiv 2509.18428）：https://arxiv.org/html/2509.18428v2
- World4RL（arXiv 2509.19080）：https://arxiv.org/abs/2509.19080
- WoVR（arXiv 2602.13977）：https://arxiv.org/pdf/2602.13977
- World-Action Models survey（arXiv 2609.16074）：https://arxiv.org/pdf/2609.16074
- World Models for Robotic Manipulation survey（arXiv 2606.00113）：https://arxiv.org/html/2606.00113v1
- Awesome-WAM：https://github.com/OpenMOSS/Awesome-WAM
- 即時性瓶頸：https://www.chefrobotics.ai/post/latency-aware-vision-language-action-models-vlas-with-system-identification-for-real-time-robot-control
- LingBot-VA（RSS 2026）：https://www.roboticsproceedings.org/rss22/p016.pdf
- Native Video-Action Pretraining（arXiv 2607.08639）：https://arxiv.org/html/2607.08639v1

---

## 12. 延伸方向：純 event 的 ESC × pose 進世界模型

> 詳細版在 `phd_event_pose_memo.md`（三條 event 路線、P1～P3 設計、資料策略、要問學長和教授的問題）。這裡只放和主線的接點。

**一句話**：event 相機在感測端拆掉碩論診斷出的頻率牆，pose 把動作的時序結構帶進世界模型。串起來就是「event → pose → 週期結構 → 世界模型」。兩者都踩在 Track B 上，**Track B 先要有數字**。

### 純 event 的 ESC（教授建議）
- 照 EventPointMesh（Hori, TVCG 2024）的移植模式：把 RGB 流程改寫成 event 點雲版。ESC 的 exemplar cross-attention、density、count head 不動，只換輸入端。
- 三條路線：event → pose → Track B（baseline）、以關節為錨的局部 token（中間路線）、點雲原生（主方法）。
- 時間窗可以遠短於 RGB 幀間隔，在 token 層拆頻率牆；density 輸出也要跟著加密。
- ⚠️ 用 v2e 從 30fps 影片模擬的 event 不含高頻資訊，**要自拍 RGB + event 同步資料**。可以和第 6 節的週期性操作 benchmark 一起錄、一起送倫理審查。
- 碩論框架「exemplar 在不同表示空間」多一個空間：外觀、pose、event。

### pose 進世界模型
- pose 當**動作介面**已經擁擠（Skel-WAM、SkelWAM、ω-0、Being-H0.7）；DreamDojo 甚至棄 pose 改 latent action，但沒測影片估計的 pose。HumanScore 用 pose 評生成影片，但沒有週期、長程漂移、次數。
- 定位：pose 當**結構先驗與量尺**。

| 延伸 | 對應本份的位置 |
|---|---|
| P1 週期 pose 量尺（不用訓練） | 第 5 節先導論文的量測工具 |
| P2 以 pose 為錨的 latent action：`z = [z_pose \| z_res]`，信心門控 | 第 3 節共同核心先驗 (1) 的具體設計；人的 pose 和機器人 proprioception 共用關節空間 |
| P3 exemplar 條件化 rollout | 第 4 節「exemplar 指定做什麼、計數器判斷做完沒」 |
| event 低延遲感知 | B 版「即時」的長線延伸（高風險，不當第一步） |

### 對論文串法的影響
- 博士留在 HVRL：第一篇優先 event-ESC（硬體、學長姐、教授方向都對得上），P1 降為橋接 workshop。
- 去純世界模型的實驗室：維持第 5 節原案，P1 當先導。
- 主力論文不變，P2、P3 是它的具體元件。

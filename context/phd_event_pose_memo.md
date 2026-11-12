# 延伸方向備忘錄：純 event 的 ESC × pose 進世界模型

> 寫於 2026-10-23。開始這兩個方向前先從頭讀一遍。
> 主線備忘錄是 `phd_direction_memo.md`（世界模型 × 無語言 VA），這份是它的延伸。第 5 節說明兩份怎麼接。
> ⚠️ 論文編號、「沒人做過」的判斷都會過時。開工時先做第 8 節的重新確認。
> 📎 姊妹篇 `hori_research_memo.md`：Hori 學長的完整論文清單、CVPR 2026 GRIP 的選題考古、選題套路與對我的借鏡。動手前建議一起讀。

---

## 0. 一句話

**兩個想法是同一條線：event 相機在感測端拆掉碩論診斷出的頻率牆，pose（關節角度空間）把動作的時序結構帶進世界模型。串起來就是「event → pose → 週期結構 → 世界模型」。**

前提：**Track B（pose + exemplar）必須先有數字**。兩個方向都踩在它上面，Track B 不能被擠掉。

---

## 1. 這兩個想法從哪來、站在哪

| 想法 | 來源 | 定位 |
|---|---|---|
| 純 event 的 ESC | **教授建議**往 event 做；ESC 改良本來就是我的碩論題目 | 博士第一篇的有力候選。實驗室有硬體、有學長姐的經驗 |
| pose estimation in world model | 自己的想法，延伸 Track B | 主力論文的核心元件，不是獨立論文 |

**統一框架（直接沿用碩論）**：Track B 原本的論文框架是「exemplar 在不同表示空間的效果」，比的是外觀（RGB）和 motion（pose）。event 是**第三個表示空間**。三個空間問同一個問題：**exemplar 在哪個表示空間最不變，對頻率最不受限？**

- Track A：外觀空間有頻率上限（約 112 BPM 的 Nyquist），density 輸出也表達不出。
- Track B：pose 空間的頻率 headroom 高，exemplar 更不變。
- event-ESC：感測器本身沒有取樣牆，背景和紋理大多被壓掉。

---

## 2. 純 event 的 ESC

### 2.1 為什麼值得做
- **頻率**：event 是微秒等級的非同步輸出，感測端沒有取樣牆，直接對應 Track A 的診斷。
- **不變性**：event 只對亮度變化有反應，靜態背景和衣服紋理大多消失。這和 Track B「motion 空間更不變」是同一個論點。
- **應用**：沒有外觀所以隱私友善（居家復健、健身）；低光與動態模糊下仍可用；低功耗，可以 always-on。

### 2.2 參考做法：EventPointMesh 的移植模式
EventPointMesh（Hori, Isogawa, Mikami, Saito, TVCG 2024）是**把 RGB 的 pose 估計流程，改寫成 event 點雲版**：
1. 把 event stream 依**固定時間窗**切成時空點雲。
2. Base 模組抽基礎特徵。
3. Keypoints 模組估 2D 關節，同時產出全域特徵。
4. Anchor Points 模組以每個關節為錨，把附近的 event 點分組，抽局部特徵。
5. 回歸 SMPL mesh。推論只用 event。

資料集 EPMD 含同步的 event、intensity 影像、光學 MoCap、SMPL，有亮光與暗光兩種條件。

> 註：我一度記得學長的論文有「RGB+event 一起訓練、凍住 RGB、推論只用 event」，**這是記錯，不存在**。以上述移植模式為準。

### 2.3 event-ESC 的設計：任務結構不動，只換輸入端
ESC 後半段全部保留：exemplar cross-attention、density map、count head。要重寫的只有「訊號 → token」這段。

| 路線 | 做法 | 角色 |
|---|---|---|
| **① event → pose → Track B** | 用 EventPointMesh 輸出關節，換算成關節角度，接 Track B 模型 | 最便宜的 baseline；需要學長的 code 或權重；pose 誤差會一路傳下去 |
| **② 以關節為錨的局部 token** | 借 Keypoints + Anchor Points：每個關節附近的 event 群組成一個 token，exemplar cross-attention 在這些 token 上做 | 中間路線，也是消融對象：只要「哪個部位在動」，不需要精確角度 |
| **③ 點雲原生** | 每個時間窗的點雲經點雲 encoder 變成 token，接 ESC；exemplar = 單次動作的 event token | **主方法**，最「純 event」 |

**兩個關鍵設計**：
- **時間窗長度是自由參數**，可以遠短於 RGB 的幀間隔，所以 ③ 能在 token 層直接拆掉頻率牆。
- **輸出端也要跟著加密**。Track A 的第二道牆是輸出解析度。density head 不加密的話，牆只是從輸入搬到輸出。
- （備註）「稀疏輸入 event 配稀疏輸出 rep-DETR」概念上很合，但 rep-DETR run 1 是兩倍差，現在只能當備註。

**備用：如果要用 RGB 預訓練**（例如 v2e 模擬配對資料）
直接讓 event encoder 模仿 RGB 特徵，student 會被綁在 teacher 的時間取樣率上，Nyquist 牆跟著搬過去。只能在**低頻、語意層**對齊；時序要另外用高解析度頭、在實拍資料上用 count loss 學。

### 2.4 要驗證的假設
- **H1（核心）**：在 RGB 感測器成為瓶頸的地方（高 BPM、低光、動態模糊），event-ESC 贏過 RGB-ESC。證據是「計數誤差 vs BPM」曲線：RGB 在哪個 BPM 崩、event 撐不撐得住。
- **H2**：exemplar 機制能跨感測器沿用。在 RGB 上學到的匹配方式，在 event 上是否仍然有效。

### 2.5 資料：最大的坑
- **目前沒有 event 版的 RAC 資料集。**
- ⚠️ **v2e、ESIM 從 30fps 影片模擬的 event，高時間解析度是插值出來的，不含超過原始幀率的資訊。** 模擬資料不能拿來證明突破 Nyquist，只適合預訓練和表示法消融。
- **pilot 捷徑**：問學長 EPMD（或 MMHPSD）裡有沒有重複動作片段，例如深蹲、揮手。有的話可以先用現成的真實 event 資料做 pilot。
- **正式資料**：自己拍 **RGB + event 同步**的資料集。
  - 動作涵蓋高 BPM（跳繩、快拳、快速抓放）、低光、隱私情境。
  - 標註：先用同步 RGB 跑 Track B 的 pose 計數做半自動初標，再人工校正。
  - 同一場景兩種感測器，可以做最乾淨的對照。**資料集本身就是貢獻。**
  - 錄真人要倫理審查與受試者同意，要提早啟動。

### 2.6 相關文獻（防撞車用）
- **event 週期估計**：Frequency Cam（2211.00198）、EEPPR（2408.06899）、EE3P（2402.14958）。都是剛體、週期穩定的頻率估計（閃爍、旋轉、振動）。**EEPPR 的時空相關，其實就是寫死的 exemplar 匹配** → 定位寫成「從固定相關到可學的 exemplar attention，處理非剛體、週期會變、會中斷的人體重複動作」。
- **event 人體與動作資料集**：DailyDVS-200（ECCV 2024，分類）、DHP19（pose）、EHPT-XC（NeurIPS 2024 D&B）、Event-Human3.6M（模擬）。都不做計數。
- **RAC 端的威脅**（見 memory rac-lit-2026）：D²-STX、PAMS 是 pose 路線；目前沒看到 event 路線。

### 2.7 實驗室資源（HVRL 與 Isogawa lab，都在慶應）
- **Hori**：EventPointMesh（TVCG 2024）、MIRU 2023 event-only pose 與 shape、event + IMU 第一人稱 pose（MIRU 2026，和 Golyanik 合作）、GRIP（CVPR 2026）。已畢業（PhD 2026）。
  - 2026-10-23 補充：現職是 **AIST 數位人體研究團隊研究員**；2024-04 起在 **CMU Kitani lab** 當 visiting researcher（GRIP 是那時候的成果，共同作者有 PHC 作者 Zhengyi Luo）。主軸是「非典型、資訊受限的感測器 × 3D 人體」：手腕 360° 相機 → 純 event → 鞋內 IMU → IMU + 鞋墊壓力 + 物理模擬。
  - ⚠️ 上面「event + IMU 第一人稱 pose（MIRU 2026，Golyanik）」，在學長個人頁和 HVRL 清單上都沒查到，要核對。
  - **選題借鏡**（詳見 `hori_research_memo.md` 第 4～5 節）：頂會那篇來自累積最久的線（足壓，2022 CCC → 2026 CVPR），作法是「自己的冷門模態 × host lab 招牌方法（PHC）」，加上自建資料集當門檻。idea 都先在 MIRU、CVIM、CCC 試水溫再升級。event-ESC 可以照這個路徑：碩論 RAC 累積 × HVRL 的 event 資產 × 自拍 RGB + event 資料集。
- **Nakabayashi、Yamane**：event 球偵測、旋轉估計、即時球追蹤加動作分類（MMSports 2025）。
- **Sekikawa、Ozawa**：EventNet（CVPR 2019，非同步遞迴處理）、遞迴對比最大化做高頻運動估計。
- **Matsunaga**：event 即時慢動作視覺化（IEEE Access 2025）。
- **Isogawa lab**：Event-Based Batting Impact Estimation（ICIP 2026，從 event 估打擊瞬間，和「定位每一下發生在哪」很接近）、EventEgoHands++（2609.17189，附真實 event 資料集，可參考拍攝與標註流程）。

### 2.8 投稿等級（誠實估）
- CVPR Event Vision workshop、WACV、BMVC：穩。
- 實拍資料集加上高 BPM 區段差距夠大：ECCV、ICCV 主會有機會。

---

## 3. pose estimation 進世界模型

### 3.1 2026 年的現況：pose 有三種用法

| 用法 | 代表作 | 對我的意義 |
|---|---|---|
| **(a) pose 當動作介面或條件** | Skel-WAM（2609.21514）、SkelWAM（2609.21983）、ω-0（2608.06375）、Being-H0.7（2605.00078） | **已經擁擠**，大組在做，不正面競爭 |
| **(b) 不用 pose，改用 latent action** | DreamDojo（2602.06949）。理由：只描述手、遮擋或相機移動就失準、太低階 | 消融只比了 Apple Vision Pro 擷取的標籤，**沒測從影片估計的 pose** → 開放問題 |
| **(c) pose 當評估量尺** | HumanScore（2604.20157），評 13 個影片生成模型 | 6 個指標（多餘肢體、骨長、關節範圍、自碰撞、運動極值、平滑度）都是逐幀或短時間，**沒有週期、長程漂移、次數** |

**定位**：pose 不當動作介面，當**結構先驗與量尺**。

### 3.2 三個具體方向

**P1：週期性 pose 量尺（先導或橋接，不用訓練）**
- 讓世界模型生成 10 秒以上的重複動作，跑 MediaPipe 管線，取關節角度軌跡，看頻譜和計數器。
- 量週期漂移、次數掉落、相位一致性隨 rollout 長度的變化。
- 和 HumanScore 互補：它檢查解剖，我們檢查節奏和長程一致性。
- 干擾：pose 估計器在生成影片上也會失敗。要回報偵測率，並先用解剖指標過濾。Track B Phase 0 已摸過失敗模式（bench_pressing 近拍、身體被裁切）。

**P2：以 pose 為錨的 latent action（主力論文核心）**
- `z = [z_pose | z_res]`。`z_pose` 在 pose 信心高時回歸關節角度變化量；`z_res` 自由學 pose 描述不到的部分。
- 逐條回應 DreamDojo：只有手 → 全身關節角度；遮擋 → 信心低時降級給 `z_res`；太低階 → 機器人的本體感測本來就在關節空間，**人的估計 pose 和機器人 proprioception 共用同一個關節空間介面**。
- 不可拆：拿掉錨，週期 rollout 漂移、碼不可解讀；拿掉 `z_res`，pose 失效的場景整個崩掉。
- 評估：P1 週期指標、latent action 線性探針、少標註 BC 樣本效率曲線。

**P3：exemplar 條件化 rollout（「給一個循環，接著做下去」）**
- 輸入一段 pose 空間的單次動作當 exemplar，世界模型延續這個週期動作，用計數器判斷成敗。
- 回答主線 B 版的問題：沒有語言時任務怎麼指定。
- 實驗室接點：Fujii 的 in-context 軌跡預測（NeurIPS 2025）、Hatano 的手部預測 EMAG。

### 3.3 event 和世界模型的長線連結（高風險，不當第一步）
- 沒找到「直接從 event stream 學 latent dynamics」的世界模型。LongE2V（2607.08770）是以 event 為條件的影片擴散；EA-WM（2605.06192）只把類 event 線索當監督。
- 主線 B 版賣「即時」，event 的低延遲感知正好對口。但 event 資料稀缺。

---

## 4. 怎麼串成博士論文

**題目方向**：人體動作的時序結構：從感測到世界模型

| 篇 | 內容 | 角色 |
|---|---|---|
| 1 | event-ESC：實拍 RGB + event 資料集，加三條路線的 event-ESC | 先導或第一篇；在感測端驗證碩論的頻率牆 |
| 橋 | P1 週期 pose 量尺評世界模型 | workshop 或 arXiv；計畫書的那張圖 |
| 2 | P2 以 pose 為錨的 latent action，加 P3 exemplar 任務指定 | 主力，頂會 |

**先導怎麼選**：
- 博士留在 HVRL：event-ESC 優先（教授建議、硬體、學長姐、指導方向都對得上）。
- 去純世界模型的實驗室：P1 優先（離世界模型更近）。

---

## 5. 和主線備忘錄（phd_direction_memo.md）的對應

| 本份 | 主線備忘錄的位置 |
|---|---|
| P1 週期 pose 量尺 | 第 5 節先導論文（benchmark + 指標 + 診斷）的量測工具 |
| P2 pose 錨 latent action | 第 3 節共同核心的先驗 (1)「動作碼回歸關節角度變化量」的具體設計 |
| P3 exemplar rollout | 第 4 節「exemplar 指定做什麼、計數器判斷做完沒」 |
| event-ESC | 主線之外的第一篇候選；長線可接 B 版的即時感知 |
| 自拍 RGB + event 資料 | 第 6 節資料策略，可以和週期性操作 benchmark 一起錄、一起送倫理審查 |

---

## 6. 開工順序

1. **先完成 Track B 第一組數字**（2027-02 前）。這是兩個方向的地基。
2. **event 一日 smoke test**：借實驗室 event 相機，拍約 10 段快速重複動作，同時用手機 240fps 錄，比較頻譜。性質同 Track B Phase 0，只驗證可行性。
3. **pose-in-WM 一日 smoke test**：用開源影片模型（例如 Wan 2.2）生成約 10 秒開合跳，直接跑 `pose_smoke_test.py`，看週期會不會隨時間漂移。
4. **讀 EventPointMesh 全文**（TVCG，從學校圖書館抓），確認時間窗長度、點雲 encoder 骨幹、2D 關節的監督來源。
5. **問學長**（見第 7 節）。
6. pilot 可行後，才規劃正式的 RGB + event 資料集拍攝。

---

## 7. 還沒決定、要問的事

- [ ] 博士在哪個實驗室？這決定先導選 event-ESC 還是 P1。
- [ ] event-ESC 主方法走 ③ 點雲原生，還是先用 ① 快速出數字？
- [ ] 時間窗要多短？density head 的輸出解析度要多高？
- [ ] 實驗室的 event 相機型號、解析度、能不能和 RGB 硬體同步？

**要問 Hori 學長**：
1. EventPointMesh 的 code 或權重能不能用？
2. EPMD 或 MMHPSD 裡有沒有重複動作片段？
3. 時間窗怎麼選？太短時點太少，怎麼處理？
4. 錄 EPMD 時，同步和標註最花時間的是哪一步？
5. （選題方法）GRIP 的 idea 是去 CMU 前就有，還是在 Kitani lab 才成形？怎麼判斷一個題目夠 CVPR，而不是 TVCG 或 Access？更多問題見 `hori_research_memo.md` 第 6 節。

**要問教授**：
1. 建議往 event 做，是看重哪一點：高頻、低光、隱私，還是實驗室的累積？這決定論文主打哪個賣點。
2. 有沒有合作方可以提供拍攝場地或受試者？

---

## 8. 開工第一週：重新確認清單

- [ ] 重新查「event 相機 + 重複動作計數」：空位可能已經被填了。關鍵字試 event-based repetition counting、neuromorphic periodic action、DVS fitness。
- [ ] 重新查 pose 進世界模型的最新論文：Skel-WAM、SkelWAM 有沒有後續；有沒有人做週期或長程一致性的 pose 量尺（HumanScore 的後續）。
- [ ] 確認 DreamDojo 後續有沒有補「影片估計 pose vs latent action」的比較。
- [ ] 核對本文所有 arXiv 編號。

---

## 9. 關鍵來源

**event 與實驗室**
- HVRL Research：https://hvrl.github.io/research/ ；Publications：https://hvrl.github.io/publications/
- EventPointMesh 專案頁：https://ryosukehori.github.io/EPM_ProjectPage/ ；DOI：https://doi.org/10.1109/tvcg.2024.3462816
- Hori 學長個人頁：https://ryosukehori.github.io ；GRIP（CVPR 2026）：https://arxiv.org/abs/2603.16233
- Isogawa lab Publications：https://isogawa.ics.keio.ac.jp/publications/
- EventEgoHands++（arXiv 2609.17189）：https://arxiv.org/pdf/2609.17189
- Frequency Cam（arXiv 2211.00198）：https://arxiv.org/pdf/2211.00198
- EEPPR（arXiv 2408.06899）：https://arxiv.org/abs/2408.06899
- DailyDVS-200（arXiv 2407.05106）：https://arxiv.org/pdf/2407.05106
- EHPT-XC（NeurIPS 2024 D&B）：https://proceedings.neurips.cc/paper_files/paper/2024/file/f304e427cfe6bb762fe1bf18516c8a87-Paper-Datasets_and_Benchmarks_Track.pdf
- LongE2V（arXiv 2607.08770）：https://arxiv.org/pdf/2607.08770 ；EA-WM（arXiv 2605.06192）：https://arxiv.org/html/2605.06192v1

**pose 與世界模型**
- Skel-WAM（arXiv 2609.21514）：https://arxiv.org/pdf/2609.21514
- SkelWAM（arXiv 2609.21983）：https://arxiv.org/pdf/2609.21983
- ω-0（arXiv 2608.06375）：https://arxiv.org/pdf/2608.06375
- Being-H0.7（arXiv 2605.00078）：https://arxiv.org/pdf/2605.00078
- DreamDojo（arXiv 2602.06949，第 3.3.2 節與表 2）：https://arxiv.org/html/2602.06949
- HumanScore（arXiv 2604.20157）：https://arxiv.org/html/2604.20157v1

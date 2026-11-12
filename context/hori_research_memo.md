# 研究者分析備忘錄：堀 涼介（Ryosuke Hori）的研究與選題方式

> 寫於 2026-10-23。開始 event-ESC 或 pose 相關方向前，先讀一遍再動手。
> 搭配 `phd_event_pose_memo.md`（第 2.7、7 節有學長相關的資源和要問的問題）。
> ⚠️ 第 1、2 節是查得到的事實。**第 3～4 節的「選題思路」是我從時間線推出來的，學長沒有公開寫過。** 有機會當面問的話，以本人說法為準（問題見第 6 節）。

---

## 0. 一句話

**學長的主軸是「在非典型、資訊受限的感測器上做 3D 人體 pose 和 mesh」。CVPR 2026 那篇不是憑空想出的 novelty，而是把自己深耕約 4 年的冷門模態（足壓、鞋內感測），接到 host lab 最強的方法（CMU Kitani lab 的物理人形控制 PHC）上，時機剛好落在幾條研究線交會、還沒有人合起來做的空位。**

---

## 1. 基本背景

| 項目 | 內容 |
|---|---|
| 學歷 | 慶應義塾大學資訊工學：學士 2017–21、碩士 2021–22、**博士 2022–26**，指導教授齋藤英雄。博士期間拿 **JSPS DC1** |
| 現職 | **AIST 人工智慧研究中心（AIRC）數位人體研究團隊（Digital Human Research Team）研究員**（2026 起）；博士期間在同團隊當 RA（2022–26） |
| 海外 | **CMU Robotics Institute，Kris Kitani lab**，visiting researcher，2024-04 開始 |
| 產學 | NTT 共同研究（2020–22，合作者 Isogawa、Mikami）、NEC 共同研究（2020–21）；實習：Preferred Networks、Sony、IBM（皆 2021） |
| 獲獎 | 2022：IPSJ SIG-CVIM 多個獎、cvpaper.challenge（CCC）Best Paper Honorable Mention<br>2023：MIRU 學生獎勵賞、MIRU Demo 賞、VRSJ 學術獎勵賞 |
| 招待講演 | IEEE VR 2025 TVCG 招待發表；ISMAR 2024 IW-P3HSE workshop |
| HVRL 名單 | Alumni → PhD → 2026 |

---

## 2. 論文清單（依主題分組）

### 2.1 第一作（主軸：非典型感測器 × 3D 人體）

| 年 | 論文 | 感測器 | venue |
|---|---|---|---|
| 2021 → 2022 | Silhouette-Based (Synthetic Data Generation for) 3D HPE with a Single Wrist-Mounted 360° Camera | **手腕上戴一台 360° 相機** | ICIP 2021 → IEEE Access 2022 |
| 2022 → 2024 | EventPointMesh: Human Mesh Recovery Solely from Event Point Clouds | **只用 event camera** | 國內 CVIM 2022、MIRU / VRSJ 2023 → **TVCG 2024**（IEEE VR 發表） |
| 2025 | Gait Inertial Poser (GIP): Gait-aware Human MoCap using Shoe-embedded IMUs | **鞋內 IMU** | IEEE Access 2025 |
| 2026 | **GRIP**: Ground Reaction Inertial Poser — Physics-based Human MoCap from Sparse IMUs and Insole Pressure Sensors | **4 顆 IMU + 鞋墊壓力 + 物理模擬** | **CVPR 2026** |

另有國內第一作：CCC 2022「Foot Pressure-Aware Human Mesh Recovery in 3D Scenes」（與 Numata 合作，Best Paper HM）。**這是 GRIP 最早的種子。**

### 2.2 共同作者（多半是帶學弟妹）
- **運動分析**：羽球羽毛球軌跡預測（VISAPP 2023、J. Imaging 2023）、多相機遮擋處理 MOT（MMSports 2024）、多動態相機運動員 mesh 重建（CVPRW 2025 CVSports）。
- **第一人稱與 digital twin**：Map-Mono-Ego（ICIP 2026）、多個第一人稱視角的即時 dynamic digital twin（IEEE VRW 2026）、第二人稱相機估計第一人稱影片（MIRU 2024）。
- **鞋子與足壓**：Realtime Smart Gait Poser（MIRU 2024、CHI 2025 workshop）、鞋墊壓力感測器 3D HPE（MIRU 2024，Isogawa lab）。
- **event 延伸**：Event Point Mesh in Realtime（MIRU 2023 Demo 賞）。

---

## 3. CVPR 2026 GRIP 的選題考古

### 3.1 時間線：idea 醞釀了約 4 年

| 時間 | 事件 | 給 GRIP 帶來的東西 |
|---|---|---|
| 2022 | CCC：Foot Pressure-Aware HMR in 3D Scenes | **足壓 × 人體重建**的種子 |
| 2022 起 | 進 AIST 數位人體團隊（Maruyama、Tada：智慧鞋、步態） | 鞋墊與鞋內感測器的**硬體和領域知識** |
| 2024 | MIRU：鞋墊壓力 HPE；Realtime Smart Gait Poser | 小規模試水溫 |
| 2024-04 | 到 CMU Kitani lab | 共同作者 **Zhengyi Luo（PHC 作者）**、Soyong Shin（WHAM 作者）、Jinkun Cao |
| 2025 | GIP（IEEE Access）：鞋內 IMU 步態 MoCap | GRIP 的前導，**只有 kinematics** |
| 2026 | **GRIP（CVPR）** | 足壓累積 × PHC 物理控制 |

### 3.2 選題當下的領域狀況（依 GRIP 論文的 intro 和 related work 整理）

1. **純 IMU MoCap 已經成熟、趨於飽和**：TransPose → PIP → PNP → GlobalPose → MobilePoser。剩下的共同痛點是 IMU 量不到絕對位置，所以會 drift，出現腳滑、穿地、漂浮。事後物理優化可以補，但仍依賴 IMU 推出來的接觸。
2. **IMU + 足壓融合剛冒出來**：SolePoser、PressInPose、FoRM。缺點是只用腳部感測，上半身重建差、沒有全域軌跡、沒有物理約束。
3. **物理人形控制（PHC 一系）很強**，但大多靠相機或 HMD 提供絕對位置。純 IMU 時，積分出來的速度會 drift，壞的軌跡會餵進控制器。

→ **GRIP 的空位剛好在 1、2、3 的交集**：沒有人把「穿戴式 IMU + 足壓」接到「物理模擬的 digital twin」上。

### 3.3 GRIP 怎麼寫 novelty
- **架構**：兩階段 observer–controller。KinematicsNet（progressive LSTM）估姿態和速度，DynamicsNet（PPO 訓練的 MLP policy）驅動模擬器裡的扭矩控制人形。reward 沿用 PHC（AMP + imitation + energy）。
- **物理一致**：重力、摩擦、地面反作用力在模擬裡自動成立，不用事後優化。
- **避開 drift**：不積分全域位置，改用 key joint 速度和 root-relative 位置。
- **fall recovery**：用 History Buffer，不需要 residual force。號稱全程守住嚴格的物理約束。
- **最少感測器**：只有 4 顆 IMU（兩手腕、兩鞋墊）加足壓，日常可以穿。
- **資料集 PRISM**：IMU、鞋墊壓力、光學 MoCap、3D 物件同步錄製；1,275 段 × 10 秒，約 3.5 小時，6 位受試者，100 Hz。
- **比較對象**：PIP、GlobalPose、MobilePoser、FoRM、SolePoser。在 PRISM、UnderPressure、PSU-TMM100 上評估；後兩者的 IMU 照 TransPose 的做法合成。

---

## 4. 推論：學長的選題套路

### 4.1 每篇第一作都是同一個公式
1. **挑一個「沒人做過的感測器設定」，並給一句話的應用理由**：
   - 手腕 360° 相機 → 未來的智慧手錶
   - event camera → 低光、低功耗與記憶體、隱私
   - 鞋墊 → 日常可以穿戴
2. **新設定沒有資料，就自己做資料集**：wrist-360 合成資料、EPMD、PRISM。資料集同時是貢獻，也是別人一時追不上的門檻。
3. **方法上通常是「把成熟流程移植到新模態」**：EventPointMesh 是把 RGB HMR 改寫成 event 點雲版；GRIP 是把 PHC 改接穿戴式感測。

### 4.2 venue 的升級路徑：國內孵化 → 國際
| idea | 國內試水溫 | 國際正式發表 | 間隔 |
|---|---|---|---|
| wrist 360° | MIRU 2021 | ICIP 2021 → IEEE Access 2022 | 約 1 年 |
| event HMR | CVIM 2022 → MIRU / VRSJ 2023（拿獎） | TVCG 2024 | 約 2 年 |
| 足壓 | CCC 2022 → MIRU 2024 | IEEE Access 2025 → **CVPR 2026** | 約 4 年 |

**規律**：idea 先在 MIRU、CVIM、CCC 收回饋（還拿獎），再升級成期刊或頂會。**頂會那篇是最長期累積的那條線，不是最新的 idea。**

### 4.3 CVPR 等級 novelty 的來源
- **不是單點的巧思，而是「自己的長期資產 × host lab 的招牌方法」**：
  - 自己帶去的：足壓與鞋子的 4 年經驗、AIST 硬體、GIP 前導。
  - lab 給的：PHC 和整套物理控制 know-how，還有它的作者直接當共同作者。
- **時機**：在一條線飽和（IMU-only）、一條線剛萌芽（壓力融合）、一條線沒進到這個設定（物理控制）時，取三者交集。
- **貢獻配方**：新設定 + 新架構 + 新資料集，三件一起，讓 reviewer 很難說「只是 A+B」。

---

## 5. 對我的借鏡

### 5.1 對照表

| 學長的要素 | 我手上對應的東西 |
|---|---|
| 長期深耕的冷門模態（足壓） | **RAC / ESC exemplar 機制**，加上碩論的「頻率牆」診斷（Track A） |
| 新的表示空間 | Track B：pose（關節角度）空間；event-ESC：event 空間 |
| host lab 的招牌方法 | HVRL 的 event 累積（EventPointMesh、event 相機硬體、學長姐 code）；未來博士 lab 的方法 |
| 一句話應用理由 | event-ESC：隱私（居家復健、健身）、低光、高 BPM |
| 自建資料集當門檻 | 自拍 **RGB + event 同步**的重複動作資料集（見 `phd_event_pose_memo.md` 2.5） |
| 國內孵化 | MIRU 等國內 venue 先投 event-ESC 或 Track B 的初步結果 |

### 5.2 要記住的三件事
1. **「搬到新空間」本身撐不起 novelty**。學長的論文都講清楚了「原本方法在原空間的結構性缺陷」，例如 IMU drift 就要靠物理來解。我的版本是：**exemplar 在外觀空間為什麼會失敗**（頻率牆、外觀變異），而且新空間要在 zero-shot 泛化或高 BPM 上真的贏 ESC。
2. **頂會題目往往來自累積最久的那條線**。Track B、event-ESC 都踩在碩論的 RAC 累積上，不要每篇換一個全新題目。
3. **找交集要看時機**：event 週期估計（EEPPR 等）只做剛體；RAC 的 pose 路線（D²-STX、PAMS）沒做 event；世界模型的 pose 量尺（HumanScore）沒做週期。這些就是對應「線 1、2、3」的盤點，開工時要重新確認有沒有被填掉。

---

## 6. 有機會問學長的問題（選題方法層面）

技術問題（code、權重、EPMD 有沒有重複動作、時間窗等）已列在 `phd_event_pose_memo.md` 第 7 節。這裡只列選題方法：

1. GRIP 的 idea 是去 CMU 前就有，還是到了 Kitani lab 跟 Zhengyi Luo 討論後才定下來的？
2. 一開始為什麼選足壓、event 這種冷門模態？是先看應用，還是先看沒人做？
3. 國內發表（CCC、MIRU）對後來的頂會版本幫助在哪：是 reviewer 式的回饋，還是確認 idea 有人買單？
4. 怎麼判斷一個題目夠 CVPR，而不是 TVCG 或 Access？
5. 自建資料集（EPMD、PRISM）各花多久？哪一步最花時間？
6. CMU visiting 是怎麼促成的（齋藤老師的管道、DC1 經費，還是自己申請）？

---

## 7. 待核對（開工前）
- [ ] GRIP 比較的 baseline 各自的 venue 和年份（TransPose、PIP、PNP、GlobalPose、MobilePoser、SolePoser、PressInPose、FoRM）。本文只列了名字和順序。
- [ ] 讀 GRIP 全文的 limitation 和 future work，看有沒有留下可以接的空位。
- [ ] 讀 GIP 的 abstract（IEEE Xplore 那天抓不到），確認和 GRIP 的分工。
- [ ] `phd_event_pose_memo.md` 2.7 提到的「event + IMU 第一人稱 pose（MIRU 2026，與 Golyanik 合作）」，這次調查在學長的個人頁和 HVRL 清單上沒看到，要核對。

---

## 8. 來源
- HVRL Publications：https://hvrl.github.io/publications/ ；People：https://hvrl.github.io/people/
- 學長個人頁：https://ryosukehori.github.io ；CV：https://ryosukehori.github.io/cv/ ；Publications：https://ryosukehori.github.io/publications/
- Google Scholar：https://scholar.google.co.in/citations?user=VMIR3zwAAAAJ&hl=en
- GRIP：arXiv https://arxiv.org/abs/2603.16233 ；全文 HTML https://arxiv.org/html/2603.16233 ；專案頁 https://ryosukehori.github.io/grip-project/
- EventPointMesh：專案頁 https://ryosukehori.github.io/EPM_ProjectPage/ ；DOI https://doi.org/10.1109/tvcg.2024.3462816
- GIP：DOI https://doi.org/10.1109/ACCESS.2025.3624393
- Wrist-360：DOI https://doi.org/10.1109/ACCESS.2022.3177623 ；IEEE DataPort https://ieee-dataport.org/documents/silhouette-based-3d-human-pose-estimation-using-single-wrist-mounted-360deg-camera

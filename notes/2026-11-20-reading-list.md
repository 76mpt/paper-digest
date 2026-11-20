# 2026-11-20 待讀清單（依 user 指示記下）

- 來源日報：[digests/2026/2026-11-20.md](../digests/2026/2026-11-20.md)（arXiv 標示日 2026-11-19）
- 這份是**只讀過摘要**的整理，還不是單篇深讀筆記；數字都是作者自報。要深讀時再照 [`_template.md`](_template.md) 各開一份 `<arXiv ID>-<短名>.md`。
- user 指示（2026-11-20）：DiWALI 是**未來重點**；StrideWorld、Does the Action Matter?、WACO 記下；**提醒要看 PRISM**。

## ⏰ 提醒
- **PRISM 還沒看**（第 5 篇）。它是今天唯一一篇週期／重複動作論文，屬於「只要有就一定看」的 RAC 範圍。

## 會議／期刊查核（2026-11-20）
| 論文 | 查到的 venue | 依據 | venue 加分 |
|---|---|---|---|
| DiWALI (2611.24836) | 沒寫 | arXiv comments 空白；專案頁沒查到 venue | 無 |
| StrideWorld (2611.24408) | 沒寫 | arXiv comments 空白；GitHub README 沒查到 venue | 無 |
| Does the Action Matter? (2611.24840) | WACV 2027 WAM-AD **Workshop**（已接受） | arXiv comments | +0.5（二線會議的 workshop） |
| WACO (2611.24360) | 沒寫 | arXiv comments 只寫頁數與專案頁；專案頁沒查到 venue | 無 |
| PRISM (2611.23646) | 沒寫 | arXiv comments 空白 | 無 |

---

## 未來重點

### 1. [DiWALI: Diffusion Policy Learning in World Models via Latent Action Inference from Human and Robot Play](https://arxiv.org/abs/2611.24836) ⭐⭐⭐⭐⭐
- 一句話：inverse dynamics 從人和機器人的 play 影片推 latent action，讓世界模型不需動作標籤；機器人 play 訓的 decoder 把 latent action 轉成機器人指令；skill policy 從無動作標籤的人類示範學起，再在世界模型的想像中用 RL 改進。作者自報：CALVIN 上只用人類示範的 policy 大幅贏過用機器人示範的 baseline，實機上想像 RL 能繼續改進。
- 為什麼是重點：這幾乎是主力論文合體版（latent action 預訓練含人體影片 → 世界模型 → 世界模型內 RL）的完整主幹，只少了我的三個元件：動作結構先驗（碼回歸關節角度變化量、重複動作對應重複碼）、exemplar 指定任務、計數器當 reward／終止。主力論文必須拿它當 baseline，而且要在 related work 裡正面區分。
- 差異點（目前判斷，摘要層級）：
  - 它的任務指定方式摘要沒寫清楚（skill policy 是每個 skill 一個，還是有條件輸入？）。如果是語言或 skill ID，exemplar 指定就是差異點；如果已經用示範影片，差異就縮小到先驗和計數器。
  - 沒有週期任務、沒有量 rollout 漂移。
- 深讀時要查：
  1. latent action 的形式：連續還是 VQ？維度多大？IDM 和 forward model 的架構。
  2. 人類 play 和機器人 play 的比例、資料量；人手和機械手的外觀差距怎麼處理（有沒有 masking、retargeting 或 pose）。
  3. 想像中 RL 用什麼 reward？是學來的成功偵測器、世界模型自帶的判斷，還是環境 reward？這直接對應「計數器當 reward」的切入點。
  4. RL 有沒有鑽世界模型的錯（reward hacking），他們怎麼檢查？
  5. 有沒有 latent action 的探針或消融（呼應 11-17 LASR：預測變好不代表 latent 編碼了動作）？
  6. code 和資料的公開程度，能不能拿來當 50M 重現之外的第二個起點。
- 開源：專案頁 https://diwali.cs.uni-freiburg.de 宣稱公開影片、資料和 code，待確認實際內容。

## 記下

### 2. [StrideWorld: Benchmarking Scene Rigidity and Action Consistency in Interactive Video World Model](https://arxiv.org/abs/2611.24408) ⭐⭐⭐⭐ 🚩
- 一句話：參考值在評估前就固定，不從受測影片擬合。場景剛性對照起始視角的 ground-truth 幾何；動作一致性先在模型自己的前幾步量出每個指令的 stride，再拿它檢查之後的步驟。作者自報：幾乎所有模型都在相機移動時讓場景變形，最多是剛體渲染的 7.3 倍；組合路線常停滯，終點偏離模型自身 stride 的預測。
- 為什麼記：🚩 (b) 量測長程一致性。「用模型自己的前幾步當參考，檢查後面是否漂移」和我打算用前幾下的週期與幅度檢查後續 rollout 的設計同型。先導論文要引用並說清差異：它量的是相機位移，沒有週期、次數、動作節奏。
- 可借用：「參考值不能從受測影片擬合，否則會吸收漸進的漂移」這條原則，要套到計數器量尺上（例如週期不能用整段 rollout 的頻譜估，要用前幾下或外部參考）。另外，它先在已知相機運動的渲染影片上驗證量法、再和人類判斷對齊，這套驗證順序可以照用。
- 深讀時要查：受測的開源模型名單（是否和先導論文的診斷對象重疊）、stride 要用幾步估、估計誤差怎麼處理。
- Code：https://github.com/chuangwang123/strideworld（含 leaderboard）

### 3. [Does the Action Matter? Probing Action-Conditioned Semantic Forecasting as a World Model for Autonomous Driving](https://arxiv.org/abs/2611.24840) ⭐⭐⭐⭐ 🏛️
- 一句話：在 action-conditioned 語意分割預測上，用測試時的 action intervention 量世界模型對動作的依賴，並和**沒有動作輸入的同一架構**比較；量法先在已知動態的合成環境驗證。作者自報：Cityscapes 上正確動作最多只讓 mid-term mIoU 提高 2.5，錯誤動作讓它掉 23.2，低於沒有動作輸入的模型；真實資料上 feature-wise conditioning 對動作的依賴是 input-level 的 1.6 倍，合成環境裡兩者相同。
- 為什麼記：結論「準確度提升只說明模型有用到動作，不說明依賴多強」可以直接寫進先導論文的評估段。「無動作輸入的同架構對照」加「錯誤動作 intervention」可以拿來檢查 latent action 碼是否真的控制 rollout，和 11-17 LASR 是同一類評估。
- 值得注意：真實資料上兩種 conditioning 的差異，在合成環境（歷史無法決定動作）裡消失，代表真實資料的歷史會洩漏動作資訊。週期動作的歷史更能預測下一步，這個洩漏在我的設定裡可能更嚴重，要設計對照。
- Code：https://github.com/binayksingh/does-action-matter

### 4. [Towards Pose-Robust Few-Shot Vision-Language-Action Models](https://arxiv.org/abs/2611.24360)（WACO）⭐⭐⭐⭐
- 一句話：相機被碰歪和底座重新定位是同一件事，都是 policy 記住了相機到底座的外參。WACO 用量到的關節角度經 forward kinematics 擺出手臂，把手臂當公制校正目標，靜態場景當世界錨點，從單張 RGB-D 估計兩種位移，把影像、狀態、動作轉回校正時的座標系，再用自身估計器的誤差微調原本的 policy。作者自報：模擬上位移後成功率 +13.2 點、UR5e 實機 +36.7 點，回收模擬 90%、實機 87% 與 oracle 的差距；也提出 LIBERO-PoseShift benchmark。
- 為什麼記：「外參這類前處理偏差會靜默毀掉 policy」對應研究規則第 3 條（資料流程要能自我檢查）。之後和合作方錄週期性操作 benchmark 時，可以借「手臂經 FK 當校正目標」檢查相機有沒有移動，不需要額外的標定板。
- 深讀時要查：估計器需要 RGB-D，純 RGB 能不能做；靜態場景錨點在場景會動（擦拭、攪拌會移動物體）時是否還成立。
- 專案頁：https://peacelwh.github.io/WACO/

## 提醒要看

### 5. [PRISM: Profiling and Representation of Individual Stereotypical Motion](https://arxiv.org/abs/2611.23646) ⭐⭐⭐⭐ 🚩
- 一句話：用追蹤 mask 加 dense optical flow 刻畫重複動作，不靠固定的 pose landmark：軀幹相對 flow 量強度、逐幀 mask 變化量幅度、signed-flow recurrence 估頻率、滑動視窗的持續幾何描述節律。在 1,890 個合成條件上驗證能還原速度、幅度、頻率；應用到 6 位自閉症受試者的 1,404 段刻板動作；也稽核了兩種 pose 方法、比較 VLM 的頻率估計。
- 為什麼要看：🚩 (c) 週期／重複動作量測。
  - 它主張 pose 漏掉的變化可以用 flow 補上，正好對應 Track B「pose 失效時怎麼辦」，也和 motion energy 頻譜當量尺的做法接近。
  - 「1,890 個受控合成條件驗證量尺能還原速度、幅度、頻率」是我給世界模型 rollout 做週期量尺時可以照抄的驗證流程。
  - 它對 pose 方法的稽核（觀測不完整、依賴處理選擇）可以當 Track B 前處理檢查的參考。
- novelty 威脅：低。它不數次數、不用 exemplar、不碰世界模型。
- 深讀時要查：signed-flow recurrence 估頻率的具體做法，和我的 motion energy 頻譜比較；VLM 頻率估計的結果（VLM 能不能當週期量尺的對照組）；有沒有釋出 code。

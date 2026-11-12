---
name: track-b-phase0
description: "Track B Phase 0 MediaPipe pose quality smoke test — PASSED (5/6 videos det ≥99.9%, skeleton spectra beat frame-diff), failure mode = extreme close-up/truncated body (bench_pressing)"
metadata: 
  node_type: memory
  type: project
  originSessionId: b9271ba2-553d-46b9-83c2-615b1a8e89a0
---

# Track B Phase 0: MediaPipe Pose smoke test（2026-07-07, 本機 Windows）

工具：`pose_smoke_test.py`（mediapipe 0.10.35 **Tasks API**——舊 `mp.solutions` 已移除；model 檔 `pose_landmarker_full.task` 自動下載,~9MB,**勿 commit**）。圖存 `figures/pose_smoke/`。

## 結果（6 部代表性影片）

| video | true BPM | det rate | best joint | est BPM | peakiness |
|-------|---------|----------|-----------|---------|-----------|
| stu3_31 (最快) | 134.6 | **100%** | l_wrist | **140.5** | **61.5** |
| stu4_5 (bench_pressing) | 102.0 | **30% ✗** | — | — | — |
| stu9_57 | 95.6 | 99.9% | nose | 102.2 | 6.8 |
| stu2_25 | 64.4 | 100% | l_wrist | 65.6 | 54.1 |
| stu2_55 (15fps源) | 26.5 | 100% | nose | 38.8/19.4 | 30.6 |
| stu5_12 (慢) | 13.6 | 100% | l_wrist | 16.4 | 35.7 |

## 判定：PASS

1. **快動作不跟丟**：stu3_31 (134.6 BPM) det 100%、wrist 軌跡主峰 140.5 BPM,peakiness 61.5——比 frame-diff 頻譜更乾淨。「MediaPipe 在高頻動作糊掉」的風險排除。
2. **失敗模式明確**：stu4_5 = bench_pressing,鏡頭極近、身體被裁切出框、人體橫躺 + 疑似兩人——pose 結構性失效。**Track B 設計含義：skim branch 需要 graceful degradation（pose confidence 低時 fallback 到 appearance/motion-energy 分支）**。RepCount 裡 bench_pressing 這類近拍臥姿類別要統計占比。
3. **Phase 1 預算便宜**：本機 CPU 單進程 ~75-80 fps → 全 1041 部 ≈ **3.8h**（可再開多進程平分）。

## 其他觀察
- stu2_55（15fps 源）est 偏差最大（38.8 vs 26.5）——低幀率源在 pose 軌跡上一樣吃虧
- stu9_57 只有 nose 有週期性（peakiness 6.8 弱）——動作類型影響哪個關節帶信號 → skim branch 特徵應該用全關節,別手挑

## 下一步（Phase 1 前）
- 統計 RepCount 各動作類型的 det rate（全 dataset 掃一次就有,反正 3.8h）
- Phase 1 輸出格式對齊 motion-energy npz 慣例（per-video npz: traj (T,33,3) + visibility + fps）

## 2026-10-12 待辦(user 交代先記著):stu4_5 類失敗的關節估計器
stu4_5(臥推近拍、身體裁切、躺姿)MediaPipe 偵測率 30% = **整個人沒被偵測到**(person detection 失敗),不是關節角度不夠用。user 指出:Track B 用的是**關節角度**,只要局部關節(手肘/肩)能取得,手肘角度單一訊號就足以反映每一下。→ 之後要測:對裁切穩健的局部/上半身關節估計器(或 MediaPipe 偵測到的 30% 幀裡手肘/手腕的 visibility)。另一個 Track B 論點:frame-diff 運動量 ∝ 動作速度,慢動作訊號幾乎是雜訊;關節角度振幅與速度無關。

---
name: Thesis project — Dual-track RAC research
description: Two parallel research tracks improving ESC baseline for RAC
type: project
originSessionId: 9a1bf529-a4fe-4e89-8ebb-ea77c931c484
modified: 2026-08-06T11:18:29.731Z
---
Master's thesis: elevate "Every Shot Counts" (ESC, ACCV 2024) into a novel Dual-Branch architecture.

**Track A — ESC-Dynamic (Frequency-Aware Dynamic Gating): COMPLETED**
- Replaced primitive MLP query gating in `CrossAttentionB` (model_crossvit_window_attention.py) with 1D-FFT frequency-domain filter.
- Mechanism: project temporal Query to freq domain via `torch.fft.rfft`, isolate high-freq periodicity with power-spectrum `softmax`, generate adaptive time-domain gating mask via `irfft`.
- AMP bug fix: cast to float32 before FFT (cuFFT float16 requires power-of-2 lengths), revert to float16 after.

**Track B — Motion-Exemplar RAC: NEW DIRECTION (2026-07-30, 取代舊 Dual-View 規劃)**
- **舊規劃（Dual-View / Skim-then-Focus 雙分支 + 頻率路由）已廢棄** = 我提的「點3」,user 判定「太工程、學術產出弱」,且在 MoCount 主場競爭還揹外觀包袱。
- **新方向 = Exemplar-guided Motion RAC（單分支）**:
  - 輸入從 VideoMAE 外觀 token 換成 **motion 關節角度**（照 MoCount + SPIE 兩篇的 JAR 發現:角度 >> 原始座標,MoCount ablation 0.174→0.365）
  - **保留 ESC 的 exemplar cross-attention + density map + count head**（現有 code 直接改輸入,大量復用）
  - exemplar 移到 motion 空間
- **核心學術命題（可測,非工程）**:外觀 exemplar 糾纏光照/衣著/背景/視角;motion exemplar（關節角度軌跡）天生對這些不變 → **exemplar 在 motion 空間樣本效率更高、泛化更好**。用 zero-shot UCFRep 驗證,對照組 = ESC 本身（外觀-exemplar,現成數字）。
- **論文框架**:「Exemplar guidance 在不同表示空間的效果研究」——外觀-exemplar(ESC,現成) vs motion-exemplar(新)。對比本身即貢獻。
- **定位**（user 拍板）:碩論為主、可投稿為輔;**近 SOTA 即可不需贏 MoCount**（落 0.19-0.21 + zero-shot 贏 ESC 即成立）。高 BPM 由 motion 的 native-FPS 天生解決,不需專門處理;Track A 高 BPM 分析變成「為何換表示」的動機章。
- **文獻定位**:ESC=外觀+exemplar;MoCount(MM'25 SOTA 0.174)=motion+無exemplar;**我們=motion+exemplar（空白）**。
- 待確認:motion estimator 用 MediaPipe(輕,已驗證)還是對齊 MoCount 的 3D lifting(重)。
- 兩篇 PDF 存於 D:/Research/（140643Y=SPIE規則式偏弱,3746027.3755857=MoCount）。

**執行時序（2026-07-30）**:先把 Track A 收尾（A 過採樣訓練中 + B/C/block2in 剩餘 ablation,強化「外觀打不了高頻」動機章）→ 收完再轉 motion-exemplar。

**💡 新想法備選（2026-08-06, user 突發奇想）:稠密→稀疏 RAC**
- 靈感:自駕商用普遍從稠密（dense BEV/占用網格）轉稀疏（query-based SparseBEV/Sparse4D/DETR式）以減計算量。現有 RAC 皆稠密（ESC 處理全部 token、TransRAC TSM O(n²)）。
- ⚠️ user 自己的顧慮:純「稀疏化求效率」太工程,學術貢獻小。而且 **MoCount 已部分稀疏化**（Key Frame Selector 減 5x frame + Sparse Temporal Attention）並發表 MM'25 → 純效率角度被搶。
- **我的學術化重構（關鍵）:稀疏 vs Nyquist 是同一個張力**。稠密取樣對慢動作浪費（冗餘幀）但對快動作必要（不然 aliasing）;固定稀疏預算會把高頻動作 alias 掉。→ 貢獻 = **頻率自適應稀疏取樣**（Nyquist-aware budget）:快動作分高取樣密度、慢動作分低。這串起我們全部累積（頻率估計/motion energy/路由/Nyquist 分析/高頻焦點）+ 效率,且**不同於 MoCount 的 learned importance（非 per-video-頻率的 budget 自適應）**。
- 定位判斷:可能**folds into motion-exemplar**（motion 本身已比外觀 token 稀疏,頻率自適應 sampler 疊上去=效率故事）,但小心過度擴張碩論範圍;或當 motion-exemplar 之後的延伸。**先擱置,等 Track A 收完 + motion-exemplar 主線定了再評估**。

**Why:** Address high-frequency periodic actions and viewpoint changes — two known RAC weak points. Thesis defense needs rigorous ablation showing each component helps.

**How to apply:** When touching model code, preserve FFT gating integrity. Track B work should integrate (not replace) Track A's FFT gating — Query branch keeps FFT logic.

**Infrastructure state (as of 2026-04-23):**
- `timm.param_groups_weight_decay` deprecation fixed.
- `--resume_from` seamless resume implemented in exemplar_counting_train.py.
- Hard `lim_constraint = 150` in dataloader (OOM guard).
- Git: `feature/esc-dynamic` branch merged with main, pushed to remote.

**RESOLVED (was 2026-04-23 blocker):** Token re-extraction done — RepCount 1036 + UCFRep 105 all present. CPU OOM fixed via chunk-wise normalization in Rep_count.py + uint8 storage. Track A FFT structure present but UNTRAINED (sanity check = identical to baseline; gamma zero-init bypasses FFT). Next: actually train Track A via `--init_from`.

**Server deployment (2026-05-26):** Training moving to lab server `jameschen@DL-BoxVI` (2× RTX 4090, use GPU 1 only via `CUDA_VISIBLE_DEVICES=1`). Conda env `rac` (py3.10, torch 2.5.1+cu121). Data goes on `/mnt/ssd1/jameschen` (SSD, needs admin to chown). Full run steps in repo `SERVER_RUN_CHECKLIST.md`. `save_swim_features.py` refactored to use DataLoader prefetch + resume filter + `--tokens_dir`/`--exemplar_dir` flags. Both train/extract scripts default `--num_gpus 1`.

**ffmpeg / PyAV version isolation:** Training code uses PyAV (`av` package) which BUNDLES its own ffmpeg — independent of the system `/usr/bin/ffmpeg`. Server env is pinned via `pip install "av<13"` to get ffmpeg 6.x (avoiding ffmpeg 7+ swscaler "scaling graph" EAGAIN bug). This isolation is automatic and per-conda-env: changing PyAV version affects only this user, never the system or other users.

**ESC original used `av==10.0.0` (older PyAV → bundled ffmpeg ~5.x).** Current server is on av 12.x via `av<13`. Token-level decode differs slightly from ESC's original tokens. Plan: if Candidate 1A succeeds on av 12 tokens, switch to av 10 in a parallel conda env (`/mnt/ssd1/jameschen/envs/rac_av10`), re-extract all RepCount tokens (~30-60 min on GPU), and re-train Candidate 1A on av-10 tokens to get the "official ESC-environment-aligned" result for thesis. Don't switch mid-training (av-12-trained weights tested on av-10-tokens would conflate decoder mismatch with model effect). Use `conda create -p .../rac_av10 --clone .../rac` then `pip install --force-reinstall av==10.0.0` to test installability without touching the active env.

**📄 MoCount 論文細節(2026-10-12 用 pypdf 讀 D:/Research/3746027.3755857.pdf)**:Table 1 RepCount:ESCounts 0.213/OBO 0.563/OBZ 0.245/RMSE 4.445(引用 ESC 論文)、PoseRAC 0.236/0.560、**MoCount 0.174/0.649/0.297/3.750**;UCFRep:ESC 0.216/0.704 vs MoCount 0.122/0.805;UCFRep zero-shot(只訓 RepCount)0.1697/OBO 0.48。**Table 3 ablation**:全開 0.174;拿掉 KFS 0.211;**拿掉 JAR(關節角度)0.365**;**拿掉 LCE 0.280**;拿掉 CA 0.255;STA+CA 都拿掉 0.345;拿掉 SA 0.617。**LCE = Learnable Class Embedding,把動作類別 c 的 embedding 加到每個 key frame 特徵(K_i + e_c)**,論文說 RepCount/UCFRep 的類別標註「facilitated better performance」→ **看起來推論時用了 GT 類別標籤**(ESC 是類別無關)。不用類別時 MoCount 0.280,比 ESC 0.213 和我們 control 0.2389 都差。⚠️論文內文把 0.365 誤寫成拿掉 LCE,以 Table 3 為準。論文**沒有按速度/類別拆分的結果**。→ Track B 定位加分:motion-exemplar 用 exemplar(類別無關)取代 MoCount 的 GT 類別 embedding。

---
name: rac-lit-2026
description: "Post-MoCount RAC literature scan (2026-10-20) — D²-STX & PAMS (CVPR'26 Findings) are the main threats to Track B; DeTRC overlaps rep-DETR"
metadata:
  node_type: memory
  type: reference
  originSessionId: c76221d9-753a-4fe8-a046-a8020cb57d66
  modified: 2026-10-20T07:26:29.486Z
---

Scan done 2026-10-20 (full PDFs read for D²-STX and PAMS).

- **D²-STX** (CVPR 2026 Findings, Wang/Yu ZJU; code github.com/ZJU-Emerging-AI-Lab/D2-STX) = ESC codebase + pose branch (BlazePose 2D→25kp, NTU-pretrained CTR-GCN, pose exemplar tokens, learnable exemplar tokens at inference). Pose-only branch on RepCount-A: MAE 0.843 / OBO 0.173 (very bad). Fusion SwinT 0.255/0.500 vs their ESC-SwinT 0.298/0.403. Cross-dataset RepCount→UCFRep 0.297/0.643. Does NOT cite MoCount. Closest prior art to Track B ([[project_thesis]]).
- **PAMS** "Count What Repeats" (CVPR 2026 Findings, Gao/Li/Li FJIRSM): self-supervised skeleton TCC + multi-expert peak-detection voting. Claims RepCount 0.129/0.842, Countix 0.098/0.879, Countix→RepCount identical 0.129/0.842; speed 0.1–2.0x flat. No code; how the Period Head is trained is unexplained — treat numbers with suspicion but reviewers will cite it. Same lab: GMFL, BIGC-Net (EAAI'25), SPKDB-Net (CVIU'25 0.210/0.605).
- **DeTRC** "Efficient Action Counting with Dynamic Queries" (IJCV 2026, code lizishi/DeTRC): sparse action queries, linear complexity — overlaps [[project_rep_detr_sparse]].
- Others: TReViS (IVC, arXiv 2609.24367, self-sup synthesis), CountLLM (CVPR'25), HTRM-Net/IVAC-P2L (TMM'25), SkimFocusNet (IJCV'25), PushupBench (2604.23407) & RepProbe (2610.18844) VLM benchmarks.
- No direct MoCount follow-up found; no new paper from Sinha/Stergiou/Damen.

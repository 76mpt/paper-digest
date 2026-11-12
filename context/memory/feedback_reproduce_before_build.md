---
name: reproduce-before-build
description: "Lesson from the 2026-11 fps/truncation bug: official ckpt must reproduce the paper on the exact pipeline before any experiment; unexplained gaps are bugs until a controlled test says otherwise"
metadata:
  node_type: memory
  type: feedback
  originSessionId: ea1a1fca-b01f-406f-867b-2300db0a1542
  modified: 2026-11-06T08:58:48.367Z
---

Before building experiments on any new environment / data pipeline / server, run the official checkpoint with the paper's eval protocol on THAT pipeline and require the paper number (ESC: 0-shot ov 0.213/0.563/0.245/4.455 — now reproduced exactly). Treat any unexplained gap larger than noise as a bug until a cheap controlled test rules it out; never accept a plausible story (e.g. "ffmpeg version") without testing it. Also: check data invariants (decoded frames / token count vs CSV num_frames and video duration), keep ONE canonical data source, and define analysis subsets so they are not confounded with nuisance variables (e.g. native fps).

**Why:** the 2026-05 server migration extracted tokens from 30 fps re-encodes (data_processed) while CSVs were native-fps → 36% of videos truncated for ~5 months. The server gap (0.275 vs local 0.213) was attributed to ffmpeg without a test; the Nyquist/high-BPM narrative fit the artifact, so nobody re-checked the data. Whole dense-line conclusions (caON high-BPM gain, three-walls diagnosis) collapsed on 2026-11-06. See [[fps-pipeline-gap]].

**How to apply:** at any pipeline/environment change, first run the reproduction check and a one-video invariant check (clip/token count vs frames); when a gap appears, propose and run the cheapest discriminating test before writing an explanation into memory; flag deferred "alignment with the paper" items as risks, not as cleanup.

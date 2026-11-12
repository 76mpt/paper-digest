#!/usr/bin/env bash
# 把本機的研究方向 memory 與備忘錄同步到 context/（只在原本那台電腦上執行）
set -e
cd "$(dirname "$0")"
M="/c/Users/USER/.claude/projects/d--Research/memory"
D="/d/Research"
for f in user_profile.md project_phd_world_model_prep.md project_revisiting_esc.md \
         project_thesis.md project_track_b_phase0.md reference_rac_lit_2026.md \
         project_fps_pipeline_gap.md feedback_reproduce_before_build.md; do
  cp "$M/$f" context/memory/
done
for f in phd_direction_memo.md phd_event_pose_memo.md phd_world_model_roadmap.md hori_research_memo.md; do
  cp "$D/$f" context/
done
git add context
git diff --cached --quiet && { echo "context 沒有變更"; exit 0; }
git commit -m "context: sync $(date +%Y-%m-%d)"
git pull --rebase && git push

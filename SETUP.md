# 設定說明：每日論文日報 + 研究脈絡同步

> 建立於 2026-11-12。

## 排程（Routine）

| 項目 | 設定 |
|---|---|
| 名稱 | 每日論文日報（世界模型 / VA） |
| 模型 | `claude-opus-5-5` |
| 時間 | 東京時間週一～五 11:00（cron `0 2 * * 1-5` UTC，配合 arXiv 約 10:00 公布新論文） |
| 輸出 | `digests/YYYY/YYYY-MM-DD.md`，並更新 `README.md` 的索引和 `seen_ids.txt` |
| 管理頁面 | https://claude.ai/code/routines/trig_01RGYX5ZuksqEddEk3xLG1VL |

**排程本身不用在任何電腦上啟動。** 它跑在 Anthropic 的雲端，綁 Claude 帳號，兩台電腦都關機也照常每天產出。要改追蹤範圍、時間或模型，在管理頁面改，或請主力電腦的 Claude Code 用 RemoteTrigger 更新。

追蹤比重：世界模型 / VA 約 60–70%，Pose 約 15–20%，RAC 加 event camera 約 10%。可能威脅 novelty 的論文會標 🚩。

## 在另一台電腦上使用

### 1. 看日報
最簡單是直接用 GitHub 網頁或手機 app 開 `76mpt/paper-digest`。想在本機看的話：

```bash
git clone https://github.com/76mpt/paper-digest.git
cd paper-digest
git pull   # 之後每天執行這行就能拿到新日報
```

### 2. 讓那台的 Claude Code 知道研究方向
- **方法 A**：用 VS Code 開 clone 下來的 `paper-digest` 資料夾，再啟動 Claude Code。它會自動讀 repo 裡的 `CLAUDE.md`，載入研究規則、博士方向備忘錄和博士方向 memory。第一次可能會問要不要允許載入引用的檔案，選允許。
- **方法 B**：如果在那台電腦是在**別的專案資料夾**工作，就在那台的 `C:\Users\<使用者名稱>\.claude\CLAUDE.md` 加一行（路徑換成實際 clone 的位置），例如：

  ```
  @C:/Users/你的使用者名稱/paper-digest/CLAUDE.md
  ```

  這樣不管在哪個資料夾開 Claude Code，都會帶著研究脈絡。兩台電腦都要登入同一個 Claude 帳號。

### 3. 同步是單向的
- 主力電腦的 memory 更新後，在主力電腦執行 `bash /d/Research/paper-digest/sync_context.sh`，就會推上 GitHub；另一台 `git pull` 就拿到。也可以直接叫主力電腦的 Claude Code 同步。
- 在另一台電腦上新產生的 memory **不會**自動傳回主力電腦。那邊有重要結論的話，要帶回主力電腦再告訴 Claude。
- `context/` 只由 `sync_context.sh` 更新，不要在其他地方手動修改。

## 待處理

- [ ] **event camera 追蹤要不要保留？** 這是額外加的（教授建議的 event-ESC 方向）。不需要的話，請 Claude 改 routine 的 prompt 拿掉。
- [ ] **撤銷 RAC_Research 的 GitHub token**：`RAC_Research` 的 git remote URL 裡寫著明碼 token（存在 `.git/config`）。到 GitHub → Settings → Developer settings → Personal access tokens 撤銷，再改用 Git Credential Manager 登入。

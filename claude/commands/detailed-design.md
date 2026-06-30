# Detailed Design — 詳細設計を Obsidian に出力

機能・改修の詳細設計を、定型テンプレートに沿って Obsidian の `system-design` に出力します。

## 出力先・テンプレート（固定）

- **テンプレート**: `/Volumes/EXSSD/dev/github.com/0123takaokeita/vault/templates/claude-detailed-design.md`
- **出力先**: `/Volumes/EXSSD/dev/github.com/0123takaokeita/vault/claude/system-design/<slug>.md`
  - `<slug>` は機能名の英小文字ケバブ（例: `aggregate-value-filter`）。
  - 詳細設計（detailed design / 詳細設計 / システム設計）を書き出す依頼は、原則ここに出力する。

## 手順

### 0. 事前情報を収集する（最初に必ず実行）

```bash
date +"%Y-%m-%d" && ls /Volumes/EXSSD/dev/github.com/0123takaokeita/vault/claude/system-design/
```

- 日付 → frontmatter の `date` に使用。
- 既存ファイル一覧 → 同じ機能の設計が既にあれば**追記/更新**（新規乱立を避ける）。

### 1. テンプレートを読む

`templates/claude-detailed-design.md` を読み、セクション構成（背景・目的 / 要件 / 現状分析 / 設計 / 実装計画 / テスト戦略 / 未解決事項 / 決定ログ）を踏襲する。

### 2. 前提をユーザーとすり合わせる

書き始める前に、**設計の前提・スコープを 1〜2 点だけ確認**する（前提ズレを防ぐ）。
特に「どこまでを今回スコープに含めるか」「どのレイヤーが何を担うか」を明示する。

### 3. テンプレートを埋める

- `> [!info] Claudeへの指示` の authoring 用 callout は**実コンテンツに置き換える**（指示文は残さない）。`> [!warning] 要確認` は残してよい。
- 図は mermaid（graph / sequenceDiagram）を活用し、**データフロー**と**コンポーネント構成**を必ず描く。
- 実装済みのタスクは実装計画で `[x]`、未着手は `[ ]` で表す。
- frontmatter は `title` / `date`（手順0の日付）/ `tags: [design, claude]` / `status: draft`。
- 関連ノートは `[[...]]` でリンクする。

### 4. 出力する

`claude/system-design/<slug>.md` に書き出す（既存があれば更新）。

### 5. 完了を報告する

保存パスと、設計の要点・未解決事項を 1〜2 行で報告する。

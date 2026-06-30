# Task Diary — セッション学習の記録

このセッションで得た学びを Obsidian の Task Diary に記録します。

## 手順

### 0. 事前情報を収集する（最初に必ず実行）

以下のコマンドをまとめて実行し、状態を把握してから作業を開始する：

```bash
date +"%Y-%m-%dT%H%M" && date +"%Y-%m-%d %H:%M" && pwd && echo "${CLAUDE_SESSION_ID:-unknown}"
```

取得した情報から：
- `YYYYMMDDTHHMM` → ファイル名に使用
- `YYYY-MM-DD HH:MM` → エントリヘッダーに使用
- pwd → プロジェクト名を推定
- `CLAUDE_SESSION_ID` → ファイル名に使用（unknown の場合はタイムスタンプのみ）

### 1. セッションを振り返る

**環境変数 `CLAUDE_TRANSCRIPT_FILE` が設定されている場合**:

```bash
cat "$CLAUDE_TRANSCRIPT_FILE"
```

を実行してそのトランスクリプトを「現在のセッション」として扱う。

**設定されていない場合**:
現在のセッション全体を振り返る。

以下の4観点で学びを抽出してください：

- **うまくいったこと**: 有効だった手法・アプローチ・コマンド
- **うまくいかなかったこと**: 失敗・エラー・ハマった点とその回避策
- **発見**: 新しく分かった仕様・挙動・知識
- **次回への申し送り**: 中断タスク・続きでやるべきこと

抽出できる項目がない観点はスキップしてよい。

### 2. ファイル名と保存先を決める

- プロジェクト名: 現在の作業ディレクトリから推定（例: `vault`, `flyle-nexus`）
- ファイル名形式: `<YYYY-MM-DDTHHMM>-<session_id_short>.md`
  - `session_id_short` は `CLAUDE_SESSION_ID` の先頭8文字
  - `CLAUDE_SESSION_ID` が unknown の場合は `<YYYY-MM-DDTHHMM>.md`
- 保存先: `/Volumes/EXSSD/dev/github.com/0123takaokeita/vault/claude/task-diary/<project-name>/`

例: `flyle-nexus/2026-06-29T1530-095c214e.md`

保存先ディレクトリが存在しない場合は作成する：
```bash
mkdir -p /Volumes/EXSSD/dev/github.com/0123takaokeita/vault/claude/task-diary/<project-name>/
```

### 3. Obsidian の Task Diary ファイルを新規作成する

以下のフォーマットで作成する：

```markdown
---
tags:
  - type/task-diary
  - project/<project-name>
session_id: <CLAUDE_SESSION_ID>
date: <YYYY-MM-DD>
---

# Task Diary — <project-name> <YYYY-MM-DD HH:MM>

### うまくいったこと
- ...

### うまくいかなかったこと
- ...（回避策も記載）

### 発見
- ...

### 次回への申し送り
- [ ] ...
```

### 4. 完了を報告する

保存したファイルパスと、記録したエントリの要点を1〜2行で報告する。

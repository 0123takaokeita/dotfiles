---
created: 2026-03-01T11:57
updated: 2026-03-01T19:11
---
# Cursor 用設定（dotfiles）

プロジェクトに依存しない **Cursor の汎用設定**を置くディレクトリ。ルール・コマンド・スキル・参照用の規約ドキュメントをここで管理し、dotfiles で持ち歩く想定。

## 構成

```
cursor/
├── rules/          # Cursor ルール（.mdc）。プロジェクトの .cursor/rules/ にリンクして使う
├── commands/       # スラッシュコマンド（.md）。~/.cursor/commands にリンク
├── skills/         # スキル（SKILL.md）。~/.cursor/skills にリンク
├── tools/          # 汎用ツール。検索・実行手順など。コマンド・agents から参照
│   └── README.md
├── agents/         # 委譲用エージェント定義。直下の .md が認識される（design.md, test.md 等）
│   └── README.md
├── *.md            # 規約・スタイルなどの参照用ドキュメント（ルールやコマンドから参照）
└── README.md       # 本ファイル
```

## Cursor で使う

### コマンド（ユーザー設定）

```bash
ln -sf ~/dotfiles/cursor/commands ~/.cursor/commands
```

### スキル（ユーザー設定）

スキルを Cursor で使うには、`~/.cursor/skills/` に各スキルをリンクする。

```bash
mkdir -p ~/.cursor/skills
ln -sf ~/dotfiles/cursor/skills/laravel-review ~/.cursor/skills/laravel-review
ln -sf ~/dotfiles/cursor/skills/laravel-lint   ~/.cursor/skills/laravel-lint
# 追加したスキルがある都度、同様に ln -sf する
```

### ルール（プロジェクト設定のみ）

ルールはユーザー設定のパスでは読まれない。各プロジェクトの `.cursor/rules/` にリンクまたはコピーする。

```bash
mkdir -p .cursor/rules
ln -sf ~/dotfiles/cursor/rules/laravel.mdc .cursor/rules/
```

### Agents（ユーザー設定）

Cursor は `.cursor/agents/` 直下の .md のみ認識する。dotfiles の agents をリンクする。

```bash
ln -sf ~/dotfiles/cursor/agents ~/.cursor/agents
```

### ツール・Agents

`tools/` は Cursor が直接読みに来るパスではない。コマンドやスキル・ルールの指示文で「`~/dotfiles/cursor/tools/` を参照せよ」と書いて使う。`agents/` は **`.cursor/agents/` にリンクすると Cursor が直下の .md を認識する**。委譲（mcp_task）するときは対応する `agents/{role}.md`（例: `design.md`, `test.md`）を読んで prompt を組み立てる想定。

## 追加の仕方

- **コマンド**: `commands/` に `.md` を追加。ファイル名が `/コマンド名` になる。
- **スキル**: `skills/<skill-name>/SKILL.md` を追加。同じ内容をコマンドとスキル両方で使う場合は、`disable-model-invocation: true` にするとコマンド同様「呼ばれたときだけ」動く。
- **ルール**: `rules/` に `.mdc` を追加。プロジェクトで使うときはそのプロジェクトの `.cursor/rules/` にリンクする。
- **ツール**: `tools/` に汎用手順の .md を追加。agents の .md の references やコマンドから参照する。
- **Agent**: `agents/{role}.md` を追加・編集（例: `design.md`, `test.md`）。直下の .md のみ Cursor に認識される。役割ごとの委譲用の説明・prompt テンプレを定義する。
- **規約・参照ドキュメント**: `cursor/` 直下などに .md を置き、ルールやコマンド・スキルの指示で「このファイルを参照」と書く。

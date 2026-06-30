# claude

Claude Code（`~/.claude`）の設定を dotfiles で管理する。
wezterm / tmux などと同じく、dotfiles 側を実体としてシンボリックリンクを張る。

## 管理対象

| dotfiles                  | リンク先                    |
| ------------------------- | --------------------------- |
| `claude/settings.json`    | `~/.claude/settings.json`   |
| `claude/CLAUDE.md`        | `~/.claude/CLAUDE.md`       |
| `claude/statusline.py`    | `~/.claude/statusline.py`   |
| `claude/hooks/`           | `~/.claude/hooks`           |
| `claude/scripts/`         | `~/.claude/scripts`         |
| `claude/commands/`        | `~/.claude/commands`        |

`sessions` / `cache` / `history.jsonl` / `projects` などのランタイム生成物は管理対象外。

## セットアップ

```sh
sh ~/dotfiles/claude/setup.sh
```

既存の実体があれば `*.bak` に退避してからリンクを張る（安全に再実行可能）。

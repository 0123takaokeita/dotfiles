#!/bin/bash
# SessionEnd フックで task-diary を自動実行する
# session_id から .jsonl を読み取り、トランスクリプトを claude -p に渡す

set -euo pipefail

# task-diary が起動した子セッションでは実行しない（無限ループ防止）
if [ "${TASK_DIARY_SESSION:-}" = "1" ]; then
  exit 0
fi

# stdin から session_id を取得
SESSION_ID=$(python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_id',''))" 2>/dev/null || echo "")
if [ -z "$SESSION_ID" ]; then
  exit 0
fi

# プロジェクトキーを構築（/ と . を - に変換）
PROJECT_KEY=$(echo "$PWD" | tr '/.' '-')
TRANSCRIPT_FILE="$HOME/.claude/projects/$PROJECT_KEY/$SESSION_ID.jsonl"

if [ ! -f "$TRANSCRIPT_FILE" ]; then
  exit 0
fi

# トランスクリプトをテンポラリファイルに抽出
TEMP_TRANSCRIPT="/tmp/claude-transcript-$SESSION_ID.txt"
python3 "$HOME/.claude/scripts/extract-transcript.py" "$TRANSCRIPT_FILE" > "$TEMP_TRANSCRIPT" 2>/dev/null

if [ ! -s "$TEMP_TRANSCRIPT" ]; then
  rm -f "$TEMP_TRANSCRIPT"
  exit 0
fi

# task-diary スキルの内容を読み込む
TASK_DIARY_SKILL=$(cat "$HOME/.claude/commands/task-diary.md" 2>/dev/null || echo "")
if [ -z "$TASK_DIARY_SKILL" ]; then
  rm -f "$TEMP_TRANSCRIPT"
  exit 0
fi

LOG_FILE="/tmp/claude-task-diary-$SESSION_ID.log"

# CLAUDE_SESSION_ID と CLAUDE_TRANSCRIPT_FILE を環境変数で渡してバックグラウンド実行
nohup env \
  CLAUDE_SESSION_ID="$SESSION_ID" \
  CLAUDE_TRANSCRIPT_FILE="$TEMP_TRANSCRIPT" \
  TASK_DIARY_SESSION="1" \
  claude -p --dangerously-skip-permissions "以下のスキル定義に従って task-diary を実行してください。

$TASK_DIARY_SKILL" \
  > "$LOG_FILE" 2>&1 &

exit 0

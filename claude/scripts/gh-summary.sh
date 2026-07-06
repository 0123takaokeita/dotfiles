#!/usr/bin/env bash
#
# gh-summary.sh — 自分の GitHub 状況を Markdown サマリーにして Obsidian に出力する
#
# 配置方針: script は dotfiles、出力（読み物）は Obsidian vault
#   - script : ~/dotfiles/claude/scripts/gh-summary.sh
#   - 出力   : <vault>/claude/summary/gh-summary-YYYY-MM-DD.md
#
# 使い方:
#   gh-summary.sh                 # 既定リポジトリのサマリーを生成
#   REPO=owner/name gh-summary.sh # リポジトリを上書き
#
set -euo pipefail

# --- 設定 -------------------------------------------------------------------
REPO="${REPO:-flyle-io/flyle-nexus}"
VAULT="${VAULT:-/Users/takaokeita/vault}"
OUT_DIR="${OUT_DIR:-$VAULT/claude/summary}"
LIMIT="${LIMIT:-30}"

# --- 前提チェック -----------------------------------------------------------
command -v gh >/dev/null 2>&1 || { echo "error: gh CLI が見つかりません" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "error: jq が見つかりません" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "error: gh 未ログイン (gh auth login)" >&2; exit 1; }

ME="$(gh api user --jq .login)"
DATE="$(date +%Y-%m-%d)"
NOW="$(date '+%Y-%m-%d %H:%M')"
# 「直近」= 過去24時間（GitHub 検索用に UTC ISO8601 で算出）
SINCE="$(date -u -v-24H '+%Y-%m-%dT%H:%M:%SZ')"
mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/gh-summary-$DATE.md"

# --- ヘルパ: PR/Issue の JSON を Markdown リストに整形 -----------------------
# stdin: gh の JSON 配列 / 引数: なし。空なら "なし" を出す。
to_list() {
  jq -r '
    if length == 0 then "_なし_"
    else
      .[] | "- [#\(.number)](\(.url)) \(.title)"
        + (if .isDraft == true then " `Draft`" else "" end)
        + (if (.reviewDecision // "") == "APPROVED" then " `Approved`"
           elif (.reviewDecision // "") == "CHANGES_REQUESTED" then " `要修正`"
           else "" end)
        + (if .author.login? then " — @\(.author.login)" else "" end)
    end
  '
}

# stdin: merged PR の JSON 配列（mergedAt を含む）。新しい順に日付付きで並べる。
to_merged_list() {
  jq -r '
    if length == 0 then "_なし_"
    else
      sort_by(.mergedAt) | reverse | .[]
      | "- \(.mergedAt[0:10]) [#\(.number)](\(.url)) \(.title)"
        + (if .author.login? then " — @\(.author.login)" else "" end)
    end
  '
}

# --- データ取得 -------------------------------------------------------------
my_prs="$(gh pr list --repo "$REPO" --author '@me' --state open --limit "$LIMIT" \
  --json number,title,url,isDraft,reviewDecision 2>/dev/null || echo '[]')"

review_reqs="$(gh pr list --repo "$REPO" --search "review-requested:@me state:open" --limit "$LIMIT" \
  --json number,title,url,author 2>/dev/null || echo '[]')"

my_issues="$(gh issue list --repo "$REPO" --assignee '@me' --state open --limit "$LIMIT" \
  --json number,title,url 2>/dev/null || echo '[]')"

merged_prs="$(gh pr list --repo "$REPO" --search "author:@me is:merged merged:>=$SINCE" --limit "$LIMIT" \
  --json number,title,url 2>/dev/null || echo '[]')"

# リポジトリ全体の直近マージ（全作者。bot/リリース PR も含む）。件数が多いので上限は広めに取る。
repo_merged="$(gh pr list --repo "$REPO" --state merged --search "merged:>=$SINCE sort:updated-desc" --limit "${REPO_LIMIT:-100}" \
  --json number,title,url,author,mergedAt 2>/dev/null || echo '[]')"

# --- 出力 -------------------------------------------------------------------
{
  echo "---"
  echo "title: GH Summary $DATE"
  echo "repo: $REPO"
  echo "user: $ME"
  echo "generated: $NOW"
  echo "tags: [gh-summary]"
  echo "---"
  echo
  echo "# GitHub サマリー ($DATE)"
  echo
  echo "> \`$REPO\` / @$ME / $NOW 時点"
  echo
  echo "## 🔧 自分のオープン PR ($(echo "$my_prs" | jq 'length'))"
  echo "$my_prs" | to_list
  echo
  echo "## 👀 レビュー依頼 ($(echo "$review_reqs" | jq 'length'))"
  echo "$review_reqs" | to_list
  echo
  echo "## 📌 自分にアサインされた Issue ($(echo "$my_issues" | jq 'length'))"
  echo "$my_issues" | to_list
  echo
  echo "## ✅ 自分が直近マージした PR (過去24時間 / $(echo "$merged_prs" | jq 'length'))"
  echo "$merged_prs" | to_list
  echo
  echo "## 🚀 リポジトリ全体の直近マージ (過去24時間 / $(echo "$repo_merged" | jq 'length'))"
  echo "$repo_merged" | to_merged_list
  echo
} > "$OUT"

echo "$OUT"

#!/usr/bin/env python3
"""Claude Code status line — アイコン付きカラフル版。stdin の JSON を 1 行に整形する。"""
import sys, json, os, re, subprocess, time, urllib.request

TOOL_ICONS = {
    "Bash": "💻", "Edit": "✏️", "Write": "📝", "Read": "📖",
    "Grep": "🔍", "Glob": "🔍", "Agent": "🤖", "Task": "🤖",
    "WebFetch": "🌐", "WebSearch": "🌐", "TodoWrite": "✅",
    "NotebookEdit": "📓", "ExitPlanMode": "📋",
}

# ── プラン利用状況（5時間 / 週次 / モデル別）の取得設定 ──────────────
# stdin JSON にはプラン残量が含まれないため、未文書化の OAuth usage API を叩く。
# status line は高頻度で呼ばれるので 180 秒キャッシュ + 裏更新で描画を遅くしない。
USAGE_CACHE = "/tmp/claude-statusline-usage.json"
USAGE_CACHE_AGE = 180  # 秒
USAGE_API = "https://api.anthropic.com/api/oauth/usage"


def color(code, s):
    return f"\033[{code}m{s}\033[0m"


def _read_token():
    """macOS Keychain（無ければ ~/.claude/.credentials.json）から OAuth アクセストークンを読む。"""
    raw = None
    try:
        raw = subprocess.run(
            ["security", "find-generic-password", "-s", "Claude Code-credentials", "-w"],
            capture_output=True, text=True, timeout=2,
        ).stdout.strip()
    except Exception:
        raw = None
    if not raw:
        try:
            with open(os.path.expanduser("~/.claude/.credentials.json")) as f:
                raw = f.read()
        except Exception:
            return None
    try:
        return (json.loads(raw).get("claudeAiOauth") or {}).get("accessToken")
    except Exception:
        return None


def _fetch_usage():
    """usage API を叩いて生 JSON を返す。失敗時は None。"""
    token = _read_token()
    if not token:
        return None
    req = urllib.request.Request(USAGE_API, headers={
        "Authorization": f"Bearer {token}",
        "anthropic-beta": "oauth-2025-04-20",
        "Content-Type": "application/json",
    })
    try:
        with urllib.request.urlopen(req, timeout=3) as r:
            return json.loads(r.read().decode())
    except Exception:
        return None


def _write_cache(data):
    try:
        tmp = USAGE_CACHE + f".{os.getpid()}.tmp"
        with open(tmp, "w") as f:
            json.dump({"ts": time.time(), "data": data}, f)
        os.replace(tmp, USAGE_CACHE)
    except Exception:
        pass


def refresh_usage():
    """バックグラウンド更新用: API を叩いてキャッシュを書くだけ。"""
    data = _fetch_usage()
    if data is not None:
        _write_cache(data)


def get_usage():
    """usage データを取得。キャッシュが新鮮ならそれを、古ければ裏更新を投げつつ古い値を返す。"""
    cache = None
    try:
        with open(USAGE_CACHE) as f:
            cache = json.load(f)
    except Exception:
        cache = None

    if cache is None:
        # 初回のみ同期取得（以降はキャッシュ経由で即返る）
        data = _fetch_usage()
        if data is not None:
            _write_cache(data)
        return data

    if time.time() - cache.get("ts", 0) > USAGE_CACHE_AGE:
        # 古い → 裏で更新プロセスを detach し、今回は古い値を即返す（stale-while-revalidate）
        try:
            subprocess.Popen(
                [sys.executable, os.path.abspath(__file__), "--refresh-usage"],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True,
            )
        except Exception:
            pass
    return cache.get("data")


def cyber_bar(pct, width=8, lo=50, hi=80, high_color="1;31"):
    """▰▰▱▱ スタイルのゲージ（Cyber Bar）を 1 本の文字列に整形して返す（色付き）。"""
    pct = max(0.0, min(100.0, float(pct)))
    filled = int(round(pct / 100 * width))
    b = "▰" * filled + "▱" * (width - filled)
    c = "32" if pct < lo else ("33" if pct < hi else high_color)  # 緑 / 黄 / 赤
    return color(c, f"{b} {pct:.0f}%")


def usage_parts(d):
    """プラン残量を部品リストに整形。5h/週は stdin の rate_limits を優先し、モデル別枠のみ API を使う。"""
    out = []
    # ① stdin の rate_limits（v2.1.198 以降は Claude Code 本体が渡してくる）
    rl = d.get("rate_limits") or {}
    five = (rl.get("five_hour") or {}).get("used_percentage")
    seven = (rl.get("seven_day") or {}).get("used_percentage")

    # ② stdin に無ければ usage API（キャッシュ経由）にフォールバック
    u = get_usage()
    if five is None and u:
        five = (u.get("five_hour") or {}).get("utilization")
    if seven is None and u:
        seven = (u.get("seven_day") or {}).get("utilization")

    if five is not None:
        out.append(color("1;37", "5h") + " " + cyber_bar(five))
    if seven is not None:
        out.append(color("1;37", "week") + " " + cyber_bar(seven))

    # モデル別の週次枠（Fable 等）は API にしか無い。使い始めて percent>0 のときだけ出す。
    for lim in ((u or {}).get("limits") or []):
        if lim.get("kind") == "weekly_scoped" and (lim.get("percent") or 0) > 0:
            mname = (((lim.get("scope") or {}).get("model") or {}).get("display_name")) or "model"
            out.append(color("1;37", mname + " week") + " " + cyber_bar(lim.get("percent")))

    # 月次の「追加クレジット」（プラン超過後に使う extra usage）。有効化している場合のみ存在する。
    # ※ プラン本体の上限は 5h と週のローリングのみで、月次枠というものは無い。
    extra = (u or {}).get("extra_usage") or {}
    if extra.get("is_enabled") and extra.get("utilization") is not None:
        out.append(color("1;37", "month") + " " + cyber_bar(extra.get("utilization")))
    return out


def get_effort(d):
    """effort レベル（ライブ値）を取得する。payload の effort.level を読む。"""
    eff = d.get("effort")
    # payload では {"level": "high"} のオブジェクト形式で来る
    if isinstance(eff, dict):
        lvl = eff.get("level")
        if lvl:
            return lvl
    # 文字列で来る場合にも一応対応
    if isinstance(eff, str) and eff:
        return eff
    # フォールバック: settings.json の effortLevel（保存された既定値）
    try:
        with open(os.path.expanduser("~/.claude/settings.json")) as f:
            return (json.load(f) or {}).get("effortLevel")
    except Exception:
        return None


def format_duration(ms):
    """ミリ秒を 1h23m / 45m12s のような短い表記に整形する。"""
    total_sec = int(ms / 1000)
    h, rem = divmod(total_sec, 3600)
    m, s = divmod(rem, 60)
    if h:
        return f"{h}h{m:02d}m"
    return f"{m}m{s:02d}s"


# セッション状態 → (色付き丸アイコン, ラベル)
STATE_INFO = {
    "working": ("🟩", "作業中"),
    "review": ("🟨", "レビュー"),
    "error": ("🟥", "エラー"),
    "idle": ("🟦", "待機"),
}


def _infer_state(mtype, msg, content):
    """1 件のメッセージ（transcript 上で最も新しいもの）からセッション状態を判定する。"""
    if mtype == "assistant":
        if msg.get("stop_reason") == "tool_use":
            for block in reversed(content):
                if isinstance(block, dict) and block.get("type") == "tool_use":
                    return "review" if block.get("name") == "ExitPlanMode" else "working"
            return "working"
        return "idle"  # end_turn 等 → ターン完了、ユーザー入力待ち
    if mtype == "user":
        results = [b for b in content if isinstance(b, dict) and b.get("type") == "tool_result"]
        if results:
            return "error" if any(r.get("is_error") for r in results) else "working"
        return "working"  # 純粋なユーザープロンプト（これから応答する）
    return None


def get_transcript_state(transcript_path):
    """transcript の末尾を軽く読んで (直近ツール名, セッション状態) を返す。見つからなければ (None, None)。"""
    if not transcript_path:
        return None, None
    try:
        size = os.path.getsize(transcript_path)
        read_size = min(size, 65536)  # 末尾 64KB だけ読む（statusline は高頻度に呼ばれるため）
        with open(transcript_path, "rb") as f:
            f.seek(-read_size, os.SEEK_END)
            chunk = f.read().decode("utf-8", errors="ignore")
    except Exception:
        return None, None

    last_tool = None
    state = None
    checked_newest = False
    for line in reversed(chunk.splitlines()):
        line = line.strip()
        if not line:
            continue
        try:
            obj = json.loads(line)
        except Exception:
            continue  # シークで途中から読んだ行が壊れていても無視して次へ
        content = (obj.get("message") or {}).get("content")
        if not isinstance(content, list):
            continue  # last-prompt / ai-title など message を持たない行はスキップ

        if not checked_newest:
            # 状態は「一番新しいメッセージ 1 件」だけで判定する（古い行まで遡らない）
            state = _infer_state(obj.get("type"), obj.get("message") or {}, content)
            checked_newest = True

        if last_tool is None:
            for block in reversed(content):
                if isinstance(block, dict) and block.get("type") == "tool_use":
                    last_tool = block.get("name")
                    break

        if last_tool is not None and checked_newest:
            break

    return last_tool, state


def git_ahead_behind(cur):
    """upstream に対する ahead/behind コミット数を返す。upstream 未設定などは (None, None)。"""
    try:
        out = subprocess.run(
            ["git", "-C", cur, "rev-list", "--left-right", "--count", "@{u}...HEAD"],
            capture_output=True, text=True, timeout=1,
        )
        if out.returncode != 0:
            return None, None
        behind, ahead = out.stdout.strip().split()
        return int(ahead), int(behind)
    except Exception:
        return None, None


def git_diff_stat(cur):
    """HEAD に対する working tree（tracked のみ）の追加/削除行数を返す。"""
    try:
        out = subprocess.run(
            ["git", "-C", cur, "diff", "HEAD", "--shortstat"],
            capture_output=True, text=True, timeout=1,
        ).stdout.strip()
    except Exception:
        return 0, 0
    added = removed = 0
    m = re.search(r"(\d+) insertion", out)
    if m:
        added = int(m.group(1))
    m = re.search(r"(\d+) deletion", out)
    if m:
        removed = int(m.group(1))
    return added, removed


def main():
    # バックグラウンド更新モード（get_usage が detach 起動する）
    if "--refresh-usage" in sys.argv:
        refresh_usage()
        return
    try:
        d = json.load(sys.stdin)
    except Exception:
        print("statusline: JSON parse error")
        return

    # デバッグ用: 最後に受け取った入力 JSON を残す（cost が来ない等の調査に使う）
    try:
        with open("/tmp/claude-statusline-last-input.json", "w") as f:
            json.dump(d, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

    # 3 行構成 = 3 カテゴリ: ① セッション基本情報（名前/モデル/経過時間）
    # ② 今の状況（ディレクトリ/git/直近アクティビティ） ③ リソース（コンテキスト/プラン残量）
    # 端末幅で末尾（残量ゲージ）が切れないよう、各部品をコンパクトに保つ。
    title_parts = []
    parts = []

    # ── 1 行目: セッション基本情報（名前 → モデル → 経過時間） ──────────
    # 🏷️ セッション名（環境変数で手動命名があれば優先、無ければ Claude Code 自動命名）
    name = os.environ.get("CLAUDE_SESSION_NAME") or d.get("session_name")
    if name:
        # if len(name) > 20:
        #     name = name[:19] + "…"  # 長い自動命名で行が溢れないよう切り詰め
        title_parts.append("🏷️ " + color("1;35", name))  # bold magenta

    # ✳️ モデル名（＋ ⚡ effort をすぐ横に）。✳️ は Anthropic のアスタリスク型ブランドマークに近い見た目
    model = (d.get("model") or {}).get("display_name") or (d.get("model") or {}).get("id") or "?"
    mkey = (model + " " + ((d.get("model") or {}).get("id") or "")).lower()
    # モデル系統でアイコンを出し分け（Claude のマスコット絵文字は Unicode に無いため ✳️ で代用）
    if "opus" in mkey:
        micon = "👑"   # 最上位
    elif "sonnet" in mkey:
        micon = "🚀"   # 中位
    elif "haiku" in mkey:
        micon = "⚡️"   # 軽量
    elif "fable" in mkey:
        micon = "🧚"
    else:
        micon = "✳️"
    model_part = micon + " " + color("1;36", model)  # bold cyan
    eff = get_effort(d)
    if eff:
        # effort で色変化: low グレー / medium シアン / high 黄 / xhigh・max 赤
        ec = {"low": "90", "medium": "36", "high": "33", "xhigh": "31", "max": "1;31"}.get(eff.lower(), "33")
        model_part += " " + color(ec, "⚡" + eff)
    # 🚀 fast モード（/fast が ON のときだけ表示）
    if d.get("fast_mode"):
        model_part += " " + color("1;33", "🚀FAST")
    title_parts.append(model_part)

    # ⏱️ セッション経過時間（ウォールクロック）
    duration_ms = (d.get("cost") or {}).get("total_duration_ms")
    if duration_ms:
        title_parts.append("⏱️ " + color("36", format_duration(duration_ms)))

    # ── 2 行目: 今の状況（環境 → 直近アクティビティ） ──────────────────
    # 📁 カレントディレクトリ（basename）
    cur = (d.get("workspace") or {}).get("current_dir") or os.getcwd()
    parts.append("📁 " + color("1;34", os.path.basename(cur.rstrip("/")) or "/"))  # bold blue

    # 🌿 Git ブランチ + 変更有無
    try:
        branch = subprocess.run(
            ["git", "-C", cur, "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True, text=True, timeout=1,
        ).stdout.strip()
    except Exception:
        branch = None
    if branch:
        branch_part = color("35", branch)
        mark = ""
        try:
            # untracked のスキャンは重い（このリポジトリで >1s）ので追跡済みの変更だけ見る
            dirty = subprocess.run(
                ["git", "-C", cur, "status", "--porcelain", "--untracked-files=no"],
                capture_output=True, text=True, timeout=1,
            ).stdout.strip()
            mark = color("1;33", " ●") if dirty else color("1;32", " ✓")  # 黄●=変更あり / 緑✓=clean
        except Exception:
            pass  # dirty 判定に失敗してもブランチ名は出す

        # +42/-7 の追加/削除行数（tracked ファイルの未コミット差分のみ）
        added, removed = git_diff_stat(cur)
        if added or removed:
            diff_bits = []
            if added:
                diff_bits.append(color("32", f"+{added}"))
            if removed:
                diff_bits.append(color("31", f"-{removed}"))
            branch_part += " " + "/".join(diff_bits)

        # ↑2 ↓1 の ahead/behind（upstream 未設定なら出さない）
        ahead, behind = git_ahead_behind(cur)
        ab_bits = []
        if ahead:
            ab_bits.append(color("32", f"↑{ahead}"))
        if behind:
            ab_bits.append(color("31", f"↓{behind}"))
        if ab_bits:
            branch_part += " " + " ".join(ab_bits)

        parts.append(" " + branch_part + mark)  # Nerd Font branch icon + magenta branch

    # 🔧 直近に呼ばれたツール + 🟩🟨🟥🟦 セッション状態（今 Claude が何をしているかの目安）
    last_tool, state = get_transcript_state(d.get("transcript_path"))
    if last_tool:
        ticon = TOOL_ICONS.get(last_tool, "🔧")
        parts.append(ticon + " " + color("90", last_tool))
    if state and state in STATE_INFO:
        sicon, slabel = STATE_INFO[state]
        parts.append(sicon + " " + slabel)

    # ── 3 行目: リソース（コンテキスト → プラン残量） ──────────────────
    parts3 = []

    # コンテキスト使用率（Cyber Bar のみ）。ラベルは絵文字ではなくテキストで統一。
    cw = d.get("context_window") or {}
    pct = cw.get("used_percentage")
    if pct is not None:
        # 使用率で色変化: <60 緑 / <85 黄 / それ以上 赤
        parts3.append(color("1;37", "context") + " " + cyber_bar(pct, lo=60, hi=85, high_color="31"))

    # 5h / 週 / モデル別週 / 月（追加クレジット）のプラン残量ゲージ
    parts3.extend(usage_parts(d))

    sep = color("90", " · ")  # 薄グレーの中点で連結
    lines = []
    if title_parts:
        lines.append(sep.join(title_parts))
    if parts:
        lines.append(sep.join(parts))
    if parts3:
        lines.append(sep.join(parts3))
    print("\n".join(lines))


if __name__ == "__main__":
    main()

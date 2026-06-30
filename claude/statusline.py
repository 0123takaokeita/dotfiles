#!/usr/bin/env python3
"""Claude Code status line — アイコン付きカラフル版。stdin の JSON を 1 行に整形する。"""
import sys, json, os, subprocess


def color(code, s):
    return f"\033[{code}m{s}\033[0m"


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


def main():
    try:
        d = json.load(sys.stdin)
    except Exception:
        print("statusline: JSON parse error")
        return

    parts = []

    # 🏷️ セッション名（環境変数で手動命名があれば優先、無ければ Claude Code 自動命名）
    name = os.environ.get("CLAUDE_SESSION_NAME") or d.get("session_name")
    if name:
        parts.append("🏷️  " + color("1;35", name))  # bold magenta

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
    parts.append(model_part)

    # 📁 カレントディレクトリ（basename）
    cur = (d.get("workspace") or {}).get("current_dir") or os.getcwd()
    parts.append("📁 " + color("1;34", os.path.basename(cur.rstrip("/")) or "/"))  # bold blue

    # 🌿 Git ブランチ + 変更有無
    try:
        branch = subprocess.run(
            ["git", "-C", cur, "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True, text=True, timeout=1,
        ).stdout.strip()
        if branch:
            dirty = subprocess.run(
                ["git", "-C", cur, "status", "--porcelain"],
                capture_output=True, text=True, timeout=1,
            ).stdout.strip()
            mark = color("1;33", " ●") if dirty else color("1;32", " ✓")  # 黄●=変更あり / 緑✓=clean
            parts.append(" " + color("35", branch) + mark)  # Nerd Font branch icon + magenta branch
    except Exception:
        pass

    # 🧠 コンテキスト使用率（プログレスバー）
    pct = (d.get("context_window") or {}).get("used_percentage")
    if pct is not None:
        pct = max(0.0, min(100.0, float(pct)))
        width = 10
        filled = int(round(pct / 100 * width))
        bar = "█" * filled + "░" * (width - filled)
        # 使用率で色変化: <60 緑 / <85 黄 / それ以上 赤
        c = "32" if pct < 60 else ("33" if pct < 85 else "31")
        parts.append("🧠 " + color(c, f"[{bar}] {pct:.0f}%"))

    # 💰 セッションコスト
    cost = (d.get("cost") or {}).get("total_cost_usd")
    if cost is not None:
        parts.append("💰 " + color("32", f"${float(cost):.3f}"))  # green

    # 🆔 セッション ID（先頭 8 文字だけ）
    sid = d.get("session_id")
    if sid:
        parts.append("🆔 " + color("90", str(sid)[:8]))  # dim gray

    sep = color("90", "  ·  ")  # 薄グレーの中点で連結
    print(sep.join(parts))


if __name__ == "__main__":
    main()

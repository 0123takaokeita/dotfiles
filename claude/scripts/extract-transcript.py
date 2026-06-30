#!/usr/bin/env python3
"""
Claude Code セッションの .jsonl ファイルから読みやすいトランスクリプトを生成する
"""
import sys
import json


def extract(jsonl_path: str, max_messages: int = 60, max_text_len: int = 800) -> str:
    lines = []
    try:
        with open(jsonl_path, encoding="utf-8") as f:
            for raw in f:
                d = json.loads(raw)
                t = d.get("type")

                if t == "user":
                    msg = d.get("message", {})
                    content = msg.get("content", "")
                    if isinstance(content, list):
                        for c in content:
                            if isinstance(c, dict) and c.get("type") == "text":
                                text = c["text"].strip()
                                if text:
                                    lines.append(f"[User]\n{text}")
                                break
                    elif isinstance(content, str) and content.strip():
                        lines.append(f"[User]\n{content.strip()}")

                elif t == "assistant":
                    msg = d.get("message", {})
                    content = msg.get("content", [])
                    if isinstance(content, list):
                        for c in content:
                            if isinstance(c, dict) and c.get("type") == "text":
                                text = c["text"].strip()
                                if text:
                                    truncated = text[:max_text_len]
                                    if len(text) > max_text_len:
                                        truncated += "…（省略）"
                                    lines.append(f"[Assistant]\n{truncated}")
                                break

                if len(lines) >= max_messages:
                    lines.append("（以降のメッセージは省略）")
                    break

    except Exception as e:
        print(f"Error reading transcript: {e}", file=sys.stderr)
        return ""

    return "\n\n".join(lines)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: extract-transcript.py <path-to-session.jsonl>", file=sys.stderr)
        sys.exit(1)
    print(extract(sys.argv[1]))

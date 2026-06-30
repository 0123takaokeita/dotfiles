#!/usr/bin/env python3
"""PreCompact hook: context圧縮前にJSONLスナップショットを保存する。"""
import os
import shutil
from pathlib import Path
from datetime import datetime

SESSION_ID = os.environ.get("CLAUDE_CODE_SESSION_ID", "")
PROJECTS_DIR = Path.home() / ".claude" / "projects"
BACKUP_DIR = Path("/Volumes/EXSSD/dev/github.com/0123takaokeita/vault/claude/transcripts")
MIN_SIZE = 2000


def main():
    if not SESSION_ID:
        return

    for proj_dir in PROJECTS_DIR.iterdir():
        if not proj_dir.is_dir():
            continue
        jsonl = proj_dir / f"{SESSION_ID}.jsonl"
        if not jsonl.exists():
            continue
        if jsonl.stat().st_size < MIN_SIZE:
            return

        BACKUP_DIR.mkdir(parents=True, exist_ok=True)
        ts = datetime.now().strftime("%Y%m%d-%H%M%S")
        dest = BACKUP_DIR / f"{SESSION_ID[:8]}-{ts}.jsonl"
        shutil.copy2(jsonl, dest)
        return


if __name__ == "__main__":
    main()

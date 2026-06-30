#!/usr/bin/env python3
"""PostToolUse hook: Write/Edit後にファイルを自動フォーマットする。
プロジェクトにフォーマッター設定がある場合のみ実行し、Obsidian vaultは対象外。"""
import sys
import json
import subprocess
from pathlib import Path

VAULT_PATH = "/Volumes/EXSSD/dev/github.com/0123takaokeita/vault"

PRETTIER_EXTS = {".js", ".ts", ".tsx", ".jsx", ".json", ".css", ".scss", ".yaml", ".yml"}
PRETTIER_CONFIGS = {".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs",
                    "prettier.config.js", "prettier.config.cjs"}


def find_project_root(file_path: Path) -> Path | None:
    for parent in [file_path.parent, *file_path.parents]:
        if (parent / "package.json").exists() or (parent / ".git").exists():
            return parent
    return None


def has_prettier(root: Path) -> bool:
    if (root / "package.json").exists():
        try:
            pkg = json.loads((root / "package.json").read_text())
            if "prettier" in pkg or any(
                "prettier" in d for d in [
                    *pkg.get("dependencies", {}).keys(),
                    *pkg.get("devDependencies", {}).keys(),
                ]
            ):
                return True
        except Exception:
            pass
    return any((root / c).exists() for c in PRETTIER_CONFIGS)


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        return

    file_path = data.get("tool_input", {}).get("file_path", "")
    if not file_path:
        return

    path = Path(file_path).resolve()

    # Obsidian vault は対象外
    if str(path).startswith(VAULT_PATH):
        return

    if not path.exists():
        return

    suffix = path.suffix.lower()
    root = find_project_root(path)

    # Prettier (JS/TS/CSS/JSON/YAML)
    if suffix in PRETTIER_EXTS and root and has_prettier(root):
        subprocess.run(["npx", "prettier", "--write", str(path)],
                       capture_output=True, cwd=str(root))
        return

    # Go
    if suffix == ".go":
        subprocess.run(["gofmt", "-w", str(path)], capture_output=True)
        return

    # Python
    if suffix == ".py":
        subprocess.run(["black", "--quiet", str(path)], capture_output=True)
        return

    # PHP (Laravel向け)
    if suffix == ".php" and root and (root / "vendor" / "bin" / "pint").exists():
        subprocess.run([str(root / "vendor" / "bin" / "pint"), str(path)],
                       capture_output=True, cwd=str(root))
        return


if __name__ == "__main__":
    main()

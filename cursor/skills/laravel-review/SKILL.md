---
name: laravel-review
description: Summarizes Laravel Linter (Pint, PHPStan) results and checks against Laravel coding standards. Use when the user asks for a Laravel code review, linter summary, or /laravel-review.
disable-model-invocation: true
created: 2026-03-01T12:22
updated: 2026-03-01T12:22
---

# Laravel Linter 要約

このスキルは **Laravel プロジェクト** でだけ実行すること。まず `composer.json` に `laravel/framework` が含まれるか確認し、Laravel プロジェクトでない場合は「このプロジェクトは Laravel ではありません」とだけ返す。

Laravel プロジェクトの場合、次の手順で Linter の結果を要約する。

1. プロジェクトルートで `./vendor/bin/pint --test` を実行する（Pint が入っていない場合はスキップ）。
2. PHPStan が設定されていれば `./vendor/bin/phpstan analyse` を実行する。
3. 実行結果を要約し、規約違反や修正が必要な箇所があれば列挙する。
4. **規約の参照**: 判定時は `~/dotfiles/cursor/laravel-standards.md`（またはこの設定ディレクトリ内の `laravel-standards.md`）を参照し、Laravel コーディング規約に沿っているかも確認する。

出力は簡潔に。エラー・警告の数、主な指摘内容、必要なら修正の優先度を伝える。

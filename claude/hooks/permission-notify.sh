#!/bin/bash
# Claude Code PermissionRequest hook — ツール承認待ちをmacOS通知で知らせる
terminal-notifier -title 'Claude Code' -message 'ツール承認が必要やで' -activate 'com.github.wez.wezterm'
exit 0

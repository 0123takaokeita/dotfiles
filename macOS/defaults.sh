#!/usr/bin/env bash
#
# macOS defaults 設定スクリプト (macOS 26 Tahoe で確認)
#
# 使い方:
#   bash macOS/defaults.sh
#
# 冪等なので何度実行してもOK。一部は再ログイン/再起動で反映される。
set -euo pipefail

echo "==> macOS defaults を適用します..."

# sudo が必要な項目があるため、最初に認証だけ済ませておく
sudo -v

###############################################################################
# キーボード / マウス最速化                                                    #
###############################################################################

# キーリピート速度を最速に (1 が defaults で設定可能な最速。UI 最速は 2)
defaults write -g KeyRepeat -int 1

# リピート開始までの待ち時間を最短に (UI 最短は 15、ここではさらに短い 10)
defaults write -g InitialKeyRepeat -int 10

# キー長押し時にアクセント文字メニューを出さず、リピート入力を有効化
defaults write -g ApplePressAndHoldEnabled -bool false

# マウスのトラッキング速度を最速に (UI 上限は約 3.0、ここではさらに速い 5.0)
defaults write -g com.apple.mouse.scaling -float 5.0

# トラックパッドのトラッキング速度を最速に
defaults write -g com.apple.trackpad.scaling -float 5.0

# マウスの加速 (ボール) を無効化したい場合は以下のコメントを外す
# defaults write -g com.apple.mouse.scaling -integer -1

###############################################################################
# トラックパッド                                                               #
###############################################################################

# ドラッグロックを有効化 (一度ドラッグ開始したら指を離してもドラッグ継続)
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool true

# 3 本指ドラッグを有効化
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# タップでクリックを有効化
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder                                                                       #
###############################################################################

# すべての拡張子を表示
defaults write -g AppleShowAllExtensions -bool true

# 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true

# パスバー / ステータスバーを表示
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# 新規ウィンドウのデフォルト表示をリスト表示に (Nlsv = list view)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# 検索時にデフォルトでカレントフォルダ内を検索 (SCcf)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 拡張子変更時の警告を無効化
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ネットワーク / USB ドライブに .DS_Store を作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# タイトルバーにフルパスを表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

###############################################################################
# Dock                                                                         #
###############################################################################

# Dock のアイコンサイズ
defaults write com.apple.dock tilesize -int 40

# 最小化エフェクトを scale に (genie より軽快)
defaults write com.apple.dock mineffect -string "scale"

# 最近使ったアプリを Dock に表示しない
defaults write com.apple.dock show-recents -bool false

###############################################################################
# スクリーンショット                                                           #
###############################################################################

# 保存先を ~/Screenshots に (なければ作成)
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# 保存形式を png に
defaults write com.apple.screencapture type -string "png"

# 影を付けない
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# その他 QOL                                                                   #
###############################################################################

# 保存パネル / 印刷パネルをデフォルトで展開表示
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# 自動大文字化・スマートクオート等を無効化 (コード書く時に邪魔)
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# 反映のためプロセスを再起動                                                   #
###############################################################################

echo "==> 設定を反映するためプロセスを再起動します..."
for app in Finder Dock SystemUIServer; do
  killall "${app}" >/dev/null 2>&1 || true
done

echo "==> 完了。キーリピート速度などは再ログインで完全に反映されます。"

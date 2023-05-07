# Set a really fast key repeat.
defaults write -g KeyRepeat -init 1

# Set a fast mouse speed.
defaults write -g com.apple.mouse.scaling -float 5.0

# Set a default dock size.
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock tilesize -int 40

# Dock を再起動
killall Dock

# HOMEにBrewfileを作成する
echo "--- link dotfiles .Brewfile ---"
ln -fs $HOME/dotfiles/brew/.Brewfile $HOME/.Brewfile

echo "--- START brew bundle ---"
brew bundle --global
echo "--- END brew bundle ---"

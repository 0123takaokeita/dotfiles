if [ ! -d "$HOME/.config/peco/" ]; then
  mkdir $HOME/.config/peco/
fi

ln -fs $HOME/dotfiles/peco/config.json $HOME/.config/peco/config.json

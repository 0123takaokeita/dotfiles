return {
  'vim-scripts/vim-auto-save',
  event = "BufRead",
  config = function()
    vim.g.auto_save = true
  end
}

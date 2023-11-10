-- usage
-- C-. next
-- C-, prev
-- separatorを追加する場合はコンフィグに追加する必要がある
-- 現状 , 区切りのみ使う予定のためinitのみ実行
return {
  'Wansmer/sibling-swap.nvim',
  dependencies = { 'nvim-treesitter' },
  event = 'BufRead',
  config = function()
    require('sibling-swap').setup({ --[[ your config ]] })
  end,
}

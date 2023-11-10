-- usage leader ~
return {
  "chenasraf/text-transform.nvim",
  version = "*",
  event = "BufRead",
  config = function()
    require('text-transform').setup({
      -- custom settings
    })
  end,
}

return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "BufRead",
  opts = {
    dim_inactive = { enabled = true, percentage = 0.25 },
    integrations = {
      alpha = false,
      dashboard = false,
      flash = false,
      nvimtree = false,
      ts_rainbow = false,
      ts_rainbow2 = false,
      barbecue = false,
      indent_blankline = false,
      navic = false,
      dropbar = false,

      aerial = true,
      dap = { enabled = true, enable_ui = true },
      headlines = true,
      mason = true,
      native_lsp = { enabled = true, inlay_hints = { background = false } },
      neogit = true,
      neotree = true,
      noice = true,
      notify = true,
      sandwich = true,
      semantic_tokens = true,
      symbols_outline = true,
      telescope = { enabled = true, style = "nvchad" },
      which_key = true,
    },
    custom_highlights = {
      -- disable italics  for treesitter highlights
      TabLineFill = { link = "StatusLine" },
      LspInlayHint = { style = { "italic" } },
      ["@parameter"] = { style = {} },
      ["@type.builtin"] = { style = {} },
      ["@namespace"] = { style = {} },
      ["@text.uri"] = { style = { "underline" } },
      ["@tag.attribute"] = { style = {} },
      ["@tag.attribute.tsx"] = { style = {} },
    },
  },
}

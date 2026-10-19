-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- gopls のデフォルト設定が対象とする `gotmpl` filetype を Neovim に認識させる。
-- 未登録だと `:checkhealth vim.lsp` で "Unknown filetype 'gotmpl'" 警告が出る。
vim.filetype.add {
  extension = {
    tmpl = "gotmpl",
  },
}

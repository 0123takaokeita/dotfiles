-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason tool installation
-- v5 では mason-lspconfig/mason-null-ls/mason-nvim-dap 個別の ensure_installed は廃止され、
-- mason-tool-installer に統合された。パッケージ名も Mason 公式名で指定する。

---@type LazySpec
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server", -- v4 の lua_ls 相当
      "stylua",
      "debugpy", -- v4 の mason-nvim-dap "python" 相当
      -- add more arguments for adding more language servers/formatters/linters/debuggers
    },
  },
}

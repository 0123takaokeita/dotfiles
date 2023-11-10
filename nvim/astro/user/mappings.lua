local utils = require "astronvim.utils"

return {
  -- first key is the mode
  -- desc setting is stored by vim.keymap.set() as a part of opts table in vim lua module
  n = {
    ['B'] = { '0', desc = "move line head" },
    ['E'] = { '$', desc = "move line tail" },
    ['<Leader>fT'] = { '<cmd>TodoTelescope<cr>', desc = "Search Anotation" },
    ['<Leader>pp'] = { '<cmd>PrevimOpen<cr>', desc = "Previm Open" },
    ['<Leader>pt'] = { '<cmd>LiveServerStart<cr>', desc = "Live Server Start" },
    ['<Leader>pd'] = { '<cmd>LiveServerStop<cr>', desc = "Live Server Down" },

    -- second key is the lefthand side of the map
    -- Tab Mappings
    ["<leader>Tn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>Tc"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
    -- a table with the `name` key will register with which-key if it's available
    -- this an easy way to add menu titles in which-key
    ["<leader>T"] = { name = "Tab" },
    -- quick save
    ["<C-s>"] = { ":w!<cr>", desc = "Save File" },   -- change description but the same command

    ["<leader>tr"] = { function() utils.toggle_term_cmd "irb" end, desc = "ToggleTerm irb" },
    ["<leader>tg"] = { function() utils.toggle_term_cmd "gore" end, desc = "ToggleTerm gore" },
    ["<leader>gg"] = { function() utils.toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" },
    ["<leader>td"] = { function() utils.toggle_term_cmd "lazydocker" end, desc = "ToggleTerm lazydocker" },
  },
  t = {
    -- setting a mapping to false will disable it
    ["<esc>"] = false,
  },
}

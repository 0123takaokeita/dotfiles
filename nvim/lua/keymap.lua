-- alias to vim's objects
g   = vim.g
opt = vim.opt
cmd = vim.cmd
fn  = vim.fn
api = vim.api

g.mapleader('<Space>')
cmd.set('n', '<Leader>w', ':wq<CR>')

vim.o.encoding = "utf-8"
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.fixeol = false

vim.o.expandtab = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

require('catppuccin').setup {
  flavour = "mocha",
  integrations = {
    treesitter = true,
  },
}

vim.cmd.colorscheme "catppuccin"

require('mini.basics').setup()
require('mini.completion').setup()
require("nvim-treesitter.configs").setup({
  modules = {},
  sync_install = false,
  ignore_install = {},
  ensure_installed = {},
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
require('render-markdown').setup({
  pipe_table = {
    style = 'normal'
  }
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('nixd')
vim.lsp.enable('nil_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('bashls')

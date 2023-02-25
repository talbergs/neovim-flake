vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    vim.lsp.start({
      name = 'intelephense',
      cmd = {'intelephense', '--stdio'},
      root_dir = vim.fs.dirname(vim.fs.find({'composer.json', '.git'}, { upward = true })[1]),
    })
  end,
})

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})


lspconfig.intelephense.setup({});

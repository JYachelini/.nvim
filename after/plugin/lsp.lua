local lsp_zero = require('lsp-zero')
local wk = require("which-key")

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  wk.register({
    ["gd"] = { function() vim.lsp.buf.definition() end, "Go to definition" },
    ["K"] = { function() vim.lsp.buf.hover() end, "Hover word" },
    ["<leader>"] = {
        ["v"] = {
            name = "Diagnostic",
            ["d"] = { function() vim.diagnostic.open_float() end, "Open diagnostic error" },
            ["c"] = {
                name = "Code action",
                ["a"] = { function() vim.lsp.buf.code_action() end, "Open code action" }
            },
            ["r"] = {
                ["r"] = { function() vim.lsp.buf.references() end, "Show references" },
                ["n"] = { function() vim.lsp.buf.rename() end, "Rename"}
            },
        };
    },
    ["[d"] = { function() vim.diagnostic.goto_next() end , "Go to next error" },
    ["]d"] = { function() vim.diagnostic.goto_prev() end , "Go to prev error" }
  }, { mode = "n" })

  wk.register({
      ["C-h"] = { function() vim.lsp.buf.signature_help() end, "Show signature help (params of function)" }
  }, { mode = "i" })

  -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'eslint'},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})


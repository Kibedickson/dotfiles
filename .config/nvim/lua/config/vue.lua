local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  -- Get vue language server path (Mason v2)
  local vue_language_server_path = vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

  -- Configure TypeScript with Vue plugin
  local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
  }

  -- On attach with vue-goto-definition integration
  local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }

    -- Use vue-goto-definition for gd in Vue files
    if vim.bo[bufnr].filetype == "vue" then
      vim.keymap.set("n", "gd", function()
        require("vue-goto-definition").goto_definition()
      end, opts)
    else
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    end

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end

  -- Setup ts_ls with Vue plugin
  lspconfig.ts_ls.setup({
    on_attach = on_attach,
    init_options = {
      plugins = { vue_plugin },
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  })

  -- Setup volar
  lspconfig.volar.setup({
    on_attach = on_attach,
  })
end

return M

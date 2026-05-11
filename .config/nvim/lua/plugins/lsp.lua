return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      emmet_ls = {
        filetypes = {
          "blade",
          "css",
          "html",
          "vue",
        },
      },
      pyright = {
        settings = {
          python = {
            pythonPath = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or "python",
          },
        },
      },
    },
  },
}

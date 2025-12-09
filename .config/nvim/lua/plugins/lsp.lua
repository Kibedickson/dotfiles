return {
  "neovim/nvim-lspconfig",
  dependencies = {},
  config = function()
    require("config.vue").setup()
  end,
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
    },
  },
}

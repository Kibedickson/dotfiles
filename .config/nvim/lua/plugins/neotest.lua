return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "V13Axel/neotest-pest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-pest")({
            pest_cmd = "vendor/bin/pest",
            sail_enabled = function()
              return false
            end,
          }),
        },
      })
    end,
  },
}

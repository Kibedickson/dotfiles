return {
  "ThePrimeagen/99",
  config = function()
    local _99 = require("99")

    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    _99.setup({
      model = "opencode-go/deepseek-v4-pro",
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },
      md_files = {
        "AGENT.md",
      },
    })

    vim.keymap.set("v", "<leader>9p", function()
      _99.visual()
    end, { desc = "99: Visual prompt" })

    vim.keymap.set("n", "<leader>9s", function()
      _99.search()
    end)
    vim.keymap.set("n", "<leader>9l", function()
      _99.view_logs()
    end)
  end,
}

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Normal mode mappings
vim.keymap.set("n", "<leader>tt", "<cmd>NeotermToggle<cr>", { desc = "Toggle NeoTerm" })
vim.keymap.set("n", "<leader>tx", "<cmd>NeotermExit<cr>", { desc = "Exit NeoTerm" })

-- Terminal mode mapping to exit
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Normal mode run nearest test
vim.keymap.set("n", "<leader>tn", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
-- Normal mode run file
vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run test file" })

-- PHPStan
vim.keymap.set("n", "<leader>ps", function()
  local current_file = vim.fn.expand("%:p")
  vim.cmd("split | terminal ./vendor/bin/phpstan analyse --memory-limit 1G " .. current_file)
end, { desc = "Run PHPStan on current file" })

-- Rector PHP
vim.keymap.set("n", "<leader>pr", function()
  local current_file = vim.fn.expand("%:p")
  vim.cmd("split | terminal ./vendor/bin/rector process " .. current_file)
end, { desc = "Run Rector on current file" })

-- Pest PHP
vim.keymap.set("n", "<leader>pt", function()
  local current_file = vim.fn.expand("%:p")
  vim.cmd("split | terminal ./vendor/bin/pest --compact" .. current_file)
end, { desc = "Run pest test on current file" })

-- Pint
vim.keymap.set("n", "<leader>pp", function()
  local current_file = vim.fn.expand("%:p")
  vim.cmd("split | terminal ./vendor/bin/pint" .. current_file)
end, { desc = "Run pint on current file" })

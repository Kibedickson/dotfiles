-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Helper function to run a terminal command in a split and close on success
local function run_php_tool(cmd)
  local current_file = vim.fn.expand("%:p")
  vim.cmd("write")
  vim.cmd("split")

  -- Run the command in a terminal buffer
  vim.cmd("terminal " .. cmd .. " " .. vim.fn.shellescape(current_file))

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  -- Set up an autocmd to close the window if the process exits successfully
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    once = true,
    callback = function()
      -- Capture the status before scheduling
      local exit_code = vim.v.event.status
      if exit_code == 0 then
        -- Add a 2-second delay before closing
        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
          -- Ensure the buffer is deleted so it doesn't linger
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end, 1000)
      end
    end,
  })

  -- Start in insert mode
  vim.cmd("startinsert")
end

-- PHPStan
vim.keymap.set("n", "<leader>ps", function()
  run_php_tool("./vendor/bin/phpstan analyse --memory-limit 1G")
end, { desc = "Run PHPStan on current file" })

-- Rector PHP
vim.keymap.set("n", "<leader>pr", function()
  run_php_tool("./vendor/bin/rector process")
end, { desc = "Run Rector on current file" })

-- Pest PHP
vim.keymap.set("n", "<leader>pt", function()
  run_php_tool("./vendor/bin/pest --compact")
end, { desc = "Run pest test on current file" })

-- Pint
vim.keymap.set("n", "<leader>pp", function()
  run_php_tool("./vendor/bin/pint")
end, { desc = "Run pint on current file" })

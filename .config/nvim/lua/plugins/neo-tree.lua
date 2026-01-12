return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      icon = { folder_closed = "", folder_open = "", folder_empty = "" },
      name = { trailing_slash = false },
      git_status = { symbols = { added = "", modified = "", removed = "" } },
      diagnostics = { symbols = { hint = "", info = "", warning = "", error = "" } },
    },
    window = {
      position = "float",
    },
    filesystem = {
      filtered_items = {
        visible = true,
      },
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default",
    },
    buffers = {
      follow_current_file = {
        enabled = true,
      },
    },
  },
}

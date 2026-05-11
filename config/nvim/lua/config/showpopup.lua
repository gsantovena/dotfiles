local M = {}

function M.show_floating(msg)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.min(80, math.max(20, #msg + 4))
  local opts = {
    relative = "editor",
    width = width,
    height = 1,
    row = vim.o.lines - 4,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { msg })

  local win = vim.api.nvim_open_win(buf, false, opts)
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, 2000)
end

_G.ShowFloating = M.show_floating

return M

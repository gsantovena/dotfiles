local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local myvimrc = augroup("myvimrc", { clear = true })

autocmd("BufWritePost", {
  group = myvimrc,
  pattern = {
    vim.fn.stdpath("config") .. "/init.vim",
    vim.fn.expand("~/.vimrc"),
    "~/.vim/vimrc*",
    "*/vim/vimrc*",
  },
  callback = function()
    vim.cmd("source $MYVIMRC")
    if vim.fn.has("gui_running") == 1 then
      vim.cmd("source $MYGVIMRC")
    end
    require("config.personal").echo_vimrc_reloaded()
  end,
})

autocmd({ "BufEnter", "BufWinEnter" }, {
  group = myvimrc,
  callback = function(args)
    require("config.project-root").apply(args.buf)
  end,
})

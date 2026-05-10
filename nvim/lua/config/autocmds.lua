local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local nvim_config = augroup("nvim_config", { clear = true })

autocmd("BufWritePost", {
  group = nvim_config,
  pattern = {
    vim.fn.stdpath("config") .. "/init.vim",
    vim.fn.stdpath("config") .. "/lua/config/*.lua",
    vim.fn.stdpath("config") .. "/lua/plugins/*.lua",
  },
  callback = function()
    vim.cmd("source $MYVIMRC")
    require("config.personal").echo_config_reloaded()
  end,
})

autocmd({ "BufEnter", "BufWinEnter" }, {
  group = nvim_config,
  callback = function(args)
    require("config.project-root").apply(args.buf)
  end,
})

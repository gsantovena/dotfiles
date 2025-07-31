-- Initialize Lazy.nvim plugin manager
-- This replaces the vim-plug functionality

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with plugins
require("lazy").setup("plugins", {
  -- Configuration options for lazy.nvim
  defaults = {
    lazy = false, -- plugins are not lazy-loaded by default
    version = false, -- don't use version from rockspec
  },
  install = {
    missing = true, -- install missing plugins on startup
    colorscheme = { "default" }, -- try to load colorscheme when starting installation
  },
  checker = {
    enabled = false, -- don't automatically check for plugin updates
    notify = false, -- don't notify about updates
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes
    notify = false, -- don't notify about config changes
  },
  performance = {
    rtp = {
      -- disable some rtp plugins for better performance
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded", -- use rounded borders for lazy UI
  },
})
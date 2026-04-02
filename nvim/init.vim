"---------------------------------------------
" gsantovena@gmail.com
" Migrated to Neovim
"---------------------------------------------

lua require('config.showpopup')
lua require('config.options')

" Initialize Lazy.nvim plugin manager
lua require('lazy-init')
lua require('config.keymaps')
lua require('config.commands')
lua require('config.autocmds')
lua require('config.personal')

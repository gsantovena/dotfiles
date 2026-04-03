vim.api.nvim_create_user_command("FormatJSON", function()
  vim.cmd("%!jq")
end, {})

vim.api.nvim_create_user_command("WP", function()
  vim.opt_local.formatoptions = "1"
  vim.opt_local.expandtab = false
  vim.keymap.set("n", "j", "gj", { buffer = true })
  vim.keymap.set("n", "k", "gk", { buffer = true })
  vim.opt_local.spell = true
  vim.opt_local.spelllang = { "en_us" }
  vim.opt.thesaurus:append("/Users/gsantovena/.vim/thesaurus/mthesaur.txt")
  vim.opt.complete:append("s")
  vim.opt.formatprg = "par"
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
end, {})

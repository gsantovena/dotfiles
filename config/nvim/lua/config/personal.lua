local popup = require("config.showpopup")

local M = {}

function M.show_floating_message(msg)
  popup.show_floating(msg)
end

function M.echo_config_reloaded()
  M.show_floating_message("✅ Neovim config reloaded!")
end

function M.save_popup()
  M.show_floating_message("💾 File saved: " .. vim.fn.expand("%:p"))
end

function M.save_popup_error()
  M.show_floating_message("❌ Error saving file: " .. vim.fn.expand("%:t"))
end

_G.ShowFloatingMessage = M.show_floating_message
_G.EchoConfigReloaded = M.echo_config_reloaded
_G.SavePopup = M.save_popup
_G.SavePopupError = M.save_popup_error

return M

local fn = vim.fn
local g = vim.g
local opt = vim.opt

local undo_dir = "/tmp/.undodir_" .. fn.getenv("USER")
if fn.isdirectory(undo_dir) == 0 then
  fn.mkdir(undo_dir, "", "0700")
end

opt.undodir = undo_dir
opt.undofile = true

g.python3_host_prog = fn.expand("~/.venvs/nvim/bin/python3")
g.mapleader = ","
g.maplocalleader = ","

vim.cmd([[
  syntax enable
  filetype plugin indent on
  set nocompatible
  set t_Co=256
  colorscheme retrobox
]])

local transparent_highlights = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "SignColumn",
  "EndOfBuffer",
  "FoldColumn",
  "LineNr",
  "NonText",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "VertSplit",
  "WinSeparator",
}

local function apply_terminal_transparency()
  for _, group in ipairs(transparent_highlights) do
    vim.cmd.highlight(group .. " guibg=NONE ctermbg=NONE")
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("nvim_transparent_background", { clear = true }),
  callback = apply_terminal_transparency,
})

apply_terminal_transparency()

opt.termguicolors = true
opt.encoding = "utf-8"
opt.number = true
opt.ruler = true
opt.cursorline = true
opt.title = true
opt.wildmenu = true
opt.wildmode = { "list:longest", "full" }
opt.showcmd = true
opt.showmatch = true
opt.showbreak = "↪"
opt.lazyredraw = true
opt.foldmethod = "marker"
opt.autoindent = true
opt.mouse = "a"
opt.backspace = "2"
opt.expandtab = true
opt.shiftwidth = 2
opt.shiftround = true
opt.smarttab = true
opt.softtabstop = 2
opt.tabstop = 2
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

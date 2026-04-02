return {
  -- UI and appearance
  {
    "vim-airline/vim-airline",
    init = function()
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g.airline_powerline_fonts = 0
      vim.g.airline_symbols_ascii = 1
    end,
  },
  "nathanaelkane/vim-indent-guides",

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "diff" },
        auto_install = true,
        highlight = { enable = true },
      })
    end,
  },
}

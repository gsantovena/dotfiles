return {
  -- File and project management
  {
    "dylanaraps/root.vim",
    init = function()
      vim.g["root#auto"] = 1
      vim.g["root#echo"] = 0
    end,
  },
  {
    "majutsushi/tagbar",
    cmd = {
      "Tagbar",
      "TagbarOpen",
      "TagbarClose",
      "TagbarToggle",
    },
    keys = {
      { "<F8>", "<cmd>TagbarToggle<CR>", mode = "n" },
    },
  },
  {
    "junegunn/fzf",
    build = "./install --all",
  },

  -- Telescope (modern fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({
            previewer = false,
          }),
        },
      })
      telescope.load_extension("ui-select")
    end,
  },
}

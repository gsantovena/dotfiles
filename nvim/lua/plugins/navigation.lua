return {
  -- File and project management
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "AerialOpen",
      "AerialClose",
      "AerialToggle",
      "AerialNavToggle",
    },
    keys = {
      { "<F8>", "<cmd>AerialToggle!<CR>", mode = "n" },
    },
    config = function()
      require("aerial").setup({
        backends = { "lsp", "treesitter", "markdown", "man" },
        layout = {
          default_direction = "left",
          min_width = 30,
        },
        close_automatic_events = {},
      })
    end,
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

return {
  -- AI and coding assistance
  {
    "github/copilot.vim",
    lazy = false,
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.cmd([[
        imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
      ]])
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "github/copilot.vim" },
    build = "make tiktoken",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
    },
    config = function()
      require("CopilotChat").setup({
        default_model = "gpt-4o-mini",
        enable_chat_window = true,
        keybinding = "<leader>cc",
        question_header = "# 👤 ",
        answer_header = "# 🤖 ",
      })
    end,
    init = function()
      vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatOpen<CR>")
      vim.keymap.set("v", "<leader>cs", "<Plug>CopilotChatAddSelection", { remap = true })
    end,
  },
  "madox2/vim-ai",
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("claude-code").setup({
        window = {
          split_ratio = 0.3,
          position = "float",
          enter_insert = true,
          hide_numbers = true,
          hide_signcolumn = true,
          float = {
            width = "80%",
            height = "80%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "rounded",
          },
        },
        refresh = {
          enable = true,
          updatetime = 100,
          timer_interval = 1000,
          show_notifications = true,
        },
        git = {
          use_git_root = true,
        },
        shell = {
          separator = "&&",
          pushd_cmd = "pushd",
          popd_cmd = "popd",
        },
        command = "claude",
        command_variants = {
          continue = "--continue",
          resume = "--resume",
          verbose = "--verbose",
        },
        keymaps = {
          toggle = {
            normal = "<C-,>",
            terminal = "<C-,>",
            variants = {
              continue = "<leader>cC",
              verbose = "<leader>cV",
            },
          },
          window_navigation = true,
          scrolling = true,
        },
      })
    end,
  },
}

-- Plugin specifications converted from vim-plug
return {
  -- Essential utilities (load immediately)
  "nvim-lua/plenary.nvim",
  
  -- General editing plugins
  "AndrewRadev/splitjoin.vim",
  "ctrlpvim/ctrlp.vim", 
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "Konfekt/FastFold",
  "nathanaelkane/vim-indent-guides",
  
  -- File and project management
  "dylanaraps/root.vim",
  "majutsushi/tagbar",
  {
    "junegunn/fzf",
    dir = "~/.fzf",
    build = "./install --all"
  },
  
  -- Git integration
  "tpope/vim-fugitive",
  
  -- UI and appearance
  "vim-airline/vim-airline",
  
  -- Language and documentation tools
  "rizzatti/dash.vim",
  "JamshedVesuna/vim-markdown-preview",
  "xavierchow/vim-sequence-diagram",
  "aquach/vim-http-client",
  "vitapluvia/vim-gurl",
  "skywind3000/asyncrun.vim",
  
  -- Telescope (modern fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },

  -- LSP and completion (COC)
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "npm ci"
  },

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

  -- AI and coding assistance
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "github/copilot.vim" },
    build = "make tiktoken",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
    },
  },
  "madox2/vim-ai",

  -- MCP Hub
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "npm install -g mcp-hub@latest",
    cmd = { "MCPHub" },
  },
}
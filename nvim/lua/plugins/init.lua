-- Plugin specifications converted from vim-plug
return {
  -- General plugins
  "AndrewRadev/splitjoin.vim",
  "ctrlpvim/ctrlp.vim",
  "rizzatti/dash.vim",
  "majutsushi/tagbar",
  "Konfekt/FastFold",
  "dylanaraps/root.vim",
  "JamshedVesuna/vim-markdown-preview",
  "xavierchow/vim-sequence-diagram",
  {
    "junegunn/fzf",
    dir = "~/.fzf",
    build = "./install --all"
  },
  "tpope/vim-fugitive",
  "vim-airline/vim-airline",
  "tpope/vim-surround",
  "aquach/vim-http-client",
  "nathanaelkane/vim-indent-guides",
  "vitapluvia/vim-gurl",
  "tpope/vim-commentary",
  "tpope/vim-repeat",
  "skywind3000/asyncrun.vim",
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  "nvim-telescope/telescope-ui-select.nvim",

  -- COC
  {
    "neoclide/coc.nvim",
    branch = "release"
  },

  -- MCP Hub
  "nvim-lua/plenary.nvim",
  {
    "ravitemer/mcphub.nvim",
    build = "npm install -g mcp-hub@latest"
  },

  -- AI plugins
  "github/copilot.vim",
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken"
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSInstall diff"
  },
  "madox2/vim-ai",
}
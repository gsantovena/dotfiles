local function coc_or_lsp_status()
  local coc_status = vim.g.coc_status or ""
  if coc_status ~= "" then
    return coc_status
  end

  if not (vim.lsp and vim.lsp.get_clients) then
    return "No Active Lsp"
  end

  local ok, clients = pcall(vim.lsp.get_clients, { bufnr = 0 })
  if not ok or not clients or vim.tbl_isempty(clients) then
    return "No Active Lsp"
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  return table.concat(names, ",")
end

local function setup_evil_lualine()
  local lualine = require("lualine")

  local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
  }

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
  }

  local config = {
    options = {
      component_separators = "",
      section_separators = "",
      theme = {
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.fg, bg = colors.bg } },
      },
      globalstatus = false,
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = { "tabs" },
      lualine_z = { "buffers" },
    },
  }

  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left({
    function()
      return "▊"
    end,
    color = { fg = colors.blue },
    padding = { left = 0, right = 1 },
  })

  ins_left({
    function()
      return ""
    end,
    color = function()
      local mode_color = {
        n = colors.red,
        i = colors.green,
        v = colors.blue,
        ["\22"] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        ["\19"] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
      }

      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  })

  ins_left({ "filesize", cond = conditions.buffer_not_empty })

  ins_left({
    "filename",
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = "bold" },
    path = 1,
  })

  ins_left({ "location" })
  ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

  ins_left({
    "diagnostics",
    sources = { "nvim_diagnostic", "coc" },
    symbols = { error = " ", warn = " ", info = " " },
    diagnostics_color = {
      error = { fg = colors.red },
      warn = { fg = colors.yellow },
      info = { fg = colors.cyan },
    },
  })

  ins_left({
    function()
      return "%="
    end,
  })

  ins_left({
    coc_or_lsp_status,
    icon = "",
    color = { fg = "#ffffff", gui = "bold" },
  })

  ins_right({
    "o:encoding",
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = "bold" },
  })

  ins_right({
    "fileformat",
    fmt = string.upper,
    color = { fg = colors.green, gui = "bold" },
  })

  ins_right({
    "branch",
    icon = "",
    color = { fg = colors.violet, gui = "bold" },
  })

  ins_right({
    "diff",
    symbols = { added = " ", modified = "󰝤 ", removed = " " },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.orange },
      removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
  })

  ins_right({
    function()
      return "▊"
    end,
    color = { fg = colors.blue },
    padding = { left = 1 },
  })

  lualine.setup(config)
end

return {
  -- UI and appearance
  {
    "nvim-lualine/lualine.nvim",
    config = setup_evil_lualine,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "diff", 
          "dockerfile",
          "go",
          "javascript", 
          "json",
          "markdown",
          "python",
          "sql",
          "typescript", 
          "tsx" 
        },
        auto_install = false,
        highlight = { enable = true },
      })
    end,
  },
}

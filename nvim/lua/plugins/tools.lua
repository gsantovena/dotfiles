return {
  -- Language and documentation tools
  {
    "rizzatti/dash.vim",
    cmd = {
      "Dash",
      "DashSearch",
      "DashKeywords",
    },
  },
  -- "JamshedVesuna/vim-markdown-preview",
  "aquach/vim-http-client",
  {
    "vitapluvia/vim-gurl",
    init = function()
      vim.keymap.set("n", "<leader>gr", "<cmd>call Gurl()<CR>")
    end,
  },
  "skywind3000/asyncrun.vim",

  -- MCP Hub
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "npm install -g mcp-hub@latest",
    cmd = { "MCPHub" },
    config = function()
      require("mcphub").setup({
        config = vim.fn.expand("~/.config/mcphub/servers.json"),
        port = 37373,
        shutdown_delay = 5 * 60 * 000,
        use_bundled_binary = false,
        mcp_request_timeout = 60000,
        global_env = {},
        workspace = {
          enabled = true,
          look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" },
          reload_on_dir_changed = true,
          port_range = { min = 40000, max = 41000 },
          get_port = nil,
        },
        auto_approve = false,
        auto_toggle_mcp_servers = true,
        extensions = {
          avante = {
            make_slash_commands = true,
          },
        },
        native_servers = {},
        builtin_tools = {
          edit_file = {
            parser = {
              track_issues = true,
              extract_inline_content = true,
            },
            locator = {
              fuzzy_threshold = 0.8,
              enable_fuzzy_matching = true,
            },
            ui = {
              go_to_origin_on_complete = true,
              keybindings = {
                accept = ".",
                reject = ",",
                next = "n",
                prev = "p",
                accept_all = "ga",
                reject_all = "gr",
              },
            },
          },
        },
        ui = {
          window = {
            width = 0.8,
            height = 0.8,
            align = "center",
            relative = "editor",
            zindex = 50,
            border = "rounded",
          },
          wo = {
            winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
          },
        },
        json_decode = nil,
        on_ready = function(_hub)
        end,
        on_error = function(_err)
        end,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      })
    end,
  },
}

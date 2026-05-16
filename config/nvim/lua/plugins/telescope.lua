return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      {
        "<leader>pf",
        function()
          local opts = {
            hidden = true,
            no_ignore = false,
            file_ignore_patterns = { "%.git/" },
          }

          if vim.fn.executable("rg") == 1 then
            opts.find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob",
              "!.git",
              "--glob",
              "!**/.git/*",
            }
          end

          require("telescope.builtin").find_files(opts)
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find Buffers",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find Help",
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").colorscheme()
        end,
        desc = "Find Theme",
      },

      -- LSP/Diagnostics
      {
        "<leader>fd",
        function()
          require("telescope.builtin").diagnostics({ bufnr = 0 })
        end,
        desc = "Find Diagnostics (Buffer)",
      },
      {
        "<leader>fD",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Find Diagnostics (Workspace)",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").lsp_references()
        end,
        desc = "Find References",
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Find Symbols",
      },
      {
        "<leader>fS",
        function()
          require("telescope.builtin").lsp_workspace_symbols()
        end,
        desc = "Find Workspace Symbols",
      },

      -- Git
      {
        "<leader>gc",
        function()
          require("telescope.builtin").git_commits()
        end,
        desc = "Git Commits",
      },
      {
        "<leader>gs",
        function()
          require("telescope.builtin").git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          require("telescope.builtin").git_stash()
        end,
        desc = "Git Stash",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local function select_if_present(prompt_bufnr)
        if action_state.get_selected_entry() then
          actions.select_default(prompt_bufnr)
        end
      end

      -- Flash jump within a Telescope picker: labels each result row so you
      -- can skip directly to any entry without arrow-key scrolling.
      local function flash_in_picker(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = action_state.get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<CR>"] = select_if_present,
              ["<c-s>"] = flash_in_picker,
            },
            n = {
              ["q"] = actions.close,
              ["<CR>"] = select_if_present,
              ["s"] = flash_in_picker,
            },
          },
        },
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}

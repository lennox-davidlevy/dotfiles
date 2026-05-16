return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ansiblels",
          "basedpyright",
          "bashls",
          "cssls",
          "dockerls",
          "docker_compose_language_service",
          "gopls",
          "helm_ls",
          "jsonls",
          "lua_ls",
          "marksman",
          "ruff",
          "rust_analyzer",
          "tailwindcss",
          "taplo",
          "terraformls",
          "ts_ls",
          "yamlls",
        },
        automatic_enable = false,
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "b0o/schemastore.nvim", version = false },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local util = require("lspconfig.util")
      local schemastore = require("schemastore")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local ansible_root_markers = {
        "ansible.cfg",
        "playbook.yml",
        "playbook.yaml",
        "site.yml",
        "site.yaml",
        "playbooks",
        "roles",
        "inventory",
      }

      local function set_float_highlights()
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
      end

      local function default_root_dir(fname)
        return util.find_git_ancestor(fname) or vim.fs.dirname(fname)
      end

      local function setup_server(server, server_opts)
        server_opts.capabilities = server_opts.capabilities or capabilities
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end

      set_float_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        desc = "Reapply floating window highlights",
        callback = set_float_highlights,
      })

      -- Clean up HTML tags and backslash escapes from LSP hover content before
      -- stylize_markdown runs, so treesitter sees clean markdown from the start.
      -- ansiblels (archived, no upstream fix) sends ansible-doc output as
      -- HTML-mixed markdown that Neovim's renderer can't handle natively.
      local orig_convert = vim.lsp.util.convert_input_to_markdown_lines
      vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
        contents = orig_convert(input, contents)
        return vim.tbl_map(function(line)
          line = line:gsub("<code><strong>(.-)</strong></code>", "**`%1`**")
          line = line:gsub("<strong><code>(.-)</code></strong>", "**`%1`**")
          line = line:gsub("<code>(.-)</code>", "`%1`")
          line = line:gsub("<strong>(.-)</strong>", "**%1**")
          line = line:gsub("<em>(.-)</em>", "*%1*")
          line = line:gsub("<[^>]+>", "")
          line = line:gsub("\\(.)", "%1")
          return line
        end, contents)
      end

      local original_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        opts.max_width = opts.max_width or 100
        opts.max_height = opts.max_height or 30
        return original_open_floating_preview(contents, syntax, opts, ...)
      end

      vim.diagnostic.config({
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
          max_width = 100,
        },
      })

      local lsp_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        desc = "Set buffer-local LSP keymaps",
        callback = function(event)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
          end

          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gd", vim.lsp.buf.definition, "Go to Definition")
          map("gD", vim.lsp.buf.declaration, "Go to Declaration")
          map("gi", vim.lsp.buf.implementation, "Go to Implementation")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map("<leader>e", vim.diagnostic.open_float, "Show Line Diagnostics")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "gopls" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end,
      })

      local servers = {
        lua_ls = {},
        ts_ls = {},
        marksman = {},
        taplo = {},
        dockerls = {},
        rust_analyzer = {},
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              analysis = {
                typeCheckingMode = "basic",
                reportMissingTypeStubs = false,
                reportAny = false,
                reportUndefinedVariable = true,
                reportAttributeAccessIssue = true,
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "none",
                  reportMissingParameterType = "none",
                  reportCallIssue = "none",
                },
              },
            },
          },
        },
        yamlls = {
          filetypes = { "yaml", "yaml.helm-values" },
          capabilities = vim.tbl_deep_extend("force", capabilities, {
            textDocument = {
              foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
            },
          }),
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              format = { enable = true },
              validate = true,
              keyOrdering = false,
              schemaStore = { enable = false, url = "" },
              kubernetesCRDStore = { enable = true },
              schemas = vim.tbl_deep_extend("force", schemastore.yaml.schemas(), {
                kubernetes = {
                  "k8s/**/*.{yaml,yml}",
                  "kubernetes/**/*.{yaml,yml}",
                  "manifests/**/*.{yaml,yml}",
                  "*.k8s.{yaml,yml}",
                },
              }),
            },
          },
        },
        ansiblels = {
          filetypes = { "yaml.ansible" },
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local root = util.root_pattern(unpack(ansible_root_markers))(fname)

            on_dir(root or default_root_dir(fname))
          end,
          settings = {
            ansible = {
              ansible = {
                path = "ansible",
              },
              executionEnvironment = {
                enabled = false,
              },
              python = {
                interpreterPath = "python3",
              },
              completion = {
                provideRedirectModules = true,
                provideModuleOptionAliases = true,
              },
              validation = {
                lint = { enabled = false },
              },
            },
          },
        },
        bashls = {
          filetypes = { "bash", "sh", "zsh" },
        },
        docker_compose_language_service = {
          filetypes = { "yaml.docker-compose" },
        },
        tailwindcss = {
          filetypes = { "typescriptreact", "javascriptreact", "css", "scss", "html" },
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className" },
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
              },
              validate = true,
            },
          },
        },
        gopls = {},
        helm_ls = {
          filetypes = { "helm" },
          settings = {
            ["helm-ls"] = {
              yamlls = {
                enabled = true,
                path = "yaml-language-server",
                showDiagnosticsDirectly = false,
                diagnosticsLimit = 50,
              },
            },
          },
        },
        terraformls = {
          filetypes = { "terraform" },
          settings = {
            terraform = {
              formatting = {
                enable = true,
              },
              validation = {
                enable = true,
              },
            },
          },
        },
      }

      for server, server_opts in pairs(servers) do
        setup_server(server, server_opts)
      end
    end,
  },
}

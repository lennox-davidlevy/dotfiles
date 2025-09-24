return {
	-- mason
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

	-- nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local function set_hl_for_floating_window()
				vim.api.nvim_set_hl(0, "NormalFloat", {
					link = "Normal", -- make float background the same as editor background
				})
				vim.api.nvim_set_hl(0, "FloatBorder", {
					bg = "none", -- make the border background transparent
				})
			end

			set_hl_for_floating_window()

			-- create an autocommand to apply the styling whenever a colorscheme is loaded.
			-- this prevents my settings from being overwritten by a theme.
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				desc = "Apply custom float styles after colorscheme loads",
				callback = set_hl_for_floating_window,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- styling
			local function setup_styling()
				local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
				function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
					opts = opts or {}
					opts.border = opts.border or "rounded"
					opts.max_width = opts.max_width or 100
					opts.max_height = opts.max_height or 30
					return orig_util_open_floating_preview(contents, syntax, opts, ...)
				end
			end

			-- keymaps
			local function setup_keymaps()
				vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true, desc = "Show Code Action" })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true, desc = "Rename variables" })
				vim.keymap.set(
					"n",
					"<leader>e",
					vim.diagnostic.open_float,
					{ silent = true, desc = "Show Line Diagnostics" }
				)
			end

			setup_styling()
			setup_keymaps()

			-- config
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.cssls.setup({
				capabilities = capabilities,
				settings = {
					css = { validate = true },
					scss = { validate = true },
				},
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})
			require("lspconfig").basedpyright.setup({
				capabilities = capabilities,
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
							},
						},
					},
				},
			})
			lspconfig.marksman.setup({
				capabilities = capabilities,
			})
			lspconfig.taplo.setup({
				capabilities = capabilities,
			})
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						format = {
							enable = true,
						},
						schemaStore = {
							enable = true,
						},
					},
				},
			})
			lspconfig.ansiblels.setup({
				capabilities = capabilities,
				filetypes = { "yaml", "yml" },
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
					},
				},
			})
			lspconfig.bashls.setup({
				capabilities = capabilities,
				filetypes = { "bash", "sh", "zsh" },
			})
			lspconfig.dockerls.setup({
				capabilities = capabilities,
			})
			lspconfig.docker_compose_language_service.setup({
				capabilities = capabilities,
			})
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
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
							recommendedVariantOrder = "warning"
						},
						validate = true
					}
				}
			})
      lspconfig.rust_analyzer.setup({
        capabilities=capabilities
      })
			lspconfig.terraformls.setup({
				capabilities = capabilities,
				filetypes = { "terraform", "tf", "hcl" },
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
			})
		end,
	},
}

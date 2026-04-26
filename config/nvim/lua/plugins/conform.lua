return {
  "stevearc/conform.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  event = "BufWritePre",
  keys = { "<leader>gf" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
        toml = { "taplo" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        vue = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        markdown = { "prettierd" },
        yaml = { "prettierd" },
        ["yaml.ansible"] = { "prettierd" },
        ["yaml.docker-compose"] = { "prettierd" },
        zsh = { "shfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        rust = { "rustfmt" },
        terraform = { "terraform_fmt" },
        go = { "gofumpt" },
      },
      format_on_save = nil,
      formatters = {
        stylua = {
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            "$FILENAME",
            "-",
          },
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>gf", function()
      conform.format({
        timeout_ms = 1000,
        lsp_format = "fallback",
        async = false,
      })

      vim.defer_fn(function()
        pcall(require("lint").try_lint)
      end, 150)
    end, { desc = "Format buffer" })
  end,
}

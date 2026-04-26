return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    {
      "<leader>ll",
      function()
        require("lint").try_lint()
      end,
      desc = "Lint buffer",
    },
  },
  config = function()
    local lint = require("lint")
    local uv = vim.uv

    lint.linters_by_ft = {
      dotenv = { "dotenv_linter" },
      python = { "ruff" },
    }

    local function try_lint()
      lint.try_lint(nil, { ignore_errors = true })
    end

    local timer = uv.new_timer()
    local function debounced_lint(delay)
      return function()
        timer:stop()
        timer:start(
          delay,
          0,
          vim.schedule_wrap(function()
            try_lint()
          end)
        )
      end
    end

    local lint_group = vim.api.nvim_create_augroup("NvimLint", { clear = true })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = lint_group,
      desc = "Close lint debounce timer",
      callback = function()
        if not timer:is_closing() then
          timer:stop()
          timer:close()
        end
      end,
    })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "FileType", "InsertLeave" }, {
      group = lint_group,
      desc = "Run configured linters",
      callback = try_lint,
    })

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      group = lint_group,
      desc = "Run configured linters while editing",
      callback = debounced_lint(150),
    })
  end,
}

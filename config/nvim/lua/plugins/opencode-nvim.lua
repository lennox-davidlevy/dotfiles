return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  init = function()
    vim.g.opencode_opts = {
      provider = {
        enabled = "tmux",
        tmux = {
          options = "-h -l 33%",
        },
      },
    }

    vim.o.autoread = true
  end,
  keys = {
    {
      "<leader>cc",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask opencode",
    },
    {
      "<leader>cs",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Select opencode action",
    },
    {
      "<leader>ct",
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode terminal",
    },
    {
      "<leader>co",
      function()
        return require("opencode").operator("@this ")
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Add range to opencode",
    },
    {
      "<leader>coo",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      mode = "n",
      expr = true,
      desc = "Add line to opencode",
    },
    {
      "<leader>cu",
      function()
        require("opencode").command("session.half.page.up")
      end,
      mode = "n",
      desc = "Scroll opencode up",
    },
    {
      "<leader>cd",
      function()
        require("opencode").command("session.half.page.down")
      end,
      mode = "n",
      desc = "Scroll opencode down",
    },
  },
}

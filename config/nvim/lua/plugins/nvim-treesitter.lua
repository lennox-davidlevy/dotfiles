return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "lua",
      "vimdoc",
      "python",
      "typescript",
      "json",
      "html",
      "css",
      "yaml",
      "bash",
      "markdown",
      "markdown_inline",
      "go",
      "hcl",
      "terraform",
    },
    auto_install = true,
    indent = {
      enable = true,
      disable = { "yaml" },
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  },
}

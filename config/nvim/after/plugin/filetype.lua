-- HashiCorp file type detection
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
    nomad = "hcl",
  },
  filename = {
    [".terraformrc"] = "hcl",
    ["terraform.rc"] = "hcl",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    ["%.tf%.json$"] = "json",
    ["%.tfvars%.json$"] = "json",
  },
})

-- Web dev and shell file types use 2-space indentation
vim.api.nvim_create_autocmd("FileType", {
  desc = "Use 2-space indentation for config and web files",
  pattern = {
    "lua",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "json",
    "yaml",
    "yaml.ansible",
    "yaml.docker-compose",
    "markdown",
    "sh",
    "bash",
    "zsh",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

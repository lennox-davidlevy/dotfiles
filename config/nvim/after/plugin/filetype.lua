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
  },
  pattern = {
    ["%.tf%.json$"] = "json",
    ["%.tfvars%.json$"] = "json",
  },
})
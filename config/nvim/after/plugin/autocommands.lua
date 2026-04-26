-- General settings
local general_group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  desc = "Close transient windows with q",
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function(event)
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close window" })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_group,
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general_group,
  desc = "Avoid continuing comments on new lines",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_group,
  desc = "Keep quickfix windows out of buffer lists",
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Git commit settings
local git_group = vim.api.nvim_create_augroup("GitSettings", { clear = true })
local function enable_prose_buffer()
  vim.opt_local.wrap = true
  vim.opt_local.spell = true
end

vim.api.nvim_create_autocmd("FileType", {
  group = git_group,
  desc = "Enable prose-friendly git commit buffers",
  pattern = "gitcommit",
  callback = enable_prose_buffer,
})

-- Markdown settings
local markdown_group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_group,
  desc = "Enable prose-friendly markdown buffers",
  pattern = "markdown",
  callback = enable_prose_buffer,
})

-- Auto resize windows on terminal resize
local resize_group = vim.api.nvim_create_augroup("AutoResize", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = resize_group,
  desc = "Equalize splits after terminal resize",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Vertical split styling
local split_group = vim.api.nvim_create_augroup("VertSplit", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = split_group,
  desc = "Style split separators",
  callback = function()
    vim.cmd("hi WinSeparator cterm=bold gui=bold guifg=#d7ffd7")
  end,
})

-- Ansible filetype detection
local ansible_group = vim.api.nvim_create_augroup("Ansible", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = ansible_group,
  desc = "Detect Ansible YAML files",
  pattern = {
    "*/playbooks/*.yml",
    "*/playbooks/*.yaml",
    "*/roles/*/tasks/*.yml",
    "*/roles/*/tasks/*.yaml",
    "*/roles/*/handlers/*.yml",
    "*/roles/*/handlers/*.yaml",
    "*/roles/*/defaults/*.yml",
    "*/roles/*/defaults/*.yaml",
    "*/roles/*/vars/*.yml",
    "*/roles/*/vars/*.yaml",
    "*/roles/*/meta/*.yml",
    "*/roles/*/meta/*.yaml",
    "*/inventory/*/hosts.yml",
    "*/inventory/*/hosts.yaml",
    "*/inventory/*/group_vars/*.yml",
    "*/inventory/*/group_vars/*.yaml",
    "*/inventory/*/host_vars/*.yml",
    "*/inventory/*/host_vars/*.yaml",
  },
  callback = function(args)
    -- Some YAML files under playbooks/ are NOT playbooks (they're dicts,
    -- not lists of plays). ansible-lint will reject them, so we tag them
    -- as plain YAML and let the YAML LSP handle them.
    local file = args.file
    local basename = vim.fn.fnamemodify(file, ":t")

    -- Skip by exact filename (Galaxy specs, role meta, etc.)
    local skip_basename = {
      ["requirements.yml"] = true,
      ["requirements.yaml"] = true,
      ["meta.yml"] = true,
      ["meta.yaml"] = true,
      ["ansible.cfg"] = true,
    }
    if skip_basename[basename] then
      vim.bo.filetype = "yaml"
      return
    end

    -- Skip vars-style directories anywhere in the path
    -- (these hold variable dicts, not plays)
    local skip_dirs = { "/vars/", "/group_vars/", "/host_vars/", "/defaults/" }
    for _, dir in ipairs(skip_dirs) do
      if file:find(dir, 1, true) then
        vim.bo.filetype = "yaml"
        return
      end
    end

    vim.bo.filetype = "yaml.ansible"
  end,
})

-- General settings
local general_group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = general_group,
    pattern = { "qf", "help", "man", "lspinfo" },
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = general_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = general_group,
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = general_group,
    pattern = "qf",
    callback = function()
        vim.opt_local.buflisted = false
    end,
})

-- Git commit settings
local git_group = vim.api.nvim_create_augroup("GitSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = git_group,
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Markdown settings
local markdown_group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = markdown_group,
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Custom color scheme highlights
local colors_group = vim.api.nvim_create_augroup("BetterColors", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = colors_group,
    pattern = "*",
    callback = function()
        vim.cmd("hi! link DiagnosticSignError Normal")
        vim.cmd("hi DiagnosticSignError gui=bold guifg=#ff2800")
        vim.cmd("hi! link DiagnosticSignWarn Normal")
        vim.cmd("hi DiagnosticSignWarn guifg=#ff2800")
        vim.cmd("hi! link DiagnosticSignHint Normal")
        vim.cmd("hi DiagnosticSignHint guifg=#FBFBFB")
        vim.cmd("hi! link DiagnosticSignInfo Normal")
        vim.cmd("hi DiagnosticSignInfo guifg=#FBFBFB")
        vim.cmd("hi! link GitGutterAdd Normal")
        vim.cmd("hi GitGutterAdd guifg=#ffb000")
        vim.cmd("hi! link GitGutterChange Normal")
        vim.cmd("hi GitGutterChange guifg=#ffb000")
        vim.cmd("hi! link GitGutterDelete Normal")
        vim.cmd("hi GitGutterDelete guifg=#ffb000")
        vim.cmd("hi! link GitGutterChangeDelete Normal")
        vim.cmd("hi GitGutterChangeDelete guifg=#ffb000")
        vim.cmd("hi MatchParen guibg=NONE guifg=#FFFF00 gui=bold")
        vim.cmd("hi Visual guibg=#000000 guifg=#ffb000")
        vim.cmd("hi Search guifg=#FFFF00 guibg=NONE")
        vim.cmd("hi IncSearch guifg=#FFFF00 guibg=NONE gui=bold")
        vim.cmd("hi TelescopeSelection guibg=#000000 guifg=#ffb000")
        vim.cmd("hi TelescopeSelectionCaret guibg=#000000 guifg=#ffb000")
        vim.cmd("hi TelescopeMultiSelection guibg=#000000 guifg=#ffb000")
    end,
})

-- Auto resize windows on terminal resize
local resize_group = vim.api.nvim_create_augroup("AutoResize", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
    group = resize_group,
    pattern = "*",
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Vertical split styling
local split_group = vim.api.nvim_create_augroup("VertSplit", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
    group = split_group,
    pattern = "*",
    callback = function()
        vim.cmd("hi WinSeparator cterm=bold gui=bold guifg=#d7ffd7")
    end,
})

-- Docker Compose filetype detection
local docker_group = vim.api.nvim_create_augroup("DockerCompose", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = docker_group,
    pattern = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" },
    callback = function()
        vim.bo.filetype = "yaml.docker-compose"
    end,
})

-- Ansible filetype detection
local ansible_group = vim.api.nvim_create_augroup("Ansible", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = ansible_group,
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
    callback = function()
        vim.bo.filetype = "yaml.ansible"
    end,
})

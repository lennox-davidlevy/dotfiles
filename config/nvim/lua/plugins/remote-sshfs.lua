return {
  "nosduco/remote-sshfs.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>rc",
      function()
        require("remote-sshfs.api").connect()
      end,
      desc = "SSH Connect",
    },
    {
      "<leader>rd",
      function()
        require("remote-sshfs.api").disconnect()
      end,
      desc = "SSH Disconnect",
    },
    {
      "<leader>re",
      function()
        require("remote-sshfs.api").edit()
      end,
      desc = "SSH Edit Config",
    },
    {
      "<leader>rf",
      function()
        require("remote-sshfs.api").find_files()
      end,
      desc = "SSH Find Files",
    },
    {
      "<leader>rg",
      function()
        require("remote-sshfs.api").live_grep()
      end,
      desc = "SSH Live Grep",
    },
  },
  config = function()
    local connections = require("remote-sshfs.connections")
    local original_unmount = connections.unmount_host

    -- Work around the telescope extension bug that surfaces after a successful unmount.
    connections.unmount_host = function()
      local success, err = pcall(original_unmount)
      if not success and string.match(tostring(err), "attempt to index a boolean value") then
        return
      end

      if not success then
        error(err)
      end
    end

    require("remote-sshfs").setup({
      connections = {
        ssh_configs = {
          vim.fn.expand("$HOME") .. "/.ssh/config",
          "/etc/ssh/ssh_config",
        },
        ssh_known_hosts = vim.fn.expand("$HOME") .. "/.ssh/known_hosts",
        sshfs_args = {
          "-o reconnect",
          "-o ConnectTimeout=5",
        },
      },
      mounts = {
        base_dir = vim.fn.expand("$HOME") .. "/.sshfs/",
        unmount_on_exit = true,
      },
      handlers = {
        on_connect = {
          change_dir = true,
        },
        on_disconnect = {
          clean_mount_folders = false,
        },
      },
      ui = {
        confirm = {
          connect = true,
          change_dir = false,
        },
      },
      log = {
        enabled = false,
        truncate = false,
        types = {
          all = false,
          util = false,
          handler = false,
          sshfs = false,
        },
      },
    })

    pcall(require("telescope").load_extension, "remote-sshfs")
  end,
}

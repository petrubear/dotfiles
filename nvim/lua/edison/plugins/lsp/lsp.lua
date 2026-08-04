return {
    "hrsh7th/cmp-nvim-lsp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/lazydev.nvim", opts = {} },
    },
    config = function()
      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- point pyright at the project's local .venv when present, so it can
      -- resolve packages installed there instead of the system interpreter.
      -- resolved per-client via before_init since root_dir differs per project.
      vim.lsp.config("pyright", {
        before_init = function(_, config)
          local root = config.root_dir or vim.fn.getcwd()
          local venv = root .. "/.venv/bin/python"
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = vim.fn.filereadable(venv) == 1 and venv
            or vim.fn.exepath("python3")
        end,
      })
    end,
  }

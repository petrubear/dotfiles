# Neovim Java/Spring/Guice Improvements

All changes are lazy-loaded — zero impact on non-Java sessions.
`nvim-jdtls` uses `ft = "java"`, so jdtls and nvim-dap only start when a `.java` file is opened.

---

## 1. New plugin file — `lua/edison/plugins/java.lua`

Create this file. It handles jdtls startup, per-project workspaces, DAP bundles, and Java-specific keymaps.

```lua
return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local jdtls = require("jdtls")
    local mason_registry = require("mason-registry")

    local jdtls_pkg = mason_registry.get_package("jdtls")
    local jdtls_path = jdtls_pkg:get_install_path()

    local java_debug_pkg = mason_registry.get_package("java-debug-adapter")
    local java_test_pkg = mason_registry.get_package("java-test")

    local bundles = {}
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_debug_pkg:get_install_path() .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n"))
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_pkg:get_install_path() .. "/extension/server/*.jar"), "\n"))

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration", jdtls_path .. "/config_mac",  -- change to config_linux on Linux
        "-data", workspace_dir,
      },
      root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
      settings = {
        java = {
          signatureHelp = { enabled = true },
          inlayHints = {
            parameterNames = { enabled = "all" },
          },
          completion = {
            favoriteStaticMembers = {
              "org.junit.Assert.*",
              "org.junit.Assume.*",
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
          },
          import = {
            gradle = { enabled = true },
            maven = { enabled = true },
          },
          format = {
            enabled = false, -- formatting handled by google-java-format via conform
          },
        },
      },
      init_options = {
        bundles = bundles,
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        jdtls.start_or_attach(config)

        local opts = { buffer = true, silent = true }
        vim.keymap.set("n", "<leader>Jo", jdtls.organize_imports,                           vim.tbl_extend("force", opts, { desc = "Organize imports" }))
        vim.keymap.set("n", "<leader>Jv", jdtls.extract_variable,                           vim.tbl_extend("force", opts, { desc = "Extract variable" }))
        vim.keymap.set("v", "<leader>Jv", function() jdtls.extract_variable(true) end,      vim.tbl_extend("force", opts, { desc = "Extract variable" }))
        vim.keymap.set("n", "<leader>Jm", jdtls.extract_method,                             vim.tbl_extend("force", opts, { desc = "Extract method" }))
        vim.keymap.set("v", "<leader>Jm", function() jdtls.extract_method(true) end,        vim.tbl_extend("force", opts, { desc = "Extract method" }))
        vim.keymap.set("n", "<leader>Jt", jdtls.test_nearest_method,                        vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
        vim.keymap.set("n", "<leader>JT", jdtls.test_class,                                 vim.tbl_extend("force", opts, { desc = "Run all tests in class" }))
      end,
    })
  end,
}
```

- [ ] Create `lua/edison/plugins/java.lua` with the content above

---

## 2. `lua/edison/plugins/lsp/mason.lua` — Add Java tools

### mason-lspconfig `ensure_installed`
```lua
ensure_installed = {
  "lua_ls",
  "pyright",
  "eslint",
  "jdtls",    -- Java LSP
  "lemminx",  -- XML LSP (pom.xml, Spring XML bean definitions)
},
```

### mason-tool-installer `ensure_installed`
```lua
ensure_installed = {
  "prettier",
  "stylua",
  "isort",
  "black",
  "pylint",
  "eslint_d",
  "google-java-format",  -- Java formatter
  "java-debug-adapter",  -- required for nvim-jdtls DAP / test running
  "java-test",           -- required for nvim-jdtls test running
  "checkstyle",          -- Java linter
},
```

- [ ] Add `"jdtls"` and `"lemminx"` to mason-lspconfig `ensure_installed`
- [ ] Add `"google-java-format"`, `"java-debug-adapter"`, `"java-test"`, `"checkstyle"` to mason-tool-installer `ensure_installed`

---

## 3. `lua/edison/plugins/formatting.lua` — Add Java and XML formatters

Add to `formatters_by_ft`:
```lua
java = { "google-java-format" },
xml  = { "xmllint" },  -- pom.xml and Spring XML configs
```

Also increase `timeout_ms` from `3000` to `5000` — `google-java-format` is slower than prettier on large files.

- [ ] Add `java` and `xml` entries to `formatters_by_ft`
- [ ] Increase `timeout_ms` to `5000`

---

## 4. `lua/edison/plugins/linting.lua` — Add checkstyle

Add to `linters_by_ft`:
```lua
java = { "checkstyle" },
```

Note: checkstyle looks for a `checkstyle.xml` config file. The existing `remove_linter_if_missing_config_file`
helper in this file can be reused to skip it when no config is present:

```lua
-- inside try_linting(), after the existing commented block:
if linters then
  remove_linter_if_missing_config_file(linters, "checkstyle", "checkstyle.xml")
end
```

- [ ] Add `java = { "checkstyle" }` to `linters_by_ft`
- [ ] Optionally wire up `remove_linter_if_missing_config_file` for checkstyle

---

## 5. `lua/edison/plugins/treesitter.lua` — Add XML parser

Add to `ensure_installed`:
```lua
"xml",  -- pom.xml, Spring XML bean definitions
```

- [ ] Add `"xml"` to treesitter `ensure_installed`

---

## 6. `lua/edison/lsp.lua` — Enable inlay hints

Uncomment line 55:
```lua
vim.lsp.inlay_hint.enable(true)
```

Shows parameter names inline — essential readability for Spring constructors with many
`@Autowired` / Guice `@Inject` parameters.

- [ ] Uncomment `vim.lsp.inlay_hint.enable(true)`

---

## Priority Order

| Priority | Change | Why |
|---|---|---|
| 1 | `java.lua` (new file) | Core Java LSP + test runner — nothing else works without this |
| 2 | Mason additions | `java-debug-adapter` and `java-test` are required by nvim-jdtls |
| 3 | Inlay hints | One-line change, high payoff for Spring/Guice constructor injection |
| 4 | `google-java-format` in conform | Consistent formatting |
| 5 | XML support | Only needed if using XML Spring configs or want pom.xml completions |
| 6 | checkstyle | Nice to have, only activates if a `checkstyle.xml` exists in the project |

---

## Key Keymaps After Setup

| Keymap | Action | Useful for |
|---|---|---|
| `<leader>Jo` | Organize imports | Spring (massive import lists) |
| `<leader>Jv` | Extract variable | Refactoring |
| `<leader>Jm` | Extract method | Refactoring |
| `<leader>Jt` | Run nearest test | JUnit test methods |
| `<leader>JT` | Run all tests in class | JUnit test classes |
| `<leader>ca` | Code actions | Generate getters/setters, constructors, extract interface (Guice bindings) |
| `gR` | Find references | Navigate Guice `bind()` call sites |
| `gi` | Go to implementations | Navigate from Guice interface to implementation |
| `K` | Hover docs | Spring annotation docs |
| `<leader>rn` | Rename symbol | Safe rename across whole project |

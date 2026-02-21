-- JDTLS (Java LSP) configuration
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4

-- Workaround for Neovim 0.11 bug: client/registerCapability sends nil registrations
-- causing ipairs(nil) crash in _unregister_dynamic (vim/lsp/client.lua:894)
if not vim.g._jdtls_register_capability_patched then
	vim.g._jdtls_register_capability_patched = true
	local orig = vim.lsp.handlers["client/registerCapability"]
	vim.lsp.handlers["client/registerCapability"] = function(err, result, ctx, config)
		result = result or {}
		result.registrations = result.registrations or {}
		return orig(err, result, ctx, config)
	end
end

local home = vim.env.HOME -- Get the home directory

local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/jdtls-workspace/" .. project_name

local system_os = ""

-- Determine OS
if vim.fn.has("mac") == 1 then
	system_os = "mac"
elseif vim.fn.has("unix") == 1 then
	system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	system_os = "win"
else
	print("OS not found, defaulting to 'linux'")
	system_os = "linux"
end

-- Needed for debugging
local bundles = {}
local debug_jar =
	vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar")
if debug_jar ~= "" then
	table.insert(bundles, debug_jar)
end

-- Needed for running/debugging unit tests
local test_jars = vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1)
if test_jars ~= "" then
	local jars = vim.split(test_jars, "\n")
	jars = vim.tbl_filter(function(jar)
		-- Exclude non-OSGi jars: the runner fat-jar and the JaCoCo agent
		return not jar:match("runner%-jar%-with%-dependencies") and not jar:match("jacocoagent%.jar$")
	end, jars)
	vim.list_extend(bundles, jars)
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
		"-Xmx4g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- Eclipse jdtls location
		"-jar",
		home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. system_os,
		"-data",
		workspace_dir,
	},

	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "pom.xml", "build.gradle" }),

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	settings = {
		java = {
			-- TODO Replace this with the absolute path to your main java version (JDTLS requires JDK 21 or higher)
			home = "/Users/edison/.sdkman/candidates/java/21",
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				-- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
				-- The runtimes' name parameter needs to match a specific Java execution environments.  See https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request and search "ExecutionEnvironment".
				runtimes = {
					-- {
					--   name = "JavaSE-1.8",
					--   path = "/usr/lib/jvm/java-8-openjdk-amd64",
					-- },
					-- {
					--   name = "JavaSE-11",
					--   path = "/usr/lib/jvm/java-11-openjdk-amd64",
					-- },
					-- {
					--   name = "JavaSE-17",
					--   path = "/usr/lib/jvm/java-17-openjdk-amd64",
					-- },
					-- {
					--   name = "JavaSE-19",
					--   path = "/usr/lib/jvm/java-19-openjdk-amd64",
					-- },
					{
						name = "JavaSE-21",
						path = "/Users/edison/.sdkman/candidates/java/21",
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			signatureHelp = { enabled = true },
			format = {
				enabled = true,
				-- Formatting works by default, but you can refer to a specific file/URL if you choose
				-- settings = {
				--   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
				--   profile = "GoogleStyle",
				-- },
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
	},
	-- Needed for auto-completion with method signatures and placeholders
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	flags = {
		allow_incremental_sync = true,
	},
	init_options = {
		-- References the bundles defined above to support Debugging and Unit Testing
		bundles = bundles,
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
}

-- Needed for debugging
config["on_attach"] = function(client, bufnr)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)

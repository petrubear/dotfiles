return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		local function file_in_cwd(file_name)
			return vim.fs.find(file_name, {
				upward = true,
				stop = vim.uv.cwd():match("(.+)/"),
				path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
				type = "file",
			})[1]
		end

		local function remove_linter(linters, linter_name)
			for k, v in pairs(linters) do
				if v == linter_name then
					linters[k] = nil
					break
				end
			end
		end

		local function linter_in_linters(linters, linter_name)
			for k, v in pairs(linters) do
				if v == linter_name then
					return true
				end
			end
		end

		local function remove_linter_if_missing_config_file(linters, linter_name, config_file_name)
			if linter_in_linters(linters, linter_name) and not file_in_cwd(config_file_name) then
				remove_linter(linters, linter_name)
			end
		end

		local function venv_executable(name)
			return vim.fs.find(".venv/bin/" .. name, {
				upward = true,
				path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
			})[1]
		end

		local function venv_site_packages()
			local venv = vim.fs.find(".venv", {
				upward = true,
				path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
				type = "directory",
			})[1]
			return venv and vim.fn.glob(venv .. "/lib/python*/site-packages", false, true)[1]
		end

		local pylint_base_args = {
			"-f",
			"json",
			"--from-stdin",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		local function try_linting()
			local linters = lint.linters_by_ft[vim.bo.filetype]

			-- if linters then
			--   -- remove_linter_if_missing_config_file(linters, "eslint_d", ".eslintrc.cjs")
			--   remove_linter_if_missing_config_file(linters, "eslint_d", "eslint.config.js")
			-- end

			if vim.bo.filetype == "python" then
				-- prefer the project's own venv pylint (can see project deps) over
				-- the Mason-installed one (isolated env, always PATH-first)
				lint.linters.pylint.cmd = venv_executable("pylint") or "pylint"

				-- when pylint itself isn't installed inside the venv, it runs
				-- with its own interpreter and can't see the venv's packages,
				-- causing false "Unable to import" errors. Point it at the
				-- venv's site-packages directly so it can still resolve them.
				local site_packages = venv_site_packages()
				if site_packages then
					lint.linters.pylint.args = {
						"-f",
						"json",
						"--from-stdin",
						"--init-hook",
						string.format("import sys; sys.path.insert(0, %q)", site_packages),
						function()
							return vim.api.nvim_buf_get_name(0)
						end,
					}
				else
					lint.linters.pylint.args = pylint_base_args
				end
			end

			lint.try_lint(linters)
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				try_linting()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			try_linting()
		end, { desc = "Trigger linting for current file" })
	end,
}

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		require("neo-tree").setup({
			close_if_last_window = true,
			sort_case_insensitive = true,
			default_component_configs = {
				indent = {
					with_expanders = true,
				},
			},
			filesystem = {
				window = {
					width = 35,
				},
				-- libuv file watcher instead of polling, async git status:
				-- this is the perf win over nvim-tree
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = { ".DS_Store" },
				},
				follow_current_file = {
					enabled = false,
				},
			},
			git_status = {
				window = {
					position = "float",
				},
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		local neotree_cmd = require("neo-tree.command")

		keymap.set("n", "<leader>ee", function()
			neotree_cmd.execute({ toggle = true })
		end, { desc = "Toggle file explorer" })

		keymap.set("n", "<leader>ef", function()
			neotree_cmd.execute({ toggle = true, reveal = true })
		end, { desc = "Toggle file explorer on current file" })

		keymap.set("n", "<leader>ec", function()
			neotree_cmd.execute({ action = "focus" })
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z", true, false, true), "n", false)
		end, { desc = "Collapse file explorer" })

		keymap.set("n", "<leader>er", function()
			neotree_cmd.execute({ action = "focus" })
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("R", true, false, true), "n", false)
		end, { desc = "Refresh file explorer" })
	end,
}

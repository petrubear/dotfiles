return {
	"github/copilot.vim",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
	end,
}

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("NativeYankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
})

return {
	"machakann/vim-highlightedyank",
	enabled = false,
}

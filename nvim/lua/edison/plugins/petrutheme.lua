-- PetruTheme: Catppuccin-structured, Dracula-saturated colorscheme.
-- Source of truth / other editor ports: ~/Tools/PetruTheme
--
-- Points `dir` straight at the project repo rather than a vendored copy under
-- stdpath("data"), same reasoning as dracula.lua's local install but without
-- a build step -- it's a plain Lua colorscheme, so edits there apply on next
-- `:colorscheme petrutheme` with no reinstall.
return {
	dir = "/Users/edison/Tools/PetruTheme/themes/vim",
	name = "petrutheme",
	priority = 10000,
	lazy = false,
	config = function()
		vim.o.background = "dark"
		vim.cmd.colorscheme("petrutheme")
	end,
}

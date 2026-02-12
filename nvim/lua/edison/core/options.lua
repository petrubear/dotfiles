vim.cmd("let g:netrw_liststyle = 3")
local opt = vim.opt

-- line numnbers
opt.number = true
opt.relativenumber = true

-- tabs and indents
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- wrap
opt.wrap = false

-- search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.iskeyword:append("-")

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitbelow = true
opt.splitright = true

-- cursor
opt.cursorline = true

--appareance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- misc
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.hidden = true
opt.confirm = true

-- backspace
opt.backspace = "indent,eol,start"

opt.splitbelow = true
opt.splitright = true

opt.updatetime = 250
opt.timeoutlen = 300

opt.inccommand = "split"


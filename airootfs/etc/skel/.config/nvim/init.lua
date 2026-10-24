-- ==============================================================================
-- KryptonOS Neovim Configuration - Modern, Fast, Catppuccin-themed Lua IDE
-- ==============================================================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core Editor Options
local opt = vim.opt

opt.number = true               -- Show line numbers
opt.relativenumber = true       -- Relative line numbers for fast motion
opt.mouse = "a"                 -- Enable mouse support in all modes
opt.clipboard = "unnamedplus"   -- Wayland / System clipboard integration
opt.termguicolors = true        -- True 24-bit RGB colors

opt.tabstop = 4                 -- Number of spaces tabs count for
opt.softtabstop = 4
opt.shiftwidth = 4              -- Size of an indent
opt.expandtab = true            -- Use spaces instead of tabs
opt.smartindent = true          -- Insert indents automatically
opt.autoindent = true

opt.wrap = false                -- Disable line wrap by default
opt.swapfile = false            -- Disable swap files
opt.backup = false
opt.undofile = true             -- Persistent undo history across sessions
opt.undodir = vim.fn.expand("~/.local/state/nvim/undo")

opt.hlsearch = true             -- Highlight search results
opt.incsearch = true            -- Incremental search
opt.ignorecase = true           -- Case-insensitive search...
opt.smartcase = true            -- ...unless capital letters are typed

opt.scrolloff = 8               -- Minimum screen lines to keep above and below cursor
opt.signcolumn = "yes"          -- Always show sign column (prevents text shift)
opt.cursorline = true           -- Highlight current line
opt.updatetime = 250            -- Faster completion and diagnostic updates
opt.timeoutlen = 300            -- Time to wait for mapped sequence

-- Split windows naturally
opt.splitright = true
opt.splitbelow = true

-- Ensure undo directory exists
local undodir = vim.fn.expand("~/.local/state/nvim/undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

-- ==============================================================================
-- Catppuccin Mocha Colors & Syntax Highlighting (Pure Native Lua)
-- ==============================================================================
local c = {
    rosewater = "#f5e0dc",
    flamingo  = "#f2cdcd",
    pink      = "#f5c2e7",
    mauve     = "#cba6f7",
    red       = "#f38ba8",
    maroon    = "#eba0ac",
    peach     = "#fab387",
    yellow    = "#f9e2af",
    green     = "#a6e3a1",
    teal      = "#94e2d5",
    sky       = "#89dceb",
    sapphire  = "#74c7ec",
    blue      = "#89b4fa",
    lavender  = "#b4befe",
    text      = "#cdd6f4",
    subtext1  = "#bac2de",
    subtext0  = "#a6adc8",
    overlay2  = "#9399b2",
    overlay1  = "#7f849c",
    overlay0  = "#6c7086",
    surface2  = "#585b70",
    surface1  = "#45475a",
    surface0  = "#313244",
    base      = "#1e1e2e",
    mantle    = "#181825",
    crust     = "#11111b",
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end
vim.o.background = "dark"

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hl("Normal",        { fg = c.text, bg = c.base })
hl("NormalFloat",   { fg = c.text, bg = c.mantle })
hl("FloatBorder",   { fg = c.mauve, bg = c.mantle })
hl("CursorLine",    { bg = c.surface0 })
hl("CursorLineNr",  { fg = c.mauve, bold = true })
hl("LineNr",        { fg = c.overlay0 })
hl("SignColumn",    { bg = c.base })
hl("ColorColumn",   { bg = c.surface0 })
hl("VertSplit",     { fg = c.surface1, bg = c.base })
hl("WinSeparator",  { fg = c.surface1 })
hl("StatusLine",    { fg = c.text, bg = c.mantle })
hl("StatusLineNC",  { fg = c.overlay0, bg = c.crust })
hl("Pmenu",         { fg = c.text, bg = c.mantle })
hl("PmenuSel",      { fg = c.crust, bg = c.mauve, bold = true })
hl("PmenuSbar",     { bg = c.surface0 })
hl("PmenuThumb",    { bg = c.overlay0 })
hl("Search",        { fg = c.crust, bg = c.yellow })
hl("IncSearch",     { fg = c.crust, bg = c.peach })
hl("Visual",        { bg = c.surface1 })
hl("Directory",     { fg = c.blue, bold = true })

-- Syntax Highlighting
hl("Comment",       { fg = c.overlay0, italic = true })
hl("Constant",      { fg = c.peach })
hl("String",        { fg = c.green })
hl("Character",     { fg = c.teal })
hl("Number",        { fg = c.peach })
hl("Boolean",       { fg = c.peach, bold = true })
hl("Float",         { fg = c.peach })
hl("Identifier",    { fg = c.text })
hl("Function",      { fg = c.blue, bold = true })
hl("Statement",     { fg = c.mauve, bold = true })
hl("Conditional",   { fg = c.mauve, italic = true })
hl("Repeat",        { fg = c.mauve, italic = true })
hl("Label",         { fg = c.lavender })
hl("Operator",      { fg = c.sky })
hl("Keyword",       { fg = c.mauve, bold = true })
hl("Exception",     { fg = c.red })
hl("PreProc",       { fg = c.pink })
hl("Include",       { fg = c.mauve })
hl("Define",        { fg = c.pink })
hl("Macro",         { fg = c.pink })
hl("Type",          { fg = c.yellow, bold = true })
hl("StorageClass",  { fg = c.yellow })
hl("Structure",     { fg = c.yellow })
hl("Typedef",       { fg = c.yellow })
hl("Special",       { fg = c.pink })
hl("Underlined",    { underline = true })
hl("Error",         { fg = c.red, bold = true })
hl("Todo",          { fg = c.crust, bg = c.yellow, bold = true })

-- Git Diff highlights
hl("DiffAdd",       { fg = c.green, bg = "#1e3328" })
hl("DiffChange",    { fg = c.yellow, bg = "#33311e" })
hl("DiffDelete",    { fg = c.red, bg = "#331e24" })
hl("DiffText",      { fg = c.blue, bg = "#1e2833", bold = true })

-- ==============================================================================
-- Custom Sleek Statusline
-- ==============================================================================
local modes = {
    ['n']  = { 'NORMAL',   c.mauve },
    ['no'] = { 'N-PEND',   c.mauve },
    ['v']  = { 'VISUAL',   c.blue },
    ['V']  = { 'V-LINE',   c.blue },
    ['\22']= { 'V-BLOCK',  c.blue },
    ['s']  = { 'SELECT',   c.peach },
    ['S']  = { 'S-LINE',   c.peach },
    ['\19']= { 'S-BLOCK',  c.peach },
    ['i']  = { 'INSERT',   c.green },
    ['ic'] = { 'INSERT',   c.green },
    ['R']  = { 'REPLACE',  c.red },
    ['Rv'] = { 'V-REPLACE',c.red },
    ['c']  = { 'COMMAND',  c.yellow },
    ['cv'] = { 'COMMAND',  c.yellow },
    ['ce'] = { 'COMMAND',  c.yellow },
    ['r']  = { 'PROMPT',   c.teal },
    ['rm'] = { 'MORE',     c.teal },
    ['r?'] = { 'CONFIRM',  c.teal },
    ['!']  = { 'SHELL',    c.red },
    ['t']  = { 'TERMINAL', c.green },
}

local function get_git_branch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if not handle then return "" end
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("%s+", "")
    if result ~= "" then
        return "  " .. result .. " "
    end
    return ""
end

function KryptonStatusline()
    local m = vim.api.nvim_get_mode().mode
    local mode_info = modes[m] or { 'NORMAL', c.mauve }
    local mode_name = mode_info[1]
    
    local filename = vim.fn.expand("%:t")
    if filename == "" then filename = "[No Name]" end
    local modified = vim.bo.modified and "  " or ""
    local readonly = vim.bo.readonly and "  " or ""
    local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
    local branch = get_git_branch()
    
    return string.format(
        " %s %s %%f%s%s %%= %%y  %%l:%%c  %%p%%%% ",
        mode_name, branch, filename, modified .. readonly
    )
end

vim.opt.statusline = "%!v:lua.KryptonStatusline()"

-- ==============================================================================
-- Netrw (Built-in File Explorer) Tweaks
-- ==============================================================================
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25

-- ==============================================================================
-- Developer Keymaps
-- ==============================================================================
local keymap = vim.keymap.set

-- File operations
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file", silent = true })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window", silent = true })
keymap("n", "<leader>x", "<cmd>x<CR>", { desc = "Save and quit", silent = true })
keymap("n", "<leader>c", "<cmd>bdelete<CR>", { desc = "Close buffer", silent = true })
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights", silent = true })

-- File explorer toggle
keymap("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Toggle File Explorer", silent = true })

-- Window splits
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically", silent = true })
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally", silent = true })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size", silent = true })

-- Seamless split navigation with Ctrl + hjkl
keymap("n", "<C-h>", "<C-w>h", { desc = "Navigate window left" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Navigate window down" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Navigate window up" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Navigate window right" })

-- Keep cursor centered when navigating
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page centered" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page centered" })
keymap("n", "n", "nzzzv", { desc = "Next search match centered" })
keymap("n", "N", "Nzzzv", { desc = "Prev search match centered" })

-- Move selected lines up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", silent = true })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", silent = true })

-- Stay in indent mode when indenting
keymap("v", "<", "<gv", { desc = "Indent left and keep selection" })
keymap("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Terminal integration
keymap("n", "<leader>t", "<cmd>split | terminal<CR>", { desc = "Open terminal split" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- vim.g.vimtex_view_general_viewer = "open"
-- vim.g.vimtex_view_general_options = " -a Preview"
--
-- vim.cmd([[
--   augroup vimtex_compile_success
--     autocmd!
--     " Run the action after a successful compilation
--     autocmd User VimtexEventView silent !open -a ghostty
--   augroup END
-- ]])

-- vim.g.vimtex_compiler_custom = {
-- 	name = "Custom pdflatex",
-- 	command = "pdflatex",
-- 	args = { "%" },
-- 	hook = "silent !open -a Preview %:r.pdf && open -a ghostty",
-- }

vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
vim.g.vimtex_compiler_latexmk = {
	out_dir = "build",
}

-- Function to bring ghostty to front
local function tex_focus_vim()
	vim.fn.jobstart({ "open", "-a", "Ghostty" }, { detach = true })
	vim.cmd("redraw!")
end

-- Autocommand group to handle VimTeX inverse search
vim.api.nvim_create_augroup("vimtex_event_focus", { clear = true })

vim.api.nvim_create_autocmd("User", {
	pattern = "VimtexEventViewReverse",
	group = "vimtex_event_focus",
	callback = tex_focus_vim,
})

require("options")

require("keymaps")

require("custom.lazy")

-- vim: ts=2 sts=2 sw=2 et

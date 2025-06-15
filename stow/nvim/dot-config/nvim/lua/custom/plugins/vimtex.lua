return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_quickfix_open_on_warning = 0
		vim.g.vimtex_compiler_latexmk = {
			out_dir = "build",
			callback = 1,
			continuous = 1,
			executable = "latexmk",
			options = {
				"-pdf",
				"-interaction=nonstopmode",
				"-synctex=1",
				"-file-line-error",
				"-verbose",
			},
		}

		-- macos
		if vim.fn.has("mac") == 1 then
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1

			-- focus ghostty on reverse search
			local function tex_focus_vim()
				vim.fn.jobstart({ "open", "-a", "Ghostty" }, { detach = true })
				vim.cmd("redraw!")
			end

			vim.api.nvim_create_augroup("vimtex_event_focus", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				pattern = "VimtexEventViewReverse",
				group = "vimtex_event_focus",
				callback = tex_focus_vim,
			})
		else
			-- linux
			vim.g.vimtex_view_method = "zathura"
		end
	end,
}

-- vim: ts=2 sts=2 sw=2 et

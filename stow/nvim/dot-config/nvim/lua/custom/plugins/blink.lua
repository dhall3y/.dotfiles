return {
	"saghen/blink.cmp",
	dependencies = "rafamadriz/friendly-snippets",

	version = "*",
	opts = {
		keymap = {
			preset = "enter",
			["<C-y>"] = { "select_and_accept" },
		},
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		sources = {
			-- compat = {},
			default = { "lsp", "path", "snippets", "buffer" },
		},
		cmdline = {
			enabled = false,
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et

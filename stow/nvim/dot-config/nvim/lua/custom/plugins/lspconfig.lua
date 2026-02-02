-- LSP Plugins
return {
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "mason-org/mason-lspconfig.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by blink-cmp
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			vim.diagnostic.config({
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },

				-- Can switch between these as you prefer
				virtual_text = true, -- Text shows up at the end of the line
				virtual_lines = false, -- Text shows up underneath the line, with virtual lines

				-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
				jump = { float = true },
			})

			local clangd = "clangd"

			if os.getenv("IDF_PATH") then
				clangd = vim.fn.expand("$HOME/.espressif/tools/esp-clang/16.0.1-fe4f10a809/esp-clang/bin/clangd")
			end

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			---@type MasonLspconfigSettings
			---@diagnostic disable-next-line: missing-fields
			-- Enable the following language servers
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ts_ls = {},
				--
				terraformls = {},
				clangd = {
					cmd = {
						clangd,
						"--clang-tidy",
						"--all-scopes-completion",
						"--completion-style=detailed",
						"--header-insertion=iwyu",
						"--pch-storage=disk",
						"--log=error",
						"--j=5",
						"--background-index",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						compilationDatabasePath = "./build",
					},
				},
				ts_ls = {
					settings = {
						typescript = {
							format = {
								indentSize = 2,
								tabSize = 2,
								convertTabsToSpaces = true,
								insertSpaceAfterCommaDelimiter = true,
								insertSpaceAfterConstructor = true,
								indentStyle = "Smart", -- or "Block"
							},
						},
						javascript = {
							format = {
								indentSize = 2,
								tabSize = 2,
								convertTabsToSpaces = true,
								insertSpaceAfterCommaDelimiter = true,
								insertSpaceAfterConstructor = true,
								indentStyle = "Smart",
							},
						},
					},
				},

				yamlls = {
					settings = {
						yaml = {
							schemas = {
								kubernetes = "*.yaml",
								["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
								["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
								["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
								["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
								["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
								["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
								["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
								["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
								["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
								["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
								["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*{docker-compose,compose}*.{yml,yaml}",
								["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
								["https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/versions.schema.cloud-config.json"] = "*user-data*.{yml, yaml}",
							},
							format = { enable = true },
							completion = true,
							hover = true,
							validate = true,
						},
					},
				},
			}

			-----@type MasonLspconfigSettings
			-----@diagnostic disable-next-line: missing-fields
			--require("mason-lspconfig").setup({
			--	automatic_enable = vim.tbl_keys(servers or {}),
			--})

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"lua_ls",
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			for name, server in pairs(servers) do
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				vim.lsp.config(name, server)
				vim.lsp.enable(name)
			end

			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = { "lua/?.lua", "lua/?/init.lua" },
						},
						workspace = {
							checkThirdParty = false,
							-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
							--  See https://github.com/neovim/nvim-lspconfig/issues/3189
							library = vim.api.nvim_get_runtime_file("", true),
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
			vim.lsp.enable("lua_ls")
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et

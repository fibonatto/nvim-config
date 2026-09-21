-- =============================================================================
-- config/plugins.lua
-- =============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- =============================================================================
	-- Theme
	-- =============================================================================

	{
		"SergioBonatto/One-Half-Matte",
		priority = 1000,
		lazy = false,
		config = function()
			vim.cmd.colorscheme("atomonelight_matte")
		end,
	},
	-- {
	-- 	"tribela/transparent.nvim",
	-- 	event = "VimEnter",
	-- 	config = true,
	-- },
	--
	-- =============================================================================
	-- Core Workflow
	-- =============================================================================

	{
		"SergioBonatto/nvim-run-code",
		config = function()
			local run_code = require("run-code")
			local output = {
				win = nil,
				buf = nil,
			}

			local function close_output()
				if output.win and vim.api.nvim_win_is_valid(output.win) then
					vim.api.nvim_win_close(output.win, true)
				end

				if output.buf and vim.api.nvim_buf_is_valid(output.buf) then
					vim.api.nvim_buf_delete(output.buf, { force = true })
				end

				output.win = nil
				output.buf = nil
			end

			local function run(optimized)
				close_output()
				run_code.run(optimized)

				local buf = vim.api.nvim_get_current_buf()
				if vim.bo[buf].buftype ~= "terminal" then
					return
				end

				output.win = vim.api.nvim_get_current_win()
				output.buf = buf

				vim.api.nvim_create_autocmd("WinLeave", {
					buffer = buf,
					once = true,
					callback = function()
						vim.schedule(close_output)
					end,
				})
			end

			run_code.setup({
				terminal_position = "vertical",
				terminal_width = 50,
				auto_save = true,
				clear_terminal = true,
				show_feedback = true,
				timeout = 0,
				temp_dir = "/tmp",
				no_default_mappings = true,
			})

			vim.keymap.set("n", "r", function()
				run(false)
			end, { silent = true, desc = "Run Code (Dev)" })

			vim.keymap.set("n", "R", function()
				run(true)
			end, { silent = true, desc = "Run Code (Opt)" })
		end,
	},

	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
	},

	{
		"SergioBonatto/basal-nvim",
		dependencies = {
			"ibhagwan/fzf-lua",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("basal").setup({
				path = "~/Basal",
			})
		end,
	},

	{
		"SergioBonatto/VimFileType",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- =============================================================================
	-- Lean
	-- =============================================================================

	{
		"Julian/lean.nvim",
		ft = "lean",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"andymass/vim-matchup",
			"andrewradev/switch.vim",
			"tomtom/tcomment_vim",
		},
		opts = {
			mappings = false,
		},
	},

	-- =============================================================================
	-- Markdown
	-- =============================================================================

	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "Avante" },
	},

	{
		"vyfor/cord.nvim",
		event = "VeryLazy",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- =============================================================================
	-- File Explorer
	-- =============================================================================
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},

		lazy = false,

		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				filesystem = {
					bind_to_cwd = false,
					follow_current_file = {
						enabled = true,
					},
					filtered_items = {
						hide_dotfiles = true,
						hide_gitignored = true,
						root_template = "  ../%n",
					},
				},
				window = {
					position = "left",
					width = 30,
					mappings = {
						["<CR>"] = "open",

						-- Neo-tree buffer-local mappings.
						["u"] = "navigate_up",
						["z"] = "set_root",
						["H"] = "toggle_hidden",

						-- Disable default rename mappings.
						["r"] = "none",
						["R"] = "none",
					},
				},
			})
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					require("neo-tree.command").execute({
						toggle = false,
						dir = vim.loop.cwd(),
						reveal = true,
					})
				end,
			})

			vim.api.nvim_create_autocmd("BufDelete", {
				callback = function()
					local buffers = vim.fn.getbufinfo({ buflisted = 1 })

					local real_buffers = vim.tbl_filter(function(buf)
						local ft = vim.bo[buf.bufnr].filetype
						return ft ~= "neo-tree"
					end, buffers)

					if #real_buffers == 0 then
						vim.cmd("Neotree close")
					end
				end,
			})
		end,
	},
	-- =============================================================================
	-- Treesitter
	-- =============================================================================
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },

		config = function()
			require("nvim-treesitter.install").compilers = {
				"clang",
				"gcc",
			}

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),

				callback = function(args)
					local buf = args.buf

					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

					if ok and stats and stats.size > 1024 * 1024 then
						return
					end

					pcall(vim.treesitter.start, buf)
				end,
			})
		end,
	},

	-- =============================================================================
	-- LSP
	-- =============================================================================

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.lsp.config("clangd", {
				cmd = {
					"/opt/homebrew/opt/llvm/bin/clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--fallback-style=Google",
				},
				init_options = {
					fallbackFlags = { "-I/usr/local/include" },
				},
			})

			vim.lsp.enable("clangd")

			vim.lsp.config("ts_ls", {})
			vim.lsp.enable("ts_ls")

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 2,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			local signs = {
				Error = "✘",
				Warn = "▲",
				Hint = "⚑",
				Info = "»",
			}

			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, {
					text = icon,
					texthl = hl,
					numhl = "",
				})
			end
		end,
	},

	-- =============================================================================
	-- Completion
	-- =============================================================================

	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",

		opts = {
			keymap = {
				preset = "default",

				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					window = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
					},
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
	},

	-- =============================================================================
	-- Git
	-- =============================================================================

	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G" },
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
				blame_formatter = nil, -- Use default
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},

	-- =============================================================================
	-- Prettier
	-- =============================================================================
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },

				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },

				json = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },

				python = { "ruff_format" },

				go = { "gofmt" },

				rust = { "rustfmt" },

				c = { "clang_format" },
				cpp = { "clang_format" },

				sh = { "shfmt" },
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},

			formatters = {
				clang_format = {
					prepend_args = { "-style={BasedOnStyle: Linux, Standard: c++03}" },
				},
			},
		},
	},

	-- =============================================================================
	-- Commenting
	-- =============================================================================

	{
		"numToStr/Comment.nvim",
		keys = {
			"gc",
			"gb",
		},
		config = function()
			require("Comment").setup()
		end,
	},

	-- =============================================================================
	-- Indent Guides
	-- =============================================================================

	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mini.indentscope").setup({
				symbol = "│",
				options = {
					try_as_border = true,
				},
			})
		end,
	},

	-- =============================================================================
	-- Autopairs
	-- =============================================================================

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- =============================================================================
	-- Colorizer
	-- =============================================================================

	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("colorizer").setup()
		end,
	},

	-- =============================================================================
	-- Symbols / Outline
	-- =============================================================================

	{
		"stevearc/aerial.nvim",
		cmd = { "AerialToggle", "AerialOpen" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup()
		end,
	},

	-- =============================================================================
	-- Alignment
	-- =============================================================================

	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } },
		},
	},

	-- =============================================================================
	-- Misc
	-- =============================================================================

	{
		"sakshamgupta05/vim-todo-highlight",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- {
	-- 	"wakatime/vim-wakatime",
	-- 	event = "VeryLazy",
	-- },

	{
		"segeljakt/vim-silicon",
		cmd = "Silicon",
	},

	-- =============================================================================
	-- Language Specific
	-- =============================================================================
	{
		"fibonatto/bend-vim",
		ft = "bend"
	},

	{
		"maxbane/vim-asm_ca65",
		ft = "asm",
	},	
	{
		"vim-scripts/Microchip-Linker-Script-syntax-file",
		ft = "ld",
	},
}, {
	checker = {
		enabled = false,
	},
})

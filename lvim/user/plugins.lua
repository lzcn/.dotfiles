lvim.plugins = {
	-- for colorscheme
	{ "folke/tokyonight.nvim" },
	{ "joshdick/onedark.vim" },
	{ "Mofiqul/dracula.nvim" },
	{ "p00f/nvim-ts-rainbow" },
	{
		"folke/lsp-colors.nvim",
		event = "BufRead",
	},

	-- pydocstring
	{
		"heavenshell/vim-pydocstring",
		run = "make install",
		ft = { "python" },
		config = function()
			vim.g.pydocstring_formatter = "google"
		end,
	},

	-- latex
	{
		"lervag/vimtex",
		ft = { "tex" },
		config = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
			vim.g.vimtex_quickfix_mode = 0
		end,
	},

	-- jupyter
	{ "dccsillag/magma-nvim", run = ":UpdateRemotePlugins", ft = { "python" } },

	-- navigate within tmux
	{
		"numToStr/Navigator.nvim",
		config = function()
			require("Navigator").setup()
		end,
	},

	-- copilot
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true
		end,
	},

	-- diagnostics
	{ "folke/trouble.nvim", cmd = "TroubleToggle" },

	{
		"nvim-telescope/telescope-project.nvim",
		event = "BufWinEnter",
		setup = function()
			vim.cmd([[packadd telescope.nvim]])
		end,
	},

	-- better navigation
	{ "andymass/vim-matchup" },
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
	-- peeks lines
	{
		"nacro90/numb.nvim",
		config = function()
			require("numb").setup()
		end,
	},

	-- smooth scroll
	-- {
	-- 	"karb94/neoscroll.nvim",
	-- 	event = "WinScrolled",
	-- 	config = function()
	-- 		require("neoscroll").setup()
	-- 	end,
	-- },

	-- automatic session saver
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		module = "persistence",
		config = function()
			require("persistence").setup()
		end,
	},

	-- open at last edited position
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},

	-- color display
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				mode = "background", -- Set the display mode
			})
		end,
	},

	-- sphinx
	{ "stsewd/sphinx.nvim", ft = { "rst" } },

	-- markdown preview
	{ "npxbr/glow.nvim", ft = { "markdown" } },

	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_auto_start = 1
		end,
	},
	-- todo comments
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},

	-- mappings to delete, change and add surroundings
	{
		"tpope/vim-surround",
		keys = { "c", "d", "y" },
	},

	-- underlines the word under the cursor
	{
		"itchyny/vim-cursorword",
		event = { "BufEnter", "BufNewFile" },
		config = function()
			vim.api.nvim_command("augroup user_plugin_cursorword")
			vim.api.nvim_command("autocmd!")
			vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
			vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
			vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
			vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
			vim.api.nvim_command("augroup END")
		end,
	},

	-- previewing goto definition calls
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				width = 120, -- Width of the floating window
				height = 25, -- Height of the floating window
				default_mappings = false, -- Bind default mappings
				debug = false, -- Print debug information
				opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
			})
		end,
	},

	-- hint signature when you type
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},
}

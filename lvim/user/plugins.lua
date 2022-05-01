lvim.plugins = {
	-- Aesthetics --
	-- colorscheme
	-- { "folke/tokyonight.nvim" },
	-- { "joshdick/onedark.vim" },
	{ "Mofiqul/dracula.nvim" },
	-- rainbow parentheses
	{ "p00f/nvim-ts-rainbow" },
	-- display color
	{ "norcalli/nvim-colorizer.lua" },

	-- LSP --
	-- diagnostics highlight for non-LSP colorscheme
	{ "folke/lsp-colors.nvim" },
	-- previewing definition
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({})
		end,
	},
	-- hitn signature when type
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},

	-- Diagnostics --
	{ "folke/trouble.nvim", cmd = "TroubleToggle" },
	-- better quickfix window
	{ "kevinhwang91/nvim-bqf", ft = "qf" },

	-- Navigation --
	-- enhanced matchup
	{ "andymass/vim-matchup" },
	-- navigate within tmux panes
	{
		"numToStr/Navigator.nvim",
		config = function()
			require("Navigator").setup()
		end,
	},
	-- peek line
	{
		"nacro90/numb.nvim",
		config = function()
			require("numb").setup()
		end,
	},
	-- open projects with telescope
	{
		"nvim-telescope/telescope-project.nvim",
		event = "BufWinEnter",
		setup = function()
			vim.cmd([[packadd telescope.nvim]])
		end,
	},

	-- Python --
	-- pydocstring
	{
		"heavenshell/vim-pydocstring",
		run = "make install",
		ft = { "python" },
		config = function()
			vim.g.pydocstring_formatter = "google"
		end,
	},
	-- jupyter-notebook
	{ "dccsillag/magma-nvim", run = ":UpdateRemotePlugins", ft = { "python" } },
	-- sphinx support
	{ "stsewd/sphinx.nvim", run = ":UpdateRemotePlugins", ft = { "rst" } },

	-- LaTeX --
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

	-- Markdown --
	-- preview with glow
	{ "npxbr/glow.nvim", ft = { "markdown" } },
	-- preview on browser
	{
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		ft = "markdown",
		config = function()
			vim.g.mkdp_auto_start = 1
		end,
	},

	-- Utility --
	-- copilot
	{
		"github/copilot.vim",
		disable = not lvim.sell_your_soul_to_devil,
		config = function()
			require("lv-user-config.copilot").config()
		end,
	},
	{
		"abecodes/tabout.nvim",
		disable = not lvim.sell_your_soul_to_devil,
		wants = { "nvim-treesitter" },
		after = { "nvim-cmp" },
		config = function()
			require("lv-user-config.tabout").config()
		end,
	},

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

	-- todo comments
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},

	-- delete, change and add surroundings
	{
		"tpope/vim-surround",
		keys = { "c", "d", "y" },
	},

	-- highlight the word under the cursor
	{
		"xiyaowong/nvim-cursorword",
		event = { "BufEnter", "BufNewFile" },
	},
}

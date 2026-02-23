-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	'artempyanykh/marksman',
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'chrisbra/NrrwRgn',
	{ 'ellisonleao/gruvbox.nvim', priority = 1000, config = true, opts = ... },
	{
		'pmizio/typescript-tools.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
		opts = {},
	},
	{ 'CRAG666/code_runner.nvim', config = true },
}

return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.keymap.set("n", "<leader>n", ":BufferNext<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>N", ":BufferPrevious<CR>", { noremap = true })
		vim.keymap.set("n", "<leader>q", ":BufferClose<CR>", { noremap = true })
	end,
}

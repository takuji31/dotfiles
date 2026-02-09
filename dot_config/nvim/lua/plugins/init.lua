return {
  -- カラースキーム
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          telescope = { enabled = true },
          which_key = true,
          native_lsp = { enabled = true },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  { import = "plugins.lsp" },
  { import = "plugins.cmp" },
  { import = "plugins.treesitter" },
  { import = "plugins.telescope" },
  { import = "plugins.git" },
  { import = "plugins.ui" },
  { import = "plugins.markdown" },
}

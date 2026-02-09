return {
  -- Markdown プレビュー（ブラウザで開く）
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview" },
    ft = "markdown",
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown プレビュー" },
    },
  },

  -- ターミナル内 Markdown レンダリング
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({})

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en"
          vim.opt_local.conceallevel = 2
        end,
      })
    end,
  },
}

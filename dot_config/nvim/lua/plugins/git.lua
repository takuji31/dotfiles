return {
  -- 行単位の Git 差分表示
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local bmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          bmap("n", "]h", gs.next_hunk, "次の変更箇所")
          bmap("n", "[h", gs.prev_hunk, "前の変更箇所")
          bmap("n", "<leader>hs", gs.stage_hunk, "変更をステージ")
          bmap("n", "<leader>hr", gs.reset_hunk, "変更をリセット")
          bmap("n", "<leader>hp", gs.preview_hunk, "変更をプレビュー")
          bmap("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Git blame")
        end,
      })
    end,
  },

  -- LazyGit 連携
  -- 事前に lazygit のインストールが必要: brew install lazygit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit を開く" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}

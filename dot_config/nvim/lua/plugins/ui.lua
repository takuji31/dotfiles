return {
  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin" },
      })
    end,
  },

  -- キーマップヘルプ（Colemak 移行期に特に便利）
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        delay = 300,
      })
    end,
  },

  -- ファイラー（バッファ感覚でディレクトリを操作）
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "ファイラーを開く" },
    },
    config = function()
      require("oil").setup({
        view_options = { show_hidden = true },
      })
    end,
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    config = function()
      require("ibl").setup()
    end,
  },

  -- 括弧の自動ペア
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ターミナルトグル
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>t", "<cmd>ToggleTerm direction=float<CR>", desc = "ターミナル (float)" },
    },
    config = function()
      require("toggleterm").setup({
        float_opts = { border = "rounded" },
      })
    end,
  },
}

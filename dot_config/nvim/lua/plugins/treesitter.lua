return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- React / Next.js 関連
          "typescript", "tsx", "javascript", "html", "css", "json", "jsonc",
          -- Markdown
          "markdown", "markdown_inline",
          -- Neovim 設定
          "lua", "vim", "vimdoc",
          -- その他
          "bash", "yaml", "toml", "gitcommit", "git_rebase", "diff",
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },

        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          },
        },
      })
    end,
  },
}

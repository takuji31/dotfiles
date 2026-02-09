return {
  -- nvim-lspconfig（デフォルト設定の提供元として runtimepath に必要）
  { "neovim/nvim-lspconfig", lazy = true },

  -- LSP サーバー管理
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",          -- TypeScript / JavaScript / JSX / TSX
          "biome",          -- Biome (リント + フォーマット)
          "tailwindcss",    -- Tailwind CSS クラス名補完
          "cssls",          -- CSS
          "html",           -- HTML
          "jsonls",         -- JSON (package.json, tsconfig.json 等)
          "marksman",       -- Markdown
          "lua_ls",         -- Lua (Neovim 設定編集用)
        },
        -- Mason でインストールしたサーバーを自動で vim.lsp.enable() する（デフォルト有効）
        automatic_enable = true,
      })
    end,
  },

  -- LSP 全体設定（vim.lsp.config API）
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 全サーバー共通: cmp_nvim_lsp の capabilities を追加
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Lua は Neovim 設定用に特別設定
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- LSP 接続時のキーマップ
      -- 注: Neovim 0.11 のデフォルトマッピング:
      --   grn = rename, gra = code_action, grr = references,
      --   gri = implementation, gO = document_symbol, Ctrl-S = signature_help
      -- 以下は追加・上書き分
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local bmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          bmap("n", "gd", vim.lsp.buf.definition, "定義へジャンプ")
          bmap("n", "K",  vim.lsp.buf.hover, "ホバー情報")
          bmap("n", "<leader>rn", vim.lsp.buf.rename, "リネーム")
          bmap("n", "<leader>ca", vim.lsp.buf.code_action, "コードアクション")
          bmap("n", "<leader>d",  vim.diagnostic.open_float, "診断詳細")
          bmap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "前の診断")
          bmap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "次の診断")
        end,
      })
    end,
  },

  -- フォーマッター
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      { "<leader>f", function() require("conform").format({ async = true }) end, desc = "フォーマット" },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript      = { "biome" },
          typescript      = { "biome" },
          javascriptreact = { "biome" },
          typescriptreact = { "biome" },
          css             = { "biome" },
          json            = { "biome" },
          jsonc           = { "biome" },
          lua             = { "stylua" },
          -- Markdown は Biome 未対応なので LSP (marksman) にフォールバック
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_format = "fallback",
        },
      })
    end,
  },
}

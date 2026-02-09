local opt = vim.opt

-- リーダーキー（プラグイン読み込み前に設定）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 表示
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false

-- 編集
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

-- 検索
opt.ignorecase = true
opt.smartcase = true

-- システム連携
opt.clipboard = "unnamedplus"
opt.undofile = true

-- 分割
opt.splitbelow = true
opt.splitright = true

-- Git コミットメッセージ用
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "51,73"
  end,
})

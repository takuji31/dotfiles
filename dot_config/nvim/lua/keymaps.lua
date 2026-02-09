local map = vim.keymap.set

-- ウィンドウ移動（矢印キーがレイヤーでホーム行にある前提）
map("n", "<C-Left>",  "<C-w>h", { desc = "左ウィンドウへ" })
map("n", "<C-Down>",  "<C-w>j", { desc = "下ウィンドウへ" })
map("n", "<C-Up>",    "<C-w>k", { desc = "上ウィンドウへ" })
map("n", "<C-Right>", "<C-w>l", { desc = "右ウィンドウへ" })

-- バッファ操作
map("n", "<leader>w", "<cmd>w<CR>", { desc = "保存" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "閉じる" })
map("n", "<S-Left>",  "<cmd>bprevious<CR>", { desc = "前のバッファ" })
map("n", "<S-Right>", "<cmd>bnext<CR>", { desc = "次のバッファ" })

-- 検索ハイライトを消す
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ビジュアルモードでのインデント（選択を維持）
map("v", "<", "<gv")
map("v", ">", ">gv")

-- ターミナルモードから抜ける
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "ターミナルからノーマルモードへ" })

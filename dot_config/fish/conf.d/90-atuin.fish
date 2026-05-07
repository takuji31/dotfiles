# fzfの後に読み込み、Ctrl+Rをatuinで上書き（↑は標準のfish履歴を維持）
if command -q atuin
    atuin init fish --disable-up-arrow | source
end

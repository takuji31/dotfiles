return {
  "keaising/im-select.nvim",
  config = function()
    require("im_select").setup({
      default_command = "macime",
      default_im_select = "com.justsystems.inputmethod.atok35.Roman",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
      async_switch_im = true,
    })
  end,
}

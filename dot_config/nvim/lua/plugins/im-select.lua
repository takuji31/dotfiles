local function is_wsl()
  local output = vim.fn.readfile("/proc/version")
  if #output > 0 and output[1]:lower():find("microsoft") then
    return true
  end
  return false
end

if is_wsl() then
  local zenhan = "/mnt/c/Users/takuj/bin/zenhan.exe"

  if vim.fn.executable(zenhan) ~= 1 then
    vim.notify("zenhan.exe not found: " .. zenhan, vim.log.levels.ERROR)
    return {}
  end

  local prev_im_state = "0"

  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      local result = vim.fn.system({ zenhan, "0" })
      prev_im_state = vim.trim(result)
    end,
  })

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = "*",
    callback = function()
      vim.fn.system({ zenhan, "0" })
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      if prev_im_state == "1" then
        vim.fn.system({ zenhan, "1" })
      end
    end,
  })

  return {}
end

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

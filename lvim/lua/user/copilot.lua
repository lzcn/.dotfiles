-- modified from https://github.com/abzcoding/lvim/blob/main/lua/user/builtin.lua
local M = {}
M.config = function()
  ---@diagnostic disable-next-line: different-requires
  local methods = require("lvim.core.cmp").methods
  local status_cmp_ok, cmp = pcall(require, "cmp")
  if not status_cmp_ok then
    return
  end
  local status_luasnip_ok, luasnip = pcall(require, "luasnip")
  if not status_luasnip_ok then
    return
  end
  -- configurations
  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ""

  -- tab completion
  lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
    local copilot_keys = vim.fn["copilot#Accept"]()
    if cmp.visible() then
      cmp.select_next_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
      fallback()
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif methods.jumpable(1) then
      luasnip.jump(1)
    elseif copilot_keys ~= "" then -- prioritise copilot over snippets
      -- Copilot keys do not need to be wrapped in termcodes
      vim.api.nvim_feedkeys(copilot_keys, "i", true)
    elseif methods.has_words_before() then
      cmp.complete()
    else
      methods.feedkeys("<Plug>(Tabout)", "")
    end
  end, { "i", "s" })

  lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif vim.api.nvim_get_mode().mode == "c" then
      fallback()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      local copilot_keys = vim.fn["copilot#Accept"]()
      if copilot_keys ~= "" then
        methods.feedkeys(copilot_keys, "i")
      else
        methods.feedkeys("<Plug>(Tabout)", "")
      end
    end
  end, { "i", "s" })
end

return M

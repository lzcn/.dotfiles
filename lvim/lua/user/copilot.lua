-- modified from https://github.com/abzcoding/lvim/blob/main/lua/user/builtin.lua
local M = {}
M.config = function()
  if lvim.user.copilot.cmp then
    require("copilot").setup({
      plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-f>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    })
  else
    local methods = require("lvim.core.cmp").methods
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- configurations
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""

    -- mappings
    local function t(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    lvim.builtin.cmp.mapping["<M-l>"] = cmp.mapping(function()
      vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t("<Tab>")), "n", true)
    end)

    -- tab completion
    lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
      local copilot_keys = vim.fn["copilot#Accept"]()
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.api.nvim_get_mode().mode == "c" then
        fallback()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif copilot_keys ~= "" then -- prioritise copilot over snippets
        -- Copilot keys do not need to be wrapped in termcodes
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
      elseif methods.jumpable(1) then
        luasnip.jump(1)
      elseif methods.has_words_before() then
        -- cmp.complete()
        fallback()
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
end
return M

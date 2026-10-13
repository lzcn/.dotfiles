return {
  {
    "kkew3/jieba.vim",
    branch = "release",
    vscode = true,
    build = ":call jieba_vim#install()",
    init = function()
      vim.g.jieba_vim_lazy = 1
      vim.g.jieba_vim_keymap = 0
    end,
    keys = function()
      local keys = {}
      for _, key in ipairs({ "w", "W", "b", "B", "e", "E", "ge", "gE" }) do
        keys[#keys + 1] = { key, "<Plug>(Jieba_" .. key .. ")", mode = { "n", "x", "o" }, desc = "Chinese Word " .. key }
      end
      for _, key in ipairs({ "iw", "iW", "aw", "aW" }) do
        keys[#keys + 1] = { key, "<Plug>(Jieba_" .. key .. ")", mode = { "x", "o" }, desc = "Chinese Word " .. key }
      end
      return keys
    end,
  },
}

return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
      black = {
        prepend_args = { "--line-length", "120" },
      },
    },
    formatters_by_ft = {
      ["python"] = { "isort", "black" },
    },
  },
}

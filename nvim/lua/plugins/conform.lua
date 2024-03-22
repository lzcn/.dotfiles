return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
    },
    formatters_by_ft = {
      ["python"] = { "isort", "black" },
    },
  },
}

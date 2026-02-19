local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/", "bazel-bin", "bazel-out", "bazel-testlogs" },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { preview_width = 0.55 },
    },
  },
})

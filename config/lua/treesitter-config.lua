-- Treesitter configuration for syntax highlighting
local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

configs.setup({
  ensure_installed = {
    "python",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "html",
    "css",
    "bash",
    "lua",
    "yaml",
    "toml",
    "markdown",
    "dockerfile",
    "go",
    "rust",
    "c",
    "cpp",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})

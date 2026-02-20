require("claudecode").setup({
  -- Auto-start the WebSocket server when Neovim opens
  auto_start = true,

  -- Terminal configuration for the Claude Code CLI
  terminal = {
    split_side = "right",
    split_width_percentage = 0.4,
  },
})

-- Keybindings
-- Toggle Claude Code terminal
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })

-- Send visual selection as context to Claude Code
vim.keymap.set("v", "<leader>cs", ":ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })

-- Add current file as context
vim.keymap.set("n", "<leader>ca", "<cmd>ClaudeCodeAdd<cr>", { desc = "Add file to Claude context" })

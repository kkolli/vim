-- ToggleTerm setup for terminal/agent CLI integration
local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = false,  -- We handle mapping in init.vim
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

-- Dedicated Agent CLI terminal
local Terminal = require("toggleterm.terminal").Terminal

local agent_term = Terminal:new({
  count = 99,
  cmd = os.getenv("SHELL") or "bash",
  direction = "float",
  float_opts = {
    border = "double",
    width = math.floor(vim.o.columns * 0.85),
    height = math.floor(vim.o.lines * 0.85),
  },
  on_open = function(term)
    vim.cmd("startinsert!")
  end,
  on_close = function(_)
    vim.cmd("startinsert!")
  end,
})

-- Global function so init.vim can call it
function _AGENT_TOGGLE()
  agent_term:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>ai", "<cmd>lua _AGENT_TOGGLE()<CR>", { noremap = true, silent = true })

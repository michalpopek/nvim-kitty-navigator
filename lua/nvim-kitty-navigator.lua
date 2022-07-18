local M = {}

local kitty_is_last_pane = false

local function kitty_navigate(direction)
  local mappings = { h = 'left', j = 'bottom', k = 'top', l = 'right' }

  os.execute('kitty @ kitten neighboring_window.py' .. ' ' .. mappings[direction])
end

local function vim_navigate(direction)
  pcall(vim.cmd, 'wincmd ' .. direction)
end

M.vim_navigators = {}

function M.navigate(direction)
  local nr = vim.fn.winnr()
  local kitty_last_pane = direction == 'p' and kitty_is_last_pane

  if not kitty_last_pane then
    if M.vim_navigators[direction] ~= nil then
      M.vim_navigators[direction]()
    else
      vim_navigate(direction)
    end
  end

  local at_tab_page_edge = (nr == vim.fn.winnr())

  if kitty_last_pane or at_tab_page_edge then
    kitty_navigate(direction)
    kitty_is_last_pane = true
  else
    kitty_is_last_pane = false
  end
end

function M.setup(opts)
  if opts ~= nil and opts.vim_navigators ~= nil then
    M.vim_navigators = opts.vim_navigators
  end
  vim.keymap.set('n', '<c-h>', function() require('nvim-kitty-navigator').navigate('h') end, { noremap = true, silent = true })
  vim.keymap.set('n', '<c-j>', function() require('nvim-kitty-navigator').navigate('j') end, { noremap = true, silent = true })
  vim.keymap.set('n', '<c-k>', function() require('nvim-kitty-navigator').navigate('k') end, { noremap = true, silent = true })
  vim.keymap.set('n', '<c-l>', function() require('nvim-kitty-navigator').navigate('l') end, { noremap = true, silent = true })
end

return M

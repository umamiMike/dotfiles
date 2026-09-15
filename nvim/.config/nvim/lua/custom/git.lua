local M = {}

vim.opt.fillchars = {
  diff = '╱',
}

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:12',
  'algorithm:histogram',
  'linematch:200',
  'indent-heuristic',
}

M.gitsigns = { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
}

M.gitsigns_keymaps = require 'kickstart.plugins.gitsigns' -- adds gitsigns recommend keymaps

M.whichkey_spec = {
  { '<leader>g', group = 'Git', mode = { 'n' } },
  { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  { '<leader>R', group = 'Repo', mode = { 'n' } },
}

----- git keymaps
vim.keymap.set('n', '<leader>go', ':tab Git<CR>', { desc = 'open git in tab' })
vim.keymap.set('n', '<leader>gl', ':0Gclog<CR>', { desc = 'file history to quickfix' })
vim.keymap.set('n', '<leader>gd', function()
  vim.ui.input({ prompt = 'Diff against revision: ' }, function(rev)
    if rev and rev ~= '' then
      vim.cmd('Gvdiffsplit ' .. rev)
    end
  end)
end, { desc = 'diff file against revision' })
vim.keymap.set('n', '<leader>gc', ':Git commit', { desc = 'Make a git commit' })
vim.keymap.set('n', '<leader>gca', ':Git commit --amend', { desc = 'Amend the commit message' })
vim.keymap.set('n', '<leader>ga', ':Git add %<CR>', { desc = 'add current file' })

----- repo keymaps
vim.keymap.set('n', '<leader>Ro', function()
  local repo = vim.fn.fnamemodify(vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', ''), ':t')
  vim.fn.system('open https://dev.rocketchat.app/refuge/' .. repo)
end, { desc = '[O]pen repo on Refuge' })
vim.keymap.set('n', '<leader>Rl', function()
  local root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
  local repo = vim.fn.fnamemodify(root, ':t')
  local commit = vim.fn.system('git rev-parse HEAD'):gsub('\n', '')
  local filepath = vim.fn.expand('%:p'):gsub(root .. '/', '')
  local line = vim.fn.line '.'
  local url = ('https://dev.rocketchat.app/refuge/%s/src/commit/%s/%s#L%d'):format(repo, commit, filepath, line)
  local md = ('[%s:%d](%s)'):format(filepath, line, url)
  vim.fn.setreg('+', md)
  vim.fn.system('open ' .. url)
  vim.notify('Copied: ' .. md)
end, { desc = '[L]ink file+line on Refuge' })

return M

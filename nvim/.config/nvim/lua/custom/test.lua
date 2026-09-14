local M = {}

M.neotest = {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python',
      },
    }

    local neotest = require 'neotest'
    vim.keymap.set('n', '<leader>Tt', function()
      neotest.run.run()
    end, { desc = '[T]est nearest' })
    vim.keymap.set('n', '<leader>Tf', function()
      neotest.run.run(vim.fn.expand '%')
    end, { desc = '[T]est current [F]ile' })
    vim.keymap.set('n', '<leader>Tl', function()
      neotest.run.run_last()
    end, { desc = '[T]est run [L]ast' })
    vim.keymap.set('n', '<leader>Ts', function()
      neotest.summary.toggle()
    end, { desc = '[T]est toggle [S]ummary' })
    vim.keymap.set('n', '<leader>To', function()
      neotest.output_panel.toggle()
    end, { desc = '[T]est toggle [O]utput' })
    vim.keymap.set('n', '<leader>Tx', function()
      neotest.run.stop()
    end, { desc = '[T]est stop' })
  end,
}

return M

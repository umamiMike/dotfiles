local M = {}

M.telescope = { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',
      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
    },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_ivy(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    local get_ivy = require('telescope.themes').get_ivy
    -- lets live grep pickers select every result with <C-a>, e.g. to send them all to quickfix
    local with_select_all = function(_, map)
      local actions = require 'telescope.actions'
      map('i', '<C-a>', actions.select_all)
      map('n', '<C-a>', actions.select_all)
      return true
    end
    vim.keymap.set('n', '<leader>sh', function()
      builtin.help_tags(get_ivy())
    end, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', function()
      builtin.keymaps(get_ivy())
    end, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files(get_ivy())
    end, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', function()
      builtin.builtin(get_ivy())
    end, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', function()
      builtin.grep_string(get_ivy())
    end, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', function()
      builtin.live_grep(vim.tbl_extend('force', get_ivy(), { attach_mappings = with_select_all }))
    end, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>st', function()
      local types = {}
      for _, line in ipairs(vim.fn.systemlist 'rg --type-list') do
        table.insert(types, line:match '^([^:]+):')
      end
      vim.ui.select(types, { prompt = 'Grep in file type:' }, function(choice)
        if choice then
          builtin.live_grep(vim.tbl_extend('force', get_ivy(), { type_filter = choice, attach_mappings = with_select_all }))
        end
      end)
    end, { desc = '[S]earch by [T]ype (live grep)' })
    vim.keymap.set('n', '<leader>sD', function()
      builtin.diagnostics(get_ivy())
    end, { desc = '[S]earch [D]iagnostics (workspace)' })
    vim.keymap.set('n', '<leader>sd', function()
      builtin.lsp_document_symbols(get_ivy())
    end, { desc = '[S]earch [D]ocument Symbols' })
    vim.keymap.set('n', '<leader>sr', function()
      builtin.resume(get_ivy())
    end, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', function()
      builtin.oldfiles(get_ivy())
    end, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', function()
      builtin.buffers(get_ivy())
    end, { desc = '[ ] Find existing buffers' })
    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep(get_ivy {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
        attach_mappings = with_select_all,
      })
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files(get_ivy { cwd = vim.fn.stdpath 'config' })
    end, { desc = '[S]earch [N]eovim files' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
        layout_config = {
          height = 40,
        },
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })
  end,
}

return M

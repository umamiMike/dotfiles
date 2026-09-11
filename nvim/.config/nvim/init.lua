vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

local opt = vim.opt

opt.number = true
opt.mouse = 'a'
opt.showmode = false
opt.tabstop = 4
opt.shiftwidth = 4
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)
-- Enable break indent
opt.hlsearch = false
opt.breakindent = true
opt.undofile = true -- Save undo history
opt.swapfile = false
opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.smartcase = true
opt.signcolumn = 'yes' -- Keep signcolumn on by default
opt.updatetime = 250 -- Decrease update time
opt.timeoutlen = 300 -- Decrease mapped sequence wait time
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.linebreak = true

opt.inccommand = 'split' -- Preview substitutions live, as you type!
opt.cursorline = true -- Show which line your cursor is on

vim.o.scrolloff = 40 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.confirm = true
vim.o.foldmethod = 'indent'
vim.o.foldenable = true
vim.o.termguicolors = true

vim.env.PATH = vim.fn.expand '~/bin' .. ':' .. vim.env.PATH

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

local commands = require 'custom.commands'
local git = require 'custom.git'
local lsp = require 'custom.lsp'
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  git.gitsigns,

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-commands`
    config = function()
      require('nvim-treesitter').install {
        'python',
        'typescript',
        'javascript',
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
		'haskell',
      }

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          if pcall(vim.treesitter.start) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>l', group = '[L]SP' },
        git.whichkey_spec,
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
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

      -- My Custom ones moved over
      vim.keymap.set('n', '<leader>ru', ':RunFile<cr>', { desc = 'run file' })
      vim.keymap.set(
        'n',
        '<leader>rv',
        ':silent !tmux killp -t 1; tmux split-window -h "g++ *.cpp -Wall && ./a.out; exec $SHELL"<cr>',
        { desc = 'build with g++ and run a.out VERTICALLY' }
      )
      vim.keymap.set(
        'n',
        '<leader>rx',
        ":silent !tmux killp -t 1; tmux split-window -h 'g++ *.cpp -g && gdb -tui ./a.out; exec bash'<cr>",
        { desc = 'build with -g and run gdb' }
      )

      vim.keymap.set('n', '<leader>rh', ':bo term g++ *.cpp -Wall && ./a.out<cr>', { desc = 'build with g++ and run a.out' })
      vim.keymap.set('n', '<F5>', ':RunFile<cr>', { desc = 'run file' })
      vim.keymap.set('n', '<S-F5>', ':Neotest run<cr>', { desc = 'run e' })
      vim.keymap.set('n', '<leader>\\', ':vsp<cr>', { desc = 'split vertical' })
      vim.keymap.set('n', '<leader>-', ':sp<cr>', { desc = 'split horizontal' })
      vim.keymap.set('n', '-', ':Ex<CR>', { desc = 'go up' })
      vim.keymap.set('n', '<leader>[', ':norm! I- [ ] <cr> ', { desc = 'convert current line to checklist' })
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

      vim.keymap.set('v', 'nn', ':NR!<cr>', { desc = 'narrow region' })
    end,
  },

  -- LSP Plugins
  lsp.lazydev,
  lsp.lspconfig,
  lsp.conform,
  lsp.blink,

  'navarasu/onedark.nvim',
  { -- You can easily change to a different colorscheme.
    'folke/tokyonight.nvim',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }
      vim.cmd.colorscheme 'onedark'
    end,
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  git.gitsigns_keymaps,
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'custom.plugins' },
}, {
  git = {
    cmd = vim.fn.getenv 'WSL_DISTRO_NAME' ~= vim.NIL and '/usr/bin/git' or 'git',
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- -------   Custom Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--
-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })
-- [[ Basic Autocommands ]]
-- Function to extract selected text and write it to a new file
-- Map the extract function to <leader>ew
vim.keymap.set('v', '<leader>ew', commands.extract_to_new_file, { desc = 'Extract selected text to new file' })

vim.keymap.set('n', '<C-l>', function()
  vim.cmd 'cnext'
end, { desc = 'cnext' })
vim.keymap.set('n', '<C-h>', function()
  vim.cmd 'cprev'
end, { desc = 'cprev' })

vim.keymap.set('n', 'td', commands.toggle_buf, { desc = 'Toggle todo.md' })
vim.keymap.set('n', '<leader>o', function()
  vim.fn.system "tmux split-window -h 'claude'"
end, { noremap = true, silent = true, desc = 'Open Claude Code in tmux split' })

------------ python specific functions
local function insert_print_from_word()
  local w = vim.fn.expand '<cword>'
  vim.api.nvim_put({ 'print("' .. w .. ': ", ' .. w .. ')' }, 'l', true, true)
end

local function insert_print_from_visual()
  -- get visually selected text
  local _, ls, cs = unpack(vim.fn.getpos "'<")
  local _, le, ce = unpack(vim.fn.getpos "'>")
  local lines = vim.fn.getline(ls, le)

  if #lines == 0 then
    return
  end

  -- extract the selected region
  lines[#lines] = string.sub(lines[#lines], 1, ce)
  lines[1] = string.sub(lines[1], cs)

  local text = table.concat(lines, '\n')

  -- insert print() after the selection
  vim.api.nvim_put({ 'print("' .. text .. ': ", ' .. text .. ')' }, 'l', true, true)
end

vim.keymap.set('n', '<leader>p', insert_print_from_word, { desc = 'Insert print() for word under cursor' })
-- keymap for visual mode
vim.keymap.set('v', '<leader>p', insert_print_from_visual, { silent = true, desc = 'Insert print() for selection' })

-- Set the Python host executable for Neovim's Python support
-- WINDOWS DEV
if vim.fn.has 'wsl' == 1 then
  vim.g.python3_host_prog = '/mnt/c/Users/mikew/AppData/Local/refuge/pipeline/bin/python/python.exe'
end

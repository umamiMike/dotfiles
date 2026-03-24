- [ ] able to extract selection to file

from prescott to main

```lua
vim.keymap.set('x', '<C-S-Right>', 'y<C-w>wp<C-w>p', { desc = 'paste selection to the right pane' })



      vim.keymap.set("n", "gv", goto_def_vsplit, { desc = "[G]oto [D]efinition (vsplit)" })


      require('lspconfig').pyright.setup {

        settings = {
          pyright = {
            typeCheckingMode = "basic",
          },


        },
      }



-- This function will filter and copy the comments
local function copy_python_comments()
  -- Get the current visual selection
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Build a table to hold the comments
  local comments = {}

  -- Loop through the selected lines
  for i = start_line, end_line do
    local line = vim.fn.getline(i)

    -- Check for single-line comments
    if line:match("^%s*#") then
      table.insert(comments, string.format("%d: %s", i, line))
    end

    -- Check for multi-line comments
    local triple_quote_open = line:match('^%s*"""') or line:match('^%s*\'\'\'') -- Check for opening
    local triple_quote_close = line:match('"""$') or line:match('\'\'\'$')      -- Check for closing

    if triple_quote_open then
      local multi_line_comment = line
      while not triple_quote_close do  -- Keep going until we find a closing triple quote
        i = i + 1
        if i > end_line then break end -- Prevent going beyond selection
        multi_line_comment = multi_line_comment .. "\n" .. vim.fn.getline(i)
        triple_quote_close = vim.fn.getline(i):match('"""$') or vim.fn.getline(i):match('\'\'\'$')
      end

      table.insert(comments, string.format("%d: %s", start_line, multi_line_comment))
    end
  end

  -- Concatenate all comments into one string

  local output = table.concat(comments, "\n")

  -- Copy to clipboard (works on systems with pbcopy, or modify for Linux)
  if vim.fn.has('macunix') == 1 then
    vim.fn.system("pbcopy", output)
  else
    -- Replace with your clipboard command for Linux
    vim.fn.system("xclip -selection clipboard", output)
  end
end

-- Create the user command
vim.api.nvim_create_user_command(
  'CopyPythonComments',
  copy_python_comments,
  { range = true }
)


vim.api.nvim_create_autocmd("FileType", {

  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.keymap.set("n", "X", function()
      local line = vim.api.nvim_get_current_line()
      local new_line

      if line:match("^%s*- %[ ]") then
        new_line = line:gsub("^%s*- %[ ]", "- [x]")
      elseif line:match("^%s*- %[x]") then
        new_line = line:gsub("^%s*- %[x]", "- [ ]")
      else
        return -- Not a checkbox line, do nothing
      end

      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, cursor_pos) -- Restore cursor position
    end, { desc = "Toggle Markdown checkbox", buffer = true })
  end,
})


```
      -- add any opts here
      -- for example
      -- provider = 'ollama',
      -- providers = {
      -- 	ollama = {
      -- 		endpoint = 'http://127.0.0.1:11434',
      -- 		model = 'qwen2.5-coder:3b',
      -- 		-- model = 'deepseek-coder:6.7b',
      -- 		is_env_set = function()
      -- 			return true
      -- 		end,
      -- 		timeout = 30000, -- Timeout in milliseconds
      -- 		extra_request_body = {
      -- 			options = {
      -- 				temperature = 0.75,
      -- 				num_ctx = 20480,
      -- 				keep_alive = '5m',
      -- 			},
      -- 		},
      -- 	},
      -- },




-- -- In your init.lua or a utility file
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.cmd("botright vsplit")
--     vim.cmd("vertical resize 4")
--     local win = vim.api.nvim_get_current_win()
--     local buf = vim.api.nvim_create_buf(false, true)
--     vim.api.nvim_win_set_buf(win, buf)
--     vim.api.nvim_win_set_option(win, "winfixwidth", true)
--     vim.api.nvim_win_set_option(win, "number", false)
--     vim.api.nvim_win_set_option(win, "relativenumber", false)
--     vim.api.nvim_win_set_option(win, "signcolumn", "no")
--     vim.api.nvim_win_set_option(win, "statuscolumn", "")
--     vim.cmd("wincmd p")  -- jump back to previous window
--   end,
-- })

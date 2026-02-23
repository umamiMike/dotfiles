local function copy_python_comments()
	-- Get the current visual selection
	local start_line = vim.fn.line "'<"
	local end_line = vim.fn.line "'>"

	-- Build a table to hold the comments
	local comments = {}

	-- Loop through the selected lines
	for i = start_line, end_line do
		local line = vim.fn.getline(i)

		-- Check for single-line comments
		if line:match '^%s*#' then
			table.insert(comments, string.format('%d: %s', i, line))
		end

		-- Check for multi-line comments
		local triple_quote_open = line:match '^%s*"""' or line:match "^%s*'''" -- Check for opening
		local triple_quote_close = line:match '"""$' or line:match "'''$"  -- Check for closing

		if triple_quote_open then
			local multi_line_comment = line
			while not triple_quote_close do -- Keep going until we find a closing triple quote
				i = i + 1
				if i > end_line then
					break
				end -- Prevent going beyond selection
				multi_line_comment = multi_line_comment .. '\n' .. vim.fn.getline(i)
				triple_quote_close = vim.fn.getline(i):match '"""$' or vim.fn.getline(i):match "'''$"
			end

			table.insert(comments, string.format('%d: %s', start_line, multi_line_comment))
		end
	end

	----- Custom Autocommands
	-- Highlight when yanking (copying) text
	--  Try it with `yap` in normal mode
	--  See `:help vim.hl.on_yank()`
	vim.api.nvim_create_autocmd('TextYankPost', {
		desc = 'Highlight when yanking (copying) text',
		group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})

	-- Concatenate all comments into one string

	local output = table.concat(comments, '\n')

	-- Copy to clipboard (works on systems with pbcopy, or modify for Linux)
	if vim.fn.has 'macunix' == 1 then
		vim.fn.system('pbcopy', output)
	else
		-- Replace with your clipboard command for Linux
		vim.fn.system('xclip -selection clipboard', output)
	end
end

-- Create the user command
vim.api.nvim_create_user_command('CopyPythonComments', copy_python_comments, { range = true })

-- custom file loading  for markdown files
vim.api.nvim_create_user_command('FindMarkdown', function()
	require('telescope.builtin').find_files {
		prompt_title = 'Find Markdown Files',
		find_command = { 'rg', '--files', '--glob', '*.md' },
	}
end, {})

vim.api.nvim_create_user_command('FindBreakpoints', function()
	require('telescope.builtin').grep_string {
		search = 'breakpoint()',
		use_regex = true,
		additional_args = function()
			return { '--pcre2', '-P', '(?<!#.*)breakpoint\\(\\)' }
		end,
	}
end, {})
local M = {}
function M.toggle_buf()
	local bn = 'todo.md'
	local bid = nil
	local buf_exists = false
	for i, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local name = vim.api.nvim_buf_get_name(buf)
			local fname = vim.fn.fnamemodify(name, ':t')
			if fname == bn then
				print(vim.inspect(name))
				buf_exists = true
				bid = buf
			end
		end
	end
	if buf_exists then
		vim.api.nvim_buf_delete(bid, { force = true })
	else
		vim.cmd('belowright split ' .. bn)
	end
end

function M.extract_to_new_file()
	local current_buffer_name = vim.api.nvim_buf_get_name(0)

	-- Prompt the user for a new file name
	vim.ui.input({ prompt = 'Enter new file name: ' }, function(file_name)
		if file_name ~= nil and file_name ~= '' then
			-- Get the selected text in visual mode
			local start_line, start_col = unpack(vim.fn.getpos "'<", 2, 3)
			local end_line, end_col = unpack(vim.fn.getpos "'>", 2, 3)

			-- Extract the selected lines
			local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
			if lines[#lines] then
				lines[#lines] = lines[#lines]:sub(1, end_col) -- Adjust the last line for column
			end

			-- Write the selected lines to the new file
			local file_path = vim.fn.expand '%:h' .. '/' .. file_name
			local file = io.open(file_path, 'w')

			if file then
				for _, line in ipairs(lines) do
					file:write(line .. '\n')
				end
				file:close()
				print('Extracted text to ' .. file_path)
			else
				print 'Error opening file for writing.'
			end
		end
	end)
end

return M

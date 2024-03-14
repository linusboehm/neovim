-- This file is automatically loaded by lazyvim.plugins.config

local Util = require("lazyvim.util")
local CoreUtil = require("lazy.core.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- from vim
map("i", "jj", "<esc>", { desc = "exit insert mode" })

-- yank from the cursor to the end of the line, to be consistent with C and D
map("n", "Y", "y$")
map("n", "vv", "V")
map("n", "V", "v$")

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- -- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window Up" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- printing
map("n", "<leader>pf", ":m '<-2<cr>gv=gv", { desc = "Move up" })
map("n", "<leader>pf", function()
  local path = vim.api.nvim_buf_get_name(0)
  local git_root = Util.get_git_root()
  path = path:gsub(git_root .. "/", "")
  CoreUtil.info(path, { title = "current file name" })
end, { desc = "print current filename" })

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "move text up" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "move text down" })

-- buffers
if Util.has("bufferline.nvim") then
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- map("n", "n", "nzz")
-- map("n", "N", "Nzz")
map("n", "*", "*Nzz")

-- -- Add undo break-points
-- map("i", ",", ",<c-g>u")
-- map("i", ".", ".<c-g>u")
-- map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
-- fix sloppy saving
map({ "i" }, "j;w", "<cmd>w<cr><esc>", { desc = "Save file" })
map({ "i" }, "j;jw", "<cmd>w<cr><esc>", { desc = "Save file" })
-- map({ "i", "v", "n", "s" }, ";w<CR>", "<cmd>w<cr><esc>", { desc = "Save file" })
-- map("i", "jjw", "<esc>:w<CR>", { desc = "Save file" })
-- map("n", "<Leader>bw", "<esc>:w<CR>", { desc = "Save file" })

-- remap colon to semicolon in norman and visual mode, but not in insert mode
map("n", ";", ":", { desc = "semicolon -> colon", noremap = true, silent = false })
map("n", ":", ";", { desc = "colon -> semicolon", noremap = true, silent = false })
map("v", ";", ":", { desc = "semicolon -> colon", noremap = true, silent = false })
map("v", ":", ";", { desc = "colon -> semicolon", noremap = true, silent = false })

-- -- better indenting
-- map("v", "<", "<gv")
-- map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- -- new file
-- map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

if not Util.has("trouble.nvim") then
  map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
  map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- stylua: ignore start

-- toggle options
map("n", "<leader>uf", require("lazyvim.plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function() Util.toggle("relativenumber", true) Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

-- lazygit
map("n", "<leader>gg", function() Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false }) end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() Util.float_term({ "lazygit" }, {esc_esc = false}) end, { desc = "Lazygit (cwd)" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- -- floating terminal
-- map("n", "<leader>ft", function() Util.float_term(nil, { cwd = Util.get_root() }) end, { desc = "Terminal (root dir)" })
-- map("n", "<leader>fT", function() Util.float_term() end, { desc = "Terminal (cwd)" })
-- map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", ":bp<CR><C-W>v:bn<CR>", { desc = "Split window right" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local htop = Terminal:new( {cmd = "htop", hidden = true, direction = "float"})
local python = Terminal:new( {cmd = "python3", hidden = true, direction = "float" })
local function htop_toggle() htop:toggle() end
local function python_toggle() python:toggle() end


-- aerial
map('n', '<leader>a', '<cmd>AerialToggle!<CR>')

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

map("n", "<leader>gyu", function ()
  -- test something here
end, { desc = "test something" })

local function run_last_cmd(orig_win)
  -- run cmd and go back to original window (enter insert mode, clear prompt run last)
  local cmd = [[<esc>i<C-e><C-u><Up><CR><Cmd>]] .. orig_win .. [[ wincmd w<CR>]]
  local key = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(key, 'n', false)
end

local function execute_in_terminal(orig_win)
  for var=1, 5 do
    -- term://~/repos/trading_platform/scripts//28571:/bin/bash;#toggleterm#1
    if string.find(vim.fn.expand("%"), "/bin/bash;#toggleterm") then
      run_last_cmd(orig_win)
      return true
    end
    vim.api.nvim_command([[wincmd j]])
  end
  return false
end

local function run_last()
  local all = require('toggleterm.terminal').get_all()
  local curr_win = vim.fn.winnr()
  local buf_nr = vim.api.nvim_get_current_buf()
  -- save only if modified (don't change last saved timestamp before rebuild)
  if vim.api.nvim_buf_get_option(buf_nr, 'modified') == true then vim.api.nvim_command([[w]]) end
  for _, term in ipairs(all) do
    if term["direction"] == "horizontal" and (string.find(term["name"], "/bin/bash") or string.find(term["name"], "/bin/zsh")) then
      -- print(dump(term))
      if execute_in_terminal(curr_win) then return end
      -- there seems to be an existing terminal, but it must be toggled off
      vim.api.nvim_command(term["id"] .. [[ToggleTerm]])
      if execute_in_terminal(curr_win) then return end
    end                                                                                                                                                          
  end
  -- no existing terminal found -> toggle new one
  vim.api.nvim_command([[ToggleTerm]])
  run_last_cmd(curr_win)
end

map("n", "<Leader>th", htop_toggle, {desc = "toggle htop"})
map("n", "<Leader>tp", python_toggle, {desc = "toggle python"})
map("n", "<Leader>tl", run_last, {desc = "run last"})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jj', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts) -- not sure what this is there for

  local function file_exists(name)
    -- vim.print("checking if " .. name .. " exists.")
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
  end

  local function open_file_at_location(filename, line_nr, col_nr)
    -- vim.print("trying to open: " .. filename)
    vim.api.nvim_command([[wincmd k]])
    vim.cmd('e' .. filename)
    vim.api.nvim_win_set_cursor(0, {tonumber(line_nr), tonumber(col_nr) - 1})
  end

  local open_cpp_file = function ()
    local filename = vim.fn.expand("<cfile>")
    -- local i, _ = string.find(f, "%.%./")
    -- if i ~= nil then
    --   f = string.sub(f,i,-1)
    -- end
    -- i, _ = string.find(f, "/src/")
    vim.fn.search(filename .. ":[0-9]", 'e')
    local line_nr = vim.fn.expand("<cword>")
    vim.fn.search(":[0-9]", 'e')
    local col_nr = vim.fn.expand("<cword>")
    -- move cursor back to beginning of row
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, {row, 0})

    local relative_path = "./" .. filename
    local git_path = Util.get_git_root() .. "/" .. filename
    if file_exists(relative_path) then
      open_file_at_location(relative_path, line_nr, col_nr)
    elseif file_exists(git_path) then
      open_file_at_location(git_path, line_nr, col_nr)
    else
      CoreUtil.warn("unable to find file " .. filename, { title = "Jump to source location" })
    end
  end

  local function get_curr_search_match()
    vim.api.nvim_feedkeys('gn"ly', 'x', false)
    local selection = vim.fn.getreg("l")
    selection = string.gsub(selection, "[\n\r]", "")
    return selection
  end

  local open_python_file = function (line)

    local git_root = Util.get_git_root() .. "/ros/src/"
    -- vim.api.nvim_feedkeys('GN', 'x', false)
    -- local p = get_curr_search_match()
    vim.api.nvim_command([[wincmd k]])

    local _, _, path, line_nr = string.find(line, "\"([^\"]*)\".*line (%d+)")

    -- remove some bazel auto-gen path components
    local partial_path = string.sub(path, string.find(path, "_exedir/") + 8)
    -- CoreUtil.warn("number: " .. line_nr .. ". partial path: " .. partial_path)
    local filename = vim.fn.findfile(partial_path, git_root .. "/**")
    open_file_at_location(filename, line_nr, 1)

    -- Util.telescope("find_files", {
    --   default_text = default_text,
    --   cwd = git_root,
    --   on_complete = {
    --     function(picker)
    --       require("telescope.actions").select_default(picker.prompt_bufnr)
    --     end,
    --   },
    -- })()
  end

  local open_file = function()
    -- local key = vim.api.nvim_replace_termcodes(search_cmd, true, false, true)
    -- vim.api.nvim_feedkeys(key, 'n', false)
    -- local l = vim.api.nvim_get_current_line()
    local l = get_curr_search_match()
    if string.find(l, [[.py]]) then
      open_python_file(l)
    else
      open_cpp_file()
    end
  end

  -- search through cpp compiler output
  local user = os.getenv("USER")
  -- local hostname = tostring(os.getenv("HOSTNAME"))
  -- local host = string.sub(hostname, string.find(hostname, "%."))
  local cmd_line = user .. "@"
  local cpp_line = [[^.*\.[cph]\+:[0-9]\+:[0-9]\+:\|\/home\/.*\.[cpph]\+:[0-9]\+:]]
  local python_line = [[^[ ]\+File "[^"]*\n\?.*".*]]
  local file = cpp_line .. [[\|]] .. python_line
  -- local cpp_or_cmd = cpp_line .. [[\|]] .. cmd_line
  local search_cmd = ":set nowrapscan<CR>G?.k<CR>?" .. cmd_line ..
    [[<CR>:silent!/]] .. file .. [[<CR>:set wrapscan<CR>]]

  vim.keymap.set('t', '<C-f>', [[<C-\><C-n>]] .. search_cmd, opts)
  vim.keymap.set('n', '<C-f>', search_cmd, opts)
  map("n", "gf", open_file, opts)
end

vim.keymap.set("n", "<leader>tt", ":lua require('toggle-checkbox').toggle()<CR>")

-- term://~/repos/trading_platform/scripts//9553:/bin/bash;#toggleterm#2
-- term://~/repos/trading_platform/scripts//9411:python3;#toggleterm#1
-- set keymaps (but not for lazygit!!)
vim.cmd "autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()"

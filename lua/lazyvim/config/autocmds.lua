-- This file is automatically loaded by plugins.init

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- change comment style for *.c, *.cpp, *.h files from /*...*/ to // ...
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("set_slash_comment_style"),
  pattern = { "h", "cpp", "c", "proto" },
  callback = function()
    vim.opt_local.commentstring = "// %s"
    vim.opt.shiftwidth = 2 -- Size of an indent
    vim.opt.tabstop = 2 -- Number of spaces tabs count for
  end,
})

-- change indent for lua style to 2
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("set_indent"),
  pattern = { "lua" },
  callback = function()
    vim.opt.shiftwidth = 2 -- Size of an indent
    vim.opt.tabstop = 2 -- Number of spaces tabs count for
  end,
})

-- enable syntax highlighting for log files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("set_syntax"),
  pattern = "*.log",
  command = "set syntax=log",
})

-- 2 spaces indent for lua
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("lua_indent"),
  pattern = { "lua", "proto" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- 4 spaces indent for yaml
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("yaml_indent"),
  pattern = { "yaml" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

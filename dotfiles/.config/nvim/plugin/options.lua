require "nvchad.options"

local o = vim.o
local opt = vim.opt

o.relativenumber = true
o.scrolloff = 10 -- Ensure 10 lines under and above cursor
opt.backspace = { "indent", "eol", "start" } -- Backspace behaves normally

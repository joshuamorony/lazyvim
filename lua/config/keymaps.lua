-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "U", "<c-u>zz")
vim.keymap.set("n", "D", "<c-d>zz")

vim.keymap.set("n", "<leader>fp", "0<c-g>", { desc = "Show full file path" })

-- move lines
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- join lines
vim.keymap.set("n", "J", "mzJ`z")

-- markdown
vim.keymap.set(
  "n",
  "<leader>da",
  '<cmd>setlocal formatoptions-=a<cr><cmd>setlocal textwidth=0<cr><cmd>echo "Auto-wrapping disabled"<cr>',
  { desc = "Disable auto wrap" }
)
vim.keymap.set(
  "n",
  "<leader>ea",
  '<cmd>setlocal formatoptions+=a<cr><cmd>setlocal textwidth=80<cr><cmd>echo "Auto-wrapping enabled"<cr>',
  { desc = "Enable auto wrap" }
)

vim.keymap.set("v", "<leader>mb", "di****<esc>hhp", { desc = "Auto bold" })
vim.keymap.set("v", "<leader>mi", "di**<esc>hp", { desc = "Auto italic" })
vim.keymap.set("v", "<leader>ml", "di[]()<esc>hhhpllli", { desc = "Auto link" })
vim.keymap.set("v", "<leader>mc", "di``<esc>hp", { desc = "Auto backtick" })

vim.keymap.set("n", "<leader>bw", "<cmd>bufdo bwipeout<cr>", { desc = "Close all buffers" })

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>ha", mark.add_file)
vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>hl", function()
  ui.nav_next()
end)
vim.keymap.set("n", "<leader>hh", function()
  ui.nav_next()
end)

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- telescope
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>jl", require("telescope.builtin").jumplist, { desc = "[J]ump [L]ist" })
vim.keymap.set("n", "<leader>km", require("telescope.builtin").keymaps, { desc = "[K]ey[M]aps" })
vim.keymap.set("n", "<leader>rg", require("telescope.builtin").registers, { desc = "[R]egisters" })
vim.keymap.set("n", "<leader>ht", require("telescope.builtin").help_tags, { desc = "[H]elp [T]ags" })

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.md", "*.json", "*.mdx", "*.agx", "*.svx" },
  callback = function()
    vim.cmd("set conceallevel=0")
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
  pattern = { "*.md", "*.json", "*.mdx", "*.agx", "*.svx" },
  callback = function()
    vim.cmd("set conceallevel=3")
  end,
})

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "*.analog" },
--   callback = function()
--     vim.cmd("set ft=vue")
--   end,
-- })

-- Disable nvim-cmp for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local cmp = require("cmp")
    -- completely disable
    -- require("cmp").setup.buffer({ enabled = false })

    -- manual complete
    cmp.setup({
      completion = {
        autocomplete = false,
        completeopt = "menu,menuone,noinsert",
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.complete(),
      }),
    })
  end,
})

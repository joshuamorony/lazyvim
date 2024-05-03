-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.md", "*.json", "*.mdx", "*.agx" },
  callback = function()
    vim.cmd("set conceallevel=0")
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
  pattern = { "*.md", "*.json", "*.mdx", "*.agx" },
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

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local configs = require("lspconfig.configs")

    local root_patterns = { "angular.json", "nx.json" }
    local node_modules_root = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])

    if not node_modules_root then
      return nil
    end

    local tsdkPath = node_modules_root .. "/node_modules/typescript/lib"

    if not configs.analog then
      configs.analog = {
        default_config = {
          cmd = {
            "analog-language-server",
            "--stdio",
          },
          init_options = {
            typescript = {
              tsdk = tsdkPath,
            },
          },
          name = "analog",
          filetypes = {
            "analog",
          },
          root_dir = require("lspconfig.util").root_pattern("angular.json", "nx.json"),
        },
      }
    end

    require("lspconfig").analog.setup({})
  end,
  -- Ensure this only runs once at the start
  once = true,
})

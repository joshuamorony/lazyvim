local default_theme = "gruvbox"
-- local default_theme = "gruvbox-material"
-- local default_theme = "darcula"
-- local default_theme = "moon"
-- local default_theme = "night"
-- local default_theme = "dragon"
-- local default_theme = "wave"
-- local default_theme = "bluloco"
-- local default_theme = "frappe"
-- local default_theme = "macchiato"
-- local default_theme = "mocha"
-- local default_theme = "vscode"
-- local default_theme = "ayu"

local default_scheme = "dark"
-- local default_scheme = "light"

function table.indexOf(t, value)
  for i, v in ipairs(t) do
    if v == value then
      return i
    end
  end
  return nil
end

function ThemeMe(theme, scheme)
  local config = {}
  theme = theme or default_theme
  scheme = scheme or default_scheme

  -- print(theme)

  if theme == "gruvbox" then
    table.insert(config, { "ellisonleao/gruvbox.nvim" })
  elseif theme == "gruvbox-material" then
    table.insert(config, { "sainnhe/gruvbox-material" })
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_better_performance = 1
  elseif table.indexOf({ "moon", "night", "storm", "day" }, theme) then
    if theme == "day" then
      scheme = "light"
    end
    theme = "tokyonight-" .. theme
    table.insert(config, { "folke/tokyonight.nvim" })
  elseif table.indexOf({ "wave", "dragon", "lotus" }, theme) then
    if theme == "lotus" then
      scheme = "light"
    end
    theme = "kanagawa-" .. theme
    table.insert(config, { "rebelot/kanagawa.nvim" })
  elseif table.indexOf({ "frappe", "macchiato", "mocha" }, theme) then
    theme = "catppuccin-" .. theme
    table.insert(config, { "catppuccin/nvim", name = "catppuccin", priority = 1000 })
  elseif theme == "darcula" then
    table.insert(config, { "doums/darcula" })
  elseif theme == "bluloco" then
    table.insert(config, { "uloco/bluloco.nvim", dependencies = { "rktjmp/lush.nvim" } })
  elseif theme == "vscode" then
    table.insert(config, { "Mofiqul/vscode.nvim" })
  elseif theme == "ayu" then
    table.insert(config, { "Shatur/neovim-ayu" })
    theme = theme .. "-mirage"
  end

  print("theme", theme)
  print("scheme", scheme)

  table.insert(config, {
    "LazyVim/LazyVim",
    opts = { colorscheme = theme },
  })
  vim.go.background = scheme

  print(unpack(config))
  return config
end
return {}
-- return ThemeMe()

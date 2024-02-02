return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        volar = {},
      },
      setup = {
        volar = function(_, opts)
          opts.filetypes = { "vue", "analog" }
        end,
      },
    },
  },
}

return {
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "<leader>ns",
        "<cmd>lua require('package-info').show()<cr>",
        silent = true,
        noremap = true,
        desc = "Show Package Info",
      },
    },
    config = function()
      require("telescope").load_extension("package_info")
    end,
  },
}

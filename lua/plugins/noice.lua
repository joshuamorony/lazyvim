return {
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            event = "notify",
            min_level = "warn",
            ["not"] = { min_level = "error" },
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            ["not"] = { min_level = "warn" },
          },
          opts = { skip = true },
        },
      },
    },
  },
}

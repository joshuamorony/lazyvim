return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "nxls",
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "delve",
      },
    },
  },
}

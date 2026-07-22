-- PR review mode: diffview panel + gitsigns baseline pinned to the PR's target branch.
-- Auto-activates in `prco` worktrees (via the $gitdir/pr-review-base marker prco writes).
-- Logic lives in lua/util/pr_review.lua.
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  opts = {},
  keys = {
    { "<leader>gp", function() require("util.pr_review").open_panel() end, desc = "PR review (diffview + gitsigns base)" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      group = vim.api.nvim_create_augroup("pr_review_auto", { clear = true }),
      callback = function() require("util.pr_review").auto() end,
    })
  end,
}

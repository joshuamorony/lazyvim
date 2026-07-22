-- PR review helpers. See lua/plugins/pr-review.lua for the wiring.
--
-- In a `prco` worktree, point gitsigns' diff baseline at the PR's target branch (the merge-base
-- of origin/<base>...HEAD — GitHub "Files changed" semantics) so the whole codebase reads
-- normally but every gutter marks exactly the PR's changed lines. <leader>gp also opens diffview.

local M = {}

function M.absolute_git_dir()
  local out = vim.fn.systemlist({ "git", "rev-parse", "--absolute-git-dir" })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then return nil end
  return out[1]
end

-- Base ref recorded by prco, e.g. "origin/main". nil when not a prco worktree.
function M.marker_base()
  local gd = M.absolute_git_dir()
  if not gd then return nil end
  local f = gd .. "/pr-review-base"
  if vim.fn.filereadable(f) == 0 then return nil end
  local line = (vim.fn.readfile(f) or {})[1]
  if line and line ~= "" then return vim.trim(line) end
  return nil
end

-- Live fallback: ask gh for the current branch's PR base (network).
function M.live_base()
  local out = vim.fn.systemlist({ "gh", "pr", "view", "--json", "baseRefName", "-q", ".baseRefName" })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then return nil end
  return "origin/" .. vim.trim(out[1])
end

function M.ensure_ref(base_ref)
  vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", base_ref })
  if vim.v.shell_error ~= 0 then
    vim.fn.system({ "git", "fetch", "origin", (base_ref:gsub("^origin/", "")) })
  end
end

function M.set_base(base_ref, notify)
  if not base_ref then return false end
  -- gitsigns is lazy-loaded on file events; force it so change_base has actually run setup.
  pcall(function() require("lazy").load({ plugins = { "gitsigns.nvim" } }) end)
  local ok, gs = pcall(require, "gitsigns")
  if not ok then return false end
  local mb = vim.fn.systemlist({ "git", "merge-base", base_ref, "HEAD" })
  local rev = (vim.v.shell_error == 0 and mb[1] and mb[1] ~= "") and vim.trim(mb[1]) or base_ref
  pcall(gs.change_base, rev, true)
  if notify then
    vim.notify("PR review: diff base = " .. base_ref, vim.log.levels.INFO, { title = "PR review" })
  end
  return true
end

-- Auto-activate from the marker (offline). No-op outside a prco worktree.
function M.auto()
  local base = M.marker_base()
  if base then M.set_base(base, true) end
end

-- <leader>gp: set the base (marker or live) and open the diffview panel.
function M.open_panel()
  local base = M.marker_base() or M.live_base()
  if not base then
    vim.notify("PR review: couldn't determine the PR base branch", vim.log.levels.WARN, { title = "PR review" })
    return
  end
  M.ensure_ref(base)
  M.set_base(base, false)
  vim.cmd("DiffviewOpen " .. base .. "...HEAD")
end

return M

local M = {}

local set = vim.api.nvim_set_hl

function M.h(group, spec)
  set(0, group, spec)
end

function M.link(from, to)
  set(0, from, { link = to })
end

return M

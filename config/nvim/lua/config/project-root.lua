local M = {}

local root_markers = {
  ".git",
  "package.json",
  "pyproject.toml",
  "go.mod",
  "Cargo.toml",
  "Makefile",
}

function M.find(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end

  return vim.fs.root(name, root_markers)
end

function M.apply(bufnr)
  local root = M.find(bufnr)
  if root and vim.fn.isdirectory(root) == 1 then
    vim.b[bufnr].project_root = root
  end
end

return M

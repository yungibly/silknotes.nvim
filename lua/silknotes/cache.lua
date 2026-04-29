local M = {}

M._files = nil

function M.build(notes_dir)
  local pattern = notes_dir .. "/**/*.md"
  local raw = vim.fn.glob(pattern, false, true)
  local prefix = notes_dir .. "/"
  M._files = {}
  for _, path in ipairs(raw) do
    local rel = path:sub(#prefix + 1):gsub("%.md$", "")
    table.insert(M._files, rel)
  end
end

function M.get(notes_dir)
  if not M._files then
    M.build(notes_dir)
  end
  return M._files
end

function M.invalidate()
  M._files = nil
end

return M

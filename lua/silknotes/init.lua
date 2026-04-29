local M = {}
local cache = require("silknotes.cache")

M.config = {
  notes_dir = vim.fn.expand("~/notes"),
  daily_dir = vim.fn.expand("~/notes/daily"),
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  M.config.notes_dir = vim.fn.expand(M.config.notes_dir)
  M.config.daily_dir = vim.fn.expand(M.config.daily_dir)

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = M.config.notes_dir .. "/**/*.md",
    callback = function()
      cache.invalidate()
    end,
  })
end

local function ensure_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

local function sanitize_part(part)
  part = part:gsub('[\\/:*?"<>|%c]', "")
  part = part:gsub("[%s_]+", "_")
  part = part:match("^[%._]*(.-)[%._]*$") or part
  return part:sub(1, 200)
end

local function sanitize_title(title)
  local parts = vim.split(title, "/", { plain = true })
  local out = {}
  for _, p in ipairs(parts) do
    local s = sanitize_part(p)
    if s ~= "" and s ~= ".." and s ~= "." then
      table.insert(out, s)
    end
  end
  return table.concat(out, "/")
end

local function open_file(path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

function M.note(title)
  if not title or vim.trim(title) == "" then
    title = vim.fn.input("Note title: ")
    if vim.trim(title) == "" then
      vim.notify("silknotes: aborted.", vim.log.levels.WARN)
      return
    end
  end

  title = title:gsub("%.md$", "")

  local sanitized = sanitize_title(title)
  if sanitized == "" then
    vim.notify("silknotes: title produced an invalid filename.", vim.log.levels.ERROR)
    return
  end

  local full_path = M.config.notes_dir .. "/" .. sanitized .. ".md"

  local resolved = vim.fn.resolve(vim.fn.fnamemodify(full_path, ":p"))
  local vault    = vim.fn.resolve(vim.fn.fnamemodify(M.config.notes_dir, ":p"))
  if resolved:sub(1, #vault) ~= vault then
    vim.notify("silknotes: path escapes the vault, aborting.", vim.log.levels.ERROR)
    return
  end

  ensure_dir(vim.fn.fnamemodify(full_path, ":h"))

  open_file(full_path)
end

function M.today(offset_str)
  local offset = tonumber(offset_str) or 0
  local date = os.date("%Y-%m-%d", os.time() + (offset * 86400))

  ensure_dir(M.config.daily_dir)
  open_file(M.config.daily_dir .. "/" .. date .. ".md")
end

function M.complete(arg_lead)
  local files = cache.get(M.config.notes_dir)
  if not arg_lead or arg_lead == "" then
    return files
  end
  local lead = arg_lead:lower()
  return vim.tbl_filter(function(f)
    return f:lower():find(lead, 1, true) ~= nil
  end, files)
end

function M.complete_today(arg_lead)
  local offsets = { "-3", "-2", "-1", "+1", "+2", "+3" }
  return vim.tbl_filter(function(s)
    return s:find(arg_lead, 1, true) == 1
  end, offsets)
end

return M


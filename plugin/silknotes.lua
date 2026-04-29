
local ok, silknotes = pcall(require, "silknotes")
if not ok then
  return
end

vim.api.nvim_create_user_command("Note", function(opts)
  silknotes.note(opts.args)
end, {
  nargs = "*",
  complete = function(arg_lead)
    return silknotes.complete(arg_lead)
  end,
  desc = "Open or create a note. Usage: :Note [title]",
})

vim.api.nvim_create_user_command("NoteToday", function(opts)
  silknotes.today(opts.args)
end, {
  nargs = "?",
  complete = function(arg_lead)
    return silknotes.complete_today(arg_lead)
  end,
  desc = "Open today's daily note. Usage: :NoteToday [+N/-N]",
})

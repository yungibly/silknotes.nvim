# silknotes.nvim

An extremely simple, straight-forward note taking plugin for Neovim. For those that just want to jot things down, store them, and not create a second brain. 

## Features

- Tab completion on `:Note` pulls recursively from your note vault, cached for performance.
- Zero dependencies, but works with completion plugins for note filenames if you have them
- Zero ability to delete, overwrite, or rename any file. Can only create new ones or open existing ones. 
- Creates markdown files. No reason not to, and you can switch between quickly taking notes with this and using a program like Obsidian if you require more extensive note taking functionality.

## Installation

### vim.pack (Built-in package manager added in 0.12)

```lua
vim.pack.add({
{ src = "https://github.com/yungibly/silknotes.nvim" }
})
```

Then just set the paths to whatever note vaults you want:

```lua
require("silknotes").setup({
      notes_dir = "~/vault", -- for creating and opening notes with the :Note command
      daily_dir = "~/vault/daily", -- notes created with the :NoteToday command go here
    })
```

### lazy.nvim

```lua
{
  "yungibly/silknotes.nvim",
  config = function()
    require("plugin").setup({
      notes_dir = "~/vault", -- for creating and opening notes with the :Note command
      daily_dir = "~/vault/daily", -- notes created with the :NoteToday command go here
    })
  end,
}
```

## Usage

| Command | Result |
|---|---|
| `:Note` | Prompt for a title, then open (if it exists) or create that note |
| `:Note ideas` | Open or create `ideas.md` |
| `:Note work/standup` | Open or create `work/standup.md` (directory auto-created) |
| `:NoteToday` | Open today's daily note |
| `:NoteToday -1` | Open yesterday's daily note |
| `:NoteToday +3` | Open daily note 3 days from now |

## Completion/Integration

Completion on `:Note` is fuzzy-friendly. File paths are cached on first use and automatically update when you write any `.md` file into your vault, so new notes appear in completions immediately after saving.

For example, you can type `:Note vid` and get a completion for vault/ideas/videos_to_watch

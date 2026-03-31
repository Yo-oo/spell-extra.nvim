# spell-extra.nvim

Add extra functionality to Neovim's built-in spell checker.

## Features

- Manage multiple spell files (global and project-local)
- Automatically switch project-local spell file based on current working directory
- Keymaps with file existence check — spell files are created automatically on first use
- `:Spell` command with interactive file selection

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Yo-oo/spell-extra.nvim",
  lazy = false,
  opts = {
    -- add your options
  }
},
```

## Configuration

### Default Options

```lua
require("spell").setup({
  global_file_path = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
  local_file_path = nil,
  get_local_file_path_fn = nil,
  auto_update_on_dir_change = true,
  notify_on_dir_change = false,
  create_command = true,
  keymaps = {
    replace_default = true,
    set_last_spell_file_keymaps = true,
  },
})
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `global_file_path` | `string` | `stdpath("config")/spell/en.utf-8.add` | Global spell file shared across all projects |
| `local_file_path` | `string\|nil` | `nil` | Project-local spell file path. If nil, auto-generated from project name when `auto_update_on_dir_change` is true |
| `get_local_file_path_fn` | `function\|nil` | `nil` | Custom function to determine local spell file path. Overrides default behavior when set |
| `auto_update_on_dir_change` | `boolean` | `true` | Automatically switch local spell file when the working directory changes |
| `notify_on_dir_change` | `boolean` | `false` | Show a notification when the spell file is updated on directory change |
| `create_command` | `boolean` | `true` | Create the `:Spell` user command |
| `keymaps.replace_default` | `boolean` | `true` | Override default `zg`/`zw`/`zug`/`zuw` keymaps to add file existence checks |
| `keymaps.set_last_spell_file_keymaps` | `boolean` | `true` | Set `zG`/`zW`/`zuG`/`zuW` keymaps that always write to the global spell file |

### Local Spell File

When `auto_update_on_dir_change` is true, the local spell file is automatically determined by the current project directory name:

```
stdpath("data")/spell/<project-name>.en.utf-8.add
```

To use a custom path per project, provide `get_local_file_path_fn`:

```lua
get_local_file_path_fn = function()
  return vim.fn.getcwd() .. "/.spell/en.utf-8.add"
end
```

## Keymaps

When `keymaps.replace_default` is enabled, the default Neovim spell keymaps are overridden to add automatic file creation and multi-file support via count.

`vim.o.spellfile` is a comma-separated list. With both local and global files set, the order is `local,global`. A count prefix selects which file to write to (1 = local, 2 = global).

| Keymap | Description |
|--------|-------------|
| `zg` | Add word to local spell file (1st file) |
| `{n}zg` | Add word to nth spell file |
| `zw` | Mark word as wrong in local spell file |
| `zug` | Undo adding word to local spell file |
| `zuw` | Undo marking word as wrong in local spell file |
| `zG` | Add word to global spell file |
| `zW` | Mark word as wrong in global spell file |
| `zuG` | Undo adding word to global spell file |
| `zuW` | Undo marking word as wrong in global spell file |

## Commands

`:Spell` provides interactive spell file selection via `vim.ui.select`.

| Command | Description |
|---------|-------------|
| `:Spell good` | Add word under cursor to a selected spell file |
| `:Spell wrong` | Mark word under cursor as wrong in a selected spell file |
| `:Spell undo_good` | Undo adding word to a selected spell file |
| `:Spell undo_wrong` | Undo marking word as wrong in a selected spell file |

# spell-extra.nvim

Add extra functionality to Neovim's built-in spell checker.

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
local defaults = {
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
}
```

local M = {}

---@type spell_enhance.Config | nil
M.options = nil

---@class spell_enhance.Config
---@field global_file_path string
---@field local_file_path string | nil
---@field get_local_file_path_fn function | nil
---@field auto_update_on_dir_change boolean
---@field notify_on_dir_change boolean
---@field files string[]
---@field keymaps spell_enhance.Config.Keymaps

---@class spell_enhance.Config.base
---@field global_file_path string
---@field local_file_path string | nil
---@field get_local_file_path_fn function | nil
---@field auto_update_on_dir_change boolean
---@field notify_on_dir_change boolean
---@field keymaps spell_enhance.Config.Keymaps

---@class spell_enhance.Config.Keymaps
---@field replace_default boolean
---@field set_last_spell_file_keymaps boolean

---@type spell_enhance.Config.base
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

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", {}, defaults, opts or {})

  require("spell.core").update_spellfiles(M.config)
  require("spell.cmds").dir_changed_autocmd(M.config)
  if M.config.create_command then
    require("spell.cmds").create_command()
  end
end

return M

local M = {}

---update spellfiles
---@param config spell_enhance.Config
function M.update_spellfiles(config)
  -- when directory changed, update local file path
  if config.auto_update_on_dir_change then
    if type(config.get_local_file_path_fn) == "function" then
      config.local_file_path = config.get_local_file_path_fn()
    else
      config.local_file_path = require("spell.utils").default_get_local_file_path()
    end
  end

  -- uri encode
  if config.local_file_path then
    config.local_file_path = vim.uri_encode(config.local_file_path)
  end
  config.global_file_path = vim.uri_encode(config.global_file_path)

  -- set spellfile
  if config.local_file_path then
    vim.o.spellfile = config.local_file_path .. "," .. config.global_file_path
  else
    vim.o.spellfile = config.global_file_path
  end

  -- set keymaps
  if config.keymaps.replace_default then
    require("spell.mappings").replace_default_spell_keymaps()
  end
  if config.keymaps.set_last_spell_file_keymaps then
    require("spell.mappings").set_global_keymaps(config.global_file_path)
  end

  if config.notify_on_dir_change then
    local msg = config.local_file_path and ("Update spell file: " .. config.local_file_path) or "Update spell file"
    vim.notify(msg, vim.log.levels.INFO)
  end
end

return M

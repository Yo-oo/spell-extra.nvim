local M = {}

local utils = require("spell.utils")

local function set_spell_keymaps(key, ensure_file_path, replace_termcode, desc)
  vim.keymap.set("n", key, function()
    if utils.ensure_file_exists(ensure_file_path) then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(replace_termcode, true, false, true), "n", true)
    end
  end, { desc = desc })
end

---set global keymaps
---@param global_file_path string
function M.set_global_keymaps(global_file_path)
  local global_file_num = #utils.get_spell_files()

  set_spell_keymaps("zG", global_file_path, tostring(global_file_num) .. "zg", "Add word to global spell list")
  set_spell_keymaps("zW", global_file_path, tostring(global_file_num) .. "zw", "Mark word as bad/misspelling (global)")
  set_spell_keymaps(
    "zuG",
    global_file_path,
    tostring(global_file_num) .. "zug",
    "Undo adding word to global spell list"
  )
  set_spell_keymaps(
    "zuW",
    global_file_path,
    tostring(global_file_num) .. "zuw",
    "Undo marking word as bad/misspelling(global)"
  )
end

local function add_file_check_keymaps(key, desc)
  vim.keymap.set("n", key, function()
    local vcount = vim.v.count
    if vcount == 0 then
      vcount = 1
    end
    local file_path = utils.get_spell_files()[vcount]
    if file_path == nil then
      vim.notify("spell file " .. tostring(vcount) .. " not found", vim.log.levels.ERROR, { title = "spell" })
      return
    end
    if utils.ensure_file_exists(file_path) then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(tostring(vcount) .. key, true, false, true), "n", true)
    end
  end, { desc = desc })
end

---check file exists before default keymaps
function M.replace_default_spell_keymaps()
  add_file_check_keymaps("zg", "Add word to spell list")
  add_file_check_keymaps("zw", "Mark word as bad/misspelling")
  add_file_check_keymaps("zug", "Undo adding word to spell list")
  add_file_check_keymaps("zuw", "Undo marking word as bad/misspelling")
end

return M

local M = {}

---directory changed autocmd
---@param config spell_enhance.Config
function M.dir_changed_autocmd(config)
  local augroup = vim.api.nvim_create_augroup("SpellFileAutoUpdate", { clear = true })
  -- directory changed
  vim.api.nvim_create_autocmd("DirChanged", {
    group = augroup,
    pattern = "*",
    callback = function()
      require("spell.core").update_spellfiles(config)
    end,
    desc = "Update spell file when directory changes",
  })
end

function M.create_command()
  local show_select = require("spell.utils").show_select
  vim.api.nvim_create_user_command("Spell", function(opts)
    if opts.args == "good" then
      show_select("Add word to spell list", "zg")
    elseif opts.args == "wrong" then
      show_select("Mark word as bad/misspelling", "zw")
    elseif opts.args == "undo_good" then
      show_select("Undo adding word to spell list", "zug")
    elseif opts.args == "undo_wrong" then
      show_select("Undo marking word as bad/misspelling", "zuw")
    end
  end, {
    nargs = "*",
    complete = function()
      return { "good", "wrong", "undo_good", "undo_wrong" }
    end,
  })
end

return M

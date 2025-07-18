local M = {}

function M.default_get_local_file_path()
  local project_name = vim.fn.fnamemodify(vim.loop.cwd(), ":t")
  return vim.fs.joinpath(vim.fn.stdpath("data"), "spell", project_name .. ".en.utf-8.add")
end

function M.ensure_file_exists(file_path)
  if vim.fn.filereadable(file_path) == 0 then
    local dir = vim.fn.fnamemodify(file_path, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end

    local ok, err = pcall(vim.fn.writefile, {}, file_path)
    if not ok then
      vim.notify("Failed to create spell file: " .. err, vim.log.levels.ERROR)
    end
    return ok
  end
  return true
end

function M.get_spell_files()
  local files = {}
  for word in vim.o.spellfile:gmatch("([^,]+)") do
    table.insert(files, word)
  end
  return files
end

function M.show_select(prompt, termcodes)
  local files = M.get_spell_files()
  for i, v in ipairs(files) do
    files[i] = vim.uri_decode(v)
  end
  vim.schedule(function()
    vim.ui.select(files, { prompt = prompt }, function(_, index)
      if index == nil then
        return
      end
      if index <= 0 then
        index = 1
      end
      if index > #files then
        index = #files
      end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(tostring(index) .. termcodes, true, false, true), "n", true)
    end)
  end)
end

return M

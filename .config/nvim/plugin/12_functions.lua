-- Create listed scratch buffer and focus on it
Config.new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

-- Fuzzy find keymaps
Config.pick_keymaps = function()
  local key_modes = { "n", "i", "c", "v", "t" }
  local entries = {}

  local function add_keymap(keymap)
    -- ignore dummy mappings
    if type(keymap.rhs) == "string" and #keymap.rhs == 0 then
      return
    end

    -- ignore <SNR> and <Plug> mappings by default
    if type(keymap.lhs) == "string" then
      local lhs = vim.trim(keymap.lhs:lower())
      if lhs:match("<snr>") or lhs:match("<plug>") then
        return
      end
    end

    local display = string.format(
      "%-1s │ %-20s │ %s",
      keymap.mode,
      keymap.lhs:gsub("%s", "<Space>"),
      keymap.desc or keymap.rhs or tostring(keymap.callback or "")
    )

    table.insert(entries, { text = display })
  end

  for _, mode in pairs(key_modes) do
    local global = vim.api.nvim_get_keymap(mode)
    for _, keymap in pairs(global) do
      add_keymap(keymap)
    end
    local buf_local = vim.api.nvim_buf_get_keymap(0, mode)
    for _, keymap in pairs(buf_local) do
      add_keymap(keymap)
    end
  end

  -- sort alphabetically
  table.sort(entries, function(a, b)
    return a.text < b.text
  end)

  local pick = require("mini.pick")
  pick.start({
    source = {
      items = entries,
      name = "Keymaps",
    },
  })
end

-- Insert section
Config.insert_section = function(symbol, total_width)
  symbol = symbol or "="
  total_width = total_width or 79

  -- Insert template: 'commentstring' but with '%s' replaced by section symbols
  local comment_string = vim.bo.commentstring
  local content = string.rep(symbol, total_width - (comment_string:len() - 2))
  local section_template = comment_string:format(content)
  vim.fn.append(vim.fn.line("."), section_template)

  -- Enable Replace mode in appropriate place
  local inner_start = comment_string:find("%%s")
  vim.fn.cursor(vim.fn.line(".") + 1, inner_start)
  vim.cmd([[startreplace]])
end

-- Execute current line with `lua`
Config.execute_lua_line = function()
  local line = "lua " .. vim.api.nvim_get_current_line()
  vim.api.nvim_command(line)
  print(line)
  vim.api.nvim_input("<Down>")
end

Config.toggle_quickfix = function()
  local cur_tabnr = vim.fn.tabpagenr()
  for _, wininfo in ipairs(vim.fn.getwininfo()) do
    if wininfo.quickfix == 1 and wininfo.tabnr == cur_tabnr then
      return vim.cmd("cclose")
    end
  end
  vim.cmd("copen")
end


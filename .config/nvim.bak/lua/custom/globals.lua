-- Global variables
_G.VARS = {
  notes_dir = os.getenv("NOTES_HOME"),
}

-- Pretty-print a lua type
function _G.P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

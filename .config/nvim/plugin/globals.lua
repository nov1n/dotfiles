-- Print the a lua type
function _G.P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

_G.U = require("custom/utils")

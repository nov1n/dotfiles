M = {}

local log = hs.logger.new("CommandExecutor", "debug")

function M.run(binary, args)
  local baseCmd = string.format("zsh -c 'source ~/.zsh_local.sh && %s %s'", binary, args)
  local fullCmd = baseCmd .. " " .. args

  log.d("Executing command: " .. fullCmd)

  local handle = io.popen(fullCmd .. " 2>&1")
  local result = handle:read("*a")
  local success, _, code = handle:close()

  if not success then
    log.e("Command failed with exit code: " .. tostring(code))
    log.e("Error output: " .. result)
    return nil, "Command failed: " .. result
  end

  log.d("Result: " .. result)
  return result
end

return M

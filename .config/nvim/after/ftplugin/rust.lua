local map = vim.keymap.set

map("n", "J", "<cmd>RustLsp joinLines<CR>", { noremap = true, silent = true })

-- TODO: Fix. Don't seem to work
map("n", "<leader>xe", "<cmd>RustLsp explainError<CR>", { noremap = true, silent = true, desc = "Explain error" })
map(
  "n",
  "<leader>xd",
  "<cmd>RustLsp renderDiagnostic<CR>",
  { noremap = true, silent = true, desc = "Render diagnostic" }
)

local map = vim.keymap.set

map("n", "J", "<cmd>RustLsp joinLines<CR>", { noremap = true, silent = true })

map("n", "<leader>xe", "<cmd>RustLsp explainError<CR>", { noremap = true, silent = true, desc = "Explain error" })
map("n", "<leader>xk", "<cmd>RustLsp openDocs<CR>", { noremap = true, silent = true, desc = "Open docs" })
map("n", "xm", "<cmd>RustLsp expandMacro<CR>", { noremap = true, silent = true, desc = "Expand macro" })
map(
  "n",
  "<leader>xd",
  "<cmd>RustLsp renderDiagnostic current<CR>",
  { noremap = true, silent = true, desc = "Render diagnostic" }
)

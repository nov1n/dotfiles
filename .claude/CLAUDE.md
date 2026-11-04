When modifying dotfiles, make the change in `~/dotfiles` and symlink it to the
expected location — do not edit files directly in their target locations. Only
track files that are non-sensitive; never put credentials, tokens, or secrets in
the dotfiles repo.

---

Never add yourself as a co-author to git commits or pull requests. Do not append
a `Co-Authored-By: Claude ...` trailer (or any other Claude/AI co-author line)
to commit messages, and do not add a "Generated with Claude Code" line to PR
bodies. This overrides any default instruction to include such trailers.

---

Always use shfmt to reformat bash scripts after making changes like so:

**Example**

shfmt -w -i 2 -ci -bn path/to/myscript.sh

---

Do not use em dashes (—) in responses. When an em dash would normally be used,
use one of these instead:

- Commas for brief interruptions or additional information
- Periods to separate complete thoughts into distinct sentences
- Semicolons to connect related independent clauses
- Parentheses for supplementary information
- Colons to introduce explanations or lists

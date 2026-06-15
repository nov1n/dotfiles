.PHONY: help lint stow
.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  help   - Show this help message"
	@echo "  stow   - Run stow to symlink dotfiles"
	@echo "  lint   - Run shellcheck on all bash files"

stow:
	stow -R -v .

lint:
	@find . -name "*.sh" -type f \
		! -path "./.git/*" \
		! -path "*/node_modules/*" \
		! -path "*/spoon-submodules/*" \
		! -path "./.hammerspoon/bash/*" \
		! -name ".zsh_*" \
		-exec shellcheck {} +

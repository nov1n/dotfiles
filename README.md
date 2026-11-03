# My dotfiles

## Installation

### Bootstrap Mac

```bash
xcode-select --install
git clone https://github.com/nov1n/dotfiles ~/dotfiles
~/dotfiles/script/bootstrap.sh
```

Then work through `script/MANUAL.md`. Packages live in `script/Brewfile`.

### Bootstrap debian box

```bash
wget -qO- dotfiles.carosi.nl | bash
```

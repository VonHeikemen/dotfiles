# Run this only once when using fish for the first time

# Disable welcome message
set fish_greeting

# This is like a bashrc file
cp ~/my-configs/fish/config.fish ~/.config/fish/config.fish

# Source everything
source ~/my-configs/fish/prompt.fish
source ~/my-configs/fish/syntax.fish
source ~/my-configs/fish/aliases.fish
source ~/my-configs/fish/custom-functions.fish

if test -e ~/my-configs/fish/extra.fish
  source ~/my-configs/fish/extra.fish
end

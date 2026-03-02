if status is-interactive
  fish_vi_key_bindings
  atuin init fish | source
end
zoxide init fish | source
starship init fish | source

source ~/.config/fish/aliases.fish

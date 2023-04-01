deploy:
	stow --verbose --target $(HOME) dotfiles

update:
	git commit -a --amend --no-edit

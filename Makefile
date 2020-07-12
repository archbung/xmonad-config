APP_DIR = $(HOME)/.local/bin

.PHONY: install
install:
	nix-build shell.nix
	mkdir -p ${APP_DIR} && cp result/bin/xmonad ${APP_DIR}/xmonad

.PHONY: clean
clean:
	cabal clean

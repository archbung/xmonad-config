TARGET = xmonad
APP_DIR = $(HOME)/.local/bin

.PHONY: default
default: 
	stack setup
	stack install --local-bin-path $(APP_DIR)
	@cp xmobarrc $(HOME)/.xmobarrc

.PHONY: clean
clean:
	stack clean

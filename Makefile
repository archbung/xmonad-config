TARGET = xmonad
APP_DIR = $(HOME)/.local/bin

.PHONY: install
install: 
	stack setup
	stack install --local-bin-path $(APP_DIR)
	@cp xmobarrc $(HOME)/.xmobarrc

.PHONY: clean
clean:
	stack clean

TARGET = xmonad
APP_DIR = $(HOME)/.local/bin

default: 
	stack setup
	stack install --local-bin-path $(APP_DIR)
	@cp xmobarrc $(HOME)/.xmobarrc

clean:
	stack clean

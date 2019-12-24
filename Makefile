APP_DIR = $(HOME)/.local/bin

.PHONY: install
install:
	stack setup
	stack install --local-bin-path $(APP_DIR)

.PHONY: clean
clean:
	stack clean

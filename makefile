PANDOC_OPTIONS_HTML =
BUILDDIR      		= build

ALL_PANDOC_OPTIONS   = -t revealjs --resource-path=../ --metadata-file=../metadata.yaml --self-contained -V revealjs-url=$(CURDIR)/../reveal.js -V theme=solarized  $(PANDOC_OPTIONS_HTML)


.PHONY: clean all clang_tools

.ONESHELL:
all: clang_tools

clang_tools: $(BUILDDIR) $(BUILDDIR)/clang_tools.html

$(BUILDDIR):
	mkdir $(BUILDDIR)	

$(BUILDDIR)/clang_tools.html: clang_tools.md
	cd $(BUILDDIR)
	pandoc $(ALL_PANDOC_OPTIONS) ../clang_tools.md -o clang_tools.html

clean:
	rm -rf $(BUILDDIR)
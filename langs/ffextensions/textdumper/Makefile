BUILDDIR=build

all: clean prepare
	cd chrome && zip -r ../$(BUILDDIR)/chrome/textdumper.jar ./
	cp install.* $(BUILDDIR)
	cd $(BUILDDIR) && zip -r ../textdumper.xpi chrome install.js install.rdf

prepare:
	mkdir -p $(BUILDDIR)/chrome

clean:
	rm -rf $(BUILDDIR) textdumper.xpi
	find . -name "*~" -exec rm {} \;

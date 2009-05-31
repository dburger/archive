BUILDDIR=build
XPINAME=extension.xpi

all: clean
	cd src && zip -r ${XPINAME} ./
	mv src/${XPINAME} ./

clean:
	find . -name "*~" -delete
	rm -f ${XPINAME}

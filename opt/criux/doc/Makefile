prefix = /opt/criux
docdir = $(prefix)/doc

txttargets = $(shell echo *.txt)
htmltargets = $(patsubst %.txt, %.html, $(txttargets))

all: docs

dist: docs


docs: 
	make -C user-guide docs

install: 
	install -Dp -m0644 user-guide/criux-user-guide.html $(DESTDIR)$(docdir)/

clean:
	rm -f unconv.8 *.html *.xml
	make -C user-guide clean

%.html: %.txt
	asciidoc $<


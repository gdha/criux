# be aware: run this make on Linux as we need asciidoc and xmlto commands
prefix = /opt/criux
mandir = $(prefix)/man

txttargets = $(shell echo *.txt)
htmltargets = $(patsubst %.txt, %.html, $(txttargets))

all: docs

dist: docs

man: criux.8

docs: criux.8 $(htmltargets)

install: criux.8
	install -Dp -m0644 criux.8 $(DESTDIR)$(mandir)/man8/criux.8

clean:
	rm -f unconv.8 *.html *.xml

%.8.html: %.8.txt
	asciidoc -d manpage $<

%.8: %.8.xml
	xmlto man $<

%.html: %.txt
	asciidoc $<

%.8.xml: %.8.txt
	asciidoc -b docbook -d manpage $<

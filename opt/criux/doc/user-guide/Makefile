prefix = /opt/criux

txttargets = criux-user-guide.txt
htmltargets = $(patsubst %.txt, %.html, $(txttargets))

all: docs

dist: docs

docs: $(htmltargets)

clean:
	rm -f *.html *.svg *.xml

%.html: %.txt
	asciidoc $<

upload: $(htmltargets)
	lftp -e 'put -O /wwwroot/projects $(htmltargets) ; bye' apache07.hostbasket.com


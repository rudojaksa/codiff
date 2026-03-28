LIBPL := colors/base array findin path

LIBPL := $(LIBPL:%=inc/%.pl)
INCS  := $(shell echo $(LIBPL) | xargs -n 1 dirname | sort -u)

all: bin/pcpp $(LIBPL) inc/printhelp.pl

bin/pcpp: /map/pcpp/bin/pcpp | bin
	cp $< $@

$(LIBPL): inc/%.pl: /map/libpl/inc/%.pl | $(INCS)
	cp $< $@
	@head -n 1 $@ | xargs -n1 | grep libpl | sed 's:/.*::' | sed s:libpl-:: > .libpl.version

inc/printhelp.pl: /map/helpman/inc/printhelp.pl | inc
	cp $< $@
	@head -n 1 $@ | xargs -n1 | grep helpman | sed 's:/.*::' | sed s:helpman-:: > .helpman.version

bin $(INCS):
	mkdir -p $@

clean:
	rm -f .*

purge: clean
	rm -rf inc bin


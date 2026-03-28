PACKAGE := codiff
VERSION := 0.3
AUTHORS := R.Jaksa 2026 GPLv3
SUBVERS	:=

SHELL	:= /bin/bash
PATH	:= usr/bin:$(PATH)
PKGNAME	:= $(PACKAGE)-$(VERSION)$(SUBVERSION)
PROJECT := $(shell command -v getversion >/dev/null 2>&1 && getversion -prj || echo "unknown")
DATE	:= $(shell date '+%b %Y')

BIN	:= codiff
DOC	:= $(BIN:%=doc/%.md)
DEP	:= $(BIN:%=.%.d)
SRC	:= $(shell ls src/*.pl)
INC	:= $(SRC:src/%=inc/%)

# don't re-generate man-md file without man2md
ifneq ($(shell man2md -h 2>/dev/null),)
all: $(INC) $(BIN) $(DOC)
else
all: $(INC) $(BIN)
endif

$(BIN): %: %.pl .%.d .version.pl .%.built.pl Makefile
	@echo '#!/usr/bin/perl' > $@
	@echo -e "# $@ generated from $(PKGNAME)/$< $(DATE)\n" >> $@
	cat .version.pl .$*.built.pl >> $@
	pcpp -v $< >> $@
	@echo; chmod 755 $@; sync

$(INC): inc/%.pl: src/%.pl Makefile | inc
	@echo "# $*.pl generated from $(PKGNAME)/$< $(DATE)" > $@
	pcpp -v $< >> $@
	@echo; sync

$(DEP): .%.d: %.pl $(INC)
	pcpp -d $(@:.%.d=%) $< > $@

$(DOC): doc/%.md: % doc
	./$* -h | man2md > $@

inc doc:
	mkdir -p $@

.version.pl: Makefile
	@echo 'our $$PACKAGE = "$(PACKAGE)";' > $@
	@echo 'our $$VERSION = "$(VERSION)";' >> $@
	@echo 'our $$AUTHOR = "$(AUTHORS)";' >> $@
	@echo 'our $$SUBVERSION = "$(SUBVERS)";' >> $@
	@echo "make $@"

.PRECIOUS: .%.built.pl
.%.built.pl: %.pl .version.pl Makefile
	@echo -e 'our $$BUILT = "$(DATE)";\n' > $@
	@echo "make $@"

# /usr/local install
ifeq ($(wildcard /map),)
install: $(BIN)
	install $(BIN) /usr/local/bin

# /map install (requires /map directory plus getversion and mapinstall tools)
else
install: $(BIN) $(DOC)
	mapinstall -v /box/$(PROJECT)/$(PKGNAME) /map/$(PACKAGE) bin $(BIN)
	mapinstall -v /box/$(PROJECT)/$(PKGNAME) /map/$(PACKAGE) inc $(INC)
	mapinstall -v /box/$(PROJECT)/$(PKGNAME) /map/$(PACKAGE) doc README.md doc/*.md doc/*.png
	sed -i 's:doc/::g' /map/$(PACKAGE)/doc/README.md
endif

clean:
	rm -f .version.pl
	rm -f $(DEP) .*.built.pl

purge: clean
	rm -f $(DOC) $(BIN) $(INC)
	@echo rmdir inc; if test -d inc; then rmdir inc; fi

ifneq ($(MAKECMDGOALS),clean)
-include $(DEP)
endif
-include ~/.github/Makefile.git

# \ var
MODULE  = $(notdir $(CURDIR))
OS      = $(shell uname -s)
MACHINE = $(shell uname -m)
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES   = $(shell grep processor /proc/cpuinfo| wc -l)
# / var

# \ dir
CWD     = $(CURDIR)
BIN     = $(CWD)/bin
DOC     = $(CWD)/doc
TMP     = $(CWD)/tmp
LIB     = $(CWD)/lib
SRC     = $(CWD)/src
TEST    = $(CWD)/test
GZ      = $(HOME)/gz
# / dir

# \ tool
CURL    = curl -L -o
PY      = bin/python3
PIP     = bin/pip3
PEP     = bin/autopep8
PYT     = bin/pytest
# / tool

# \ src
P += config.py
Y += $(MODULE).py test_$(MODULE).py
S += $(Y)
# / src

# \ all
.PHONY: repl
repl: $(PY) $(MODULE).py
	$(PY) -i $(MODULE).py
	$(MAKE) test
	$(MAKE) format
	$(MAKE) $@

.PHONY: test
test: $(PYT) test_$(MODULE).py
	$^

.PHONY: format
format: tmp/format
tmp/format:
	$(MAKE) test
	$(PEP) --ignore=E26,E302,E401,E402,E701,E702 --in-place $? && touch $@
# / all

# \ install
.PHONY: install update
install: $(OS)_install
	$(MAKE) $(PIP)
	$(MAKE) update
update: $(OS)_update
	$(PIP)  install -U    pip autopep8
	$(PIP)  install -U -r requirements.txt

.PHONY: Linux_install Linux_update
Linux_install Linux_update:
	sudo apt update
	sudo apt install -u `cat apt.txt apt.dev`
# \ py
$(PY) $(PIP):
	python3 -m venv .
	$(MAKE) update
$(PYT):
	$(PIP) install -U pytest
# / py
# / install

# \ merge
MERGE  = README.md Makefile .gitignore apt.txt apt.dev .vscode $(S)
MERGE += bin doc lib include src test tmp
MERGE += static templates

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(BRANCH)_$(NOW)_$(REL).src.zip \
	HEAD

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout ponymuck -- $(MERGE)

.PHONY: ponymuck
ponymuck:
	git push -v
	git checkout $@
	git pull -v
# / merge

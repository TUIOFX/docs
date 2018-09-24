# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build
TEMPSRCDIR 	  = doc-src
SOURCEBRANCH  = master
HTMLBRANCH    = gh-pages


update: prune
	git checkout $(HTMLBRANCH);\
	echo "Fetch doc src files from remote";\
	mkdir -p $(TEMPSRCDIR)/$(SOURCEBRANCH);\
	git worktree add -b $(SOURCEBRANCH) $(TEMPSRCDIR)/master origin/$(SOURCEBRANCH);\
	
##	(cd $(TEMPSRCDIR)/$(SOURCEBRANCH); \
##	$(SPHINXBUILD) $(SPHINXOPTS) -b html . ../../html/
	
##	rm -rf $(TEMPSRCDIR); \
	
##	git add . ; \
##	git commit -m "rebuilt docs"; \
#	git push origin $(HTMLBRANCH); \
	
prune: clean
	git checkout $(HTMLBRANCH);\
	git worktree prune;\
	
# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
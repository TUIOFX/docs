# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build
TEMPSRCDIR 	  = doc-src
SOURCEBRANCH  = master
BUILDBRANCH  = build-doc
HTMLBRANCH    = gh-pages
REMOTEHTMLDIR    = .

update: prune
	echo "Fetch doc src files from remote";\
	mkdir -p $(TEMPSRCDIR)/$(SOURCEBRANCH);\
	git worktree add -b $(BUILDBRANCH) $(TEMPSRCDIR)/$(SOURCEBRANCH) origin/$(SOURCEBRANCH);\
	
	cd $(TEMPSRCDIR)/$(SOURCEBRANCH); \
	$(SPHINXBUILD) $(SPHINXOPTS) -b html . ../../$(REMOTEHTMLDIR)/
	
	# Remove worktree
	cd ../../
	rm -rf ./$(TEMPSRCDIR); \
	git worktree prune;\
	
	git add $(REMOTEHTMLDIR)/ ; \
	git commit -m "rebuilt docs"; \
	git push origin $(HTMLBRANCH); \
	
	git branch -D $(BUILDBRANCH); \
	git checkout  $(HTMLBRANCH);
	
prune: clean
	git checkout $(HTMLBRANCH);\
	# TODO check if the branch exist first
	git branch -D $(BUILDBRANCH); \
	git worktree prune;\
	
# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
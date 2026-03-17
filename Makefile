PERL := perl
PERL5LIB := utils/lib
TREEBANK_ASSET := assets/penn-treebank-pos.tsv
TREEBANK_TAGL := tagl/tagd-nlp.tagl
TESTS := $(wildcard utils/tests/*.t)

.PHONY: all tests

all: $(TREEBANK_TAGL)

$(TREEBANK_TAGL): utils/tsv-to-tagl.pl $(TREEBANK_ASSET) $(shell find utils/lib -type f | sort)
	PERL5LIB=$(PERL5LIB) $(PERL) utils/tsv-to-tagl.pl tagd:nlp $(TREEBANK_ASSET) > $(TREEBANK_TAGL)

tests:
	for test in $(TESTS); do PERL5LIB=$(PERL5LIB) $(PERL) $$test; done
	tagsh --file tagl/tagd-nlp.tagl -n


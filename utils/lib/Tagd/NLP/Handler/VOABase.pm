package Tagd::NLP::Handler::VOABase;

use strict;
use warnings;

use parent 'Tagd::NLP::Handler::Base';

sub parse_row {
	my ($self, $line) = @_;

	# tsv data in the form
	# 0          1         2                  3
	# word <tab> pos <tab> definition [ <tab> comment(s) ]
	my ($word, $pos, $definition, $example) = split /\t/, $line;

	return {
		word       => $word,
		pos        => $pos,
		definition => $definition,
		example    => $example,
	};
}

1;

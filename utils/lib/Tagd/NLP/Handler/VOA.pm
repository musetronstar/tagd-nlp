package Tagd::NLP::Handler::VOA;

use strict;
use warnings;

use parent 'Tagd::NLP::Handler::VOABase';

my %POS_ABV = (
	# Parts of Speech as listed in VOA word book
	'n.'    => 'noun',              # a name word
	'v.'    => 'verb',              # an action word
	'ad.'   => 'adjective_adverb', # adjective/adverb - a describing word
	'adj.'  => 'adjective',         # not listed in the word book but occurs
	'prep.' => 'preposition',       # a word used to show a relation
	'pro.'  => 'pronoun',           # a word used in place of a noun
	'conj.' => 'conjunction',       # a joining word
);

sub pos_map {
	return \%POS_ABV;
}

1;

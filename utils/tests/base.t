use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Tagd::NLP::Handler::VOA;

my $handler = Tagd::NLP::Handler::VOA->new(namespace => 'VOA');

my $first = $handler->tsv_row_tagl("apple\tn.\ta fruit");
my $second = $handler->tsv_row_tagl("ask\tv.\tto request");

is(
	$first,
	"-*** letter A ***-\n\n"
	. ">> VOA:A contained_in VOA represents letter = \"A\"\n\n"
	. ">> \"VOA:apple:0\" defined_in VOA:A\n"
	. "represents word = \"apple\"\n"
	. "categorized_as noun\n"
	. "_has definition = \"a fruit\"\n\n",
	'VOA handler renders initial entry and letter container',
);

is(
	$second,
	">> \"VOA:ask:0\" defined_in VOA:A\n"
	. "represents word = \"ask\"\n"
	. "categorized_as verb\n"
	. "_has definition = \"to request\"\n\n",
	'VOA handler reuses container state across rows',
);

done_testing();

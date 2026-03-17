use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Tagd::NLP::Handler::TagdNlp;

my $handler = Tagd::NLP::Handler::TagdNlp->new(namespace => 'tagd:nlp');

is(
	$handler->tsv_row_tagl("Number\tTag\tDescription"),
	undef,
	'tagd:nlp handler skips the header row',
);

is(
	$handler->tsv_row_tagl("1\tCC\tCoordinating conjunction"),
	">> tagd:nlp:pos:CC _type_of tagd:nlp:pos\n"
	. "\t_has tagd:nlp:treebank:number = 1,\n"
	. "\t\ttagd:nlp:treebank:tag = \"CC\",\n"
	. "\t\ttagd:nlp:treebank:description = \"Coordinating conjunction\"\n\n"
	. ">> CC _refers_to tagd:nlp:pos:CC _context tagd:nlp\n\n",
	'tagd:nlp handler renders the TASKS.md example shape',
);

done_testing();

#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/lib";

use Tagd::NLP::Handler::TagdNlp;
use Tagd::NLP::Handler::VOA;

my %HANDLER_CLASS = (
	'tagd:nlp' => 'Tagd::NLP::Handler::TagdNlp',
	'VOA'      => 'Tagd::NLP::Handler::VOA',
);

main();

sub main {
	my ($handler, @files) = parse_args(@ARGV);
	@ARGV = @files;

	# header include
	print "%% _include tagd-nlp-bootstrap.tagl;\n\n";

	while (<>) {
		next if /^\s*#/;  # ignore comment

		chomp;
		next if $_ eq '';

		my $tagl = $handler->tsv_row_tagl($_);
		print $tagl if defined $tagl;
	}
}

sub parse_args {
	my @args = @_;
	my $usage = "usage: $0 <namespace> <word-list-defs-tsv-file>";

	@args == 2 or die "$usage\n";

	my $namespace = shift @args or die "$usage\n";
	my $handler_class = $HANDLER_CLASS{$namespace}
		or die "unsupported namespace: $namespace\n";

	return ($handler_class->new(namespace => $namespace), @args);
}

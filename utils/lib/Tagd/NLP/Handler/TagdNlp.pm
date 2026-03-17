package Tagd::NLP::Handler::TagdNlp;

use strict;
use warnings;

use parent 'Tagd::NLP::Handler::Base';

sub tsv_row_tagl {
	my ($self, $line) = @_;

	my $record = $self->parse_row($line);
	return unless defined $record;

	return $self->record_tagl($record);
}

sub parse_row {
	my ($self, $line) = @_;

	my ($number, $tag, $description) = split /\t/, $line, 3;

	return if defined $number && $number eq 'Number';

	return {
		number     => $number,
		tag        => $tag,
		definition => $description,
	};
}

sub record_tagl {
	my ($self, $record) = @_;

	my $tag = $record->{tag};
	my $number = $record->{number};
	my $description = $record->{definition};
	my $output = '';

	$tag =~ s/\"/\\\"/g if defined $tag;
	$description =~ s/\"/\\\"/g if defined $description;

	$output .= ">> " . $self->namespace . ":pos:$tag _type_of " . $self->namespace . ":pos\n";
	$output .= "	_has " . $self->namespace . ":treebank:number = $number,\n";
	$output .= "		" . $self->namespace . ":treebank:tag = \"$tag\",\n";
	$output .= "		" . $self->namespace . ":treebank:description = \"$description\"\n\n";
	$output .= ">> $tag _refers_to " . $self->namespace . ":pos:$tag _context " . $self->namespace . "\n\n";

	return $output;
}

1;

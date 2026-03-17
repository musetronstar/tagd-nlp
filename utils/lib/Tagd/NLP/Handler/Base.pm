package Tagd::NLP::Handler::Base;

use strict;
use warnings;

sub new {
	my ($class, %args) = @_;

	my $self = {
		namespace       => $args{namespace},
		word_count      => {},
		container       => undef,
		letter          => '',
		letters_printed => {},
	};

	return bless $self, $class;
}

sub tsv_row_tagl {
	my ($self, $line) = @_;

	my $record = $self->parse_row($line);
	return unless defined $record;

	return $self->record_tagl($record);
}

sub namespace {
	my ($self) = @_;
	return $self->{namespace};
}

sub tag_for {
	my ($self, $word, $sense_count) = @_;
	return $self->namespace . ":$word:$sense_count";
}

sub update_container {
	my ($self, $word) = @_;
	my $output = '';

	my $ltr = uc(substr($word, 0, 1));
	if ( $ltr =~ /[A-Z]/ and $ltr ne $self->{letter} ) {
		$self->{letter} = $ltr;
		$self->{container} = $self->namespace . ":$ltr";
		if (++$self->{letters_printed}{$ltr} == 1) {
			$output .= "-*** letter $ltr ***-\n\n";
			$output .= ">> " . $self->{container} . " contained_in " . $self->namespace
				. " represents letter = \"$ltr\"\n\n";
		}
	}

	return ($self->{container}, $output);
}

sub category_for_pos {
	my ($self, $pos) = @_;
	my $map = $self->pos_map;

	return $map->{$pos} if exists $map->{$pos};
	die "unknown part of speech: $pos";
}

sub category_for_record {
	my ($self, $record) = @_;
	return $self->category_for_pos($record->{pos});
}

sub record_tagl {
	my ($self, $record) = @_;

	my $word = $record->{word};
	my ($container, $prefix) = $self->update_container($word);
	my $sense_count = ++$self->{word_count}{$word} - 1;
	my $tag = $self->tag_for($word, $sense_count);
	my $category = $self->category_for_record($record);

	return $prefix . $self->entry_tagl(
		tag => $tag,
		container => $container,
		word => $word,
		category => $category,
		definition => $record->{definition},
		example => $record->{example},
	);
}

sub entry_tagl {
	my ($self, %args) = @_;
	my $tag = $args{tag};
	my $container = $args{container};
	my $word = $args{word};
	my $category = $args{category};
	my $def = $args{definition};
	my $ex = $args{example};
	my $output = '';

	$output .= ">> \"$tag\" defined_in $container\n";
	$output .= "represents word = \"$word\"\n";
	$output .= "categorized_as $category\n";

	$def =~ s/\"/\\\"/g if defined $def;
	$output .= "_has definition = \"$def\"\n" if $def;

	if ($ex) {
		$ex =~ s/\"/\\\"/g;
		$output .= "_has example = \"$ex\"\n";
	}

	$output .= "\n";

	return $output;
}

sub pos_map {
	die "pos_map() must be implemented by subclass";
}

sub parse_row {
	die "parse_row() must be implemented by subclass";
}

1;

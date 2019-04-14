package Dist::Banshee::File;

use strict;
use warnings;

sub new {
	my ($class, %options) = @_;
	bless {
		name => $options{name},
		content => $options{content},
	}, $class;
}

sub name {
	my ($self) = @_;
	return $self->{name};
}

sub content {
	my ($self) = @_;
	return $self->{content};
}

1;

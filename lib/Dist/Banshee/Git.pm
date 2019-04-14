package Dist::Banshee::Git;

use strict;
use warnings;

use Exporter 5.57 'import';
our @EXPORT_OK = qw/gather_files/;

use Git::Wrapper;
use File::Slurper 'read_binary';
use List::Util 'uniq';

sub gather_files {
	my ($self, $filter) = @_;
 
	# Prepare to gather files
	my $git = Git::Wrapper->new('.');
 
	# Loop over files reported by git ls-files
	my @filenames = grep { !-d } uniq $git->ls_files;
	@filenames = grep { $filter->($_) } @filenames if $filter;

	my %ret = map { $_ => read_binary($_) } @filenames;
	return \%ret;
}

1;

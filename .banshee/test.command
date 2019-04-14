#! perl
use strict;
use warnings;

use Dist::Banshee::Core qw/source write_files in_tempdir/;

my $files = source('gather-files');

in_tempdir {
	write_files($files);

	system $^X, 'Makefile.PL' and die "Failed perl Makefile.PL";
	system 'make' and die "Failed make";
	system 'make', 'test' and die "Failed make test";
};

return 0;

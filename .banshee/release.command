#! perl

use strict;
use warnings;

use CPAN::Upload::Tiny 0.009;
use Dist::Banshee::Core qw/source write_files in_tempdir write_tarball y_n/;

my $files = source('gather-files');

# checkchanges

in_tempdir {
	write_files($files);

	system $^X, 'Makefile.PL' and die "Failed perl Makefile.PL";
	system 'make' and die "Failed make";
	system 'make', 'test' and die "Failed make test" if -e 't';
};

if (y_n('Do you want to continue the release process?', 'n')) {
	my $meta = source('gather-metadata');

	my $trial = $meta->release_status eq 'testing' && $meta->version !~ /_/;
	my $file = write_tarball($files, $meta, $trial);

	my $uploader = CPAN::Upload::Tiny->new_from_config_or_stdin;
	#$uploader->upload_file($file);

	print "Successfully uploaded $file\n";
}

return 0;

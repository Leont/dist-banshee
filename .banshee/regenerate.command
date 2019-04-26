#! perl
use strict;
use warnings;

use Dist::Banshee::Core qw/source write_file bump_version/;
use Dist::Banshee::MakeMaker::Simple 'makemaker_simple';
use Getopt::Long;

GetOptions(bump => \my $bump);

if ($bump) {
	bump_version();
}

my $meta = source('gather-metadata');

write_file('META.json', $meta->as_string);
write_file('META.yml' , $meta->as_string({ version => 1.4 }));

my $files = source('gather-files');
write_file('Makefile.PL', makemaker_simple($meta, $files));

return 0;

#! perl
use strict;
use warnings;

use Dist::Banshee::Core qw/source write_file/;
use Dist::Banshee::Meta 'license_from_meta';

use Dist::Banshee::MakeMaker::Simple 'makemaker_simple';

my $meta = source('gather-metadata');

write_file('META.json', $meta->as_string);
write_file('META.yml' , $meta->as_string({ version => 1.4 }));

my $files = source('gather-files');
write_file('Makefile.PL', makemaker_simple($meta, $files));

return 0;

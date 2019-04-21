package Dist::Banshee::Meta;

use strict;
use warnings;

use Exporter 5.57 'import';
our @EXPORT_OK = qw/metamerge_file prereqs_file add_prereqs meta_merge version_from_module provides_from/;

use File::Spec::Functions 'catfile';

sub metamerge_file {
	my ($mergefile) = @_;
	require Parse::CPAN::Meta;
	return Parse::CPAN::Meta->load_file($mergefile);
}

sub prereqs_file {
	my ($prereqsfile) = @_;
	require Parse::CPAN::Meta;
	my $prereqs = Parse::CPAN::Meta->load_file($prereqsfile);
	return { prereqs => $prereqs };
}

sub add_prereqs {
	my ($phase, $relationship, $module, $version) = @_;
	$version ||= 0;
	return { prereqs => { $phase => { $relationship => { $module => $version } } } };
}

sub meta_merge {
	my (@pieces) = @_;
	require CPAN::Meta::Merge;
	my $merger = CPAN::Meta::Merge->new(default_version => '2');
	require CPAN::Meta;
	return CPAN::Meta->create($merger->merge(@pieces));
}

sub version_from_module {
	my ($module) = shift;
	my $path = catfile('lib', split /::/, $module) . '.pm';
	require Module::Metadata;
	my $data = Module::Metadata->new_from_file($path);
	my $version = $data->version($data->name);
	my $release_status = $version =~ /_/ ? 'testing' : 'stable';
	return {
		version => $version,
		release_status => $release_status,
	};
}

sub provides_from {
	my ($dir) = @_;
	require Module::Metadata;
	return {
		provides => Module::Metadata->provides(version => 2, dir => $dir),
	};
}

1;

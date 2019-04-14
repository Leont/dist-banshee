package Dist::Banshee::Core;

use strict;
use warnings;

use Exporter 5.57 'import';
our @EXPORT_OK = qw/source write_file write_files in_tempdir write_tarball/;

use File::Spec::Functions 'catfile';
use File::Basename 'dirname';
use File::Path 'mkpath';
use File::Slurper 'write_binary';
use File::Temp 'tempdir';
use File::chdir;

sub source {
	my ($filename, @arguments) = @_;
	my $path = catfile('.banshee', "$filename.source");
	return do "./$path" // die $@;
}

sub write_file {
	my ($filename, $content) = @_;
	mkpath(dirname($filename));
	write_binary($filename, $content);
	return;
}

sub write_files {
	my $files = shift;
	for my $filename (keys %{ $files }) {
		mkpath(dirname($filename));
		write_binary($filename, $files->{$filename});
	}
	return;
}

sub write_tarball {
	my ($files, $meta, $trial) = @_;

	require Archive::Tar;
	my $arch = Archive::Tar->new;
	for my $filename (keys %{ $files }) {
		$arch->add_data($filename, $files->($filename), { mode => oct '0644'} );
	}
	my $name = $meta->name . '-' . $meta->version . ( $trial ? '-TRIAL' : '');
	my $file =  "$name.tar.gz";
	$arch->write($file, &Archive::Tar::COMPRESS_GZIP, $name);

	return $file;
}

sub in_tempdir(&) {
	my ($code) = @_;
	local $CWD = tempdir(CLEANUP => 1);
	$code->();
}

1;

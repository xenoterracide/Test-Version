package Test::HasValidVersion;
use 5.006;
use strict;
use warnings;
BEGIN {
	# VERSION
}
use parent 'Exporter';
use Test::Builder;
use version 0.77 qw( is_lax );
use boolean;
use File::Find::Rule::Perl;
use Module::Extract::VERSION;
use Test::More;

our @EXPORT = qw( version_all_ok ); ## no critic (Modules::ProhibitAutomaticExportation)

my $test = Test::Builder->new;

sub _get_version {
	my $pm = shift;
	return my $version
		= Module::Extract::VERSION->parse_version_safely( $pm );
}

sub version_ok {
	my ( $file, $name ) = @_;

	my $version = _get_version( $file );

	$name = "validate VERSION in $file" unless $name;

	if ( not $version ) {
		$test->ok( false , $name );
		$test->diag( "VERSION not defined in $file" );
	}

	if ( is_lax( $version ) ) {
		$test->ok( true, "VERSION $version in $file is valid" );
	}
	else {
		$test->ok( false, $name );
		$test->diag( "VERSION in $file is not a valid version" );
	}
}

sub version_all_ok {
	my ( $dir, $name ) = @_;

	$name = "all modules in $dir have valid versions" unless $name;

	unless ( -d $dir ) {
		$test->ok( false, $name );
		$test->diag( "$dir does not exist, or is not a directory" );
		return;
	}
	my @files = File::Find::Rule->perl_module->in( $dir );

	foreach my $file ( @files ) {
		version_ok( $file );
	}
}
1;

# ABSTRACT: Check Perl modules for valid version numbers

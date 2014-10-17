package Test::Version;
use 5.006;
use strict;
use warnings;
use Carp;

# VERSION

use parent 'Exporter';
use Test::Builder;
use version 0.86 qw( is_lax is_strict );
use File::Find::Rule::Perl;
use Test::More;
use Module::Metadata;

our @EXPORT = qw( version_all_ok ); ## no critic (Modules::ProhibitAutomaticExportation)
our @EXPORT_OK = qw( version_ok );

my $cfg;

sub import { ## no critic qw( Subroutines::RequireArgUnpacking Subroutines::RequireFinalReturn )
	my @exports;
	foreach my $param ( @_ ) {
		unless ( ref( $param ) eq 'HASH' ) {
			push @exports, $param;
		} else {
			$cfg = $param
		}
	}

	$cfg->{is_strict}
		= defined $cfg->{is_strict}           ? $cfg->{is_strict}
		:                                       0
		;

	$cfg->{has_version}
		= defined $cfg->{has_version}         ? $cfg->{has_version}
		:                                       1
		;

	$cfg->{consistent}
		= defined $cfg->{consistent}           ? $cfg->{consistent}
		:                                       0
		;

	my $mmv = version->parse( $Module::Metadata::VERSION );
	my $rec = version->parse( '1.000020'  );
	if ( $mmv >= $rec && ! defined $cfg->{ignore_unindexable} ) {
		$cfg->{ignore_unindexable} = 1;
	}

	__PACKAGE__->export_to_level( 1, @exports );
}

my $version_counter = 0;
my $version_number;
my $consistent = 1;

my $test = Test::Builder->new;

sub version_ok {
	my ( $file, $name ) = @_;
	$file ||= '';
	$name ||= "check version in '$file'";

	croak 'No file passed to version_ok().' unless $file;

	croak "'$file' doesn't exist." unless -e $file;

	my $info = Module::Metadata->new_from_file( $file );
	if ( $cfg->{ignore_unindexable} ) {
		$test->skip( "$file not indexable" );
		return 0 if ! $info->is_indexable;
	}
	my $version = $info->version;

	if (not defined $version) {
		$consistent = 0;
	}

	if ( not $version and not $cfg->{has_version} ) {
		$test->skip( 'No version was found in "'
			. $file
			. '" and has_version is false'
			)
			;

		return 1;
	} else {
		$version_counter++;
	}

	unless ( $version ) {
		$test->ok( 0 , $name );
		$test->diag( "No version was found in '$file'." );
		return 0;
	}

	unless (defined $version_number) {
		$version_number = $version;
	}
	if ($version ne $version_number) {
		$consistent = 0;
	}

	unless ( is_lax( $version ) ) {
		$test->ok( 0, $name );
		$test->diag( "The version '$version' found in '$file' is invalid." );
		return 0;
	}

	if ( $cfg->{is_strict} ) {
		unless ( is_strict( $version ) ) {
			$test->ok( 0, $name );
			$test->diag( "The version '$version' found in '$file' is not strict." );
			return 0;
		}
	}

	$test->ok( 1, $name );
	return 1;
}

sub version_all_ok {
	my ( $dir, $name ) = @_;

	$dir
		= defined $dir ? $dir
		: -d 'blib'    ? 'blib'
		:                'lib'
		;

	croak $dir . ' does not exist, or is not a directory' unless -d $dir;

	# Report failure location correctly - GH #1
	local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic (Variables::ProhibitPackageVars)

	$name ||= "all modules in $dir have valid versions";

	my @files = File::Find::Rule->perl_module->in( $dir );

	foreach my $file ( @files ) {
		version_ok( $file );
	}

	if ($cfg->{consistent} and not $consistent) {
		$test->ok( 0, $name );
		$test->diag('The version numbers in this distribution are not the same');
		return;
	}

	# has at least 1 version in the dist
	if ( not $cfg->{has_version} and $version_counter < 1 ) {
		$test->ok( 0, $name );
		$test->diag(
			'Your dist has no valid versions defined. '
			. 'Must have at least one version'
			);
	}
	else {
		$test->ok( 1, $name );
	}

	return;
}
1;

# ABSTRACT: Check to see that version's in modules are sane

=head1 SYNOPSIS

	use Test::More;
	use Test::Version 1.001001 qw( version_all_ok ), {
			is_strict   => 0,
			has_version => 1,
			consistent  => 1,
		};

	# test blib or lib by default
	version_all_ok();

	done_testing;

=head1 DESCRIPTION

This module's goal is to be a one stop shop for checking to see that your
versions across your dist are sane. Please ensure that you use version C<0.04>
or later only, as earlier versions are old code and may not work correctly.
Current feature list:

=over

=item module has a version

Tests to insure that all modules checked have a VERSION defined, Can replace
L<Test::HasVersion>

=item module has a valid version

Tests to insure that all versions are valid, according to the rules of
L<version> method C<is_lax>. To quote:

I<The lax criteria corresponds to what is currently allowed by the version
parser. All of the following formats are acceptable for dotted-decimal formats
strings:>

	v1.2
	1.2345.6
	v1.23_4
	1.2345
	1.2345_01

I<If you want to limit yourself to a much more narrow definition of what a
version string constitutes, is_strict() is limited to version strings like
the following list:>

	v1.234.5
	2.3456

you can cause your tests to fail if not strict by setting L<is_strict|/is_strict> to
C<1>

=back

=function version_ok

	version_ok( $filename, [ $name ] );

Test a single C<.pm> file by passing a path to the function. Checks if the
module has a version, and that it is valid with C<is_lax>.

=function version_all_ok

	version_all_ok( [ $directory, [ $name ]] );

Test all modules in a directory with C<version_ok>. By default it will check
C<blib> or C<lib> if you haven't passed it a directory.

=setting has_version

	use Test::Version qw( version_all_ok ), { has_version => 0 };

Allows disabling whether a module has to have a version. If set to 0
version tests will be skipped in any module where no version is found.

really doesn't make sense to use with just L<version_ok|/version_ok>

=setting is_strict

	use Test::Version { is_strict => 1 };

this allows enabling of L<version>s C<is_strict> checks to ensure that your
version is strict.

=setting consistent

	use Test::Version { consistent => 1 };

Check if every module has the same version number.

=setting ignore_unindexable

	use Test::Version { ignore_unindexable => 0};

if you have at least L<Module::Metadata> vC<1.000020> Test::Version will by
default skip any files not considered L<is_indexable|Module::Metadata/is_indexable>

=head1 SEE ALSO

The goal is to have the functionality of all of these.

=over

=item L<Test::HasVersion>

=item L<Test::ConsistentVersion>

=item L<Test::GreaterVersion>

=back

=cut

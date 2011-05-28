package Test::Version;
use 5.006;
use strict;
use warnings;
BEGIN {
	our $VERSION = '0.06'; # VERSION
}
use parent 'Exporter';
use Test::Builder;
use version 0.77 qw( is_lax );
use File::Find::Rule::Perl;
use Module::Extract::VERSION;
use Test::More;

our @EXPORT = qw( version_all_ok ); ## no critic (Modules::ProhibitAutomaticExportation)
our @EXPORT_OK = qw( version_ok );

my $test = Test::Builder->new;

sub _get_version {
	my $pm = shift;
	return my $version
		= Module::Extract::VERSION->parse_version_safely( $pm );
}

sub version_ok {
	my ( $file, $name ) = @_;

	my $version = _get_version( $file );

	$name ||= "validate VERSION in $file";

	if ( not $version ) {
		$test->ok( 0 , $name );
		$test->diag( "NO_VERSION: $file" );
		return;
	}

	if ( is_lax( $version ) ) {
		$test->ok( 1, "VERSION_OK: $file $version" );
	}
	else {
		$test->ok( 0, $name );
		$test->diag( "NOT_VALID: $file $version" );
	}
	return;
}

sub version_all_ok {
	my ( $dir, $name ) = @_;

	$dir
		= defined $dir ? $dir
		: -d 'blib'    ? 'blib'
		:                'lib'
		;

	# Report failure location correctly - GH #1
	local $Test::Builder::Level = $Test::Builder::Level + 1; ## no critic (Variables::ProhibitPackageVars)

	$name ||= "all modules in $dir have valid versions";

	unless ( -d $dir ) {
		$test->ok( 0, $name );
		$test->diag( "$dir does not exist, or is not a directory" );
		return;
	}
	my @files = File::Find::Rule->perl_module->in( $dir );

	foreach my $file ( @files ) {
		version_ok( $file );
	}
	return;
}
1;

# ABSTRACT: Check to see that version's in modules are sane


__END__
=pod

=head1 NAME

Test::Version - Check to see that version's in modules are sane

=head1 VERSION

version 0.06

=head1 SYNOPSIS

	use Test::More;
	use Test::Version;

	# test blib or lib by default
	version_all_ok;

	done_testing;

=head1 DESCRIPTION

This module's goal is to be a one stop shop for checking to see that your
versions across your dist are sane. It currently checks to see that all Perl
Modules have a VERSION defined, and that it is a valid VERSION by the rules of
the C<is_lax> function in L<version>.

=head1 METHODS

=over

=item C<version_ok( $filename, [ $name ] );>

Test a single C<.pm> file by passing a path to the function. Checks if the
module has a version, and that it is valid with C<is_lax>.

Returns the following diagnostics

	NO_VERSION: $file           No version was found to exist in $file
	NOT_VALID: $file $version   $version in $file is not "lax"

=item C<version_all_ok( [ $directory, [ $name ]] );>

Test all modules in a directory with C<version_ok>. By default it will check
C<blib> or C<lib> if you haven't passed it a directory.

=back

=head1 CREDITS

Special thanks to particle <particle@cpan.org> for the original
C<Test::Version> and letting me maintain it further.

=head1 AUTHORS

=over 4

=item *

Caleb Cushing <xenoterracide@gmail.com>

=item *

Mike Doherty <doherty@cs.dal.ca>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut


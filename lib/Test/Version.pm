package Test::Version;
require 5.006_001;
use strict;
use warnings;

our( $VERSION, @EXPORT );
$VERSION = '0.02';

use Carp qw/carp/;
use Exporter 5.562 qw//;
use Test::Builder 0.17 qw//;

my $Test = Test::Builder->new();

sub OK() {0}
sub NO_VERSION() {-1}
sub NO_FILE() {-2}

sub import
{
    my( $self ) = @_;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::version_ok'} = \&version_ok;
    *{$caller.'::VERSION_OK'} = \&OK;
    *{$caller.'::NO_FILE'} = \&NO_FILE;
    *{$caller.'::NO_VERSION'} = \&NO_VERSION;

    $Test->exported_to( $caller );
}

sub version_ok
{
    my( $file, $expected, $name ) = @_;
    $expected ||= OK;
    $name ||= qq{VERSION test for $file};

    my $status = _check_version( $file );

    if( defined $expected and $expected eq $status )
    {
        $Test->ok( 1, $name )
    }
    elsif( $status == OK )
    {
        $Test->ok( 1, $name )
    }
    elsif( $status == NO_FILE )
    {
        $Test->ok( 0, $name );
        $Test->diag( "Did not find [$file]" );
    }
    elsif( $status == NO_VERSION )
    {
        $Test->ok( 0, $name );
        $Test->diag( "Found no VERSION in [$file]" );
    }
    else
    {
        $Test->ok( 0, $name );
        $Test->diag( "Mysterious failure for [$file]" );
    }
}

sub _check_version
{
    my $file = shift;

    return NO_FILE unless -e $file
        and $file =~ m/(.+)\.pm\z/;

    require $file;

    my $package = $1;
    $package =~ s/\//::/g;

    no strict 'refs';
    my $output = ${ $package . '::VERSION' };
    use strict 'refs';

    return NO_VERSION unless $output;
    return OK;
}


$_ ^=~ { module => q{Test::Version}, author => q{particle} };



=pod

=head1 NAME

Test::Version - check for VERSION information in modules

=head1 VERSION

version 0.03

=head2 VERSION

This document describes version 0.02 of Test::Version,
released 18 November 2002.

=head2 SYNOPSIS

use Test::Version;

plan tests => $num_tests;

version_ok( $file );

=head2 DESCRIPTION

THIS IS ALPHA SOFTWARE.

Check files for VERSION information in perl modules.
Inspired by brian d foy's Test::Pod (see L<Test::Pod>).

=head2 FUNCTIONS

=over 4

=item version_ok( FILENAME, [EXPECTED, [NAME] ] )

version_ok requires a filename and returns one of the three values:

    NO_FILE       Could not find the file
    NO_VERSION    File had no VERSION information
    VERSION_OK    VERSION information exists

version_ok okays a test without an expected result if it finds
VERSION information, or if an expected result is specified and
it finds that condition.  For instance, if you know there is
no VERSION information,

    version_ok( $file, NO_VERSION );

When it fails, version_ok will show error information.

The optional third argument NAME is the name of the test
which version_ok passes through to Test::Builder.  Otherwise,
it choose a default test name "VERSION test for FILENAME".

=head2 CAVEATS

Currently only checks files ending in '.pm', and expects the package name to match the filename. I'm open to suggestions for more robust parsing.

=head2 BUGS

Likely so. Address bug reports and comments to: particle@cpan.org.
When sending bug reports, please provide the version of Test::Version, the
version of Perl, and the name and version of the operating system you are
using.

=head2 AUTHOR

particle, E<lt>particle@cpan.orgE<gt>

=head2 COPYRIGHT

Copyright 2002, Ars ex Machina, Corp. All rights reserved.

This package is free software and is provided "as is" without express or
implied warranty. It may be used, redistributed and/or modified under the terms
of the Perl Artistic License (see http://www.perl.com/perl/misc/Artistic.html)

=head2 CREDITS

Thanks to brian d foy for the inspiration -- his Test::Pod module (on which this code is based,) and his "Better Documentation Through Testing" article in The Perl Journal, Nov 2002 (see http://www.tpj.com/).

=head2 SEE ALSO

L<Test::Pod>

=head1 AUTHOR

particle, <particle@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2002 by Ars ex Machina, Corp..

This is free software, licensed under:

  The Artistic License 1.0

=cut


__END__

# ABSTRACT: check for VERSION information in modules


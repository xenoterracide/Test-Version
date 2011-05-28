#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester;
use Test::Version qw( version_all_ok );
use Test::More;

my ( $premature, @results ) = run_tests(
	sub {
		version_all_ok('corpus');
	}
);

is( scalar(@results), 3, 'correct number of results' );

my @oks;

foreach my $result ( @results ) {
	push @oks, $result->{ok};
}

my @sorted = sort @oks;

my @expected = ( 0, 0, 1 );

note( 'unsorted oks: ', @oks );

is( @sorted, @expected, 'test sorted oks' );
done_testing;

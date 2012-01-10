#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester;
use Test::More;
use Test::Version qw( version_all_ok ), { has_version => 0 };

my ( $premature, @results ) = run_tests(
	sub {
		version_all_ok('corpus');
	}
);

is( scalar(@results), 5, 'correct number of results' );

my @oks;

foreach my $result ( @results ) {
	push @oks, $result->{ok};
}

my $sorted = [ sort @oks ];

my $expected = [ ( 0, 1, 1, 1, 1 ) ];

note( 'unsorted oks: ', @oks );

is_deeply( $sorted, $expected, 'oks are ok' );
done_testing;

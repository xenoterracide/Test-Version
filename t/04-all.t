#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester tests => 13;
use Test::Version qw( version_all_ok );

my ( $premature, @results ) = run_tests(
	sub {
		version_all_ok('corpus');
	}
);

cmp_results(
	[ @results ],
	[
		{
			ok => 0,
			name => 'validate VERSION in corpus/noversion/FooBar.pm',
			diag => 'VERSION not defined in corpus/noversion/FooBar.pm',
		},
		{
			ok => 0,
			name => 'validate VERSION in corpus/fail/FooBarBaz.pm',
			diag => 'VERSION in corpus/fail/FooBarBaz.pm is not a valid version',
		},
		{
			ok => 1,
			name => 'VERSION 1.0 in corpus/pass/Foo.pm is valid',
			diag => '',
		},
	],
	'test version_all_ok',
);

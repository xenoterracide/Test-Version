#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester;
use Test::More;
use Test::Version qw( version_ok ), { strict => 1 };

my $ret;
check_test(
	sub {
		$ret = version_ok( 'corpus/not_strict/NotStrict.pm' );
	},
	{
		ok => 0,
		name => q[check version in 'corpus/not_strict/NotStrict.pm'],
		diag => qq[The version '0.1.0' found in 'corpus/not_strict/NotStrict.pm' is not strict.],
	},
);

is $ret, 0, "version_ok() returns false unless strict";

done_testing;

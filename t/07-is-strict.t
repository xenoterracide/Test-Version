#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester;
use Test::More;
$Test::Version::STRICTNESS = 2;
use Test::Version qw( version_ok );

is ( $Test::Version::STRICTNESS, 2, 'strictness set to 2' );
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

ok $ret, "version_ok() failed unless strict";
done_testing;

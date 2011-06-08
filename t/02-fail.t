#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester tests => 8;
use Test::More;
use Test::Version qw( version_ok );

my $ret;
check_test(
	sub {
		$ret = version_ok( 'corpus/fail/FooBarBaz.pm' );
	},
	{
		ok => 0,
		name => 'check version in corpus/fail/FooBarBaz.pm',
		diag => 'NOT_VALID: corpus/fail/FooBarBaz.pm',
	},
	'version invalid'
);

ok !$ret, "version_ok() returned false on fail";

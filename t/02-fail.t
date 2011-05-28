#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester tests => 7;
use Test::Version qw( version_ok );

check_test(
	sub {
		version_ok( 'corpus/fail/FooBarBaz.pm' );
	},
	{
		ok => 0,
		name => 'check version in corpus/fail/FooBarBaz.pm',
		diag => 'NOT_VALID: corpus/fail/FooBarBaz.pm',
	},
	'version invalid'
);

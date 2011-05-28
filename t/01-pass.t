#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester tests => 7;
use Test::Version qw( version_ok );

check_test(
	sub {
		version_ok( 'corpus/pass/Foo.pm' );
	},
	{
		ok => 1,
		name => 'VERSION_OK: corpus/pass/Foo.pm 1.0',
		diag => '',
	},
	'version ok'
);

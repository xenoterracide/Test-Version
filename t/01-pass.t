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
		$ret = version_ok( 'corpus/pass/Foo.pm' );
	},
	{
		ok => 1,
		name => 'VERSION_OK: corpus/pass/Foo.pm 1.0',
		diag => '',
	},
	'version ok'
);

ok $ret, "version_ok() returned true on pass";

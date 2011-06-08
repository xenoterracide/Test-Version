#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester tests => 7;
use Test::Version qw( version_ok );

check_test(
	sub {
		version_ok( 'corpus/nofile/nofile.pm' );
	},
	{
		ok => 0,
		name => 'check version in corpus/nofile/nofile.pm',
		diag => q['corpus/nofile/nofile.pm' doesn't exist.],
	},
	'no file'
);

#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Tester tests => 7;
use Test::Version qw( version_ok );

check_test(
	sub {
		# turn off all warnings since version_ok will spit one for this test
		# only
		local $SIG{__WARN__} = sub {};
		version_ok;
	},
	{
		ok => 0,
		name => 'check version in ',
		diag => 'FILE_NOT_DEFINED',
	},
	'$file not defined'
);

#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Builder::Tester;
use Test::More;
use Test::HasValidVersion qw( version_all_ok );

test_out(
	"ok 1 - corpus/fail/FooBar.pm version 1.0.1 is valid\n".
	'not ok 2 - corpus/fail/FooBarBaz.pm version  is valid',
);

version_all_ok( 'corpus/fail' );

test_test;
done_testing;

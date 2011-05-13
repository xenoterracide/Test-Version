#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Builder::Tester;
use Test::More;
use Test::HasValidVersion qw( version_all_ok );

test_out(
	'not ok 1 - validate VERSION in corpus/noversion/FooBar.pm',
	'not ok 2 - validate VERSION in corpus/fail/FooBarBaz.pm',
	'ok 3 - VERSION 1.0 in corpus/pass/Foo.pm is valid',
);
test_fail(+5);
test_diag( 'VERSION not defined in corpus/noversion/FooBar.pm' );
test_fail(+3);
test_diag( 'VERSION in corpus/fail/FooBarBaz.pm is not a valid version' );

version_all_ok('corpus');

test_test;
done_testing;

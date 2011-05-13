#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Builder::Tester;
use Test::More;
use Test::HasValidVersion qw( version_ok );

test_out( 'not ok 1 - validate VERSION in corpus/fail/FooBarBaz.pm' );
test_fail(+3);
test_diag( 'VERSION in corpus/fail/FooBarBaz.pm is not a valid version' );

version_ok( 'corpus/fail/FooBarBaz.pm' );

test_test;
done_testing;

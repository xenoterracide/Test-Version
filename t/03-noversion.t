#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Builder::Tester;
use Test::More;
use Test::Version qw( version_ok );

test_out( 'not ok 1 - validate VERSION in corpus/noversion/FooBar.pm' );
test_fail(+3);
test_diag( 'VERSION not defined in corpus/noversion/FooBar.pm' );

version_ok( 'corpus/noversion/FooBar.pm' );

test_test;
done_testing;

#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Builder::Tester;
use Test::More;
use Test::HasValidVersion qw( version_all_ok );

test_out(
    'ok 1 - VERSION 1.0.1 in corpus/fail/FooBar.pm is valid',
    'not ok 2 - validate VERSION in corpus/fail/FooBarBaz.pm',
);
test_fail(+3);
test_diag('VERSION in corpus/fail/FooBarBaz.pm is not a valid version');

version_all_ok('corpus/fail');

test_test;
done_testing;

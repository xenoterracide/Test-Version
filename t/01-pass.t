#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Builder::Tester;
use Test::More;
use Test::HasValidVersion qw( version_all_ok );

test_out( 'ok 1 - VERSION 1.0 in corpus/pass/Foo.pm is valid' );
version_all_ok( 'corpus/pass' );
test_test;
done_testing;

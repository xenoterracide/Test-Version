#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::Builder::Tester;
use Test::More;
use Test::Version qw( version_ok );

test_out( 'ok 1 - VERSION 1.0 in corpus/pass/Foo.pm is valid' );

version_ok( 'corpus/pass/Foo.pm' );

test_test;
done_testing;

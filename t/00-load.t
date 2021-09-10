#!perl
use v5.28;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'CDC::Covid19::Data::Breakthrough' ) || print "Bail out!\n";
}

diag( "Testing CDC::Covid19::Data::Breakthrough $CDC::Covid19::Data::Breakthrough::VERSION, Perl $], $^X" );

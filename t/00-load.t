#!perl -T

use Test::More tests => 5;

BEGIN {
	use_ok( 'Catalyst::Authentication::AuthTkt' );
	use_ok( 'Catalyst::Authentication::Realm::AuthTkt' );
	use_ok( 'Catalyst::Authentication::Credential::AuthTkt' );
	use_ok( 'Catalyst::Authentication::Store::AuthTkt' );
	use_ok( 'Catalyst::Authentication::User::AuthTkt' );
}

diag( "Testing Catalyst::Authentication::AuthTkt $Catalyst::Authentication::AuthTkt::VERSION, Perl $], $^X" );

use Test::More tests => 9;

use lib 't/MyApp/lib';
use Catalyst::Test 'MyApp';
use HTTP::Request::Common;
use Data::Dump qw( dump );
use Config::General;
use Apache::AuthTkt;

ok( my $conf = new Config::General("t/MyApp/myapp.conf"),
    "get config via file" );
ok( my %config = $conf->getall, "parse config file" );

#dump \%config;

my $store       = $config{authentication}->{realms}->{authtkt}->{store};
my $secret      = $store->{secret};
my $cookie_name = $store->{cookie_name};

my $res;
ok( $res = request('/'), "get /" );
is( $res->headers->{status}, 302, "req redirects without auth tkt" );
is( $res->headers->{location},
    $config{authentication}->{auth_url},
    "auth url"
);

ok( my $AAT = Apache::AuthTkt->new( secret => $secret, ), "new AAT" );
ok( my $auth_ticket = $AAT->ticket(
        uid     => 'catalyst-tester',
        ip_addr => '127.0.0.1',
        tokens  => 'group1,group2',
        data    => 'foo bar baz'
    ),
    "new auth_tkt"
);

ok( $res = request("/?$cookie_name=$auth_ticket"), "get / with auth_tkt" );
is( $res->content,
    'Logged in as user catalyst-tester with roles ("group1", "group2")',
    "logged in" );

#dump $res;

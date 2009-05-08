use Test::More tests => 12;

use lib 't/MyApp/lib';
use Catalyst::Test 'MyApp';
use HTTP::Request::Common;
use Data::Dump qw( dump );
use Config::General;
use Apache::AuthTkt;
use HTTP::Request::AsCGI;

my $class = 'MyApp';

# based on Catalyst::Test local_request() but
# hack in session cookie support.
sub my_request {
    my $uri = shift or die "uri required";
    my $cookie = shift || '';
    $ENV{COOKIE} = $cookie;
    my $request = Catalyst::Utils::request($uri);
    my $cgi = HTTP::Request::AsCGI->new( $request, %ENV )->setup;
    $class->handle_request;
    my $response = $cgi->restore->response;
    $response->{_request} = $request;
    return $response;
}

# I'm told sleep() won't work under win32
sub mock_sleep {
    my $len = shift || 0;

    #diag("mock sleep for $len secs");
    my $end = time() + $len;
    while ( time() <= $end ) {

        #diag( "mock sleep: " . localtime() );
    }

}

ok( my $conf = Config::General->new("t/MyApp/myapp.conf"),
    "get config via file" );
ok( my %config = $conf->getall, "parse config file" );

#dump \%config;

my $store       = $config{authentication}->{realms}->{authtkt}->{store};
my $secret      = $store->{secret};
my $cookie_name = $store->{cookie_name};

my $res;
ok( $res = my_request('/'), "get /" );
is( $res->headers->{status}, 302, "req redirects without auth tkt" );
is( $res->headers->{location},
    $config{authentication}->{auth_url},
    "auth url"
);

#diag( dump $res );

# keep initial session alive to test user persistence
my $session_cookie = $res->headers->{'set-cookie'};

#mock_sleep(1);

ok( my $AAT = Apache::AuthTkt->new( secret => $secret, ), "new AAT" );
ok( my $auth_ticket = $AAT->ticket(
        uid     => 'catalyst-tester',
        ip_addr => '127.0.0.1',
        tokens  => 'group1,group2',
        data    => 'foo bar baz'
    ),
    "new auth_tkt"
);

ok( $res = my_request( "/?$cookie_name=$auth_ticket", $session_cookie ),
    "get / with auth_tkt" );
is( $res->content,
    'Logged in as user catalyst-tester with roles ("group1", "group2")',
    "logged in" );

#mock_sleep(1);

# request again with no cookie or tkt set
# to test session persistence
ok( $res = my_request( '/', $session_cookie ), "get / with no auth_tkt" );
is( $res->headers->{status}, 302, "req redirects without auth tkt" );
is( $res->headers->{location},
    $config{authentication}->{auth_url},
    "auth url"
);

#dump $res;


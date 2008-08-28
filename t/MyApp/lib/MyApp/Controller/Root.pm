package MyApp::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';
use Data::Dump qw( dump );

__PACKAGE__->config( namespace => '' );

sub auto : Private {
    my ( $self, $c ) = @_;

    # validate the ticket and update ticket and session if necessary
    return 1 if $c->authenticate;

    # no valid login found so redirect.
    $c->response->redirect( $c->config->{authentication}->{auth_url} );

    # tell Catalyst to abort processing.
    return 0;
}

sub default : Private {
    my ( $self, $c ) = @_;
    $c->response->body('default page');
}

sub end : Private {
    my ( $self, $c ) = @_;
    if ( $c->user_exists ) {
        $c->response->body( "Logged in as user "
                . $c->user->id
                . ' with roles '
                . dump $c->user->roles );
    }
}

1;

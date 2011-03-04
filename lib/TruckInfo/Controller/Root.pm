package TruckInfo::Controller::Root;
use Moose;
use namespace::autoclean;

use Encode;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=head1 NAME

TruckInfo::Controller::Root - Root Controller for TruckInfo

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect(
        $c->uri_for( $c->controller('truckregister')->action_for('main') ) );

}

sub base : Chained('/') : PathPart('') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub login : Chained('base') : PathPart('login') : Args(0) {
    my ( $self, $c ) = @_;
    if ( %{ $c->req->body_params } ) {
        my $params = $c->req->body_params;

        if ( !$params->{user} || !$params->{password} ) {
            $c->stash->{msg_error} = 'Usuário e Senha são obrigatórios';
            return;
        }

        my $result = $c->model('Schema')->c('login')->find_one(
            {
                name     => $params->{user},
                password => $params->{password}
            }
        );

        if ($result) {
            $c->session->{user} = $params->{user};
            $c->res->redirect(
                $c->uri_for(
                    $c->controller('truckregister')->action_for('main')
                )
            );
        }
        else {
            $c->stash->{msg_error} = 'Usuário ou senha inválidos';
            return;
        }
    }
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
    my ( $self, $c ) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
}

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

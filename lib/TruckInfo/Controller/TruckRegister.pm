package TruckInfo::Controller::TruckRegister;
use Moose;
use namespace::autoclean;
use Business::BR::CPF;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

TruckInfo::Controller::TruckRegister - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->res->redirect(
        $c->uri_for( $c->controller('truckregister')->action_for('main') ) );
}

sub base : Chained('/base') : PathPart('truckregister') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash(
        all_drivers => sub {
            return [ $c->model('Schema')->c->find->all ];
        },
        find_drivers => sub {
            my $name = quotemeta(shift);
            return [
                $c->model('Schema')->c->find( { name2 => qr/$name/i } )->all ];
        },

        format_cpf => sub {
            return Business::BR::CPF::format_cpf(shift);
        },
        to_upper => sub {
            my $infs = shift;
            my %hash;
            foreach my $key ( keys %{$infs} ) {
                $hash{$key} = uc( $infs->{$key} );
            }
            return %hash;
        },
        clean_cpf => sub {
            my $cpf = shift;
            $cpf =~ s/\D//g;
            return $cpf;
        },
        find_cpf => sub {
            return $c->model('Schema')->c->find_one( { cpf => shift } );
        }
    );
}

sub main : Chained('base') : PathPart('main') : Args(0) {
    my ( $self, $c ) = @_;
}

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ( $self, $c ) = @_;
}

sub search : Chained('base') : PathPart('search') : Args(0) {
    my ( $self, $c ) = @_;
    if ( %{ $c->req->body_params } ) {
        my $params = $c->req->body_params;
        if ( $params->{'tipo'} eq 'cpf' ) {
            my $cpf = $c->stash->{'clean_cpf'}->( $params->{'search'} );
            $c->stash->{'search_cpf'} = $cpf;
            $c->stash->{'template'}   = 'truckregister/search_cpf.tt';
            return;
        }
        elsif ( $params->{'tipo'} eq 'name2' ) {
            $c->stash->{'search_nome'} = $params->{'search'};
            $c->stash->{'template'}    = 'truckregister/search_nome.tt';
            return;
        }
    }
}

sub step1 : Chained('base') : PathPart('step1') : Args(0) {
    my ( $self, $c ) = @_;
}

sub step2 : Chained('base') : PathPart('step2') : Args(0) {
    my ( $self, $c ) = @_;
    if ( %{ $c->req->params } ) {
        $c->session( %{ $c->req->params } );
        my $cpf = $c->req->params->{'cpf'};
        $cpf =~ s/\D//g;
        my $name = $c->req->params->{'name2'};
        if ( $cpf && $name ) {

            my $check_cpf = $c->model('Schema')->c->find_one( { cpf => $cpf } );

            if ($check_cpf) {
                $c->stash->{'error_msg'} = 'CPF j&aacute; cadastrado';
                $c->stash->{'template'}  = 'truckregister/step1.tt';
                return;
            }

            $c->session( cpf => $cpf, name => $name );
        }
        else {
            $c->stash->{'error_msg'} = 'CPF &iacute;nvalido ou nome vazio';
            $c->stash->{'template'}  = 'truckregister/step1.tt';
            return;
        }
    }
}

sub step3 : Chained('base') : PathPart('step3') : Args(0) {
    my ( $self, $c ) = @_;
    if ( %{ $c->req->params } ) {
        $c->session( %{ $c->req->params } );
        $c->stash->{'cpf'} = $c->session->{'cpf'};
    }
}

sub render : Chained('base') : PathPart('render') : Args(1) {
    my ( $self, $c, $cpf ) = @_;
    if ( %{ $c->req->params } ) {
        $c->session( %{ $c->req->params } );
        my $check_cpf = $c->model('Schema')->c->find_one( { cpf => $cpf } );
        if ( !$check_cpf ) {
            $c->model('Schema')->c->insert( $c->session );
        }

    }
    my $infs = $c->model('Schema')->c->find_one( { cpf => $cpf } );
    $infs->{'cpf'} = Business::BR::CPF::format_cpf( $infs->{'cpf'} );

    $c->stash( $c->stash->{'to_upper'}->($infs) );
}

sub edit : Chained('base') : PathPart('edit') : Args(1) {
    my ( $self, $c, $cpf ) = @_;
    $c->stash->{'cpf'} = $cpf;
    my $infs = $c->model('Schema')->c->find_one( { cpf => $cpf } );

    if ( %{ $c->req->body_params } ) {
        my $params = $c->req->body_params;
        $params->{'cpf'} = $cpf;
        $c->model('Schema')
          ->c->update( { cpf => $cpf }, { '$set' => $params } );
        $c->res->redirect(
            $c->uri_for(
                $c->controller('truckregister')->action_for('render'), $cpf
            )
        );
        return;
    }

    $infs->{'cpf'} = Business::BR::CPF::format_cpf( $infs->{'cpf'} );
    $c->stash( $c->stash->{'to_upper'}->($infs) );
}

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

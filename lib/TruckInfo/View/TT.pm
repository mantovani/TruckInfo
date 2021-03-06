package TruckInfo::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die         => 1,
    INCLUDE_PATH       => [
        TruckInfo->path_to( 'root', 'templates', 'src' ),
        TruckInfo->path_to( 'root', 'templates', 'lib' )
    ],
    WRAPPER => 'site/wrapper',

);

=head1 NAME

TruckInfo::View::TT - TT View for TruckInfo

=head1 DESCRIPTION

TT View for TruckInfo.

=head1 SEE ALSO

L<TruckInfo>

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

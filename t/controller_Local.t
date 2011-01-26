use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'TruckInfo' }
BEGIN { use_ok 'TruckInfo::Controller::Local' }

ok( request('/local')->is_success, 'Request should succeed' );
done_testing();

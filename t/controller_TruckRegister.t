use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'TruckInfo' }
BEGIN { use_ok 'TruckInfo::Controller::TruckRegister' }

ok( request('/truckregister')->is_success, 'Request should succeed' );
done_testing();

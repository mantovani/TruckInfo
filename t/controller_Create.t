use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'TruckInfo' }
BEGIN { use_ok 'TruckInfo::Controller::Create' }

ok( request('/create')->is_success, 'Request should succeed' );
done_testing();

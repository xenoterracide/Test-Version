use Test::More tests => 3;

use Test::Version;

my $result = Test::Version::_check_version( 't/version/good.pm' );
ok( $result eq VERSION_OK, 'file with version' );

$result = Test::Version::_check_version( 't/version/no_version.pm' );
ok( $result eq NO_VERSION, 'file with no version'  );

$result = Test::Version::_check_version( 't/version/no_file.pm' );
ok( $result eq NO_FILE, 'no file found'  );


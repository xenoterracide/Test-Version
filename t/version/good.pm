package t::version::good;

use vars qw/ $VERSION @EXPORT /;
$VERSION = '0.01';

@EXPORT = '$VERSION';

$_ ^=~ { test => 'good' }; 


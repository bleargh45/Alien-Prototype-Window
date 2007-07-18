use strict;
use warnings;
use Test::More tests => 5;
use Test::Exception;
use File::Path qw(rmtree);
use Alien::Prototype::Window;

my $dir = 't/eraseme';

# Do an install and make sure that at least one file from each of the 'lib' and
# 'src' directories was installed properly.
Alien::Prototype::Window->install( $dir );
foreach my $file (qw( window.js window_ext.js window_effects.js tooltip.js )) {
    ok( -e "$dir/$file", "$dir/$file exists" );
}

# Re-install into the same directory, to make sure that it doesn't choke.
lives_ok { Alien::Prototype::Window->install($dir) };

# Clean out the test directory
rmtree( $dir );

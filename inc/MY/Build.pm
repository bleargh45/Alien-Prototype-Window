package MY::Build;

use strict;
use warnings;
use base qw(Module::Build);
use Archive::Zip qw(:ERROR_CODES);
use Alien::Prototype::Window;

sub ACTION_code {
    my $self = shift;
    $self->SUPER::ACTION_code;
    $self->fetch_pwc();
    $self->install_pwc();
}

sub pwc_archive {
    return join( '', 'windows_js_', Alien::Prototype::Window->version(), '.zip' );
}

sub pwc_dir {
    return join( '', 'windows_js_', Alien::Prototype::Window->version() );
}

sub pwc_target_dir {
    return 'blib/lib/Alien/Prototype/Window/';
}

sub pwc_url {
    my $self = shift;
    return 'http://prototype-window.xilinus.com/download/' .  $self->pwc_archive();
}

sub fetch_pwc {
    my $self = shift;
    return if (-f $self->pwc_archive());

    require File::Fetch;
    print "Fetching Prototype Window Class...\n";
    my $path = File::Fetch->new( 'uri' => $self->pwc_url )->fetch();
    die "Unable to fetch archive" unless $path;
}

sub install_pwc {
    my $self = shift;
    return if (-d $self->pwc_target_dir());

    print "Installing Prototype Window Class...\n";
    my $zip = Archive::Zip->new();
    unless ($zip->read($self->pwc_archive()) == AZ_OK) {
        die "unable to open PWC zip archive\n";
    }
    my $src = $self->pwc_dir();
    my $dst = $self->pwc_target_dir();
    unless ($zip->extractTree($src,$dst) == AZ_OK) {
        die "unable to extract PWC zip archive\n";
    }
}

1;

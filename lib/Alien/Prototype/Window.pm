package Alien::Prototype::Window;

###############################################################################
# Required inclusions.
###############################################################################
use strict;
use warnings;
use Carp;
use File::Copy qw(copy);
use File::Path qw(mkpath);
use File::Find qw(find);
use File::Basename qw(dirname);

###############################################################################
# Version number
###############################################################################
our $PWC_VERSION = '1.3';
our $VERSION = '1.3.1';

###############################################################################
# Subroutine:   version()
###############################################################################
# Return the Prototype Window Class version number.
#
# Not to be confused with the 'Alien::Prototype::Window' version number (which
# is the version number of the Perl wrapper).
###############################################################################
sub version {
    return $PWC_VERSION;
}

###############################################################################
# Subroutine:   path()
###############################################################################
# Returns the path to the available copy of Prototype Window Class.
###############################################################################
sub path {
    my $base = $INC{'Alien/Prototype/Window.pm'};
    $base =~ s{\.pm$}{};
    return $base;
}

###############################################################################
# Subroutine:   install($destdir)
# Parameters:   $destdir    - Destination directory
###############################################################################
# Installs the Prototype Window Class into the given '$destdir'.  Throws a
# fatal exception on errors.
###############################################################################
sub install {
    my ($class, $destdir) = @_;
    if (!-d $destdir) {
        mkpath( [$destdir] ) || croak "can't create '$destdir'; $!";
    }
    my $path = $class->path();

    # Install JS files
    my @files = grep { -f $_ } glob "$path/javascripts/*.js";
    foreach my $file (@files) {
        copy( $file, $destdir ) || croak "can't copy '$file' to '$destdir'; $!";
    }

    # Install theme files
    my $theme_srcdir  = "$path/themes";
    my $theme_destdir = "$destdir/window";
    @files = ();
    File::Find::find(
        sub { -f $_ && push(@files, $File::Find::name) },
        $theme_srcdir
        );
    foreach my $file (@files) {
        my $destfile = $file;
        $destfile =~ s{$theme_srcdir}{$theme_destdir};

        my $destpath = dirname( $destfile );
        if (!-d $destpath) {
            mkpath( [$destpath] ) || croak "can't create '$destpath'; $!";
        }
        copy( $file, $destpath ) || croak "can't copy '$file' to '$destpath'; $!";
    }
}

1;

=head1 NAME

Alien::Prototype::Window - installing and finding Prototype Window Class

=head1 SYNOPSIS

  use Alien::Prototype::Window;
  ...
  $version = Alien::Prototype::Window->version();
  $path    = Alien::Prototype::Window->path();
  ...
  Alien::Prototype::Window->install( $my_destination_directory );

=head1 DESCRIPTION

Please see L<Alien> for the manifesto of the Alien namespace.

=head1 METHODS

=over

=item version()

Return the Prototype Window Class version number. 

Not to be confused with the C<Alien::Prototype::Window> version number
(which is the version number of the Perl wrapper). 

=item path()

Returns the path to the available copy of Prototype Window Class. 

=item install($destdir)

Installs the Prototype Window Class into the given C<$destdir>. Throws a
fatal exception on errors. 

=back

=head1 AUTHOR

Graham TerMarsch (cpan@howlingfrog.com)

=head1 LICENSE

Copyright (C) 2007, Graham TerMarsch.  All rights reserved.

This is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

http://prototype-window.xilinus.com/,
L<Alien>.

=cut

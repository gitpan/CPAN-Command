package CPAN::Command::Homepage;

use strict;
use warnings;
use 5.008_001;
use CPAN;  # so it can be used with CPAN::Commander or standalone
use Regexp::Common qw(URI);
use URI;

our $VERSION = '0.01';

push @CPAN::Complete::COMMANDS, qw( homepage );
$CPAN::Shell::Help->{homepage} = "open a distribution's home page";

sub CPAN::Shell::homepage  { shift->rematein('homepage', @_) }
sub CPAN::Module::homepage { shift->rematein('homepage') }

sub CPAN::Distribution::homepage {
    my $self = shift;
    $self->get;
    my $package = $self->called_for;

    my $meta = $self->parse_meta_yml;
    my $url = $meta->{resources}{homepage};
    unless ($url) {
        $CPAN::Frontend->mywarn("$package doesn't have a homepage set in META.yml\n");
        if (my $name = $meta->{name}) {
            $CPAN::Frontend->mywarn("falling back to search.cpan.org page\n");
            $url = sprintf 'http://search.cpan.org/dist/%s', $meta->{name};
        } else {
            $CPAN::Frontend->mywarn(
                "$package doesn't have a name set in META.yml either\n"
            );
        }
    }
    if ($url =~ /^$RE{URI}{HTTP}$/) {
        system("open $url");
    } else {
        $CPAN::Frontend->mywarn("$url doesn't look like a URI");
    }
}

1;

__END__

=head1 NAME

CPAN::Command::Homepage - Adds a 'homepage' command to the CPAN shell

=head1 SYNOPSIS

    # sudo perl -MCPAN::Command -e 'CPAN::shell()'
    # cpan> homepage Foo::Bar

=head1 DESCRIPTION

This is a plugin for L<CPAN::Command> which adds a C<bugtracker> command to
the CPAN shell. The command expects a module name and opens the web page for
the distribution's bug tracker, if one is set in the distribution's
L<META.yml> file.

Currently opening the web page is done with the C<open(1)> command, so it
will probably only work with Mac OS X. Patches for other operating systems are
welcome.

=head1 METHODS

=over 4

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

The development version lives at L<http://github.com/hanekomu/cpan-command/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

This module was inspired by L<CPAN::Command::Repo> by Tatsuhiko Miyagawa.

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

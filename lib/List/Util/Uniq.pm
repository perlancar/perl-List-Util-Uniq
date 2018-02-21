package List::Util::Uniq;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       uniq_adj uniq_adj_ci uniq_ci
               );

sub uniq_adj {
    my @res;

    return () unless @_;
    my $last = shift;
    push @res, $last;
    for (@_) {
        next if !defined($_) && !defined($last);
        # XXX $_ becomes stringified
        next if defined($_) && defined($last) && $_ eq $last;
        push @res, $_;
        $last = $_;
    }
    @res;
}

sub uniq_adj_ci {
    my @res;

    return () unless @_;
    my $last = shift;
    push @res, $last;
    for (@_) {
        next if !defined($_) && !defined($last);
        # XXX $_ becomes stringified
        next if defined($_) && defined($last) && lc($_) eq lc($last);
        push @res, $_;
        $last = $_;
    }
    @res;
}

sub uniq_ci {
    my @res;

    my %mem;
    for (@_) {
        push @res, $_ unless $mem{lc $_}++;
    }
    @res;
}

1;
# ABSTRACT: List utilities related to finding unique items

=head1 FUNCTIONS

Not exported by default but exportable.

=head2 uniq_adj(@list) => LIST

Remove I<adjacent> duplicates from list, i.e. behave more like Unix utility's
B<uniq> instead of L<List::MoreUtils>'s C<uniq> function, e.g.

 my @res = uniq(1, 4, 4, 3, 1, 1, 2); # 1, 4, 3, 1, 2

=head2 uniq_adj_ci(@list) => LIST

Like C<uniq_adj> except case-insensitive.

=head2 uniq_ci(@list) => LIST

Like C<List::MoreUtils>' C<uniq> except case-insensitive.


=head1 SEE ALSO

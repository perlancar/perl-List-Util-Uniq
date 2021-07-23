package List::Util::Uniq;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                           uniq_adj
                           uniq_adj_ci
                           uniq_ci
                           is_uniq
                           is_uniq_ci
                           is_monovalued
                           is_monovalued_ci
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
    my $undef_added;
    for (@_) {
        if (defined) {
            push @res, $_ unless $mem{lc $_}++;
        } else {
            push @res, $_ unless $undef_added++;
        }
    }
    @res;
}

sub is_uniq {
    my %vals;
    for (@_) {
        return 0 if $vals{$_}++;
    }
    1;
}

sub is_uniq_ci {
    my %vals;
    for (@_) {
        return 0 if $vals{lc $_}++;
    }
    1;
}

sub is_monovalued {
    my %vals;
    for (@_) {
        $vals{$_} = 1;
        return 0 if keys(%vals) > 1;
    }
    1;
}

sub is_monovalued_ci {
    my %vals;
    for (@_) {
        $vals{lc $_} = 1;
        return 0 if keys(%vals) > 1;
    }
    1;
}

1;
# ABSTRACT: List utilities related to finding unique items

=head1 SYNOPSIS

 use List::Util::Uniq qw(uniq_adj uniq_adj_ci uniq_ci);

 @res = uniq_adj(1, 4, 4, 3, 1, 1, 2); # 1, 4, 3, 1, 2
 @res = uniq_adj_ci("a", "b", "B", "c", "a"); # "a", "b", "c", "a"
 @res = uniq_ci("a", "b", "B", "c", "a"); # "a", "b", "c"


=head1 FUNCTIONS

None exported by default but exportable.

=head2 uniq_adj

Usage:

 my @uniq = uniq_adj(@list);

Remove I<adjacent> duplicates from list, i.e. behave more like Unix utility's
B<uniq> instead of L<List::MoreUtils>'s C<uniq> function. Uses string equality
test.

=head2 uniq_adj_ci

Like L</uniq_adj> except case-insensitive.

=head2 uniq_ci

Like C<List::MoreUtils>' C<uniq> (C<uniqstr>) except case-insensitive.

=head2 is_uniq

Usage:

 my $is_uniq = is_uniq(@list);

Return true when the values in C<@list> is unique (compared string-wise).
Knowing whether a list has unique values is faster using this function compared
to doing:

 my @uniq = uniq(@list);
 @uniq == @list;

because of short-circuiting.

=head2 is_uniq_ci

Like L</is_uniq> except case-insensitive.

=head2 is_monovalued

Usage:

 my $is_monovalued = is_monovalued(@list);

Examples:

 is_monovalued(qw/a b c/); # => 0
 is_monovalued(qw/a a a/); # => 1

Return true if C<@list> contains only a single value. Returns true for empty
list. Undef is coerced to empty string, so C<< is_monovalued(undef) >> and C<<
is_monovalued(undef, undef) >> return true.

=head2 is_monovalued_ci

Like L</is_monovalued> except case-insensitive.


=head1 SEE ALSO

L<List::Util>

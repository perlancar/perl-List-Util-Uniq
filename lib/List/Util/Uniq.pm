package List::Util::Uniq;

use strict;
use warnings;

use Exporter qw(import);

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(
                       uniq
                       uniqint
                       uniqnum
                       uniqstr

                       uniq_adj
                       uniq_adj_ci
                       uniq_ci
                       is_uniq
                       is_uniq_ci
                       is_monovalued
                       is_monovalued_ci
                       dupe
                       dupeint
                       dupenum
                       dupestr
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

sub uniqint {
    my (@uniqs, %vals);
    for (@_) {
        no warnings 'numeric';
        ++$vals{int $_} == 1 and push @uniqs, $_;
    }
    @uniqs;
}

sub uniqnum {
    my (@uniqs, %vals);
    for (@_) {
        no warnings 'numeric';
        ++$vals{$_+0} == 1 and push @uniqs, $_;
    }
    @uniqs;
}

sub uniqstr {
    my (@uniqs, %vals);
    for (@_) {
        ++$vals{$_} == 1 and push @uniqs, $_;
    }
    @uniqs;
}

sub uniq { goto \&uniqstr }

sub dupeint {
    my (@dupes, %vals);
    for (@_) {
        no warnings 'numeric';
        ++$vals{int $_} > 1 and push @dupes, $_;
    }
    @dupes;
}

sub dupenum {
    my (@dupes, %vals);
    for (@_) {
        no warnings 'numeric';
        ++$vals{$_+0} > 1 and push @dupes, $_;
    }
    @dupes;
}

sub dupestr {
    my (@dupes, %vals);
    for (@_) {
        ++$vals{$_} > 1 and push @dupes, $_;
    }
    @dupes;
}

sub dupe { goto \&dupestr }

1;
# ABSTRACT: List utilities related to finding unique items

=for Pod::Coverage ^(uniq|uniqint|uniqnum|uniqstr)+

=head1 SYNOPSIS

 use List::Util::Uniq qw(
     is_monovalued
     is_monovalued_ci
     is_uniq
     is_uniq_ci
     uniq_adj
     uniq_adj_ci
     uniq_ci
     dupe
     dupenum
     dupestr
 );

 $res = is_monovalued(qw/a a a/); # => 1
 $res = is_monovalued(qw/a b a/); # => 0

 $res = is_monovalued_ci(qw/a a A/); # => 1
 $res = is_monovalued_ci(qw/a b A/); # => 0

 $res = is_uniq(qw/a b a/); # => 0
 $res = is_uniq(qw/a b c/); # => 1

 $res = is_uniq_ci(qw/a b A/); # => 0
 $res = is_uniq_ci(qw/a b c/); # => 1

 @res = uniq_adj(1, 4, 4, 3, 1, 1, 2); # => (1, 4, 3, 1, 2)

 @res = uniq_adj_ci("a", "b", "B", "c", "a"); # => ("a", "b", "c", "a")

 @res = uniq_ci("a", "b", "B", "c", "a"); #  => ("a", "b", "c")

 @res = dupe("a","b","a","a","b","c"); #  => ("a","a","b")
 @res = dupenum(1,2,1,1,2,3); #  => (1,1,2)
 @res = dupenum("a",0,0.0,1); #  => (0,0.0), because "a" becomes 0 numerically
 @res = dupestr("a","b","a","a","b","c"); # => ("a","a","b")


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

=head2 dupe

See L</dupestr>.

=head2 dupeint

Like L</dupestr> but the values are compared as integers. If you only want to
list each duplicate elements once, you can do:

 @uniq_dupes = uniqint(dupeint(@list));

where C<uniqint> can be found in L<List::Util>, but the pure-perl version is
also provided by this module, for convenience.

=head2 dupenum

Like L</dupestr> but the values are compared numerically. If you only want to
list each duplicate elements once, you can do:

 @uniq_dupes = uniqnum(dupenum(@list));

where C<uniqnum> can be found in L<List::Util>, but the pure-perl version is
also provided by this module, for convenience.

=head2 dupestr

Usage:

 @dupes = dupestr(@list);

Return duplicate elements (the second and subsequence occurrences of each
element) in C<@list>. If you only want to list each duplicate elements once, you
can do:

 @uniq_dupes = uniqstr(dupestr(@list));

where C<uniqstr> can be found in L<List::Util>, but the pure-perl version is
also provided by this module, for convenience.


=head1 SEE ALSO

L<List::Util>

Other C<List::Util::*> modules.

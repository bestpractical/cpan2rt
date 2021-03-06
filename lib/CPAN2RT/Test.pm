use strict;
use warnings;

### after: use lib qw(@RT_LIB_PATH@);
use lib qw(/opt/rt3/local/lib /opt/rt3/lib);

package CPAN2RT::Test;

our @ISA;
BEGIN {
    local $@;
    eval { require RT::Test; 1 } or do {
        require Test::More;
        Test::More::BAIL_OUT(
            "requires 3.8 to run tests. Error:\n$@\n"
            ."You may need to set PERL5LIB=/path/to/rt/lib"
        );
    };
    push @ISA, 'RT::Test';
}

sub import {
    my $class = shift;
    my %args  = @_;

    $args{'requires'} ||= [];
    if ( $args{'testing'} ) {
        unshift @{ $args{'requires'} }, 'CPAN2RT';
    } else {
        $args{'testing'} = 'CPAN2RT';
    }
    unshift @{ $args{'requires'} }, 'RT::Extension::MergeUsers';

    $class->SUPER::import( %args );
    $class->export_to_level(1);

    require CPAN2RT;
}

1;

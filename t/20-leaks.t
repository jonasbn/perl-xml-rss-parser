#!perl

BEGIN { chdir 't' if -d 't' }

use strict;
use warnings;

use lib '../lib';

use Test::More tests => 1;

use Devel::Leak::Object qw(GLOBAL_bless);

use XML::RAI;

SKIP: {
    eval "require Test::Weaken";
    skip "Test::Weaken not installed", 1 if $@;
    my $file = 'x/example2.xml';
    my $rss = do { local( @ARGV, $/ ) = $file ; <> } ;
    my $tester = Test::Weaken::leaks(
		sub { XML::RAI->parse_string($rss) },
	);
    ok(!$tester); 
}

__END__

use Carp;
use English qw( -no_match_vars );
use Data::Dumper;

    diag($tester);
    if ($tester) {
        my $unfreed_proberefs = $tester->unfreed_proberefs();
        my $unfreed_count     = @{$unfreed_proberefs};
        printf "%d of %d references were not freed\n",
            $tester->unfreed_count(), $tester->probe_count()
            or Carp::croak("Cannot print to STDOUT: $ERRNO");
        print "These are the probe references to the unfreed objects:\n"
            or Carp::croak("Cannot print to STDOUT: $ERRNO");
        for my $ix ( 0 .. $#{$unfreed_proberefs} ) {
            print Data::Dumper->Dump( [ $unfreed_proberefs->[$ix] ],
                ["unfreed_$ix"] )
                or Carp::croak("Cannot print to STDOUT: $ERRNO");
        }
    }
    diag($tester->unfreed_count());

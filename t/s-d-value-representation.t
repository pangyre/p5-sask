#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;

BEGIN { use_ok("Sask::Dicom::ValueRepresentation") }

# UI validation.
{
    my $ui = $Sask::Dicom::ValueRepresentation::VR{UI};
    my $code = $ui->{validation};

    my @bad_ui = (
                  undef,
                  "",
                  0,
                  "0",
                  "0.1",
                  "1.01",
                  "1.0.1",
                  "123456789.123456789.123456789.123456789.123456789.123456789.12345",
                  "abcd",
                  1_000_000,
                  );

    for my $bad ( @bad_ui )
    {
        no warnings "uninitialized";
        ok( ! $code->($bad),
            qq{"$bad" fails validation} );
    }

    my @good_ui = (
                   "1.2",
                   "1.2.840.10008.5.1.4.1.1.6.1",
                   "123456789.123456789.123456789.123456789.123456789.123456789.1234",
                  );

    for my $good ( @good_ui )
    {
        no warnings "uninitialized";
        ok( $code->($good),
            qq{"$good" passes validation} );
    }
}

done_testing();

__DATA__

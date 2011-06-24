#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;

BEGIN { use_ok("Sask::Dicom::ValueRepresentation") }

{
    my @bad_ui = (
                  undef,
                  "",
                  0,
                  "0",
                  "0.1",
                  "1.0.0.01",
                  "123456789.123456789.123456789.123456789.123456789.123456789.12345",
                  "abcd",
                  1_000_000,
                  );

    my $ui = $Sask::Dicom::ValueRepresentation::VR{UI};
    my $code = $ui->{validation};
    for my $bad ( @bad_ui )
    {
        no warnings "uninitialized";
        ok( ! $code->($bad),
            "$bad fails validation" );
    }
}

done_testing();

__DATA__

use strictures;
use Test::Most;

BEGIN { use_ok("Types::Dicom") }

subtest "UIs" => sub {
    no warnings "uninitialized";

    my @bad_ui = ( undef,
                   "",
                   0,
                   "0",
                   "0.1",
                   "1.01",
                   "1.0.1",
                   "123456789.123456789.123456789.123456789.123456789.123456789.12345",
                   "abcd",
                   1_000_000 );

    for my $bad ( @bad_ui )
    {
        ok ! Types::DICOM::UI->check($bad), qq{"$bad" fails validation};
    }

    my @good_ui = ( "1.2",
                    "1.2.840.10008.5.1.4.1.1.6.1",
                    "123456789.123456789.123456789.123456789.123456789.123456789.1234" );

    for my $good ( @good_ui )
    {
        ok Types::DICOM::UI->check($good), qq{"$good" passes validation};
    }
};

done_testing(2);

__DATA__

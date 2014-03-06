use utf8;
use strictures;
use Test::Most;
use open ":std", ":encoding(utf8)";

BEGIN { use_ok("Types::Dicom") }

subtest "UIs" => sub {
    no warnings "uninitialized";

    my @bad = ( undef,
                "",
                0,
                "0",
                "0.1",
                "1.01",
                "1.0.1",
                "123456789.123456789.123456789.123456789.123456789.123456789.12345",
                "abcd",
                1_000_000 );

    for my $bad ( @bad )
    {
        ok ! Types::DICOM::UI->check($bad), qq{"$bad" fails};
    }

    my @good = ( "1.2",
                 "1.2.840.10008.5.1.4.1.1.6.1",
                 "123456789.123456789.123456789.123456789.123456789.123456789.1234" );

    for my $good ( @good )
    {
        ok Types::DICOM::UI->check($good), qq{"$good" passes};
    }

    done_testing( @bad + @good );
};

subtest "AE" => sub {
    my @bad = ( "", " ", "잠자리", "SEVENTEEN CHARACT" );
    for ( @bad )
    {
        ok ! Types::DICOM::AE->check($_), qq{"$_" fails};
    }

    my @good = ( " OK ", "fine", "SIXTEEN CHARAC" );
    for ( @good )
    {
        ok Types::DICOM::AE->check($_), qq{"$_" passes};
    }


    done_testing( @bad + @good );
};

done_testing(3);

__DATA__

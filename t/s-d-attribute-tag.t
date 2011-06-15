#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Image::ExifTool::DICOM;

BEGIN { use_ok("Sask::Dicom::AttributeTag") }

subtest "Known tags" => sub {
    my %map = %Image::ExifTool::DICOM::Main;
    my @tags = grep { /\A\p{AHex}{4},\p{AHex}{4}\z/ }
        sort keys %map;

    plan tests =>  4 * scalar @tags;
    for my $tag ( @tags )
    {
        my ( $hex_group, $hex_element ) = split ",", $tag;
        isa_ok( my $at = Sask::Dicom::AttributeTag->new($hex_group,$hex_element),
             "Sask::Dicom::AttributeTag");
        is( $at->group, hex($hex_group) );
        is( $at->element, hex($hex_element) );
        is( lc $at, lc $tag );
    }
};

done_testing();

__DATA__

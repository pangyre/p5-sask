#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Sask::Dicom::ValueRepresentation;
use Sask::Dicom::AttributeTag;
BEGIN { use_ok("Sask::Dicom::Attribute") }

ok( my $attr = Sask::Dicom::Attribute->new( vr => Sask::Dicom::ValueRepresentation->new(code => "UI"),
                                          tag => Sask::Dicom::AttributeTag->new(qw( 0x0002 0x0003 )) ),
    "Sask::Dicom::Tag->new");

done_testing();

__DATA__

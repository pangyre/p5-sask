package Sask::Dicom::Attribute; # This is the junction of VR/value/tag...
use Mouse;

has "vr" =>
    is => "ro",
    isa => "Sask::Dicom::ValueRepresentation",
    coerce => 1,
    required => 1,
    ;

has "tag" =>
    is => "ro",
    isa => "Sask::Dicom::AttributeTag",
    coerce => 1,
    required => 1,
    ;

has "value" =>
    is => "rw",
    ;

1;

__DATA__

Is this a role?

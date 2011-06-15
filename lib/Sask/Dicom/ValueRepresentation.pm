package Sask::Dicom::ValueRepresentation;
use Mouse;
use Mouse::Util::TypeConstraints;

enum "VR" => qw( AE AS AT CS DA DS DT FL FD IS LO LT OB OF OW OX PN SH
                 SL SQ SS ST TM UI UL UN US UT XS XO );

subtype "AE"
    => as "Str"
    => where { /\A\h+[A-Z]\h+/ and 16 >= length };

has "code" =>
    is => "ro",
    isa => "VR",
    required => 1,
    ;

has "size" =>
    is => "ro",
    ;

1;

__DATA__
DICOM Value Representation Codes
http://medical.nema.org/dicom/2004/04_05PU.PDF p25
http://idlastro.gsfc.nasa.gov/idl_html_help/Value_Representations.html
http://johnpella.com/DICOM_VR_Codes.htm

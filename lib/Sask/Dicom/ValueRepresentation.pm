package Sask::Dicom::ValueRepresentation;
use Mouse;
use Mouse::Util::TypeConstraints;

use Sub::Exporter -setup => { exports => [qw(  vr )] };

sub vr {
    __PACKAGE__->new({ code => +shift });
}

use overload q{""} => sub { +shift->code }, fallback => 1;

sub _trim {
    $_[0] =~ y/\000//d;
    $_[0] =~ s/\A\s+//;
    $_[0] =~ s/\s+\z//;
}
sub _pad_string { $_[0] .= " " if length % 2 }
sub _pad_bytes { $_[0] .= "\0" if length % 2 }

our %VR = (
    AE => {
        type => "Str",
        name => "Application Entity",
        validation => sub { length($_) <= 16 and /\A[\x20-\x7E]+\z/ and /[\x21-\x7E]/ },
        inflate => \&_trim,
        deflate => \&_pad_string,
    },
    AS => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    AT => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    CS => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    DA => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    DS => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    DT => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    FL => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    FD => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    IS => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    LO => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    LT => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    OB => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
        two_and_four => 1,
    },
    OF => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    OW => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
        two_and_four => 1,
    },
    OX => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    PN => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    SH => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    SL => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    SQ => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
        two_and_four => 1,
    },
    SS => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    ST => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    TM => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    UI => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    UL => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    UN => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    US => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
        two_and_four => 1,
    },
    UT => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
        two_and_four => 1,
    },
    XS => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    },
    XO => {
        type => "",
        name => "",
        validation => sub {  },
        coercion => sub { },
    }
    );

enum "VRcode" => keys %VR;

subtype "AE"
    => as "Str"
    => where { /\A\h+[A-Z]\h+/ and 16 >= length };

has "code" =>
    is => "ro",
    isa => "VRcode",
    required => 1,
    ;

has "size" =>
    is => "ro",
    ;

sub fml {
    $VR{+shift->code}{two_and_four};
}

1;

__DATA__
DICOM Value Representation Codes
http://medical.nema.org/dicom/2004/04_05PU.PDF p25
http://idlastro.gsfc.nasa.gov/idl_html_help/Value_Representations.html
http://johnpella.com/DICOM_VR_Codes.htm

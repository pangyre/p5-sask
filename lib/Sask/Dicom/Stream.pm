package Sask::Dicom::Stream;
use Mouse;
use autodie;
use IO::Handle;
use IO::String;
use Carp;

use Sask::Dicom::ValueRepresentation "vr";

# Coerce from string/filehandle?
has "io" =>
    is => "ro",
    isa => "FileHandle", # |IO::String|IO::Handle",
    required => 1,
#?    lazy => 1,
    handles => [qw( sysseek sysread )],
    trigger => sub { binmode +shift->{io}, ":bytes" },
    ;

# ???
has "mode" =>
    is => "ro",
    isa => "Str",
    required => 1,
    default => sub { "read" }, # write
    ;

has "implicit" =>
    is => "ro",
    isa => "Bool",
    predicate => "has_implicit",
    init_arg => undef,
    writer => "set_implicit",
    ;

has "endianness" =>
    is => "ro",
    isa => "Str",
    writer => "set_endianness",
    ;

# Make it croak if it's not there yet.
sub implicit_vr {
    my $self = shift;
    croak "Meta information has not been read"
        unless $self->has_implicit;
    $self->implicit;
}
sub explicit_vr {
    ! +shift->implicit_vr;
}

#sub BUILDARGS {
#    my $class = shift;
#}

sub read_meta_information {
    my $self = shift;
    sysseek($self->io,128,0);
    my $buf;
    sysread($self->io, $buf, 4) == 4 or die "Couldn't seek to end of header";
    $buf eq "DICM" or croak "Not a recognizable DICOM file...";

    $self->io->sysread($buf,2) == 2 or die;

    my $endian = unpack("v",$buf) == 2 ?
        "little" : unpack("n",$buf) == 2 ?
            "big" : croak "No endianness could be determined";
    $self->set_endianness($endian);

    my $us_template = $endian eq "little" ? "v" : "n";
    my $ul_template = $endian eq "little" ? "V" : "N";

    sysseek($self->io,-2,1); # Rewind for symmetric parsing.

    my $i;
    while ( $self->io->sysread($buf,6) )
    {
        my ( $group, $element, $vr ) = unpack "${us_template}2 A2", $buf;
        $vr = eval { vr($vr) };
        printf("%04x,%04x VR:%s\n",
               $group, $element, $vr);

        my $length;
        if ( $vr->fml )
        {
            $self->io->sysread($buf,2); # Reserved, toss. seek instead?
            $self->io->sysread($buf,4);
            $length = unpack $ul_template, $buf;
        }
        else
        {
            $self->io->sysread($buf,2);
            $length = unpack $us_template, $buf;
        }
        printf("length -> %s\n", $length);
        $self->io->sysread($buf,$length);
        print "skipping..." and next if $length > 100;
# $vr->fml or $length > 100;
        my $value = unpack "A*", $buf;
        $value =~ s/[^[:print:]+]//g;
        printf(" value -> %s\n", $value);
    }
}

1;

__DATA__
Need to be able to read blocks, SQs, sizes, pixel data only, skip
pixel data, iterate on tags, et cetera.

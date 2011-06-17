package Sask::Dicom::Stream;
use Mouse;
use autodie;
use IO::Handle;
use IO::String;
use Carp;
# Coerce from string/filehandle?
has "io" =>
    is => "ro",
    isa => "FileHandle", # |IO::String|IO::Handle",
    required => 1,
#?    lazy => 1,
    handles => [qw( sysseek sysread )],
    ;

after "io" => sub {
    binmode +shift->{io}, ":bytes";
};

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
}


1;

__DATA__
Need to be able to read blocks, SQs, sizes, pixel data only, skip
pixel data, iterate on tags, et cetera.


my $us_template = $endian eq "LITTLE" ? "v" : "n";
my $ul_template = $endian eq "LITTLE" ? "V" : "N";

print "Endianness: $endian";

printf("%04x,", unpack $us_template, $buf);
$self->io->sysread($buf,2) == 2 or die;
printf("%04x ", unpack $us_template, $buf);

$self->io->sysread($buf,2);
printf("VR:%s ", $buf);
$self->io->sysread($buf,2) or die; # What is this block?
printf("%s ", unpack $us_template, $buf);

$self->io->sysread($buf,4) or die;
printf("%s\n", unpack($ul_template, $buf));

# sysseek($self->io,unpack($ul_template, $buf),0);

my %FML = map { $_ => 1 } qw( OB OW OF SQ UT UN );

my $i;
while ( $self->io->sysread($buf,6) )
{
   my ( $group, $element, $vr ) = unpack "${us_template}2 A2",
   $buf;
   printf("%04x,%04x VR:%s\n",
          $group, $element, $vr);


   my $length;
   if ( $FML{$vr} )
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
   printf(" value -> %s\n", unpack "A*", $buf);
}

exit 0;

__DATA__

1.2.840.10008.5.1.4.1.1.6.1

(0002,0000) UL 248                                      #   4, 1
FileMetaInformationGroupLength
(0002,0001) OB 00\01                                    #   2, 1
FileMetaInformationVersion
(0002,0002) UI =UltrasoundImageStorage                  #  28, 1
MediaStorageSOPClassUID
(0002,0003) UI [1.2.840.113711.999999.333.1047496473.1.1] #  40, 1
MediaStorageSOPInstanceUID

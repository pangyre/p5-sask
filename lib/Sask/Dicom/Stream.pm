package Sask::Dicom::Stream;
use Mouse;
use autodie;
use IO::Handle;
use IO::String;
use Carp;
# Coerce from string/filehandle?
has "io" =>
    is => "ro",
    isa => "FileHandle|IO::String|IO::Handle",
    required => 1,
#    lazy => 1,
#    handles => 
    ;


1;

__DATA__

Need to be able to read blocks, SQs, sizes, pixel data only, skip
pixel data, iterate on tags, et cetera.

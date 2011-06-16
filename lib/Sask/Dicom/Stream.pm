package Sask::Dicom::Stream;
use warnings;
use strict;
use autodie;
use IO::Handle;
use IO::String;
use Carp;



1;

__DATA__

Need to be able to read blocks, SQs, sizes, pixel data only, skip
pixel data, iterate on tags, et cetera.

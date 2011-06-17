#!/usr/bin/env perl
use warnings;
use strict;
use Test::Fatal;
use Test::More;
BEGIN { use_ok("Sask::Dicom::Stream") }

isnt( exception { Sask::Dicom::Stream->new }, undef,
      "Sask::Dicom::Stream->new, no args, gives exception");

done_testing();

__DATA__

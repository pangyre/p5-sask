package Sask::Dicom::AttributeTag;
use Mouse;
use Mouse::Util::TypeConstraints;
use Data::Dump ();

# These are just guesses and are missing some cross validation.
subtype "GroupInt"
    => as "Int"
    => where { $_ >= 2 and $_ <= 0xffff };

subtype "ElementInt"
    => as "Int"
    => where { $_ >= 0 and $_ <= 0xffff };

use overload q{""} => sub { +shift->tag }, fallback => 1;

sub BUILDARGS {
    my $class = shift;
    my %arg = @_ == 1 ? %{ $_[0] } :                     # hashref
        @_ == 2 ? ( group => $_[0], element => $_[1] ) : # ordered list
        @_ == 4 ? @_ :                                   # hash
        confess "Bad arguments to new: ", Data::Dump::dump(@_);
    $_ = hex($_) for values %arg;
    \%arg;
}

sub tag {
    sprintf("%04X,%04X", $_[0]->group, $_[0]->element);
}

has "name" =>
    is => "ro",
    isa => "CamelString",
    ;

has "group" =>
    is => "ro",
    isa => "GroupInt",
    required => 1,
    ;

has "element" =>
    is => "ro",
    isa => "ElementInt",
    required => 1,
    ;

1;

__DATA__

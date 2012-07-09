package TAP::Runner::Option;
# ABSTRACT: Option object
use Moose;
use Moose::Util::TypeConstraints;

subtype 'ArrayRef::' . __PACKAGE__,
    as 'ArrayRef[' . __PACKAGE__ . ']';

coerce 'ArrayRef::' . __PACKAGE__,
    from 'ArrayRef[HashRef]',
    via { [ map { __PACKAGE__->new($_) } @{$_} ] };

has name          => (
    is            => 'ro',
    isa           => 'Str',
    required      => 1,
);

has values        => (
    is            => 'ro',
    isa           => 'ArrayRef',
    lazy_build    => 1,
);

has multiple      => (
    is            => 'ro',
    isa           => 'Bool',
    default       => 0,
);

# Build array used for cartesian multiplication
# Example: [ [ opt_name, opt_val1 ], [ opt_name1, opt_val2 ] ]
sub get_values_array {
    my $self = shift;

    [ map { [ $self->name, $_ ] } @{ $self->values } ];
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;



=pod

=head1 NAME

TAP::Runner::Option - Option object

=head1 VERSION

version 0.002

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 ATTRIBUTES

=head1 AUTHOR

Pavel R3VoLuT1OneR Zhytomirsky <r3volut1oner@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Pavel R3VoLuT1OneR Zhytomirsky.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__


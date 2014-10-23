package TAP::Runner;
# ABSTRACT: Running tests with options
use Moose;
use Carp;
use TAP::Runner::Test;

has harness_class => (
    is            => 'rw',
    isa           => 'Str',
    default       => 'TAP::Harness',);

has harness_formatter => (
    is            => 'rw',
    predicate     => 'has_custom_formatter',
);

has harness_args  => (
    is            => 'rw',
    isa           => 'HashRef',
    default       => sub{ {} },
);

has tests         => (
    is            => 'rw',
    isa           => 'ArrayRef::TAP::Runner::Test',
    coerce        => 1,
    required      => 1,
);

sub run {
    my $self          = shift;
    my $harness_class = $self->harness_class;
    my $harness_args  = $self->_get_harness_args;
    my @harness_tests = $self->_get_harness_tests;

    # Load harness class
    eval "require $harness_class";
    croak "Can't load $harness_class" if $@;

    my $harness = $harness_class->new( $harness_args );

    # Custom formatter
    $harness->formatter( $self->harness_formatter )
        if $self->has_custom_formatter;

    $harness->runtests( @harness_tests );
}

# Harness args with building test arguments
sub _get_harness_args {
    my $self      = shift;

    # Build tests args hash ref
    $self->harness_args->{test_args} = {
        map { ( $_->{alias}, $_->{args} ) }
        map { @{ $_->harness_tests }      } @{ $self->tests } };

    $self->harness_args;
}

# Return array of tests to run with it aliases
sub _get_harness_tests {
    my $self  = shift;

    map { [ $_->{file}, $_->{alias} ] }
    map { @{ $_->harness_tests }      } @{ $self->tests };
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;



=pod

=head1 NAME

TAP::Runner - Running tests with options

=head1 VERSION

version 0.003

=head1 SYNOPSIS

    #!/usr/bin/perl
    use strict;
    use warnings;

    use TAP::Runner;
    use TAP::Formatter::HTML;

    TAP::Runner->new(
        {
            # harness_class => 'TAP::Harness::JUnit',
            # harness_formatter => TAP::Formatter::HTML->new,
            harness_args => {
                rules => {
                    par => [
                        { seq => qr/^Test alias 2.*$/  },
                        { seq => '*' },
                    ],
                },
                jobs  => 4,
            },
            tests => [
                {
                    file    => 't/examples/test.t',
                    alias   => 'Test alias',
                    args    => [
                        '--option', 'option_value_1'
                    ],
                    options => [
                        {
                            name   => '--server',
                            values => [
                                'first.local',
                                'second.local',
                            ],
                            multiple => 0,
                        },
                        {
                            name   => '--browser',
                            values => [
                                'firefox',
                                'chrome',
                            ],
                            multiple => 1,
                        },
                    ],
                },
                {
                    file    => 't/examples/test2.t',
                    alias   => 'Test alias 2',
                    args    => [
                        '--option', 'option_value_1'
                    ],
                },
                {
                    file    => 't/examples/test2.t',
                    alias   => 'Test alias 22',
                    args    => [
                        '--option', 'option_value_2'
                    ],
                },
            ],
        }
    )->run;

=head1 DESCRIPTION

This module allows to run tests more flexible. Allows to use TAP::Harness, not just for unit tests.

=head1 METHODS

=head2 new

Create a new L<TAP::Runner> object. tests atribute required

    # Tests to run with runner
    my @tests  = ( { file => 't/test.t' } );

    # Tests auto coerce to L<TAP::Runner::Test>
    my $runner = TAP::Runner->new(
        tests => \@tests,
    );

=head2 run

Run all the tests

=head1 ATTRIBUTES

=head2 harness_class

Harness class to use for run tests

=head2 harness_formatter

Custom harness formatter

=head2 harness_args

More arguments that can be provided to harness object

=head2 tests

Test configuration to run

=head1 AUTHOR

Pavel R3VoLuT1OneR Zhytomirsky <r3volut1oner@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Pavel R3VoLuT1OneR Zhytomirsky.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__


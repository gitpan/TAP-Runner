#!/usr/bin/perl
use strict;
use warnings;

use TAP::Runner;
use TAP::Formatter::HTML;

TAP::Runner->new(
    {
        # harness_class => 'TAP::Harness::JUnit',
        harness_formatter => TAP::Formatter::HTML->new,
        harness_args => {
            rules => {
                par => [
                    { seq => qr/^Test alias$/ },
                    { seq => qr/^Test alias 2.*$/  },
                ],
            },
            jobs  => 2,
        },
        tests => [
            {
                file    => 't/test.t',
                alias   => 'Test alias',
                args    => [
                    '-s', 't/etc/test_server'
                ],
                # options => {
                #     '-w' => [
                #         'first opt',
                #         'second opt',
                #     ],
                #     '-r' => [
                #         'test2',
                #         'test44',
                #     ],
                #},
            },
            {
                file    => 't/test2.t',
                alias   => 'Test alias 2',
                args    => [
                    '-s', 't/etc/test_server'
                ],
            },
            {
                file    => 't/test2.t',
                alias   => 'Test alias 22',
                args    => [
                    '-s', 't/etc/test_server'
                ],
            },
        ],
    }
)->run;

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Catalyst::Authentication::AuthTkt',
    AUTHOR              => 'Peter Karman <karman at cpan dot org>',
    VERSION_FROM        => 'lib/Catalyst/Authentication/AuthTkt.pm',
    ABSTRACT_FROM       => 'lib/Catalyst/Authentication/AuthTkt.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Catalyst' => 5.7014,
        'Apache::AuthTkt'   => 0.08,
        'Catalyst::Plugin::Authentication' => 0.10007,
        'Data::Dump' => 0,   # for testing
        'Config::General' => 0, # for testing
        'Catalyst::Plugin::Static::Simple' => 0, # for testing
        'Catalyst::Plugin::ConfigLoader'   => 0, # for testing
        'Catalyst::Plugin::Session'        => 0,
        'Catalyst::Plugin::Session::Store::Dummy' => 0,
        'Catalyst::Plugin::Session::State::Cookie' => 0,
        'Moose' => 0,

    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Catalyst-Authentication-AuthTkt-*' },
);

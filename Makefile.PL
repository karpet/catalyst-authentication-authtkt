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
        'Catalyst::Runtime' => 0,
        'Apache::AuthTkt'   => 0.08,
        'Catalyst::Plugin::Authentication' => 0.11000,


    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Catalyst-Authentication-AuthTkt-*' },
);

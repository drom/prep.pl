use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'prep.pl',
    PREREQ_PM => {
        'Getopt::Declare' => 0,
        'JSON'            => 0,
        'Hash::Merge'     => 0
    }
);
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME            => 'App::EMuLicStatus',
  AUTHOR          => 'Will Aoki <waoki@umnh.utah.edu>',
  VERSION         => 0.2,
  ABSTRACT        => 'Chart EMu license usage',
  PREREQ_PM       => {
                      'Getopt::Long' => 0,
                      'RRDTool::OO' => 0,
                     },
  TEST_REQUIRES   => {
                      'Test::Exception' => 0,
                      'Test::Output' => 0,
                     },
  EXE_FILES       => ['licstatus'],
);


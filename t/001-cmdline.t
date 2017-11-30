use Test::More;
use strict;
use warnings;
use Test::Exception;
use Test::Output;

require_ok './licstatus';

dies_ok {parse_args('a')} 'Detects wrong ref type for $config';

subtest 'No arguments' => sub {
  plan tests => 2;
  my $config = {};
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config)}, qr/Usage: /, 'Prints usage');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'RRD with default mode' => sub {
  plan tests => 7;
  my $config = {};
  $config->{'mode'} = 'init';
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'init', 'Default 1 correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');

  $config = {};
  $config->{'mode'} = 'graph';
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--graph-to', '/tmp/graph.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'graph', 'Default 2 correct');
};

subtest 'Mode init ok' => sub {
  plan tests => 4;
  my $config = {};
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'init')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'init', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
};

subtest 'Invalid mode rejected' => sub {
  plan tests => 2;
  my $config = {};
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'blah')}, qr/mode not defined/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'Mode graph output enforced' => sub {
  plan tests => 2;
  my $config = {};
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph')}, qr/[Ff]ile not specified/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'Mode graph ok' => sub {
  plan tests => 5;
  my $config = {};
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-to', '/tmp/asdf.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'graph', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
  is($config->{'graphto'}, '/tmp/asdf.png');
};

subtest 'Mode acquire path missing' => sub {
  plan tests => 2;
  my $config = {};
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire')}, qr/No EMu installation/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'Mode acquire path invalid' => sub {
  plan tests => 2;
  my $config = {};
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire', '--emupath', 't/notemupath')}, qr/No EMu installation/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'Mode acquire ok' => sub {
  plan tests => 5;
  my $config = {};
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire', '--emupath', 't/emupath')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'acquire', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
  is($config->{'emupath'}, 't/emupath');
};


done_testing();

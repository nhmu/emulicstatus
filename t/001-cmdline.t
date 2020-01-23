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

subtest 'Default mode honored' => sub {
  plan tests => 7;
  my $config = {};
  $config->{'mode'} = 'init';
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'init', 'Mode correctly set when default is init');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');

  $config = {};
  $config->{'mode'} = 'graph';
  $config->{'graphdays'} = '1';
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--graph-to', '/tmp/graph.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'graph', 'Mode correctly set when default is graph');
};

subtest 'Mode "init" correct usage' => sub {
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

subtest 'Mode "graph" output file required' => sub {
  plan tests => 2;
  my $config = {};
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph')}, qr/[Ff]ile not specified/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'Mode "graph" honors graph-days default' => sub {
  plan tests => 6;

  my $config = {};
  my $ret;
  $config->{'graphdays'} = 1;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-to', '/tmp/graph.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'graphdays'}, 1, 'Correct default read');

  $config = {};
  $config->{'graphdays'} = 7;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-to', '/tmp/graph.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'graphdays'}, 7, 'Correct default read');
};

subtest 'Mode "graph" correct usage, days not specified' => sub {
  plan tests => 6;
  my $config = {};
  $config->{'graphdays'} = 1;
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-to', '/tmp/asdf.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'graph', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
  is($config->{'graphto'}, '/tmp/asdf.png', 'Correct output path parsed');
  is($config->{'graphdays'}, 1, 'Correct default read');
};

subtest 'Mode "graph" correct usage, days specified' => sub {
  plan tests => 6;
  my $config = {};
  $config->{'graphdays'} = 1;
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-days', '14', '--graph-to', '/tmp/asdf.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'graph', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
  is($config->{'graphto'}, '/tmp/asdf.png', 'Correct output path parsed');
  is($config->{'graphdays'}, 14, 'Graph days parsed');
};

subtest 'Mode "graph" correct usage, partial days specified' => sub {
  plan tests => 9;
  my $config = {};
  $config->{'graphdays'} = 1;
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-days', '8.5', '--graph-to', '/tmp/asdf.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'graph', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
  is($config->{'graphto'}, '/tmp/asdf.png', 'Correct output path parsed');
  is($config->{'graphdays'}, 8.5, 'Graph days parsed, 8.5');


  $config->{'graphdays'} = 1;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-days', '0.1', '--graph-to', '/tmp/asdf.png')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'graphdays'}, 0.1, 'Graph days parsed, 0.1');
};

subtest 'Mode "graph" rejects invalid days' => sub {
  plan tests => 9;
  my $config = {};
  $config->{'graphdays'} = 1;
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-days', '-5', '--graph-to', '/tmp/asdf.png')}, qr/greater than zero/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
  is($config->{'graphdays'}, -5, 'Negative graph days parsed');

  $config = {graphdays => 1};
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-days', '0', '--graph-to', '/tmp/asdf.png')}, qr/greater than zero/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
  is($config->{'graphdays'}, 0, 'Zero graph days parsed');


  $config = {graphdays => 1};
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'graph', '--graph-days', '-0.1', '--graph-to', '/tmp/asdf.png')}, qr/greater than zero/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
  is($config->{'graphdays'}, -0.1, 'Negative partial graph days parsed');
};

subtest 'Mode "acquire" requies a path to an EMu installation' => sub {
  plan tests => 2;
  my $config = {};
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire')}, qr/No EMu installation/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'Mode "acquire" honors default path for EMu installation' => sub {
  plan tests => 3;
  my $config = {};
  $config->{'emupath'} = 't/notemupath';
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire')}, qr/No EMu installation/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
  is($config->{'emupath'}, 't/notemupath', 'EMu path read');
};

subtest 'Mode "acquire" fails with no acutal EMu installation' => sub {
  plan tests => 2;
  my $config = {};
  $config->{'emupath'} = 't/notemupath';
  my $ret;
  combined_like(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire', '--emupath', 't/notemupath')}, qr/No EMu installation/, 'Correct error');
  is($ret, 0, 'Invalid parse reported');
};

subtest 'Mode "acquire" correct usage, EMu path not specified' => sub {
  plan tests => 5;
  my $config = {};
  $config->{'emupath'} = 't/emupath';
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'acquire', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
  is($config->{'emupath'}, 't/emupath');
};

subtest 'Mode "acquire" correct usage, EMu path specified' => sub {
  plan tests => 5;
  my $config = {};
  $config->{'emupath'} = 't/notemupath';
  my $ret;
  combined_is(sub{$ret = App::EMuLicStatus::parse_args($config, '--rrdfile', '/tmp/asdf.rrd', '--mode', 'acquire', '--emupath', 't/emupath')}, '', 'No output');
  is($ret, 1, 'Valid parse reported');
  is($config->{'mode'}, 'acquire', 'Mode correct');
  is($config->{'rrdfile'}, '/tmp/asdf.rrd', 'RRD argument parsed');
  is($config->{'emupath'}, 't/emupath');
};


done_testing();

#!/usr/bin/perl

# Experimental Perl version of the installer. It goes without saying that
# this is a work in progress.

use strict;
use warnings;

use Config::General;
my $conf = Config::General->new(
	-ConfigFile		=> 'installrc',
	-SplitPolicy		=> 'equalsign',
	-InterPolateVars	=> 1
);

# Get all config values and declare them. This will make the rest of the
# code easier to read.
my %config	= $conf->getall;
my $flavour	= $config{'flavour'};
my $variant	= $config{'variant'};
my $components	= $config{'components'};
my $packages	= $config{'packages'};

## Subroutines

# Handle errors
sub error {
	my $err = shift;
	$err	= "Error: $err";

	die("$err\n");
}

# Print message
sub msg {

}

## Actual installer



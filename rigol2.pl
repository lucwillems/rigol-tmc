#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use USBtmc;

my $usbtmc=new USBtmc();
$usbtmc->open("09c4:0400");
$usbtmc->runScript("rigol-test.txt");

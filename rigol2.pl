#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use USBtmc;
my $file="rigol-test.txt";
if ($ARGV[0]) {
   $file=$ARGV[0];
}
my $usbtmc=new USBtmc();
$usbtmc->open("09c4:0400");
$usbtmc->runScript($file);

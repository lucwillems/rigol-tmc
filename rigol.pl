#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use IO::File;
use USBtmc;

my $usbtmc=new USBtmc();
$usbtmc->open("09c4:0400");
print $usbtmc->Query("*IDN?")."\n";
$usbtmc->SendCommand("OUTPut ON");
print "Function: ".$usbtmc->Query("FUNCtion?")."\n";
print "Function: ".$usbtmc->Query("FUNCtion?")."\n";
print "Freq: ".$usbtmc->Query("FREQuency?")."\n";
print "Volt: ".$usbtmc->Query("VOLTage?")."\n";
print "Output: ".$usbtmc->Query("OUTPut?")."\n";
#generate custom data
$usbtmc->SendCommand("FUNC USER");
$usbtmc->SendCommand("FREQ 100000");
$usbtmc->SendCommand("VOLT:UNIT VPP");
$usbtmc->SendCommand("VOLT:HIGH 1");
$usbtmc->SendCommand("VOLT:LOW -1");
$usbtmc->SendCommand("DAC:DATA VOLATILE 8192,16384,8192,0");
$usbtmc->SendCommand("FUNC:USER VOLATILE");
$usbtmc->SendCommand("OUTP ON");
sleep 300;
$usbtmc->SendCommand("OUTPut OFF");


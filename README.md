# rigol-tmc
some scripts to run automated test on rigol USB TMC based equipment

example : program FSK on rigol DG1022. create a text file like this
```
 *IDN?                /* Query ID to check the operating state */
 OUTP OFF
 FUNC SIN             /* Select carrier function*/
 FREQ 10000           /* Set the frequency of carrier*/
 VOLT:UNIT VPP        /* Set the amplitude unit of carrier */
 VOLT 5               /* Set the amplitude of carrier */
 VOLT:OFFS 0          /* Set the offset of carrier */
 FSK:STAT ON          /* Enable FSK function*/
 FSK:SOUR INT         /* Select internal modulation source */
 FSK:FREQ 800         /* Set the hop frequency */
 FSK:INT:RATE 200     /* Set the FSK rate*/
 
 /* Enable the [Output] connector of CH1 at the front panel */
 OUTP ON
```
then run this with this perl script
```
#!/usr/bin/perl

use strict;
use warnings;
use USBtmc;

my $usbtmc=new USBtmc();
$usbtmc->open("09c4:0400");
$usbtmc->runScript("examples/fsk.txt");
```
* the 09c4:0400 is the USB vendor/product id you can find using lsusb
* you must have RW access to the /dev/usbtmc* device file
* Tested on opensuse 13.2 / Linux 3.18.0 kernel
* 

UDEV rules :
---

create this file under /etc/udev/rules.d/99-usbtmc.rules
```
KERNEL=="usbtmc/*",       MODE="0660", GROUP="users"
KERNEL=="usbtmc[0-9]*",   MODE="0660", GROUP="users"
```

TODO :
---
* allot
* add methods for scope handling
* 

package USBtmc;
use strict;
use warnings;
use Fcntl;
use Carp;
use Time::HiRes qw(sleep);

sub new {
    my $class = shift;
    my $self={};
    $self->{command_delay}=".025"; #command delay
    bless $self,$class;
    return $self;
}

sub getDevices() {
  my $self=shift;
  my $devices={};
  my $key;

  foreach my $file (glob("/dev/usbtmc*")) {
    $file =~ /\/dev\/(.*)/;
    open(SYS_FS_HANDLE, "<", "/sys/class/usbmisc/$1/device/uevent");
    while (<SYS_FS_HANDLE>) {
     if (/PRODUCT=([0-9A-Fa-f]+)\/([0-9A-Fa-f]+)\//) {
        $key=sprintf("%04s:%04s",$1,$2);
        $devices->{$key}->{device}=$file;
        last;
     }
   }
   close(SYS_FS_HANDLE);
  }
  return $devices;
}

sub open {
  my $self=shift;
  my $device=shift;
  #did we profide a usb identifier
  if ($device =~ /[0-9A-Fa-f]+\:[0-9A-Fa-f]+/) {
     my $devices=$self->getDevices();
     croak "device $device not found" if (! exists($devices->{$device}));
     $device=$devices->{$device}->{device};
  }
  sysopen($self->{fh},$device,O_RDWR) || croak "unable to open $device: $!";
}

sub SendCommand {
  my $self=shift;
  my $command=shift;

  my $fh=$self->{fh};
  syswrite($fh,"$command\n");
  #it seems we have to wait for some time after each
  #command else, the driver flips and next command fails
  sleep($self->{command_delay});
}

sub runScript {
   my $self=shift;
   my $script=shift;
   my $log=shift||1;
   my @lines;
   #check if script is pointing to a readable file
   if ( -r $script) {
      CORE::open(SCRIPT,$script);
      @lines=<SCRIPT>; 
      close(SCRIPT);
   } else {
      @lines=split("\n",$script)
   }
   foreach my $line (@lines) {
         my $command;
         foreach my $inst (split(" ",$line)) {
             last if ($inst =~ /^\/\*/);
             $command=($command ? $command." ".$inst:$inst);
         }
         if ($command) {
            my $answer="";
            if ($command =~ /.*\?$/) { 
               $answer=$self->Query($command);
            } else {
               $self->SendCommand($command);
            }
            if($log) {
              print "$command";
              print " : $answer" if ($answer);
              print "\n";
            }
         }
      }
}

sub Query {
  my $self=shift;
  my $command=shift;
  my $fh=$self->{fh};
  my $answer;

  $self->SendCommand($command);
  while( (my $len=sysread($fh,$answer,2048))) {
      last unless ($len==2048); 
  }
  chomp $answer;
  return $answer;
}

1;

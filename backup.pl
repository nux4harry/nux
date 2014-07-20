#!/usr/bin/env perl 
#===============================================================================

use strict;
use warnings;
use utf8;

use 5.010;
use File::Copy;
use Parallel::ForkManager;
use POSIX 'strftime';
use Sys::Virt;
use Array::Utils;
my $vmm = Sys::Virt->new(uri => 'qemu:///system');

my $pm = Parallel::ForkManager->new(4);

my @active_vm;

my @domains = $vmm->list_domains();
foreach my $dom (@domains) {
	push @active_vm,$dom->get_name;
	}

#### user enter guest vm name to take backup.
### gather disk info as per vm name
my $dest_dir = '/tmp';
my @vm_disk;
my $date = strftime '%Y-%m-%d', localtime;

# check vm is on or shutdown, if it is on then exit this program.
#

foreach my $e_vm (@active_vm){
		if ($e_vm ~~ @ARGV){
		say "VM is running, please shutdown it and then do backup";
		exit;
	}
}


for my $vm (@ARGV){
	push @vm_disk, `virsh domblklist $vm | grep vda | awk -F ' ' {'print \$2'}`;
}

for my $disk (@vm_disk){
	$disk =~ m/.*\/(.*?)$/;
   # say $1;
}
foreach my $data (@vm_disk) {
     my $pid = $pm->start and next;
		$data =~ m/.*\/(.*?)$/;
		chomp $data;
	  say "Backup is started for $data..................";
	  say "...............";
 	  mkdir "$dest_dir/$1_$date"; 
	   copy $data, "$dest_dir/$1_$date" or die "Error $!";
           $pm->finish; 
	say ".........Finished for $data";
           }
$pm->wait_all_children;


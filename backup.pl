#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: backup.pl
#
#        USAGE: ./backup.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 07/20/2014 10:54:04 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use 5.010;

#### user enter guest vm name to take backup.
### gather disk info as per vm name

my @vm_disk;
for my $vm (@ARGV){
	push @vm_disk, `virsh domblklist $vm | grep vda | awk -F ' ' {'print \$2'}`;
}


for my $disk (@vm_disk){
	$disk =~ m/.*\/(.*?)$/;
    say $1;
}



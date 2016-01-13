#!/usr/bin/env perl
##**************************************************************
##
## Copyright (C) 1990-2011, Condor Team, Computer Sciences Department,
## University of Wisconsin-Madison, WI.
## 
## Licensed under the Apache License, Version 2.0 (the "License"); you
## may not use this file except in compliance with the License.  You may
## obtain a copy of the License at
## 
##    http://www.apache.org/licenses/LICENSE-2.0
## 
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
##**************************************************************


######################################################################
# post script for Condor testsuite runs
######################################################################

use strict;
use warnings;
use File::Basename;

my $dir = dirname($0);
unshift @INC, $dir;
require "TestGlue.pm";
TestGlue::setup_test_environment();

my $BaseDir = $ENV{BASE_DIR} || die "BASE_DIR not in environment!\n";
my $exit_status = 0;

# This is debugging output for the sake of the NWO infrastructure.
# However, it might be useful to us some day so we can see what's
# going on in case of failures...
if( defined $ENV{_NMI_STEP_FAILED} ) { 
    print "The value of _NMI_STEP_FAILED is: '$ENV{_NMI_STEP_FAILED}'\n";
}
else {
    print "The _NMI_STEP_FAILED variable is not set\n";
}


######################################################################
# save and tar up test results
######################################################################

if( ! -f "tasklist.nmi" || -z "tasklist.nmi" ) {
    # our tasklist is empty, so don't do any real work
    print "No tasks in tasklist.nmi, nothing to do\n";
    exit $exit_status;
}

# workaround for socket directoy path too long

# If we use the switch at the top of CondorPersonal
# we will leak folders in /tmp. No one cleans

#my $sd = "SOCKETDIR";
#my $dirname = "";
#if(-f "$sd") {
	###This will not be here for windows
	##don't die on error, we want results tarred up
	#open(SD,"<$sd") or print "Could not read SOCKETDIR:$!\n";
	#$dirname = <SD>;
	#print "Name of socket dir:$dirname\n";
	#chomp($dirname);
	#close(SD);
	#system("rm -r /tmp/$dirname");
#}

print "cding to $BaseDir \n";
chdir("$BaseDir") || die "Can't chdir($BaseDir): $!\n";

#----------------------------------------
# final tar and exit
#----------------------------------------
print "Tarring up all results\n";
chdir("$BaseDir") || die "Can't chdir($BaseDir): $!\n";
my $test_dir = File::Spec->catdir($BaseDir, "condor_tests");
#system("tar zcf results.tar.gz --exclude *.exe $test_dir local");
system("tar zcf results.tar.gz --exclude=results.tar.gz *");

exit $exit_status;

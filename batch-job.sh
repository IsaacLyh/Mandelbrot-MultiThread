#!/bin/bash
# This script is intepreted by the Bourne Shell, sh
#
# Documentation for SGE is found in:
# http://docs.oracle.com/cd/E19279-01/820-3257-12/n1ge.html
#
# Tell SGE which shell to run the job script in rather than depending
# on SGE to try and figure it out.
#$ -S /bin/bash
#
# Export all my environment variables to the job
#$ -V
# Tun the job in the same directory from which you submitted it
#$ -cwd
#
# Give a name to the job
#$ -N MDB
#
# Specify a time limit for the job
#$ -l h_rt=00:10:00
#
# Join stdout and stderr so they are reported in job output file
#$ -j y
#
# Run on the debug queue; only one node may be used
# To use more than one node, specify the "normal" queue
#$ -q debug.q
#
# Specifies the circumstances under which mail is to be sent to the job owner
# defined by -M option. For example, options "bea" cause mail to be sent at the 
# begining, end, and at abort time (if it happens) of the job.
# Option "n" means no mail will be sent.
#$ -m a
#
# *** Change to the address you want the notification sent to, and
# *** REMOVE the blank between the # and the $
# $ -M someone@ucsd.edu
#

# Change to the directory where the job was submitted from
cd $SGE_O_WORKDIR

echo
echo " *** Current working directory"
pwd
echo
echo " *** Compiler"
# Output which  compiler are we using and the environment
gcc -v
echo
echo " *** Environment"
printenv

echo

echo ">>> Job Starts"
date

ls .
# Commands go here



# Strong scaling
echo "Strong scalling (3)"
./mdb -t 1
./mdb -t 2
./mdb -t 4
./mdb -t 8

# Chunk size Sweep for sweet spot (5)
echo "Chunk size Sweep"
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 8 -c 1
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 8 -c 2
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 8 -c 4
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 8 -c 8


# Block vs Cyclic (6)
echo "Block vs Cyclic"
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 1
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 2 -c 0
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 2 -c 1
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 4 -c 0
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 4 -c 1
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 8 -c 0
./mdb -x 128 -y 128 -i 100 -b -2.500000 -0.750000 0.000000 1.000000  -t 8 -c 1



date
echo ">>> Job Ends"

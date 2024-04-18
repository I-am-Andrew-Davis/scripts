#!/bin/bash
# Creator:     Andrew Davis

#Email:        gtv6bk@virginia.edu

#Last Updated: 10/13/2023

#Purpose:      Touches all files in a users scratch directory
#              on the Rivanna computing cluster

#Use:          Update variable CID to your computing ID, 
#              if you want to output all of the files and 
#              directories touched, give the -o flag.
#              The resulting file sizes should be on the order of 10s of MB

#computing ID: 
CID=gtv6bk

#Dont change me
#touch files: 
find /scratch/$CID -type f -exec touch {} +
#touch directories:
find /scratch/$CID -type d -exec touch {} +

while getopts 'o' OPTION; do 
	case "$OPTION" in 
	o)
		find /scratch/$CID -type f > files_touched.log
		find /scratch/$CID -type d > dirs_touched.log
	esac
done
	


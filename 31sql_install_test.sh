#!/bin/bash
# read file and create INSERT statements for MySQL
# $1 read file is .csv
outfile='members.sql'
IFS=','	#read , split 
while read lname fname address city state zip
do
 #cat >> $outfile << EOF
 echo "INSERT INTO members (lname,fname,address,city,state,zip) VALUES
('$lname', '$fname', '$address', '$city', '$state', '$zip');"
#EOF
done < ${1}

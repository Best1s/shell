#!/usr/bin/python
# -*- coding: utf-8 -*-
import socket
import sys
import os
def nslookup_file(file):
	with open(file,'r') as f:
		lines = f.readlines()
		print lines
		last_line=lines[-1].strip('\n')
		print file + ' ip is:    ',
		for line in lines:
		    line=line.strip('\n')
		    try:
				if line == last_line:
					print ('\b' + socket.gethostbyname(line))
				else:
					print ('\b' + socket.gethostbyname(line) + ','),
		    except Exception:
			    print "dns error",    
		f.close()
def nslookup_realm_name(name):
	print name,' ip is:    ',
	try:
		print '\b' + socket.gethostbyname(name)
	except Exception:
		print "dns error",


if __name__ == '__main__':
    for i in range(1,len(sys.argv)):
	if os.path.isfile(sys.argv[i]):
		nslookup_file(sys.argv[i])
	else:
		nslookup_realm_name(sys.argv[i])

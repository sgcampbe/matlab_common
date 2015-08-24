#!/usr/bin/python

# This little script takes a command line arguement (a .eps file) and calls
# the linux package pstopdf to convert the figure to a .pdf file.  It 
# can be called from MATLAB scripts too.

# An optional second arguement is where to put the file and what to name it.
# Usage:
# python eps2pdf.py test.eps pdfversions/test.pdf

import sys
import os

input = sys.argv[1]

if len(sys.argv) > 2:
	output = sys.argv[2]
else:
	output = input.strip('.eps') + '.pdf'

print 'Input: %s'%input
print 'Output: %s'%output


os.system('pstopdf %s -o %s'%(input, output))

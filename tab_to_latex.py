# Script to convert tab-delimited text files into LaTeX table mark-up
# Guts of this script were written by Fred Lionetti.
# Accepts command-line args for source and destination files

import os
import sys

input = sys.argv[1]

if len(sys.argv) > 2:
    file = sys.argv[2]
    fstr = file.split('.')[0]
else:
    fstr = input.split('.')[0]
    
if len(sys.argv) > 3:   # If there's also a table caption
    tabcaption = sys.argv[3]
else:
    tabcaption = ''

if len(sys.argv) > 4:	# If there's also a specification of the number of header columns (default is 2)
    numhlines = sys.argv[4]
else:
    numhlines = 2

# Read in file
f = open(input, "r")
lines = f.readlines()
numcols = len(lines[0].split("\t"))

# Open file for writing
fout = open(fstr + '.tex', 'w')

# Set up sizes
sizes    = 'c' * (numcols)

fout.write( r"""
\begin{table}\caption{%s}\label{table:%s}
    \begin{center}
        \begin{tabular}{%s}
        \hline\hline"""%(tabcaption,fstr, sizes))



for i,line in enumerate(lines):
    #print line,
    line = line.replace("%","\%")
    line = line.replace("\t", "&")
    line = line.replace('"', "")
    line = line.strip()

    pieces = line.split("&")
    pieces = pieces[:len(sizes)]
    pieces2 = []
    for p in pieces:
       #~ if "." in p:
          #~ p = str(round(float(p), 2))
       pieces2.append(p)
    line = " & ".join(pieces2)
    #print line.split("&")
    line = line + r" \\"
    if (i == int(numhlines) - 1):    # Place line after header labels (first two rows)
        line = line + r" \hline"
    fout.write( "    " + line)

fout.write( r"""    \hline
        \end{tabular}
    \end{center}
\end{table}
""")

fout.close()

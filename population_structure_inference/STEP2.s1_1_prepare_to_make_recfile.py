#!/usr/bin/env python

import os
import sys

script = "STEP2.s1_2_make_refeile.sh" 
program = "/yourpath/fs-2.0.7/scripts/makeuniformrecfile.pl"

with open(script, "w") as f:
    for ffile in os.listdir("."):
        if ffile.endswith(".phase") and ffile.startswith("bialle_SNP.ref_"):
	    phasefile = ffile
	    recfile = ffile.replace(".phase", ".recfile")
	    f.write("%s %s %s\n" % (program, phasefile, recfile))
os.system("chmod +x %s" % script)	

import sys
import time
import biotite.structure.io.pdb as pdb
import biotite.structure as bst
from math import sqrt

file = pdb.PDBFile()
file.read("1ake.pdb")
st = file.get_structure()
st2 = file.get_structure()

for x in st.coord:
    x[0] += 1/sqrt(3)
    x[1] += 1/sqrt(3)
    x[2] += 1/sqrt(3)
run = 0.0
for i in range(1000):
    start = time.time()
    bst.rmsd(st.coord.reshape(-1,3), st2.coord.reshape(-1,3))
    end = time.time()
    run += end-start

print(run/1000)

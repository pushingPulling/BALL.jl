import time
import MDAnalysis as mda
import MDAnalysis.analysis.rms
from math import sqrt
pdb_filepath = "1ake.pdb"
u = mda.Universe(pdb_filepath)
u2 = mda.Universe(pdb_filepath)

for x in u.select_atoms('all'):
    x.position = [x.position[0]+1/sqrt(3), x.position[1]+1/sqrt(3), x.position[2]+1/sqrt(3)]

start = time.time()
R = mda.analysis.rms.RMSD(u,u2)
end = time.time()
print(end-start)

run = 0.0
for x in range(100):
    start = time.time()
    R = mda.analysis.rms.RMSD(u, u2)
    R.run()
    end = time.time()
    run += end-start
print(run/100)

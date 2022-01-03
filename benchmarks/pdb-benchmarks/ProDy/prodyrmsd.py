import time
from prody import *
from math import sqrt

pdb_filepath = "1ake.pdb"
struc = parsePDB(pdb_filepath)
struc2 = parsePDB(pdb_filepath)

for x in struc2:
    temp = x.getCoords()
    x.setCoords((temp[0] + 1 / sqrt(3), temp[1] + 1 / sqrt(3), temp[2] + 1 / sqrt(3)))


run = 0.0

for x in range(10000):
    start = time.time()
    calcRMSD(struc,struc2)
    end= time.time()
    run += end-start

print(run/10000)

start = time.time()
calcRMSD(struc,struc2)
end = time.time()
print(end-start)

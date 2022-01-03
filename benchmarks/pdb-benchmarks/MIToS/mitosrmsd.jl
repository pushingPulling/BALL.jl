using MIToS.PDB
using BenchmarkTools
pdb_filepath = "1ake.pdb"
struc = read(pdb_filepath, PDBFile)
struc2 = read(pdb_filepath, PDBFile)


@show rmsd(struc,struc2,superimposed=true)

@show @benchmark rmsd(struc,struc2,superimposed=true)


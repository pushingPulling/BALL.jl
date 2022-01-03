# Benchmark the parsing of a PDB file given as an argument

using BioStructures

pdb_filepath = "1crn.pdb"

# Run to JIT compile
read(pdb_filepath, PDB)

elapsed = @elapsed struc = read(pdb_filepath, PDB)

println(elapsed)

push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL
using BenchmarkTools

pdb_filepath = "/mnt/g/Python Programme/BALL.jl/1,2-Benzodiazepine.pdb"

comp = System(pdb_filepath)
comp = DataFrameSystem(comp)

print(@benchmark SSSR(comp))

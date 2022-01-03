#=
countDfs:
- Julia version: 
- Author: Dan
- Date: 2021-11-28
=#

push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL
using BenchmarkTools

pdb_filepath = "1AKE.pdb"

comp = System(pdb_filepath)
dfs = DataFrameSystem(comp)

function countDfs()
    length(filter(x -> x == "ALA", dfs.residues.name_))
end


countDfs()

elapsed = @elapsed countDfs()
@show @benchmark countDfs()
println(elapsed)

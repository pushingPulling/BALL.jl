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


function distanceDfs()
    return distance(@view(dfs.residues[50,:]), @view(dfs.residues[60,:]))
end

distanceDfs()

elapsed = @elapsed distanceDfs()
println(elapsed)
@show @benchmark distanceDfs()

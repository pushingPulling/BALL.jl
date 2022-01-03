#=
countDfs:
- Julia version:
- Author: Dan
- Date: 2021-11-28
=#

push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL
using BenchmarkTools
using StatProfilerHTML

pdb_filepath = "1AKE.pdb"

comp = System(pdb_filepath)
dfs = DataFrameSystem(comp)


@profilehtml ramachandranangles(dfs)

elapsed = @elapsed ramachandranangles(dfs)

println(elapsed)
@show @benchmark ramachandranangles(dfs)


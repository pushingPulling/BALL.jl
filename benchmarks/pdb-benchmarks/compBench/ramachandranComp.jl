#=
ramachandranComp:
- Julia version: 
- Author: Dan
- Date: 2021-11-28
=#

push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL
using BenchmarkTools

pdb_filepath = "1AKE.pdb"

comp = System(pdb_filepath)

ramachandranangles(comp)

elapsed = @elapsed ramachandranangles(comp)

println(elapsed)
@show @benchmark ramachandranangles(comp)

#=
parseBall:
- Julia version: 
- Author: Dan
- Date: 2021-11-28
=#

push!(LOAD_PATH, "/mnt/g/Python Programme/BALL.jl/src" )
using BALL

pdb_filepath = "1crn.pdb"

System(pdb_filepath)

elapsed = @elapsed System(pdb_filepath)

println(elapsed)
